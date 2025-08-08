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
    prepareDependencies {
      $0.defaultDatabase = try! AppDatabase.setup()
    }
  }
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
