//
//  DataManager.swift
//  widget-example
//
//  Created by dtrognn on 03/10/2023.
//

import Foundation
import WidgetKit

/// using App Group and UserDefaults to share data to Widget

class DataManager: NSObject, ObservableObject {
    static let shared = DataManager()

    let GROUP_KEY: String = "group.com.dtrognn.widget-example"
    let DATA_FOR_KEY: String = "count"

    @Published var count: Int = 0

    func saveDataWithUserDefaults() {
        UserDefaults(suiteName: GROUP_KEY)?.set(count, forKey: DATA_FOR_KEY)
        WidgetCenter.shared.reloadAllTimelines() // reload func getTimeline
    }

    func readDataFromUserDefaults() -> Int? {
        if let userDefaults = UserDefaults(suiteName: GROUP_KEY) {
            let count = userDefaults.integer(forKey: DATA_FOR_KEY)
            return count
        }

        return nil
    }
}

extension DataManager {
    func saveDataWithFileManager() {
        let fileManager = FileManager.default
        let url = fileManager.containerURL(forSecurityApplicationGroupIdentifier: GROUP_KEY)?.appendingPathComponent("dtrognn")
        let data = Data("\(count)".utf8)
        try! data.write(to: url!)
    }

    func readDataFromFileManager() -> Int? {
        let fileManager = FileManager.default

        guard let url = fileManager.containerURL(forSecurityApplicationGroupIdentifier: GROUP_KEY)?.appendingPathComponent("dtrognn"),
              let data = try? Data(contentsOf: url),
              let string = String(data: data, encoding: .utf8) else { return nil }

        return Int(string)
    }
}
