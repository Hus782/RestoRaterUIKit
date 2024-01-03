//
//  RestaurantViewModel.swift
//  RestoRaterUIKit
//
//  Created by user249550 on 12/24/23.
//

import Foundation

final class RestaurantViewModel {
    var restaurants: [Restaurant] = []
    var showingAlert = Observable<Bool>(false)
    var alertMessage = Observable<String>("")
    var restaurantToDelete: Restaurant?
    var showingDeleteConfirmation = Observable<Bool>(false)
    var isLoading = Observable<Bool>(false)
    private let dataManager: CoreDataManager<Restaurant>
    
    init(dataManager: CoreDataManager<Restaurant> = CoreDataManager<Restaurant>()) {
        self.dataManager = dataManager
    }
    
    func fetchRestaurants() async {
        do {
            await MainActor.run { [weak self] in
                self?.isLoading.value = true
            }
            
            let fetchedRestaurants = try await dataManager.fetchEntities()
            await MainActor.run { [weak self] in
                self?.restaurants = fetchedRestaurants
                self?.isLoading.value = false
            }
            
        } catch {
            await MainActor.run { [weak self] in
                self?.isLoading.value = false
                self?.alertMessage.value = error.localizedDescription
            }
        }
    }
    
    func deleteRestaurant(_ restaurantToDelete: Restaurant?) async throws {
        guard let restaurantToDelete = restaurantToDelete else {
            throw UserError.userNotFound
        }
        
        do {
            try await dataManager.deleteEntity(entity: restaurantToDelete)
        } catch {
            throw error
        }
    }
}
