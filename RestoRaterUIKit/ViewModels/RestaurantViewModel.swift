//
//  RestaurantViewModel.swift
//  RestoRaterUIKit
//
//  Created by user249550 on 12/24/23.
//

import Foundation

/// ViewModel class for managing the restaurant-related functionalities in the application.
final class RestaurantViewModel {
    // Array to hold the list of restaurants
    var restaurants: [Restaurant] = []
    
    // Observable properties for UI state management
    var showingAlert = Observable<Bool>(false)
    var alertMessage = Observable<String>("")
    var restaurantToDelete: Restaurant?
    var showingDeleteConfirmation = Observable<Bool>(false)
    var isLoading = Observable<Bool>(false)
    
    // Core Data manager for restaurant entity operations
    private let dataManager: CoreDataManager<Restaurant>
    
    /// Initializes a new instance of `RestaurantViewModel`.
    /// - Parameter dataManager: The Core Data manager for handling `Restaurant` entity operations.
    init(dataManager: CoreDataManager<Restaurant> = CoreDataManager<Restaurant>()) {
        self.dataManager = dataManager
    }
    
    /// Fetches the list of restaurants asynchronously and updates the `restaurants` array.
    func fetchRestaurants() async {
        isLoading.value = true
        do {
            let fetchedRestaurants = try await dataManager.fetchEntities()
            restaurants = fetchedRestaurants
            isLoading.value = false
        } catch {
            isLoading.value = false
            alertMessage.value = error.localizedDescription
        }
    }
    
    /// Deletes a specified restaurant asynchronously.
    /// - Parameter restaurantToDelete: The restaurant to be deleted.
    func deleteRestaurant(_ restaurantToDelete: Restaurant?) async throws {
        guard let restaurantToDelete = restaurantToDelete else {
            throw UserError.userNotFound
        }
        try await dataManager.deleteEntity(entity: restaurantToDelete)
    }
}
