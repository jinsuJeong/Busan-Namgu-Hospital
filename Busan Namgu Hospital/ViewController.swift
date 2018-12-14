//
//  ViewController.swift
//  Busan Namgu Hospital
//
//  Created by D7703_18 on 2018. 12. 14..
//  Copyright © 2018년 A. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var myTableView: UITableView!
    
    var contents = NSArray()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        myTableView.delegate = self
        myTableView.dataSource = self

        
        // 데이터 로드
        let path = Bundle.main.path(forResource: "Busan", ofType: "plist")
        contents = NSArray(contentsOfFile: path!)!
        
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return contents.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let myCell = myTableView.dequeueReusableCell(withIdentifier: "myCell", for: indexPath)
        
        let myName = (contents[indexPath.row] as AnyObject).value(forKey: "name")
        let myAddr = (contents[indexPath.row] as AnyObject).value(forKey: "addr")
        
        print(myAddr!)
        
        myCell.textLabel?.text = myName as? String
        myCell.detailTextLabel?.text = myAddr as? String
        
        return myCell
    }
    
    // 위치정보 등 데이터를 DetailMapViewController에 전달
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "DetailMap" {
            
            let detailMVC = segue.destination as! DetailMapViewController
            let selectedPath = myTableView.indexPathForSelectedRow
            
            let myIndexedName = (contents[(selectedPath?.row)!] as AnyObject).value(forKey: "name")
            let myIndexedAddr = (contents[(selectedPath?.row)!] as AnyObject).value(forKey: "addr")
            
            print("myIndexedTitle = \(String(describing: myIndexedName))")
            
            detailMVC.dName = myIndexedName as? String
            detailMVC.dAddr = myIndexedAddr as? String
            
        } else if segue.identifier == "TotalMap" {
            print("this is TotlMapViewController")
            
            let totalMVC = segue.destination as! TotalMapViewController
            totalMVC.dContents = contents
            
        }
    }
    
    
}

