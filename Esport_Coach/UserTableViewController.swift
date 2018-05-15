//
//  UserTableViewController.swift
//  Esport_Coach
//
//  Created by 陈皓宇 on 07/05/2018.
//  Copyright © 2018 Haoyu Chen. All rights reserved.
//

import UIKit
import Parse
import Charts


class UserTableViewController: UIViewController {

    @IBOutlet weak var lineChartView: LineChartView!
    
    @IBOutlet weak var PieChartView: PieChartView!
    
    
    var usernames = [""]
    
    @IBAction func Logout(_ sender: Any) {
        
        PFUser.logOut()
        
        performSegue(withIdentifier: "LogOutsegue2", sender: self)
        
    }
    
    
    @IBAction func backtoMain(_ sender: Any) {
        performSegue(withIdentifier: "Goback2main", sender: self)
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        

        let query = PFUser.query()
        print(query)
        
        query?.findObjectsInBackground(block: { (users, error) in
            if error != nil {
                print(error)
                
            } else if let users = users {
                print(users)
                
                self.usernames.removeAll()
                
                for object in users {
                    
                    if let user = object as? PFUser {
                        
                        if let username = user.username {
                            
                            if let objectId = user.objectId {
                                
                                let usernameArray = username.components(separatedBy: "@")
                                
                                self.usernames.append(usernameArray[0])
                            }
                        }
                    }
                }
            }
        })
        updatePieChartData()
        setLineChartValues()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func setLineChartValues(_ count : Int = 15) {
        let values = (0..<count).map { (i) -> ChartDataEntry in
            
            var val = Double(arc4random_uniform(UInt32(count)) + 84)
            
            if i == 15{
                val = 100
            }
            return ChartDataEntry(x: Double(i), y: val)
        }
        
        lineChartView.chartDescription?.text = ""
        
        let set1 = LineChartDataSet(values: values, label: "Training Score")
        let data = LineChartData(dataSet: set1)
        
        self.lineChartView.data = data
        
    }
    
    func updatePieChartData() {
        var timeDataEntry = PieChartDataEntry(value: 18,label:"Time")
        var effDataEntry = PieChartDataEntry(value: 3, label: "Efficiency")
        
        var TrainDataEntries = [PieChartDataEntry]()
    
        PieChartView.chartDescription?.text = "Training Analysis"
        
        
        
        TrainDataEntries = [timeDataEntry, effDataEntry]

        let chartDataSet = PieChartDataSet(values: TrainDataEntries, label: "")
        let chartData = PieChartData(dataSet: chartDataSet)
        
        chartDataSet.colors = [UIColor(red: 230/255, green: 126/255, blue: 34/255, alpha: 1)]
        chartDataSet.colors = ChartColorTemplates.colorful()
        PieChartView.data = chartData
        
        
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
