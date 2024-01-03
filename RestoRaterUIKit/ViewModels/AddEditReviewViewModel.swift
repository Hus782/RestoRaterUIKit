//
//  AddEditReviewViewModel.swift
//  RestoRaterUIKit
//
//  Created by user249550 on 1/1/24.
//

import Foundation

enum ReviewViewScenario {
    case add
    case edit
}

final class AddEditReviewViewModel {
    var rating: Int = 0
    var comment: String = ""
    var visitDate = Date()
    
    var errorMessage = Observable<String?>(nil)
    var isLoading = Observable<Bool>(false)
    var scenario: ReviewViewScenario = .add
    var restaurant: Restaurant?
    var review: Review?
    
    var onAddCompletion: (() -> Void)?
    private let dataManager: CoreDataManager<Review>
    
    var title: String {
        switch scenario {
        case .add:
            return Lingo.addEditReviewCreateTitle
        case .edit:
            return Lingo.addEditReviewEditTitle
        }
    }
    
    init(dataManager: CoreDataManager<Review>) {
        self.dataManager = dataManager
    }
    
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
    
    private func configure(review: Review) {
        review.rating = Int64(rating)
        review.comment = comment
        review.visitDate = visitDate
        if let restaurant = restaurant {
            review.restaurant = restaurant
        }
    }
    
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
