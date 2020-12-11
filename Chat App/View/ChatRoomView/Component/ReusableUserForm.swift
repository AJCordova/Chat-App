//
//  ReusableUserForm.swift
//  Chat App
//
//  Created by Cordova, Jireh on 10/17/20.
//  Copyright © 2020 Cordova, Jireh. All rights reserved.
//

import UIKit

class ReusableUserForm: UIView {

    //MARK: - Outlets
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var usernameWarningLabel: UILabel!
    @IBOutlet weak var passwordWarningLabel: UILabel!
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var mainCommand: UIButton!
    @IBOutlet weak var altCommand: UIButton!
    @IBOutlet weak var userAgreement: UILabel!
    
    var mainCommandInvoked: (() -> Void)?
    var altCommandInvoked: (() -> Void)?

   let nibName = "UserForm"
   
   required init?(coder aDecoder: NSCoder) {
       super.init(coder: aDecoder)
       commonInit()
   }
   
   override init(frame: CGRect) {
       super.init(frame: frame)
       commonInit()
   }
   
   func commonInit() {
        guard let view = loadViewFromNib() else { return }
        view.frame = self.bounds
        self.addSubview(view)
        userAgreement.text = Constants.DefaultStrings.userAgreementText
   }
   
   func loadViewFromNib() -> UIView? {
       let nib = UINib(nibName: nibName, bundle: nil)
       return nib.instantiate(withOwner: self, options: nil).first as? UIView
   }
    
    // MARK: - Functions
    @IBAction func mainCommandTapped(_ sender: UIButton) {
        if let mainCommandInvoked = self.mainCommandInvoked {
            mainCommandInvoked()
        }
    }
    
    @IBAction func altCommandTapped(_ sender: UIButton) {
        if let altCommandInvoked = self.altCommandInvoked { altCommandInvoked()}
    }
}
