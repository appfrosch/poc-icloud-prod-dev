//
//  Bundle+Extension.swift
//
//
//  Created by Stewart Lynch on 1/16/19.
//  Copyright © 2019 Stewart Lynch. All rights reserved.
//

import Foundation
import OSLog

extension Bundle {
  /// The app's display name
  var displayName: String {
    object(forInfoDictionaryKey: "CFBundleName") as? String ?? "Could not determine the application name"
  }

  /// The app's build number
  var appBuild: String {
    object(forInfoDictionaryKey: "CFBundleVersion") as? String ?? "Could not determine the application build number"
  }

  /// The app's version number
  var appVersion: String {
    object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String ?? "Could not determine the application version"
  }

  /// Delivers the filename of the largest of the app icons.
  ///
  /// Usage:
  /// ```swift
  /// if let appIconString = Bundle.main.appIconString,
  ///   let image = UIImage(named: appIconString) {
  ///   Image(uiImage: image)
  /// }
  /// ```
  var appIconString: String? {
    guard let infoPlist = Bundle.main.infoDictionary
    else {
      AppLogger.misc.warning("Could not load the application's info plist")
      return nil
    }
    guard let bundleIcons = infoPlist["CFBundleIcons"] as? NSDictionary
    else {
      AppLogger.misc.warning("Could not load the application's icons")
      return nil
    }
    guard let bundlePrimaryIcon = bundleIcons["CFBundlePrimaryIcon"] as? NSDictionary
    else {
      AppLogger.misc.warning("Could not load the application's primary icon")
      return nil
    }
    guard let bundleIconFiles = bundlePrimaryIcon["CFBundleIconFiles"] as? NSArray
    else {
      AppLogger.misc.warning("Could not load the application's icon's filenames")
      return nil
    }
    guard let appIconString = bundleIconFiles.lastObject as? String
    else {
      AppLogger.misc.warning("Could not load the application's primary icon filename")
      return nil
    }
    return appIconString
  }

  func decode<T: Decodable>(
    _ type: T.Type,
    from file: String,
    dateDecodingStategy: JSONDecoder.DateDecodingStrategy = .deferredToDate,
    keyDecodingStrategy: JSONDecoder.KeyDecodingStrategy = .useDefaultKeys
  ) throws -> T {
    guard let url = self.url(forResource: file, withExtension: nil) else {
      let error = NSError(domain: "Error: Failed to locate \(file) in bundle.", code: -1)
      AppLogger.misc.error("\(error.localizedDescription)")
      throw error
    }
    guard let data = try? Data(contentsOf: url) else {
      let error = NSError(domain: "Error: Failed to load \(file) from bundle.", code: -1)
      AppLogger.misc.error("\(error.localizedDescription)")
      throw error
    }
    let decoder = JSONDecoder()
    decoder.dateDecodingStrategy = dateDecodingStategy
    decoder.keyDecodingStrategy = keyDecodingStrategy
    guard let loaded = try? decoder.decode(T.self, from: data) else {
      let error = NSError(domain: "Error: Failed to decode \(file) from bundle.", code: -1)
      AppLogger.misc.error("\(error.localizedDescription)")
      throw error
    }
    return loaded
  }
}
