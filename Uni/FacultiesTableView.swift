//
//  FacultiesTableView.swift
//  Uni
//
//  Created by David Sarkisyan on 10/10/2019.
//  Copyright © 2019 DavidS & that's all. All rights reserved.
//

import UIKit
import Firebase
import SkeletonView

class FacultiesTableView: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var universityImage: UIImageView!
    @IBOutlet weak var universityLabel: UILabel!

    let subjects: [String]? = ["математика","русский","физика"]
    let minPoints: Int?  = 100
    
           override func viewDidLoad() {
            super.viewDidLoad()
            universityImage.image = UIImage(named: "\((Manager.shared.choosed[0] as! University).name).jpg")
            universityLabel.text = (Manager.shared.choosed[0] as! University).name
            tableView.dataSource = self
            tableView.delegate = self
            if (Manager.shared.UFD[Manager.shared.choosed[0] as! University]?.keys.count)! == 0 {
                view.showAnimatedGradientSkeleton()
                Manager.shared.loadFaculties(minPoints: minPoints,subjects: subjects, completion: { [weak self] in
                   DispatchQueue.main.async{
                   self?.tableView.reloadData()
                   self?.view.hideSkeleton()
                }
            })
        }
   }
}

    extension FacultiesTableView : SkeletonTableViewDelegate,SkeletonTableViewDataSource{
        
        func collectionSkeletonView(_ skeletonView: UITableView, numberOfRowsInSection section: Int) -> Int {
               return 2
           }
           
        func collectionSkeletonView(_ skeletonView: UITableView, cellIdentifierForRowAt indexPath: IndexPath) -> ReusableCellIdentifier{
            return "FacultyCell"
        }
       
        func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return (Manager.shared.UFD[Manager.shared.choosed[0] as! University]?.keys.count)!
        }


        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let faculty = Array((Manager.shared.UFD[Manager.shared.choosed[0] as! University]?.keys)!)[indexPath.row]
            let cell = tableView.dequeueReusableCell(withIdentifier: "FacultyCell") as! FacultyCell
            cell.setFacultyCell(faculty: faculty!)
            return cell
        }


        func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            Manager.shared.choosed[1] = Array((Manager.shared.UFD[Manager.shared.choosed[0] as! University]?.keys)!)[indexPath.row]
            let viewController = storyboard?.instantiateViewController(identifier: "кафедра") as! DepartmentsTableView
            navigationController?.pushViewController(viewController, animated: true)
        }
}

