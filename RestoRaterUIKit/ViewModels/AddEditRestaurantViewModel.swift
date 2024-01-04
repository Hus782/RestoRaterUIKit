//
//  AddEditRestaurantViewModel.swift
//  RestoRaterUIKit
//
//  Created by user249550 on 1/1/24.
//

import Foundation

/// Enumeration to represent the different scenarios for the restaurant view.
enum RestaurantViewScenario {
    case add
    case edit
}

/// Protocol used for updating the restaurant after editing.
protocol RestaurantUpdateDelegate: AnyObject {
    func restaurantDidUpdate(_ updatedRestaurant: Restaurant)
}

/// ViewModel class for adding or editing restaurants.
final class AddEditRestaurantViewModel {
    // Properties to hold restaurant input
    var name: String = ""
    var address: String = ""
    var image: Data = Data()
    
    // Observable properties for UI state management
    var errorMessage = Observable<String?>(nil)
    var isLoading = Observable<Bool>(false)
    var scenario: RestaurantViewScenario = .add
    var restaurant: Restaurant?
    var onAddCompletion: (() -> Void)?
    
    // Validation flags
    var isNameValid: Bool = false {
        didSet { updateFormValidity() }
    }
    var isAddressValid: Bool = false {
        didSet { updateFormValidity() }
    }
    var isFormValid = Observable<Bool>(false)
    
    // Core Data manager for restaurant entity operations
    private let dataManager: CoreDataManager<Restaurant>
    
    // Title based on the current scenario
    var title: String {
        switch scenario {
        case .add: return Lingo.addEditRestaurantCreateTitle
        case .edit: return Lingo.addEditRestaurantEditTitle
        }
    }
    
    /// Initializes a new `AddEditRestaurantViewModel` instance.
    init(dataManager: CoreDataManager<Restaurant>, onAddCompletion: (() -> Void)? = nil) {
        self.onAddCompletion = onAddCompletion
        self.dataManager = dataManager
    }
    
    /// Initializes the ViewModel with a specific restaurant and scenario.
    func initializeWithRestaurant(scenario: RestaurantViewScenario, restaurant: Restaurant?) {
        self.scenario = scenario
        self.restaurant = restaurant
        if let restaurant = restaurant {
            self.name = restaurant.name
            self.address = restaurant.address
            self.image = restaurant.image
        }
        // Assume that existing restaurant data is valid
        if scenario == .edit {
            isNameValid = true
            isAddressValid = true
        }
    }
    
    /// Configures a `Restaurant` entity with the current input data.
    private func configure(restaurant: Restaurant) {
        restaurant.name = self.name
        restaurant.address = self.address
        restaurant.image = self.image
    }
    
    /// Adds a new restaurant asynchronously.
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
    
    /// Edits an existing restaurant asynchronously.
    func editRestaurant() async -> Restaurant? {
        guard let restaurant = restaurant else { return nil }
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
    
    /// Updates the overall form validity based on individual field validations.
    private func updateFormValidity() {
        isFormValid.value = isNameValid && isAddressValid
    }
}
