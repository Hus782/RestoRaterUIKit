//
//  AddEditRestaurantViewModel.swift
//  RestoRaterUIKit
//
//  Created by user249550 on 1/1/24.
//

import Foundation

enum RestaurantViewScenario {
    case add
    case edit
}

final class AddEditRestaurantViewModel {
    var name: String = ""
    var address: String = ""
    var image: Data = Data()
    var errorMessage = Observable<String?>(nil)
    var isLoading = Observable<Bool>(false)
    var scenario: RestaurantViewScenario = .add
    var restaurant: Restaurant?
    var onAddCompletion: (() -> Void)?
    private let dataManager: CoreDataManager<Restaurant>
    
    var isNameValid: Bool = false {
        didSet {
            updateFormValidity()
        }
    }
    
    var isAddressValid: Bool = false {
        didSet {
            updateFormValidity()
        }
    }
    
    var isFormValid = Observable<Bool>(false)
    
    var title: String {
        switch scenario {
        case .add:
            return Lingo.addEditRestaurantCreateTitle
        case .edit:
            return Lingo.addEditRestaurantEditTitle
        }
    }
    
    init(dataManager: CoreDataManager<Restaurant>, onAddCompletion: (() -> Void)? = nil) {
        self.onAddCompletion = onAddCompletion
        self.dataManager = dataManager
    }
    
    func initializeWithRestaurant(scenario: RestaurantViewScenario, restaurant: Restaurant?) {
        self.scenario = scenario
        self.restaurant = restaurant
        if let restaurant = restaurant {
            self.name = restaurant.name
            self.address = restaurant.address
            self.image = restaurant.image
        }
        
        if scenario == .edit {
            isNameValid = true
            isAddressValid = true
        }
    }
    
    private func configure(restaurant: Restaurant) {
        restaurant.name = self.name
        restaurant.address = self.address
        restaurant.image = self.image
    }
    
    func addRestaurant() async {
        isLoading.value = true
        do {
            try await dataManager.createEntity { [weak self] (restaurant: Restaurant) in
                self?.configure(restaurant: restaurant)
            }
            await MainActor.run { [weak self] in
                self?.onAddCompletion?()
            }
        } catch {
            await MainActor.run { [weak self] in
                self?.errorMessage.value = error.localizedDescription
            }
        }
        isLoading.value = false
    }
    
    func editRestaurant() async -> Restaurant? {
        guard let restaurant = restaurant else { return nil}
        restaurant.name = name
           restaurant.address = address
           restaurant.image = image
        
        isLoading.value = true
        
        do {
            try await dataManager.saveEntity(entity: restaurant)
            await MainActor.run { [weak self] in
                self?.onAddCompletion?()
                self?.isLoading.value = false
            }
            return restaurant
        } catch {
            await MainActor.run { [weak self] in
                self?.errorMessage.value = error.localizedDescription
                self?.isLoading.value = false
            }
            return nil
        }
    }
    
    private func updateFormValidity() {
        isFormValid.value = isNameValid && isAddressValid
    }
}
