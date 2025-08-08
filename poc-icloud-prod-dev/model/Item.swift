//
//  Item.swift
//  poc-icloud-prod-dev
//
//  Created by Andreas Seeger on 08.08.2025.
//

import Foundation
import SharingGRDB

@Table
struct Item: Identifiable {
  let id: UUID

  init(
    id: UUID = UUID()
  ) {
    self.id = id
  }
}
