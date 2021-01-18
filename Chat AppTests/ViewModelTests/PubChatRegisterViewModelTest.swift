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
//
//    /**
//     Tests registerviewmodel input validation property value when user input is invalid
//     */
//    func testVerifyUserInputWithInvalidInput() {
//        // arrange
//        let userInput = "XXX-XXX"
//        
//        // act
//        let result = viewModel.inputs.verifyUserInput(userInput: userInput)
//        
//        // assert
//        XCTAssertFalse(result)
//    }
//    
//    /**
//     Tests registerviewmodel input validation property value when user input is valid
//     */
//    func testVerifyUserInputWithValidInput() {
//        // arrange
//        let userInput = "XXXX-XXXX"
//        
//        // act
//        let result = viewModel.inputs.verifyUserInput(userInput: userInput)
//        
//        // assert
//        XCTAssertTrue(result)
//    }
//    
//    /**
//     Tests registerviewmodel input validation property value when user input is valid
//     */
//    func testVerifyPasswordMatchSameValues() {
//        // arrange
//        let userInput = "XXXX-XXXX"
//        let comparable = userInput
//        
//        // act
//        let result = viewModel.verifyPasswordMatch(userInput: userInput, comparable: comparable)
//        
//        // assert
//        XCTAssertTrue(result)
//    }
//    
//    /**
//     Tests verifyuserinput return value when password and confirmpassword texts are not equal.
//     */
//    func testVerifyPasswordMatchDifferentValues() {
//        // arrange
//        let userInput = "XXXX-XXXX"
//        let comparable = "XXXXX-XXXXX"
//        
//        // act
//        let result = viewModel.verifyPasswordMatch(userInput: userInput, comparable: comparable)
//        
//        // assert
//        XCTAssertFalse(result)
//    }
    
    /**
     Verify that plain-text are correctly encoded to base64.
     */
    func testHashPasswordVerifyHash() {
        // arrange
        let testString = "Base64Test"
        
        // act
        let hashedResult = viewModel.hashPassword(password: testString)
        
        // assert
        XCTAssertEqual(hashedResult.base64Decoded(), testString)
    }
}
