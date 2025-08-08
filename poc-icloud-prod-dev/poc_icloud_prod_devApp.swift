//
//  poc_icloud_prod_devApp.swift
//  poc-icloud-prod-dev
//
//  Created by Andreas Seeger on 08.08.2025.
//

import SwiftUI

@main
struct poc_icloud_prod_devApp: App {
  let coreDataStack = CoreDataStack.shared

  var body: some Scene {
    WindowGroup {
      ContentView()
        .environment(\.managedObjectContext, coreDataStack.container.viewContext)
    }
  }
}
