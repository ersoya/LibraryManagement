//
//  LoginVC.swift
//  LibraryManagement
//
//  Created by Arda ERSOY on 19.04.2021.
//

import UIKit

class LoginVC: UIViewController {

    // MARK: - Required outlets
    @IBOutlet weak var usernameTF: UITextField!
    @IBOutlet weak var passwordTF: UITextField!
    @IBOutlet weak var loginBTN: UIButton!
    
    // MARK: - Define variables
    let defaults = UserDefaults.standard
    var _userRepository: IUserRepository = UserRepository()
    
    // MARK: - Main
    override func viewDidLoad() {
        super.viewDidLoad()

        _userRepository.fetch(username: Keys.shared.AUTH_USERNAME, password: Keys.shared.AUTH_PASSWORD, completion: { existingUser in
            if let user = existingUser {
                print(user.username ?? "", user.password ?? "", "logged in")
            } else {
                self._userRepository.insert(username: Keys.shared.AUTH_USERNAME, password: Keys.shared.AUTH_PASSWORD, completion: { isInserted in
                    if isInserted {
                        print("User is inserted.")
                    }
                })
            }
        })
    }
    
    // MARK: - Handle login button click, check user credentials
    @IBAction func loginBtnTapped(_ sender: UIButton) {
        if let username = usernameTF.text, let password = passwordTF.text {
            if username.isEmpty || password.isEmpty {
                ShowAlert(style: .warning, subTitle: "Please, fill username and password field.")
                MediaPlayer.shared.playSound()
            } else {
                if username != Keys.shared.AUTH_USERNAME || password != Keys.shared.AUTH_PASSWORD {
                    ShowAlert(style: .error, subTitle: "Wrong credentials provided.")
                    MediaPlayer.shared.playSound()
                } else {
                    defaults.setValue(true, forKey: "isLoggedIn")
                    defaults.synchronize()
                    
                    self.performSegue(withIdentifier: "LoginVcSegue", sender: self)
                }
            }
        }
    }
}
