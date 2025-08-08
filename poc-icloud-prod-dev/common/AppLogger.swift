//
//  AppLogger.swift
//  App-etizer
//
//  Created by Andreas Seeger on 08.01.2025.
//


import Foundation
import OSLog

enum AppLogger {
  static let misc = Logger(subsystem: Bundle.main.bundleIdentifier ?? "", category: "misc")
  static let database = Logger(subsystem: Bundle.main.bundleIdentifier ?? "", category: "database")
}
