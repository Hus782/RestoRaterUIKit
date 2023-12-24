//
//  RestaurantViewModel.swift
//  RestoRaterUIKit
//
//  Created by user249550 on 12/24/23.
//

import Foundation

final class RestaurantViewModel {
    var restaurants = Observable<[Restaurant]>([])
    var showingAlert = Observable<Bool>(false)
    var alertMessage = Observable<String>("")
     var restaurantToDelete: Restaurant?
     var showingDeleteConfirmation = Observable<Bool>(false)
     var isLoading = Observable<Bool>(false)
    private let dataManager: CoreDataManager<Restaurant>
    
    init(dataManager: CoreDataManager<Restaurant> = CoreDataManager<Restaurant>()) {
        self.dataManager = dataManager
        Task {
            await fetchRestaurants()
        }
    }
    
    func fetchRestaurants() async {
        do {
            await MainActor.run { [weak self] in
                self?.isLoading.value = true
            }

            let fetchedRestaurants = try await dataManager.fetchEntities()
            await MainActor.run { [weak self] in
                self?.restaurants.value = fetchedRestaurants
                self?.isLoading.value = false
            }
            
        } catch {
            await MainActor.run { [weak self] in
                self?.isLoading.value = false
                self?.showingAlert.value = true
                self?.alertMessage.value = error.localizedDescription
            }
        }
    }
    
    func promptDelete(restaurant: Restaurant) {
        restaurantToDelete = restaurant
        showingDeleteConfirmation.value = true
    }
    
    func deleteRestaurant(completion: @escaping () -> Void) async {
         guard let restaurant = restaurantToDelete else {
             await MainActor.run { [weak self] in
                 self?.showingAlert.value = true
                 self?.alertMessage.value = Lingo.commonErrorMessage
             }
             return
         }
         
         do {
             try await dataManager.deleteEntity(entity: restaurant)
             await MainActor.run {
                 completion()
             }
         } catch {
             await MainActor.run { [weak self] in
                 self?.showingAlert.value = true
                 self?.alertMessage.value = error.localizedDescription
             }
         }
     }
    
}
