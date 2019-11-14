//
//  DepartmentsTableView.swift
//  Uni
//
//  Created by David Sarkisyan on 13/10/2019.
//  Copyright © 2019 DavidS & that's all. All rights reserved.
//

import UIKit
import Firebase

class DepartmentsTableView: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
           var minPoints = 100
    
           override func viewDidLoad() {
               super.viewDidLoad()
            if ((Manager.shared.UFD[Manager.shared.choosed[0] as! University]?[Manager.shared.choosed[1] as? Faculty]!?.count)!) == 0 {
               Manager.shared.loadDepartments(minPoints: minPoints, completion: { [weak self] in
                    DispatchQueue.main.async{
                     self?.tableView.reloadData()
                 }
            })
            }
               tableView.dataSource = self
               tableView.delegate = self
           }
    }

    extension DepartmentsTableView : UITableViewDataSource,UITableViewDelegate{

        func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return (Manager.shared.UFD[Manager.shared.choosed[0] as! University]?[Manager.shared.choosed[1] as? Faculty]!?.count)!
        }


        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
                let department = (Manager.shared.UFD[Manager.shared.choosed[0] as! University]?[Manager.shared.choosed[1] as? Faculty]!)![indexPath.row]
                let cell = tableView.dequeueReusableCell(withIdentifier: "DepartmentCell") as! DepartmentCell
                cell.setDepartmentCell(department: department)
                return cell
            }


        func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//            let department = departmentArray[indexPath.row]
//            if let url = URL(string: "\(department.link)") {
//                   UIApplication.shared.open(url)
//               }
            }

}

// swift inject 
