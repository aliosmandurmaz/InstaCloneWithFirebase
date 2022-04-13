//
//  SettingsViewController.swift
//  InstaCloneFirebase
//
//  Created by Ali Osman DURMAZ on 31.03.2022.
//

import UIKit
import Firebase

class SettingsViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    @IBAction func logOutCilcked(_ sender: Any) {
        do {
            try Auth.auth().signOut()
            self.performSegue(withIdentifier: "toViewController", sender: nil)
        } catch  {
            print("Error")
        }
    }
}
