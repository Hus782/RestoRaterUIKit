//
//  AddEditRestaurantViewModelTests.swift
//  RestoRaterUIKitTests
//
//  Created by user249550 on 1/3/24.
//

import XCTest
import CoreData

@testable import RestoRaterUIKit

final class AddEditRestaurantViewModelTests: XCTestCase {
    var inMemoryContainer: NSPersistentContainer!
    var dataManager: CoreDataManager<Restaurant>!
    
    override func setUp() {
        super.setUp()
        inMemoryContainer = PersistenceController.inMemoryContainer()
        dataManager = CoreDataManager<Restaurant>(context: inMemoryContainer.viewContext)
        
    }
    
    override func tearDown() {
        inMemoryContainer = nil
        dataManager = nil
        super.tearDown()
    }
    
    func testInitializationForAddScenario() throws {
        let viewModel = AddEditRestaurantViewModel(dataManager: dataManager)
        viewModel.scenario = .add
        XCTAssertEqual(viewModel.name, "", "Name should be empty for add scenario")
        XCTAssertEqual(viewModel.address, "", "Address should be empty for add scenario")
        XCTAssertEqual(viewModel.title, Lingo.addEditRestaurantCreateTitle)
    }
    
    func testInitializationForEditScenario() throws {
        let mockRestaurant = Restaurant(context: inMemoryContainer.viewContext)
        mockRestaurant.name = "Mock Restaurant"
        mockRestaurant.address = "Mock Address"
        
        let viewModel = AddEditRestaurantViewModel(dataManager: dataManager)
        viewModel.initializeWithRestaurant(scenario: .edit, restaurant: mockRestaurant)
        XCTAssertEqual(viewModel.name, "Mock Restaurant", "Name should be set for edit scenario")
        XCTAssertEqual(viewModel.address, "Mock Address", "Address should be set for edit scenario")
        XCTAssertEqual(viewModel.title, Lingo.addEditRestaurantEditTitle)
    }
    
    func testAddRestaurant() async throws {
        let viewModel = AddEditRestaurantViewModel(dataManager: dataManager)
        viewModel.name = "New Restaurant"
        viewModel.address = "New Address"
        
        await viewModel.addRestaurant()
        
        let fetchRequest: NSFetchRequest<Restaurant> = Restaurant.createFetchRequest()
        let results = try inMemoryContainer.viewContext.fetch(fetchRequest)
        XCTAssertEqual(results.count, 1, "One restaurant should be added")
        XCTAssertEqual(results.first?.name, "New Restaurant", "The restaurant name should match")
    }
    
    func testEditRestaurant() async throws {
        let mockRestaurant = Restaurant(context: inMemoryContainer.viewContext)
        mockRestaurant.name = "Mock Restaurant"
        mockRestaurant.address = "Mock Address"
        
        let viewModel = AddEditRestaurantViewModel( dataManager: dataManager)
        viewModel.initializeWithRestaurant(scenario: .edit, restaurant: mockRestaurant)
        viewModel.name = "Updated Restaurant"
        viewModel.address = "Updated Address"
        
        await viewModel.editRestaurant()
        
        XCTAssertEqual(mockRestaurant.name, "Updated Restaurant", "The restaurant name should be updated")
        XCTAssertEqual(mockRestaurant.address, "Updated Address", "The restaurant address should be updated")
    }
    
}
