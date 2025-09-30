//
//  Wallet.swift
//  Wlif
//
//  Created by OSX on 27/08/2025.
//

import Foundation


// MARK: - Wallet
struct Wallet: Codable {
    var balance: String?
    var transactions: [Transaction]?
}

// MARK: - Transaction
struct Transaction: Codable {
    var id: Int?
    var title: String?
    var itemsCount: Int?
    var status: String?
    var type, amount, createdAt: String?

    enum CodingKeys: String, CodingKey {
        case id, title
        case itemsCount = "items_count"
        case status, type, amount
        case createdAt = "created_at"
    }
}
