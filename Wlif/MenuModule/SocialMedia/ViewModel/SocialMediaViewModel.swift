//
//  SocialMediaViewModel.swift
//  Wlif
//
//  Created by OSX on 07/08/2025.
//

import Foundation

class SocialMediaViewModel {
    var isLoading: Observable<Bool> = Observable(false)
    
    var socialMedia: [SocialMediaModel]? {
        didSet {
            self.onSocialMediaFetched?(socialMedia)
        }
    }
    
    var onSocialMediaFetched: (([SocialMediaModel]?) -> Void)?
    
    func getSocialMedia(completion: ((Result<[SocialMediaModel], Error>) -> Void)? = nil) {
        self.isLoading.value = true
        
        
        NetworkManager.instance.request(Urls.socialMedia, parameters: nil, method: .get, type: [SocialMediaModel].self) { [weak self] (baseModel, error) in
            
            self?.isLoading.value = false
            
            if let data = baseModel?.data {
                self?.socialMedia = data
            }
        }
    }
}
