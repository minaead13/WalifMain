//
//  OffersViewModel.swift
//  Wlif
//
//  Created by OSX on 13/08/2025.
//

import Foundation

class OffersViewModel {
    
    var isLoading: Observable<Bool> = Observable(false)
    private(set) var sections: [SectionData] = []

    var onSectionsUpdated: (() -> Void)?
    
    func getOffers() {
        self.isLoading.value = true
        NetworkManager.instance.request(Urls.exploreList, parameters: nil, method: .get, type: OffersModel.self) { [weak self] (baseModel, error) in
            self?.isLoading.value = false

            if let data = baseModel?.data {
                self?.prepareSections(from: data)
                
            }
        }
    }
    
    private func prepareSections(from data: OffersModel) {
        sections = []
        
        if let store = data.stores, !store.isEmpty {
            sections.append(SectionData(type: .store, items: store))
        }
        
        if let clinics = data.clinics, !clinics.isEmpty {
            sections.append(SectionData(type: .clinic, items: clinics))
        }
        
        if let hotels = data.hotels, !hotels.isEmpty {
            sections.append(SectionData(type: .hotel, items: hotels))
        }
        
        DispatchQueue.main.async {
            self.onSectionsUpdated?()
        }
    }
}

enum SectionType {
    case store
    case clinic
    case hotel
}

struct SectionData {
    let type: SectionType
    let items: [Any]
}
