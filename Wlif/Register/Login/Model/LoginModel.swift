//
//  LoginModel.swift
//  Wlif
//
//  Created by OSX on 01/07/2025.
//

import Foundation

struct UserModel: Codable {
    var token: String?
    var newUser: Bool?
    var user: User?
    
    enum CodingKeys: String, CodingKey {
        case token
        case newUser = "new_user"
        case user
    }
}

struct User: Codable {
    var id: Int?
    var name, email, phone, image: String?
    var code: Int?
}
