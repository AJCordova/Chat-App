//
//  PubChatLoginViewModelTest.swift
//  Chat AppTests
//
//  Created by Amiel Jireh Cordova on 12/18/20.
//  Copyright © 2020 Cordova, Jireh. All rights reserved.
//

import XCTest
import RxCocoa
@testable import Chat_App

class PubChatLoginViewModelTest: XCTestCase {
    var viewModel = PubChatLoginViewModel()

    override func setUpWithError() throws {
        viewModel.userManager = UserManagementServiceMock()
    }

    override func tearDownWithError() throws {}
    
    /**
     Tests loginviewmodel input validation property value when user input is empty
     */
    func testProcessLogin_withEmptyUserInput() {
        // arrange
        let usernameString: String = ""
        let passwordString: String = ""
        
        // act
        viewModel.processLogin(usernameInput: usernameString, passwordInput: passwordString)
        
        // assert
        XCTAssertTrue(viewModel.isInputEmpty)
    }
    
    /**
     Tests loginviewmodel input validation property value when user input does not meet minimum requirements
     */
    func testProcessLogin_withInvalidUserInput() {
        // arrange
        let usernameString: String = "abcde"
        let passwordString: String = "abcde"
        
        // act
        
        // assert
        XCTAssertFalse(viewModel.isInputValid(username: usernameString, password: passwordString))
    }
    
    /**
     Tests loginviewmodel input validation property value when user input meets minimum requirements. 
     */
    func testProcessLogin_withValidUserInput() {
        // arrange
        let usernameString: String = "abcd1234"
        let passwordString: String = "abcde1234"
        
        // act
        
        // assert
        XCTAssertTrue(viewModel.isInputValid(username: usernameString, password: passwordString))
    }

}
