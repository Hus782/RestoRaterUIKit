//
//  AddEditReviewViewModelTests.swift
//  RestoRaterUIKitTests
//
//  Created by user249550 on 1/3/24.
//

import XCTest
import CoreData

@testable import RestoRaterUIKit

final class AddEditReviewViewModelTests: XCTestCase {
    var viewModel: AddEditReviewViewModel!
    var inMemoryContainer: NSPersistentContainer!
    var dataManager: CoreDataManager<Review>!
    
    override func setUp() {
        super.setUp()
        inMemoryContainer = PersistenceController.inMemoryContainer()
        dataManager = CoreDataManager<Review>(context: inMemoryContainer.viewContext)
    }
    
    override func tearDown() {
        viewModel = nil
        inMemoryContainer = nil
        dataManager = nil
        super.tearDown()
    }
    
    func testInitializationForAddScenario() throws {
        viewModel = AddEditReviewViewModel(dataManager: dataManager)
        
        XCTAssertEqual(viewModel.rating, 0, "Rating should be 0 for add scenario")
        XCTAssertEqual(viewModel.comment, "", "Comment should be empty for add scenario")
        XCTAssertEqual(viewModel.title, Lingo.addEditReviewCreateTitle, "Title should be correct for add scenario")
    }
    
    func testInitializationForEditScenario() throws {
        let mockReview = Review(context: inMemoryContainer.viewContext)
        mockReview.rating = 5
        mockReview.comment = "Mock Comment"
        mockReview.visitDate = Date()

        viewModel = AddEditReviewViewModel( dataManager: dataManager)
        viewModel.initialize(scenario: .edit, restaurant: nil, review: mockReview)
        XCTAssertEqual(viewModel.rating, 5, "Rating should be set for edit scenario")
        XCTAssertEqual(viewModel.comment, "Mock Comment", "Comment should be set for edit scenario")
        XCTAssertEqual(viewModel.title, Lingo.addEditReviewEditTitle, "Title should be correct for edit scenario")
    }
    
    func testAddReview() async throws {
           viewModel = AddEditReviewViewModel(dataManager: dataManager)
           viewModel.rating = 4
           viewModel.comment = "New Review Comment"
           viewModel.visitDate = Date()

           await viewModel.addReview()

           let fetchRequest: NSFetchRequest<Review> = Review.createFetchRequest()
           let results = try inMemoryContainer.viewContext.fetch(fetchRequest)
           XCTAssertEqual(results.count, 1, "One review should be added")
           XCTAssertEqual(results.first?.comment, "New Review Comment", "The review comment should match")
       }
    
    func testEditReview() async throws {
            let mockReview = Review(context: inMemoryContainer.viewContext)
            mockReview.rating = 3
            mockReview.comment = "Mock Comment"
            mockReview.visitDate = Date()

            viewModel = AddEditReviewViewModel(dataManager: dataManager)
        viewModel.initialize(scenario: .edit, restaurant: nil, review: mockReview)
            viewModel.rating = 5
            viewModel.comment = "Updated Comment"
            viewModel.visitDate = Date()

            await viewModel.editReview()

            XCTAssertEqual(mockReview.rating, 5, "The review rating should be updated")
            XCTAssertEqual(mockReview.comment, "Updated Comment", "The comment should be updated")
        }
    
    func testDeleteReview() async throws {
         let mockReview = Review(context: inMemoryContainer.viewContext)
         mockReview.rating = 4
         mockReview.comment = "Mock Comment"
         mockReview.visitDate = Date()

         viewModel = AddEditReviewViewModel(dataManager: dataManager)
        try await viewModel.deleteReview(mockReview)

         let fetchRequest: NSFetchRequest<Review> = Review.createFetchRequest()
         let results = try inMemoryContainer.viewContext.fetch(fetchRequest)
         XCTAssertEqual(results.isEmpty, true, "The review should be deleted")
     }
    
}
