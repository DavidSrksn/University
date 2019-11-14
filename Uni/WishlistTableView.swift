//
//  WishlistTableView.swift
//  Uni
//
//  Created by David Sarkisyan on 03.11.2019.
//  Copyright © 2019 DavidS & that's all. All rights reserved.
//

import UIKit
import Alamofire

class WishlistTableView: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var emptyWarningLabel: UILabel!
    
    override func viewDidAppear(_ animated: Bool) {
        if Manager.shared.realm.objects(WishlistObj.self).count == 0{
           UIView.animate(withDuration: 0.3) {
            self.view.bringSubviewToFront(self.emptyWarningLabel)
            self.emptyWarningLabel.alpha = 1
        }
    }
       else{
            if self.emptyWarningLabel.alpha == 1{
            self.emptyWarningLabel.alpha = 0
            }
        }
        tableView.reloadData()
    }
    
    override func viewDidLoad() {
        tableView.dataSource = self
        tableView.delegate = self
        super.viewDidLoad()
  }
}
 extension WishlistTableView : UITableViewDataSource,UITableViewDelegate{

        func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return Manager.shared.realm.objects(WishlistObj.self).count
        }


        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
                let object = Array(Manager.shared.realm.objects(WishlistObj.self))[indexPath.row]
                let cell = tableView.dequeueReusableCell(withIdentifier: "WishlistCell", for: indexPath) as! WishlistCell
                cell.setWishlistCell(wishedUniversity: object.universityName, wishedDepartment: object.departmentName)
                return cell
        }


        func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
          
        }
}



//            if !Manager.shared.wishlist.isEmpty{
//                let wishedUniversity = Array(Manager.shared.wishlist.keys)[universityIndex]
//                let wishedFaculty = Array(Manager.shared.wishlist[wishedUniversity]!.keys)[facultyIndex]
//                let wishedDepartment = (Manager.shared.wishlist[wishedUniversity]?[wishedFaculty])![departmentIndex]
//                print("index (wishedDepartment) = \(wishedDepartment)")
//                departmentIndex += 1
//                if departmentIndex == ((Manager.shared.wishlist[Array(Manager.shared.wishlist.keys)[universityIndex]]?[Array(Manager.shared.wishlist[Array(Manager.shared.wishlist.keys)[universityIndex]]!.keys)[facultyIndex]]!.count)!){
//                    departmentIndex = 0
//                    facultyIndex = +1
//                    if  facultyIndex == (Manager.shared.wishlist[Array(Manager.shared.wishlist.keys)[universityIndex]]?.keys.count)!{
//                        facultyIndex = 0
//                         universityIndex += 1
//                    }
//            }
//                let cell = tableView.dequeueReusableCell(withIdentifier: "WishlistCell", for: indexPath) as! WishlistCell
//                cell.setWishlistCell(wishedUniversity: wishedUniversity.name, wishedDepartment: wishedDepartment.name)
//                return cell
//            }



// weak var warning: UILabel? = {()->UILabel in
//    let warningLabel = UILabel(frame: .init(x: 100, y: 100, width: 200, height: 120))
//    warningLabel.center = self.view.center
//    warningLabel.textAlignment = .center
//    warningLabel.font = UIFont(name: "AvenirNext-Regular", size: 18)!
//    warningLabel.text = "Список пуст"
//    return warningLabel
//    }()
