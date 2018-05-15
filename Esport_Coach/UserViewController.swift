//
//  UserViewController.swift
//  Esport_Coach
//
//  Created by 陈皓宇 on 05/05/2018.
//  Copyright © 2018 Haoyu Chen. All rights reserved.
//

import UIKit
import Parse

class UserViewController: UIViewController {
    
    
    @IBAction func Logout(_ sender: Any) {
        
        PFUser.logOut()
        
        performSegue(withIdentifier: "logoutSegue", sender: self)
    }
    
    
    @IBAction func Go2Game(_ sender: Any) {
        
        performSegue(withIdentifier: "go2Game", sender: self)
    }
    
    @IBAction func ShowRanking(_ sender: Any) {
        
        performSegue(withIdentifier: "ShowRanking", sender: self)
    }
    
    @IBAction func ShowUserData(_ sender: Any) {
        performSegue(withIdentifier: "Go2Analysis", sender: self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    override func viewDidAppear(_ animated: Bool) {
        
        self.navigationController?.navigationBar.isHidden = true
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
