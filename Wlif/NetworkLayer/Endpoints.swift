//
//  Endpoints.swift
//  Wlif
//
//  Created by OSX on 01/07/2025.
//

import Foundation

struct Urls {
    
    static let base = "https://wlif.com.sa/api/v1/"
    
    static var login: String {
        return "login"
    }
    
    static var logout: String {
        return "logout"
    }
    
    static var register: String {
        return "register"
    }
    
    static var verifyOTP: String {
        return "vertify_code"
    }
    
    static var home: String {
        return "home"
    }
    
    static var store: String {
        return "store"
    }
    
    static var storesList: String {
        return "stores/list"
    }
    
    static let cart = "cart"
    
    static var storeCart: String {
        return "\(cart)/store"
    }
    
    static var cartUpdate: String {
        return "\(cart)/update"
    }
    
    static var product: String {
        return "product"
    }
    
    static var deleteItem: String {
        return "\(cart)/delete"
    }
    
    static var adoption: String {
        return "adoption"
    }
    
    static var adoptionList: String {
        return "\(adoption)/list"
    }
    
    static var deleteAdoptionPet: String {
        return "\(adoption)/delete"
    }
    
    static var comment: String {
        return "comment/\(store)"
    }
    
    static var commentsList: String {
        return "comments/list"
    }
    
    static var adoptionStore: String {
        return "\(adoption)/\(store)"
    }
    
    static var address: String {
        return "address"
    }
    
    static var addressStore: String {
        return "\(address)/\(store)"
    }
    
    static var vetsService: String {
        return "stores/list?service_slogan=veterinaryServices"
    }
    
    static var petHotels: String {
        return "stores/list?service_slogan=petHotel"
    }
    
    static var service: String {
        return "service"
    }
    
    static var category: String {
        return "category"
    }
    
    static var bookingStore: String {
        return "booking_order/\(store)"
    }
    
    static var animalsList: String {
        return "my_animals/list"
    }
    
    static var adoptedPetsList: String {
        return "my_adopted_pets/list"
    }
    
    static var chats: String {
        return "chats"
    }
    
    static var userFavourite: String {
        return "user_favourites"
    }
    
    static var favList: String {
        return "\(userFavourite)/list"
    }
    
    static var addOrRemoveFav: String {
        return "user_favourite/addOrRemove"
    }
    
    static var rooms: String {
        return "rooms"
    }
    
    static var petHotelBooking: String {
        return "pet_hotel/\(bookingStore)"
    }
    
    static var storeOrder: String {
        return "order/\(store)"
    }
    
    // MARK: - Settings
    static var profile: String {
        return "profile"
    }
    
    static var editProfile: String {
        return "profile/edit"
    }
    
    static var terms: String {
        return "terms"
    }
    
    static var contactus: String {
        return "contactus"
    }
    
    static var socialMedia: String {
        return "social_media"
    }
    
    static var addTicket: String {
        return "add_ticket"
    }
    
    static var addresses: String {
        return "addresses"
    }
    
    static var deliveryFees: String {
        return "delivery_fees"
    }
    
    //MARK: - Explore
    
    static var explore: String {
        return "explore"
    }
    
    static var exploreList: String {
        return "\(explore)/list"
    }
    
    static var exploreViewAll: String {
        return "\(explore)/view-all"
    }
    
    static var exploreShow: String {
        return "\(explore)/show"
    }
    
    static var wallet: String {
        return "wallet"
    }
    
    static var addBalance: String {
        return "add_balance"
    }
    
    //MARK: - Orders
    static var orders: String {
        return "orders"
    }
    
    static var order: String {
        return "order"
    }
    
    static var bookingOrder: String {
        return "booking_order"
    }
    
    //MARK: - Payment
    static var payment: String {
        return "order/payment"
    }
    
    //MARK: - Rate
    static var rate: String {
        return "rate"
    }
    
    static var addRate: String {
        return "\(rate)/add"
    }
}
