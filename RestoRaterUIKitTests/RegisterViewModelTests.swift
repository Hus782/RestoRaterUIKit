//
//  RegisterViewModelTests.swift
//  RestoRaterUIKitTests
//
//  Created by user249550 on 1/3/24.
//

import XCTest
import CoreData

@testable import RestoRaterUIKit

final class RegisterViewModelTests: XCTestCase {
    var viewModel: RegisterViewModel!
    var mockUserManager: MockUserManager!
    var inMemoryContainer: NSPersistentContainer!
    
    override func setUp() {
        super.setUp()
        // Setup an in-memory CoreData container for testing
        inMemoryContainer = PersistenceController.inMemoryContainer()
        let dataManager = CoreDataManager<User>(context: inMemoryContainer.viewContext)
        
        mockUserManager = MockUserManager()
        viewModel = RegisterViewModel(dataManager: dataManager, userManager: mockUserManager)
    }
    
    override func tearDown() {
        viewModel = nil
        mockUserManager = nil
        inMemoryContainer = nil
        super.tearDown()
    }
    
    func testRegisterSuccess() async {
        // Set up the viewModel with valid registration data
        viewModel.email = "test@example.com"
        viewModel.password = "password"
        viewModel.name = "Test User"
        
        await viewModel.registerUser()
        
        XCTAssertFalse(mockUserManager.isRegistering)
    }
    
}
