//
//  ContentView.swift
//  poc-icloud-prod-dev
//
//  Created by Andreas Seeger on 08.08.2025.
//

import SharingGRDB
import SwiftUI

struct ContentView: View {
  var body: some View {
    NavigationStack {
      Form {
        Section("Bundle ID") {
        Text("\(Bundle.main.bundleIdentifier ?? "Unknown")")
      }
    }
      .navigationTitle("Debug and Release with iCloud App")
      .navigationBarTitleDisplayMode(.inline)
    }
  }
}

#Preview {
  let _ = prepareDependencies {
    $0.defaultDatabase = try! AppDatabase.setup()
  }

  ContentView()
}
