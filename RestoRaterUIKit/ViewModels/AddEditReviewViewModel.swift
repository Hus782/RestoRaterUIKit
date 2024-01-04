//
//  AddEditReviewViewModel.swift
//  RestoRaterUIKit
//
//  Created by user249550 on 1/1/24.
//

import Foundation

/// Enumeration to represent the different scenarios for the review view.
enum ReviewViewScenario {
    case add
    case edit
}

/// ViewModel class for adding, editing, or deleting reviews.
final class AddEditReviewViewModel {
    // Properties to hold review input
    var rating: Int = 0
    var comment: String = ""
    var visitDate = Date()
    
    // Observable properties for UI state management
    var errorMessage = Observable<String?>(nil)
    var isLoading = Observable<Bool>(false)
    var scenario: ReviewViewScenario = .add
    var restaurant: Restaurant?
    var review: Review?
    
    // Completion handler for add/edit actions
    var onAddCompletion: (() -> Void)?
    
    // Core Data manager for review entity operations
    private let dataManager: CoreDataManager<Review>
    
    // Title based on the current scenario
    var title: String {
        switch scenario {
        case .add: return Lingo.addEditReviewCreateTitle
        case .edit: return Lingo.addEditReviewEditTitle
        }
    }
    
    /// Initializes a new `AddEditReviewViewModel` instance.
    init(dataManager: CoreDataManager<Review>) {
        self.dataManager = dataManager
    }
    
    /// Initializes the ViewModel with specific review and scenario details.
    func initialize(scenario: ReviewViewScenario, restaurant: Restaurant?, review: Review?) {
        self.scenario = scenario
        self.restaurant = restaurant
        self.review = review
        if let review = review {
            self.rating = Int(review.rating)
            self.comment = review.comment
            self.visitDate = review.visitDate
        }
    }
    
    /// Configures a `Review` entity with the current input data.
    private func configure(review: Review) {
        review.rating = Int64(rating)
        review.comment = comment
        review.visitDate = visitDate
        if let restaurant = restaurant {
            review.restaurant = restaurant
        }
    }
    
    /// Adds a new review asynchronously.
    func addReview() async {
        isLoading.value = true
        do {
            try await dataManager.createEntity { [weak self] (review: Review) in
                self?.configure(review: review)
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
    
    /// Edits an existing review asynchronously.
    func editReview() async {
        guard let review = review else { return }
        configure(review: review)
        
        isLoading.value = true
        
        do {
            try await dataManager.saveEntity(entity: review)
            await MainActor.run { [weak self] in
                self?.onAddCompletion?()
                self?.isLoading.value = false
            }
        } catch {
            await MainActor.run { [weak self] in
                self?.errorMessage.value = error.localizedDescription
                self?.isLoading.value = false
            }
        }
    }
    
    /// Deletes a specified review asynchronously.
    func deleteReview(_ reviewToDelete: Review?) async throws {
        guard let reviewToDelete = reviewToDelete else {
            throw UserError.userNotFound
        }
        
        do {
            try await dataManager.deleteEntity(entity: reviewToDelete)
        } catch {
            throw error
        }
    }
}
