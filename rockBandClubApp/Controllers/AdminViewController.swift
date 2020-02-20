//
//  AdminViewController.swift
//  rockBandClubApp
//
//  Created by Richard Roberson on 2/12/20.
//  Copyright © 2020 Richard Roberson. All rights reserved.
//

import UIKit
import Firebase

class AdminViewController: UITableViewController {

    let ref = Database.database().reference()
    
    @IBOutlet weak var codeField: UITextField!
    @IBOutlet weak var dayField: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
    }

    @IBAction func changeCodePressed(_ sender: Any) {
        if codeField.text != nil {
            let code = Int(codeField.text!)
            ref.child("properties").child("attendanceCode").setValue(code)
        }
    }
    
    
    @IBAction func changeDayPressed(_ sender: Any) {
        if dayField.text != nil {
            let day = dayField.text!
            ref.child("properties").child("meetDay").setValue(day)
        }
    }
    
    
    

}
