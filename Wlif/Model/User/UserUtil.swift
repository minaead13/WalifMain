//
//  UserUtil.swift
//  Wlif
//
//  Created by OSX on 02/07/2025.
//

import Foundation

class UserUtil {
    
    private static let UserKey = "User"
    
    static func save(_ user: UserModel?) {
        guard let user = user else { return }
        let encoder = JSONEncoder()
        if let encoded = try? encoder.encode(user) {
            UserDefaults.standard.set(encoded, forKey: UserKey)
        }
    }
    
    static func load() -> UserModel? {
        if let savedUserData = UserDefaults.standard.data(forKey: UserKey) {
            let decoder = JSONDecoder()
            return try? decoder.decode(UserModel.self, from: savedUserData)
        }
        return nil
    }
    
    static func remove() {
        UserDefaults.standard.removeObject(forKey: UserKey)
        UserDefaults.standard.removeObject(forKey: "token")
        UserDefaults.standard.synchronize()
    }
    
    class func isActive() -> Bool {
        return load() != nil
    }
}
