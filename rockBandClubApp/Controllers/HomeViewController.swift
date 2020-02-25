//
//  ViewController.swift
//
//
//  Created by Richard Roberson on 2/3/20.
//

import UIKit
import FirebaseAuth
import FirebaseUI

var homeView = HomeViewController()

class HomeViewController: UIViewController {
    
    let ref = Database.database().reference()
    var userIsAdmin = false
    var userPoints = 0
    var currentCode = Int()
    var newCode = Int()
    
    let user = Auth.auth().currentUser
    
    @IBOutlet weak var nextMeetingLabel: UILabel!
    @IBOutlet weak var codeField: UITextField!
    @IBOutlet weak var confirmAttendanceButton: UIButton!
    
    @IBOutlet weak var pointCount: UIBarButtonItem!
    @IBOutlet weak var adminButton: UIBarButtonItem!
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(false)
        homeView = self
        
        
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
    
    @IBAction func confirmAttendancePressed(_ sender: Any) {
        ref.child("properties").child("admin").observeSingleEvent(of: .value, with: { (snapshot) in
            if let dictionary = snapshot.value as? [String: AnyObject] {
                let code = dictionary["attendanceCode"] as! Int
                self.currentCode = code
                let correctCode = String(code)
                if self.codeField.text != "" {
                    if self.codeField.text == correctCode {
                        self.ref.child("users").child((self.user?.displayName)!).observeSingleEvent(of: .value, with: { (snapshot) in
                            if let dictionary = snapshot.value as? [String: AnyObject] {
                                
                                var points = dictionary["points"]! as! Int
                                
                                points += 50
                                
                                self.ref.child("users").child((self.user?.displayName)!).child("points").setValue(points)
                                
                                self.setupHome()
                                self.confirmAttendanceButton.isEnabled = false
                            }
                        })
                        
                        
                        
                    }
                    
                }
                
            }
        })
        
        
        
        
        
        
        
    }
    
    
    func setupHome() {
        
        
        ref.child("users").child((user?.displayName)!).observeSingleEvent(of: .value, with: { (snapshot) in
            if let dictionary = snapshot.value as? [String: AnyObject] {
                
                self.userPoints = dictionary["points"]! as! Int
               
                self.pointCount.title = "Points: \(self.userPoints)"
                
                self.userIsAdmin = dictionary["admin"]! as! Bool
                
                if self.userIsAdmin == false {
                    self.adminButton.isEnabled = false
                    
                } else if self.userIsAdmin == true {
                    self.adminButton.isEnabled = true
                    
                }
                
            }
        })
        
        
        var nextMeetDay = ""
        
        ref.child("properties").observe(.childAdded, with: { (snapshot) in
            if let dictionary = snapshot.value as? [String: AnyObject] {
                nextMeetDay = dictionary["meetDay"] as! String
                self.newCode = dictionary["attendanceCode"] as! Int
                self.nextMeetingLabel.text = "Next meeting is \(nextMeetDay)"
                
                if self.currentCode != self.newCode {
                    self.confirmAttendanceButton.isEnabled = true
                }
                
            }
        }, withCancel: nil)
        
        
        
    }

        
    
    
}
