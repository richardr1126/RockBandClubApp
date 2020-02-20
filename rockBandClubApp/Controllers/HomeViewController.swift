//
//  ViewController.swift
//
//
//  Created by Richard Roberson on 2/3/20.
//

import UIKit
import FirebaseAuth
import FirebaseUI

class HomeViewController: UIViewController {
    
    let ref = Database.database().reference()
    var userIsAdmin = false
    var userPoints = 0
    
    let user = Auth.auth().currentUser
    
    @IBOutlet weak var nextMeetingLabel: UILabel!
    @IBOutlet weak var codeField: UITextField!

    @IBOutlet weak var pointCount: UIBarButtonItem!
    @IBOutlet weak var adminButton: UIBarButtonItem!
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(false)
        if user == nil {
            showLoginScreen()
        }
        
        setupHome()

    }
    
    
    @IBAction func logOutPressed(_ sender: Any) {
        do
        {
             try Auth.auth().signOut()
        }
        catch let error as NSError
        {
            print(error.localizedDescription)
        }
    
        showLoginScreen()
        
    }
    
    func showLoginScreen() {
        let vc = storyboard?.instantiateViewController(withIdentifier: "LoginViewController") as? LoginViewController
        vc?.modalPresentationStyle = .fullScreen
        
        
        present(vc!, animated: true, completion: nil)
        
    }
    
    func setupHome() {
        ref.child("users").observe(.childAdded, with: { (snapshot) in
            if let dictionary = snapshot.value as? [String: AnyObject] {
                
                self.userIsAdmin = dictionary["admin"]! as! Bool
                print(self.userIsAdmin)
                if self.userIsAdmin == false {
                    self.adminButton.isEnabled = false
                    
                } else if self.userIsAdmin == true {
                    self.adminButton.isEnabled = true
                    
                }
            }
        }, withCancel: nil)
        
        ref.child("users").observe(.childAdded, with: { (snapshot) in
            if let dictionary = snapshot.value as? [String: AnyObject] {
                
                self.userPoints = dictionary["points"]! as! Int
                print(self.userPoints)
                self.pointCount.title = "Points: \(self.userPoints)"
            }
        }, withCancel: nil)
        
        var nextMeetDay = ""
        
        ref.child("properties").observe(.childAdded, with: { (snapshot) in
            if let dictionary = snapshot.value as? [String: AnyObject] {
                nextMeetDay = dictionary["meetDay"] as! String
                
                self.nextMeetingLabel.text = "Next meeting is \(nextMeetDay)"
                
            }
        }, withCancel: nil)
        
    }
    
    
}
