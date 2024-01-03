//
//  AddEditUserViewModelTests.swift
//  RestoRaterUIKitTests
//
//  Created by user249550 on 1/3/24.
//

import XCTest
import CoreData

@testable import RestoRaterUIKit

final class AddEditUserViewModelTests: XCTestCase {
    
    var inMemoryContainer: NSPersistentContainer!
    var dataManager: CoreDataManager<User>!
    
    override func setUp() {
        super.setUp()
        inMemoryContainer = PersistenceController.inMemoryContainer()
        dataManager = CoreDataManager<User>(context: inMemoryContainer.viewContext)
    }
    
    override func tearDown() {
        inMemoryContainer = nil
        dataManager = nil
        super.tearDown()
    }
    
    func testInitializationForAddScenario() throws {
        let viewModel = AddEditUserViewModel(dataManager: dataManager)
        viewModel.scenario = .add
        XCTAssertEqual(viewModel.name, "", "Name should be empty for add scenario")
        XCTAssertEqual(viewModel.email, "", "Email should be empty for add scenario")
        XCTAssertEqual(viewModel.password, "", "Password should be empty for add scenario")
        XCTAssertFalse(viewModel.isAdmin, "isAdmin should be false for add scenario")
        XCTAssertEqual(viewModel.title, Lingo.addEditUserCreateTitle, "Title should be correct for add scenario")
    }
    
    func testInitializationForEditScenario() throws {
        let mockUser = User(context: inMemoryContainer.viewContext)
        mockUser.name = "Mock User"
        mockUser.email = "mock@example.com"
        mockUser.password = "mockPassword"
        mockUser.isAdmin = true
        
        let viewModel = AddEditUserViewModel(dataManager: dataManager)
        viewModel.initializeWithUser(scenario: .edit, user: mockUser)
        
        XCTAssertEqual(viewModel.name, "Mock User", "Name should be set for edit scenario")
        XCTAssertEqual(viewModel.email, "mock@example.com", "Email should be set for edit scenario")
        XCTAssertEqual(viewModel.password, "mockPassword", "Password should be set for edit scenario")
        XCTAssertTrue(viewModel.isAdmin, "isAdmin should be true for edit scenario")
        XCTAssertEqual(viewModel.title, Lingo.addEditUserEditTitle, "Title should be correct for edit scenario")
    }
    
    func testAddUser() async throws {
        let viewModel = AddEditUserViewModel(dataManager: dataManager)
        viewModel.scenario = .add
        viewModel.name = "New User"
        viewModel.email = "new@example.com"
        viewModel.password = "newPassword"
        viewModel.isAdmin = false
        
        await viewModel.addUser()
        
        let fetchRequest: NSFetchRequest<User> = User.createFetchRequest()
        let results = try inMemoryContainer.viewContext.fetch(fetchRequest)
        XCTAssertEqual(results.count, 1, "One user should be added")
        XCTAssertEqual(results.first?.name, "New User", "The user name should match")
    }
    
    func testEditUser() async throws {
        let mockUser = User(context: inMemoryContainer.viewContext)
        mockUser.name = "Mock User"
        mockUser.email = "mock@example.com"
        mockUser.password = "mockPassword"
        mockUser.isAdmin = true
        
        let viewModel = AddEditUserViewModel(dataManager: dataManager)
        viewModel.initializeWithUser(scenario: .edit, user: mockUser)
        viewModel.name = "Updated User"
        viewModel.email = "updated@example.com"
        viewModel.password = "updatedPassword"
        viewModel.isAdmin = false
        
        await viewModel.editUser()
        
        XCTAssertEqual(mockUser.name, "Updated User", "The user name should be updated")
        XCTAssertEqual(mockUser.email, "updated@example.com", "The email should be updated")
        XCTAssertEqual(mockUser.password, "updatedPassword", "The password should be updated")
        XCTAssertFalse(mockUser.isAdmin, "isAdmin should be updated to false")
    }
    
}
