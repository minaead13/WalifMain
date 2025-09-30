//
//  AdoptionDetailsViewModel.swift
//  Wlif
//
//  Created by OSX on 13/07/2025.
//

import Foundation

class AdoptionDetailsViewModel {
    
    var id: Int?
    var isLoading: Observable<Bool> = Observable(false)
    
    var adoptiondetails: AdoptionDetailsModel? {
        didSet {
            self.onAdoptionDetailsFetched?(adoptiondetails)
        }
    }
    
    var onAdoptionDetailsFetched: ((AdoptionDetailsModel?) -> Void)?
    
    func getAdoptionDetails(completion: ((Result<AdoptionDetailsModel, Error>) -> Void)? = nil) {
             
        self.isLoading.value = true
        let url = Urls.adoption + "/\(id ?? 0)"
        
        NetworkManager.instance.request(url, parameters: nil, method: .get, type: AdoptionDetailsModel.self) { [weak self] (baseModel, error) in
            self?.isLoading.value = false
            if let data = baseModel?.data {
                self?.adoptiondetails = data
            }
        }
    }
    
    func addComment(comment: String, isReply: Bool, parentId: Int, completion: ((Result<AdoptionDetailsModel, Error>) -> Void)? = nil) {
        var param = [
            "comment": comment,
            "commentable_type": "AdoptedPost",
            "commentable_id": "\(id ?? 0)",
            "rate": "1"
        ]
        
        if isReply {
            param["parent_id"] = "\(parentId)"
        }

        NetworkManager.instance.request(Urls.comment, parameters: param, method: .post, type: AdoptionDetailsModel.self) { [weak self] (baseModel, error) in
            if let data = baseModel?.data {
                self?.adoptiondetails = data
                completion?(.success(data))
                self?.getAdoptionDetails()
            }
        }
    }
    
    func deleteFavPets(id: Int, completion: ((Result<FavModel, Error>) -> Void)? = nil) {

        let param = [
            "post_id": "\(id)"
        ] as [String: Any]
        
        NetworkManager.instance.request(Urls.addOrRemoveFav, parameters: param, method: .post, type: FavModel.self) { [weak self] (baseModel, error) in
            self?.getAdoptionDetails()
        }
    }
}
