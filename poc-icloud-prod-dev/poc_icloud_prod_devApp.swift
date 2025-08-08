//
//  poc_icloud_prod_devApp.swift
//  poc-icloud-prod-dev
//
//  Created by Andreas Seeger on 08.08.2025.
//

import SharingGRDB
import SwiftUI

@main
struct poc_icloud_prod_devApp: App {
  init() {
    prepareDependencies { dependency in
      withErrorReporting {
        dependency.defaultDatabase = try AppDatabase.setup()
      }
      withErrorReporting {
        dependency.defaultSyncEngine = try SyncEngine(
          for: dependency.defaultDatabase,
          tables: Item.self
        )
      }
    }
  }
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
