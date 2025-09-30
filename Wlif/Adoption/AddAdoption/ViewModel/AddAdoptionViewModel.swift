//
//  AddAdoptionViewModel.swift
//  Wlif
//
//  Created by OSX on 15/07/2025.
//

import UIKit

class AddAdoptionViewModel {
    
    var petName: String?
    var ageGroup: String?
    var bloodType: String?
    var description: String?
    var lon: String?
    var lat: String?
    var address: String?
    var isLoading: Observable<Bool> = Observable(false)
    var isFromEdit: Bool = false
    var petID: Int?
    let placeholder = "Description".localized
    var isAddCellAvailable = true
    var adoptionImages: [UIImage] = []
    var onImagesDownloaded: (([UIImage]) -> Void)?
    
    
    var adoptiondetails: AdoptionDetailsModel? {
        didSet {
            self.onAdoptionDetailsFetched?(adoptiondetails)
            self.downloadAdoptionImages()
        }
    }
    
    var onAdoptionDetailsFetched: ((AdoptionDetailsModel?) -> Void)?

    func validateFields() -> (Bool, String?) {
        if petName?.isEmpty ?? true {
            return (false, "Pet name is required.".localized)
        }
        
        if LocationUtil.load() == nil {
            return (false, "Location is required.".localized)
        }
        
        if ageGroup?.isEmpty ?? true {
            return (false, "Age group is required.".localized)
        }
        
        if bloodType?.isEmpty ?? true {
            return (false, "Blood type is required.".localized)
        }
        
        if description?.isEmpty ?? true {
            return (false, "Description is required.".localized)
        }
        
      
        return (true, nil)
    }
    
    func addOrUpdatePet(completion: ((Result<AdoptionDetailsModel, Error>) -> Void)? = nil) {
        self.isLoading.value = true

        let params = [
            "pet_name": petName ?? "",
            "lat": LocationUtil.load()?.lat ?? "",
            "lon": LocationUtil.load()?.lon ?? "",
            "address": LocationUtil.load()?.address ?? "",
            "age": ageGroup ?? "",
            "blood_type": bloodType ?? "",
            "description": description ?? "",
            
        ] as [String: Any]
        
        let url = isFromEdit ? "\(Urls.adoption)/\(petID ?? 0)/update" : Urls.adoptionStore
        
        NetworkManager.instance.upload(url, parameters: params, method: .post, type: AdoptionDetailsModel.self, images: adoptionImages, fileName: "", fileExt: "") { [weak self] (baseModel, message) in
            self?.isLoading.value = false

            if let data = baseModel?.data {
               completion?(.success(data))
            } else {
                completion?(.failure(ErrorHelper.makeError(message ?? "Unknown error")))
            }
        }
    }
    
    private func downloadAdoptionImages() {
        guard let attachments = adoptiondetails?.attachments else { return }
        
        var images: [UIImage] = []
        let group = DispatchGroup()
        
        for attachment in attachments {
            guard let url = URL(string: attachment) else { continue }
            group.enter()
            URLSession.shared.dataTask(with: url) { data, response, error in
                defer { group.leave() }
                if let data = data, let image = UIImage(data: data) {
                    images.append(image)
                }
            }.resume()
        }
        
        group.notify(queue: .main) { [weak self] in
            self?.adoptionImages = images
            self?.onImagesDownloaded?(images)
        }
    }
    
    func getAdoptionDetails(completion: ((Result<AdoptionDetailsModel, Error>) -> Void)? = nil) {
             
        self.isLoading.value = true
        let url = Urls.adoption + "/\(petID ?? 0)"
        
        NetworkManager.instance.request(url, parameters: nil, method: .get, type: AdoptionDetailsModel.self) { [weak self] (baseModel, error) in
            self?.isLoading.value = false
            if let data = baseModel?.data {
                self?.adoptiondetails = data
            }
        }
    }
}
