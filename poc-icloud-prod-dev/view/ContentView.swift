//
//  ContentView.swift
//  poc-icloud-prod-dev
//
//  Created by Andreas Seeger on 08.08.2025.
//

import SwiftUI

struct ContentView: View {
  @Environment(\.managedObjectContext) private var context
  @FetchRequest(sortDescriptors: [NSSortDescriptor(keyPath: \Item.id, ascending: true)])
  private var items: FetchedResults<Item>

  var body: some View {
    NavigationStack {
      Form {
        Section("Bundle ID") {
          Text("\(Bundle.main.bundleIdentifier ?? "Unknown")")
        }
        Section {
          if items.isEmpty {
            ContentUnavailableView {
              Label("No items yet", systemImage: "xmark")
            } actions: {
              addItemButton
                .labelStyle(.titleAndIcon)
            }
          } else {
            ForEach(items) { item in
              Text(item.id?.uuidString ?? "Unknown")
                .font(.caption)
            }
            .onDelete(perform: deleteItems)
          }
        } header: {
          HStack {
            Text("Items")
            Spacer()
            addItemButton
              .labelStyle(.iconOnly)
          }
        }
        .navigationTitle("Debug and Release with iCloud App")
        .navigationBarTitleDisplayMode(.inline)
      }
    }
  }

  var addItemButton: some View {
    Button("Add item", systemImage: "plus") {
      let newItem = Item(context: context)
      newItem.id = UUID()
      CoreDataStack.shared.save()
    }
  }

  func deleteItems(at offsets: IndexSet) {
    withAnimation {
      offsets.map { items[$0] }.forEach(context.delete)
      CoreDataStack.shared.save()
    }
  }
}

#Preview {
  ContentView()
}
