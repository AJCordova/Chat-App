//
//  Constants.swift
//  Chat App
//
//  Created by Cordova, Jireh on 10/23/20.
//  Copyright © 2020 Cordova, Jireh. All rights reserved.
//

import Foundation
import UIKit

struct Constants {
    enum App {
        /**
            ApplicationFlavor determines which root viewcontroller is loaded on runtime.
            Flavors:
            1. Default (Firebase + MessageKit)
            2. Pub (PubNub + MessageKit + DataPersistence + ReactiveCocoa)
         */
        static let applicationFlavor: String = "Pub"
    }

    enum DefaultStrings {
        static let navigationTitle: String = "Chat app"
        static let userAgreementText: String =
            """
                By signing up, you agree to the Terms of Service and Privacy Policy,
                including Cookie Use. Others will be able to find you by searching
                for your email address or phone number when provided."
            """
        static let signupButtonLabel: String = "Sign up"
        static let loginButtonLabel: String = "Login"
        static let invalidInputWarning: String = "Value is incorrect"
        static let NavigationBarTitle: String = "Chat app"
        static let duplicateUserWarningLabel: String = "Username is taken"
    }

    enum DefaultColors {
        static let messageBubbleColor = UIColor(red: 158, green: 223, blue: 71)
        static let messageInputBackground = UIColor(red: 245, green: 245, blue: 245)
    }

    enum PubStrings {
        static let bannerLabel: String = "PubChat"
        static let usernamePlaceholderText: String = "username"
        static let passwordPlaceholderText: String = "password"
        static let registerButtonTitle: String = "Register"
        static let loginButtonTitle: String = "Enter Server"
    }
    
    enum FirebaseStrings {
        static let userCollectionReference = "Users"
        static let userReference = "username"
    }
    
    enum UserDefaultConstants {
        static let userKey = "pub-username"
        static let UUIDKey = "pub-UUID"
        static let isLoggedIn = "pub-isLoggedIn"
    }
}
