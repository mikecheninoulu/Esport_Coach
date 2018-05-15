//
//  RankingViewController.swift
//  Esport_Coach
//
//  Created by 陈皓宇 on 05/05/2018.
//  Copyright © 2018 Haoyu Chen. All rights reserved.
//

import UIKit
import Parse



class RankingViewController: UITableViewController {

    var rankingnames = [""]
    
    var usermaxscore = [Int]()
    var usename = [String]()
    
    @IBAction func Logout(_ sender: Any) {
        
        PFUser.logOut()
        performSegue(withIdentifier: "LogOutsegue", sender: self)
        
    }
    

    
    @IBAction func BackMain(_ sender: Any) {
        performSegue(withIdentifier: "BackMainfromrank", sender: self)
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        let query = PFQuery(className: "Score")
        print(query)
        
        query.findObjectsInBackground(block: { (users, error) in
            if error != nil {
                print(error)
                
            } else if let users = users {
                print(users)
                
                self.rankingnames.removeAll()
                
                for object in users {
                    print(object)
                    if let name = object["username"] as? String
                    {
                        if self.usename.contains(name) == false
                        {
                            self.usename.append(String(name))
                            
                            if let score = object["score"] as? Int
                            {
                                self.usermaxscore.append(Int(score))
                            }
                        }
                        else{
                            let indexOfPerson1 = self.usename.index(of: name)
                            if let score = object["score"] as? Int
                            {
                                if (self.usermaxscore[indexOfPerson1] > score) {
                                    
                                    
                                }
                            }
                        }
                        
                    }

                }
                
                self.tableView.reloadData()
            }
        })
    }

        
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
         return rankingnames.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        // Configure the cell...
        cell.textLabel?.text = rankingnames[indexPath.row]
        return cell
    }
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
