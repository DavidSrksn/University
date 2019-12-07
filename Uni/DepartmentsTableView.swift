//
//  DepartmentsTableView.swift
//  Uni
//
//  Created by David Sarkisyan on 13/10/2019.
//  Copyright © 2019 DavidS & that's all. All rights reserved.
//

import UIKit
import Firebase


final class DepartmentsTableView: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    var minPoints = 100
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        Manager.shared.notificationCentre.addObserver(forName: NSNotification.Name(rawValue: "Department Deleted"), object: .none, queue: .main) { (Notification) in
            self.tableView.reloadData()
        }
        
        if ((Manager.shared.UFD[Manager.shared.choosed[0] as! University]?[Manager.shared.choosed[1] as? Faculty]!?.count)!) == 0 {
            Manager.shared.loadDepartments(subjects: Manager.shared.filterSettings.subjects ,minPoints: minPoints, completion: { [weak self] in
                DispatchQueue.main.async{
                    self?.tableView.reloadData()
                }
            })
        }
        setTable()
//        Manager.shared.queue.async {
//            Manager.shared.workItem.notify(queue: .main) {
//                self.tableView.reloadData()
//            }
//        }
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
    

    func setTable(){
        tableView.dataSource = self
        tableView.delegate = self
        self.title = "Departments"
    }
    
        func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//            let department = departmentArray[indexPath.row]
//            if let url = URL(string: "\(department.link)") {
//                   UIApplication.shared.open(url)
//               }
            }

}

// swift inject 
