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
    VStack {
      Image(systemName: "globe")
        .imageScale(.large)
        .foregroundStyle(.tint)
      Text("Hello, world!")
    }
    .padding()
  }
}

#Preview {
  let _ = prepareDependencies {
    $0.defaultDatabase = try! AppDatabase.setup()
  }

  ContentView()
}


@Table
struct Item: Identifiable {
  let id: UUID
}
