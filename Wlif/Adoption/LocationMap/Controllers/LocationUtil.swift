//
//  LocationUtil.swift
//  Chefaa
//
//  Created by Chefaa on 1/27/20.
//  Copyright © 2020 Abdelrahman Eldesoky. All rights reserved.
//

import Foundation
class LocationUtil {
    
    static let DocumentsDirectory = FileManager().urls(for: .documentDirectory, in: .userDomainMask).first
    static let ArchiveURL = DocumentsDirectory?.appendingPathComponent("location")
//    static let AutofillArchiveURL = DocumentsDirectory.appendingPathComponent("autofill_location")
    
    static func save(_ item: AddressModel?) {
        guard let item else { return }
        do {
            let data = try JSONEncoder().encode(item)
            if let ArchiveURL {
                try data.write(to: ArchiveURL)
            }
        } catch {
            print("Couldn't save file:", error)
        }
    }
    
    static func delete() {
        do {
            if let ArchiveURL {
                try FileManager.default.removeItem(at: ArchiveURL)
            }
            UserDefaults.standard.removeObject(forKey: "zoneId")
        } catch {
            print("Couldn't delete file: \(error.localizedDescription)")
        }
    }
    
    static func load() -> AddressModel? {
        guard let ArchiveURL,
              let data = try? Data(contentsOf: ArchiveURL) else { return nil }
        return try? JSONDecoder().decode(AddressModel.self, from: data)
    }
    
    static func isActive() -> Bool {
        if let location =  LocationUtil.load() {
            return true
        }
        return false
    }
}
