//
//  FilterViewModel.swift
//  Wlif
//
//  Created by OSX on 18/07/2025.
//

import Foundation

class AdoptionFilterViewModel {
    
    var selectedIndex: Int = 0
    
    var filterArr = [
        FilterModel(imageBlack: "Order.black" ,image: "Order", title: "My Animal".localized),
        FilterModel(imageBlack: "adoptedPets.black"  ,image: "adoptedPets", title: "Adopted Pets".localized),
        FilterModel(imageBlack: "chat.black" ,image: "chat", title: "All Chat".localized),
        FilterModel(imageBlack: "fav.black" ,image: "fav", title: "Favourites".localized),
    ]
    
    var isLoading: Observable<Bool> = Observable(false)
    
    var myAnimalList: [MyAnimalModel]? {
        didSet {
            self.onMyAnimalListFetched?(myAnimalList)
        }
    }
    
    var onMyAnimalListFetched: (([MyAnimalModel]?) -> Void)?
    
    var chats: [ChatModel]? {
        didSet {
            self.onChatsListFetched?(chats)
        }
    }
    
    var onChatsListFetched: (([ChatModel]?) -> Void)?
    
    
    var favPets: [FavModel]? {
        didSet {
            self.onFavAnimalListFetched?(favPets)
        }
    }
    
    var onFavAnimalListFetched: (([FavModel]?) -> Void)?

  
    func getMyAnimalList(isAnimal: Bool,completion: ((Result<[MyAnimalModel], Error>) -> Void)? = nil) {
        self.isLoading.value = true
        myAnimalList = []
        let url = isAnimal ? Urls.animalsList : Urls.adoptedPetsList
        NetworkManager.instance.request(url, parameters: nil, method: .get, type: [MyAnimalModel].self) { [weak self] (baseModel, error) in
            
            self?.isLoading.value = false
            
            if let data = baseModel?.data {
                self?.myAnimalList = data
            }
        }
    }
    
    func deleteAdoptionPet(id: Int,completion: ((Result<MyAnimalModel, Error>) -> Void)? = nil) {
        let url = Urls.deleteAdoptionPet + "/\(id)"
        NetworkManager.instance.request(url, parameters: nil, method: .delete, type: MyAnimalModel.self) { [weak self] (baseModel, error) in
            self?.getMyAnimalList(isAnimal: true)
        }
    }
    
    func getMessages(completion: ((Result<[ChatModel], Error>) -> Void)? = nil) {
        self.isLoading.value = true

       
        NetworkManager.instance.request(Urls.chats, parameters: nil, method: .get, type: [ChatModel].self) { [weak self] (baseModel, error) in
            
            self?.isLoading.value = false
            
            if let data = baseModel?.data {
                self?.chats = data
            }
        }
    }
    
    func getFavPets(completion: ((Result<[FavModel], Error>) -> Void)? = nil) {
        self.isLoading.value = true

       
        NetworkManager.instance.request(Urls.favList, parameters: nil, method: .get, type: [FavModel].self) { [weak self] (baseModel, error) in
            
            self?.isLoading.value = false
            
            if let data = baseModel?.data {
                self?.favPets = data
            }
        }
    }
    
    func deleteFavPets(id: Int, completion: ((Result<FavModel, Error>) -> Void)? = nil) {

        let param = [
            "post_id": "\(id)"
        ] as [String: Any]
        
        NetworkManager.instance.request(Urls.addOrRemoveFav, parameters: param, method: .post, type: FavModel.self) { [weak self] (baseModel, error) in
            
            self?.getFavPets()
        }
    }
    
}
