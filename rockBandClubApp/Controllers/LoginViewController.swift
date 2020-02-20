//
//  LoginViewController.swift
//  rockBandClubApp
//
//  Created by Richard Roberson on 2/3/20.
//  Copyright © 2020 Richard Roberson. All rights reserved.
//

import UIKit
import FirebaseUI
import FirebaseAuth
import Firebase



class LoginViewController: UIViewController {

    @IBOutlet weak var loginButton: UIButton!
    let ref = Database.database().reference()
    
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loginButton.layer.cornerRadius = 9
        // Do any additional setup after loading the view.
    }
    

    @IBAction func loginTapped(_ sender: Any) {
        
        let authUI = FUIAuth.defaultAuthUI()
        
        guard authUI != nil else {
            return
        }
        
        authUI?.delegate = self
        let providers: [FUIAuthProvider] = [FUIEmailAuth()]
        authUI?.providers = providers
        let authViewController = authUI!.authViewController()
        
        
        present(authViewController, animated: true, completion: nil)
    
    }
    
}


extension LoginViewController: FUIAuthDelegate {
    func authUI(_ authUI: FUIAuth, didSignInWith authDataResult: AuthDataResult?, error: Error?) {
        
        guard error == nil else {
            return
        }
        
        let user = authDataResult?.user
        
        ref.child("users").child("\(user?.displayName ?? "no-name")").setValue([
            "name": "\(user?.displayName ?? "no-name")",
            "admin": false,
            "uid": "\(user?.uid ?? "no-uid")",
            "points": 200
        ])
        
        performSegue(withIdentifier: "goHome", sender: self)
        
        
    }
}

struct AppUser {
    var admin: Bool
    var name: String
    var uid: String
    var points: Int
}
