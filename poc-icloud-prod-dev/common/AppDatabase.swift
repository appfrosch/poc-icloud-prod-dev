//
//  AppDatabase.swift
//  WhosCookin
//
//  Created by Andreas Seeger on 15.06.2025.
//

import Foundation
import OSLog
import SharingGRDB

enum AppDatabase {
  static func setup() throws -> any DatabaseWriter {
    @Dependency(\.context) var context
    var configuration = Configuration()
    configuration.foreignKeysEnabled = true
#if DEBUG
    configuration.prepareDatabase { db in
      db.trace(options: .profile) {
        if context == .preview {
          print("\($0.expandedDescription)")
        } else {
          AppLogger.database.debug("\($0.expandedDescription)")
        }
      }
    }
#endif
    let database: DatabaseWriter
    switch context {
    case .live:
      let path = URL.documentsDirectory.appendingPathComponent("db.sqlite").path()
#if DEBUG
      // Delete the database file if it exists if needed
      //    try? FileManager.default.removeItem(atPath: path)
#endif
      AppLogger.database.debug("open \(path)")
      database = try DatabasePool(path: path, configuration: configuration)
    case .test:
      let path = URL.temporaryDirectory.appending(component: "\(UUID().uuidString)-db.sqlite").path()
      database = try DatabasePool(path: path, configuration: configuration)
    case .preview:
      database = try DatabaseQueue(configuration: configuration)
    }
    try migratorSetup(for: database)
    
    if context == .preview {
      try database.write { db in
        #if DEBUG && targetEnvironment(simulator)
//        try db.seedSampleData()
        #endif
      }
    }
    return database
  }

  static private func migratorSetup(for database: DatabaseWriter) throws {
    var migrator = DatabaseMigrator()
#if DEBUG
    migrator.eraseDatabaseOnSchemaChange = true
#endif
    migrator.registerMigration("v1") { db in
      try #sql(
        """
        CREATE TABLE "items" (
          "id" TEXT PRIMARY KEY NOT NULL ON CONFLICT REPLACE DEFAULT (uuid())
        )
        """
      )
      .execute(db)
    }
    try migrator.migrate(database)
  }
}
