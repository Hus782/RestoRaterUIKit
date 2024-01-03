//
//  LoginViewModelTests.swift
//  LoginViewModelTests
//
//  Created by user249550 on 1/3/24.
//

import XCTest
import CoreData

@testable import RestoRaterUIKit

final class LoginViewModelTests: XCTestCase {
    var viewModel: LoginViewModel!
    var mockUserManager: MockUserManager!
    var inMemoryContainer: NSPersistentContainer!
    
    override func setUp() {
        super.setUp()
        // Setup an in-memory CoreData container for testing
        inMemoryContainer = PersistenceController.inMemoryContainer()
        let dataManager = CoreDataManager<User>(context: inMemoryContainer.viewContext)
        
        mockUserManager = MockUserManager()
        viewModel = LoginViewModel(dataManager: dataManager, userManager: mockUserManager)
    }
    
    override func tearDown() {
        viewModel = nil
        mockUserManager = nil
        inMemoryContainer = nil
        super.tearDown()
    }
    
    func testLoginSuccess() async {
        // Create a mock user and add it to the mock data manager
        let mockUser = User(context: inMemoryContainer.viewContext)
        mockUser.email = "test@example.com"
        mockUser.password = "password"
        mockUser.isAdmin = false
        
        try? inMemoryContainer.viewContext.save()
        
        viewModel.email = "test@example.com"
        viewModel.password = "password"
        mockUserManager.isLoginSuccess = true
        mockUserManager.isCurrent = true
        
        await viewModel.loginUser()
        
        XCTAssertTrue(mockUserManager.isCurrentUser(user: mockUser))
    }
    
    func testLoginInvalidCredentials() async {
        // Create a mock user and add it to the mock data manager
        let mockUser = User(context: inMemoryContainer.viewContext)
        mockUser.email = "test@example.com"
        mockUser.password = "password"
        mockUser.isAdmin = false
        
        try? inMemoryContainer.viewContext.save()
        
        viewModel.email = "test@example.com"
        viewModel.password = "invalid password"
        mockUserManager.isLoginSuccess = false
        
        await viewModel.loginUser()
        
        XCTAssertEqual(viewModel.alertMessage.value,  Lingo.invalidCredentials)
        XCTAssertFalse(mockUserManager.isCurrentUser(user: mockUser))
    }
    
}
