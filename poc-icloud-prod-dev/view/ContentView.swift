//
//  ContentView.swift
//  poc-icloud-prod-dev
//
//  Created by Andreas Seeger on 08.08.2025.
//

import SwiftUI

struct ContentView: View {
  var items: [Item] = []

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
              Text(item.id.uuidString)
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
      }
      .navigationTitle("Debug and Release with iCloud App")
      .navigationBarTitleDisplayMode(.inline)
    }
  }

  var addItemButton: some View {
    Button("Add item", systemImage: "plus") {

    }
  }

  func deleteItems(at offsets: IndexSet) {

  }
}

#Preview {
  ContentView()
}
