# Quick Migration: SharingGRDB → CoreData + CloudKit

## Overview
Since you have no existing data and aren't using special GRDB features, this is a straightforward replacement that should fix your "Invalid bundle ID for container" error.

## Step 1: Remove SharingGRDB
1. **Remove Package**: File → Package Dependencies → Remove SharingGRDB
2. **Clean Project**: ⇧⌘K (Clean Build Folder)
3. **Remove Imports**: Delete all `import GRDB` and `import SharingGRDB` lines

## Step 2: Add CoreData Model
1. **Add Data Model**: File → New → Data Model → Name it `DataModel.xcdatamodeld`
2. **Create Test Entity**: Add an entity (e.g., "Item") with a few attributes like:
   - `name` (String)
   - `createdAt` (Date)
   - `id` (UUID)
3. **Enable CloudKit**: Select entity → **File Inspector** → Check "Used with SwiftData" (this enables CloudKit compatibility)
4. **Generate Classes**: Select entity → Data Model Inspector → Codegen: "Class Definition"

## Step 3: Create CoreData Stack
Replace your GRDB setup with this CoreData stack:

```swift
import CoreData
import CloudKit

class CoreDataStack: ObservableObject {
    static let shared = CoreDataStack()
    
    lazy var container: NSPersistentCloudKitContainer = {
        let container = NSPersistentCloudKitContainer(name: "DataModel")
        
        guard let description = container.persistentStoreDescriptions.first else {
            fatalError("Failed to retrieve a persistent store description.")
        }
        
        // Enable history tracking and remote notifications
        description.setOption(true as NSNumber, forKey: NSPersistentHistoryTrackingKey)
        description.setOption(true as NSNumber, forKey: NSPersistentStoreRemoteChangeNotificationPostOptionKey)
        
        // Configure CloudKit
        description.cloudKitContainerOptions = NSPersistentCloudKitContainerOptions(
            containerIdentifier: "iCloud.ch.appfros.ch.poc-icloud-prod-dev"
        )
        
        container.loadPersistentStores { _, error in
            if let error = error as NSError? {
                print("CoreData error: \(error), \(error.userInfo)")
            }
        }
        
        container.viewContext.automaticallyMergesChangesFromParent = true
        
        return container
    }()
    
    func save() {
        let context = container.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                print("Save error: \(error)")
            }
        }
    }
}
```

## Step 4: Update Your App
In your main App file:

```swift
@main
struct YourApp: App {
    let coreDataStack = CoreDataStack.shared
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, coreDataStack.container.viewContext)
        }
    }
}
```

## Step 5: Update Views
Replace any GRDB code in your views with CoreData:

```swift
import SwiftUI
import CoreData

struct ContentView: View {
    @Environment(\.managedObjectContext) private var context
    @FetchRequest(sortDescriptors: [NSSortDescriptor(keyPath: \Item.createdAt, ascending: false)]) 
    private var items: FetchedResults<Item>
    
    var body: some View {
        NavigationView {
            List {
                ForEach(items) { item in
                    VStack(alignment: .leading) {
                        Text(item.name ?? "Unknown")
                            .font(.headline)
                        Text(item.createdAt ?? Date(), style: .date)
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                }
                .onDelete(perform: deleteItems)
            }
            .navigationTitle("Items")
            .toolbar {
                Button("Add") {
                    addItem()
                }
            }
        }
    }
    
    private func addItem() {
        let newItem = Item(context: context)
        newItem.id = UUID()
        newItem.name = "Test Item \(items.count + 1)"
        newItem.createdAt = Date()
        
        CoreDataStack.shared.save()
    }
    
    private func deleteItems(offsets: IndexSet) {
        withAnimation {
            offsets.map { items[$0] }.forEach(context.delete)
            CoreDataStack.shared.save()
        }
    }
}
```

## Step 6: Verify Entitlements
Double-check your entitlement files contain the correct CloudKit configuration:

**Debug entitlements (`poc-icloud-prod-dev-debug.entitlements`):**
```xml
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
    <key>com.apple.developer.icloud-container-environment</key>
    <string>Development</string>
    <key>com.apple.developer.icloud-container-identifiers</key>
    <array>
        <string>iCloud.ch.appfros.ch.poc-icloud-prod-dev</string>
    </array>
    <key>com.apple.developer.icloud-services</key>
    <array>
        <string>CloudKit</string>
    </array>
</dict>
</plist>
```

**Release entitlements (`poc-icloud-prod-dev-release.entitlements`):**
```xml
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
    <key>com.apple.developer.icloud-container-environment</key>
    <string>Production</string>
    <key>com.apple.developer.icloud-container-identifiers</key>
    <array>
        <string>iCloud.ch.appfros.ch.poc-icloud-prod-dev</string>
    </array>
    <key>com.apple.developer.icloud-services</key>
    <array>
        <string>CloudKit</string>
    </array>
</dict>
</plist>
```

## Step 7: Update Project Capabilities
1. Select your project target
2. Go to "Signing & Capabilities"
3. Ensure **CloudKit** capability is added
4. Verify the container identifier matches: `iCloud.ch.appfros.ch.poc-icloud-prod-dev`

## Step 8: Enable Debug Logging (Optional)
For troubleshooting, add these to your scheme's Environment Variables:
- `-com.apple.CoreData.CloudKitDebug` = `1`
- `-com.apple.CoreData.Logging.stderr` = `1`

To add these:
1. Edit Scheme → Run → Arguments → Environment Variables
2. Add the variables above

## Step 9: Test Both Schemes
1. **Test Debug Scheme**: 
   - Should connect to Development CloudKit environment
   - Data will be separate from Production
2. **Test Release Scheme**: 
   - Should connect to Production CloudKit environment
   - Data will be separate from Development
3. **Verify No Conflicts**: Both should run without the "Invalid bundle ID" error

## Step 10: Verify Apple Developer Setup
Make sure in your Apple Developer account:
1. Go to Certificates, Identifiers & Profiles
2. Select Identifiers → App IDs
3. Find both bundle IDs:
   - `poc-icloud-prod-dev-debug`
   - `poc-icloud-prod-dev-release`
4. For each, ensure CloudKit is enabled and assigned to `iCloud.ch.appfros.ch.poc-icloud-prod-dev`

## Why This Fixes Your Issue

The "Invalid bundle ID for container" error you were experiencing with SharingGRDB happens because:

1. **SharingGRDB** uses its own CloudKit integration that may not properly handle Apple's bundle ID validation
2. **CoreData + CloudKit** uses Apple's official APIs that:
   - Properly respect entitlement-based environment switching
   - Have built-in bundle ID validation
   - Handle Development/Production separation correctly

## Expected Results
After this migration:
- ✅ Debug scheme uses Development CloudKit environment
- ✅ Release scheme uses Production CloudKit environment  
- ✅ No more "Invalid bundle ID for container" errors
- ✅ Automatic sync between devices
- ✅ Proper separation of Development and Production data

## Troubleshooting

**If you still get container errors:**
1. Clean build folder (⇧⌘K)
2. Delete app from simulator/device
3. Rebuild and reinstall
4. Check that you're signed into iCloud on the test device

**If sync isn't working:**
1. Verify internet connection
2. Check iCloud account is signed in
3. Look at debug logs if enabled
4. Try force-closing and reopening the app

This approach uses Apple's native, recommended solution for CloudKit integration and should resolve all the issues you were experiencing with SharingGRDB.
