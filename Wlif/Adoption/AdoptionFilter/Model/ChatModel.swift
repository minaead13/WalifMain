//
//  ChatModel.swift
//  Wlif
//
//  Created by OSX on 28/07/2025.
//

import Foundation

struct ChatModel: Codable {
    var roomId: Int?
    var roomKey: String?
    var lastMessage: String?
    var lastMessageAt: String?
    var receiver: Receiver?
    
    enum CodingKeys: String, CodingKey {
        case roomId = "room_id"
        case roomKey = "room_key"
        case lastMessage = "last_message"
        case lastMessageAt = "last_message_at"
        case receiver
    }
}

struct Receiver: Codable {
    var id: Int?
    var name: String?
    var image: String?
}
