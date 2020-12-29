//
//  PubChatRegisterViewModelTest.swift
//  Chat AppTests
//
//  Created by Amiel Jireh Cordova on 12/29/20.
//  Copyright © 2020 Cordova, Jireh. All rights reserved.
//

import XCTest
@testable import Chat_App

class PubChatRegisterViewModelTest: XCTestCase {
    var viewModel = PubRegisterViewModel()

    override func setUpWithError() throws {
        viewModel.userManager = UserManagementServiceMock()
    }

    override func tearDownWithError() throws {}

    /**
     Tests registerviewmodel input validation property value when user input is invalid
     */
    func testVerifyUserInput_withInvalidInput() {
        // arrange
        let userInput = "XXX-XXX"
        
        // act
        let result = viewModel.verifyUserInput(userInput: userInput)
        
        // assert
        XCTAssertFalse(result)
    }
    
    /**
     Tests registerviewmodel input validation property value when user input is valid
     */
    func testVerifyUserInput_withValidInput() {
        // arrange
        let userInput = "XXXX-XXXX"
        
        // act
        let result = viewModel.verifyUserInput(userInput: userInput)
        
        // assert
        XCTAssertTrue(result)
    }
    
    /**
     Tests registerviewmodel input validation property value when user input is valid
     */
    func testVerifyPasswordMatch_SameValues() {
        // arrange
        let userInput = "XXXX-XXXX"
        viewModel.passwordInput = "XXXX-XXXX"
        
        // act
        let result = viewModel.verifyPasswordMatch(userInput: userInput)
        
        // assert
        XCTAssertTrue(result)
    }
    
    /**
     Tests verifyuserinput return value when password and confirmpassword texts are not equal.
     */
    func testVerifyPasswordMatch_DifferentValues() {
        // arrange
        let userInput = "XXXX-XXXX"
        viewModel.passwordInput = "XXX-XXXX"
        
        // act
        let result = viewModel.verifyPasswordMatch(userInput: userInput)
        
        // assert
        XCTAssertFalse(result)
    }
    
    /**
     Verify that plain-text are correctly encoded to base64.
     */
    func testHashPassword_verifyHash() {
        // arrange
        let testString = "Base64Test"
        viewModel.passwordInput = testString
        
        // act
        let hashedResult = viewModel.hashPassword()
        
        // assert
        XCTAssertEqual(hashedResult.base64Decoded(), testString)
    }
}
