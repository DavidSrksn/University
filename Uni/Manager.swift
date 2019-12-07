//
//  Manager.swift
//  Uni
//
//  Created by David Sarkisyan on 15.10.2019.
//  Copyright © 2019 DavidS & that's all. All rights reserved.
//

import Foundation
import Firebase
import FirebaseFirestore
import Alamofire
import RealmSwift
import CircleMenu
import paper_onboarding
import FoldingCell
import UIKit

final class Manager {
    
    private init(){}

    let queue = DispatchQueue.main

    var workItem = DispatchWorkItem(qos: .utility, flags: .assignCurrentContext) {
        
    }
    
    let notificationCentre = NotificationCenter.default
    
    let semaphore = DispatchSemaphore(value: 1)
    
    static let shared = Manager()
    
    var UFD = [ University : [Faculty? : [Department]?]]()
    
    var choosed: [Any?] = [nil,nil,nil]
    
    let db = Firestore.firestore()
    let realm = try! Realm()
    
    var preference: String?
    var flagFilterChanged = true
    var sortType: String?
    
    var filterSettings = Filter(country: nil, subjects: nil, minPoint: nil, military: nil, campus: nil)
    
    func internetConnectionCheck(viewcontroller: UIViewController ){
        if !NetworkReachabilityManager()!.isReachable{
            viewcontroller.tabBarController?.selectedIndex = 1
            let alert = UIAlertController(title: "Alert", message: "There is no internet. You can only use your wishlist info ", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "ok", style: .default, handler: nil))
            viewcontroller.present(alert, animated: true)
        }
    }
    
    
    func warningLabel(label: UILabel, warning text: String, viewController: UIViewController, tableView: UITableView){
        label.frame = CGRect(x: 0, y: 0, width: 400, height: 100)
        label.lineBreakMode = .byWordWrapping
        label.numberOfLines = 3
        label.alpha = 0
        viewController.view.addSubview(label)
        label.center = viewController.view.center
        label.font = UIFont(name: "AvenirNext-Regular", size: 21)
        label.textColor = UIColor.black
        label.textAlignment = .center
        label.text = text
        UIView.animate(withDuration: 0.5) {
            tableView.backgroundColor = .alizarin
            tableView.separatorColor = tableView.backgroundColor
            label.alpha = 1
    }
    }
    
    func loadUniversities(tableView: UITableView, wanrningLabel: UILabel, viewcontroller: UIViewController, city: String?, subjects: [String]?, minPoints: Int?, dormitory: Bool?, militaryDepartment: Bool?, completion: (() -> Void)?){
        Manager.shared.UFD.removeAll()
        db.collection("Universities")
            .whereField("city", isEqualTo: city ?? "Москва")
            .whereField("militaryDepartment", isEqualTo: militaryDepartment ?? true)
            .whereField("dormitory", isEqualTo: dormitory ?? true)
            .getDocuments { (querySnapshot1, error) in
                if let error = error {
                    print("\(error.localizedDescription)")
                }else{
                    if querySnapshot1?.documents.count == 0{
                        Manager.shared.warningLabel(label: wanrningLabel, warning: "По вашему запросу \n ничего не найдено", viewController:viewcontroller, tableView: tableView)
                    }else{
                        wanrningLabel.alpha = 0
                        tableView.backgroundColor = .white
                        tableView.separatorColor = .black
                    }
                    for document1 in (querySnapshot1?.documents)!{
                        self.db.collection("Universities")
                            .document("\(document1.documentID)")
                            .collection("\(document1.data()["name"]!)faculties")
                            .getDocuments { (querySnapshot2, error) in
                                if !Manager.shared.UFD.keys.contains(University(dictionary: document1.data())!) {
                                    if let error = error {
                                        print("\(error.localizedDescription)")
                                        completion?()
                                    } else{
                                        for document2 in (querySnapshot2?.documents)!{
                                            self.db.collection("Universities")
                                                .document("\(document1.documentID)")
                                                .collection("\(document1.data()["name"]!)faculties")
                                                .document("\(document2.documentID)")
                                                .collection("\(document2.data()["name"]!)departments")
                                                .whereField("minPoints", isLessThanOrEqualTo: minPoints ?? 400)
                                                .limit(to: 1)
                                                .getDocuments { (querySnapshot3, error) in
                                                    if let error = error {
                                                        print("\(error.localizedDescription)")
                                                    }
                                                    else{
                                                        for document3 in (querySnapshot3?.documents)!{
                                                            if subjects != nil{
                                                                if document3.data()["subjects"] as? [String] == subjects {
                                                                    if !Manager.shared.UFD.keys.contains(University(dictionary: document1.data())!){
                                                                        Manager.shared.UFD[University(dictionary: document1.data())!] = [:]
                                                                    }
                                                                }
                                                            }else{
                                                                if !Manager.shared.UFD.keys.contains(University(dictionary: document1.data())!){
                                                                    Manager.shared.UFD[University(dictionary: document1.data())!] = [:]
                                                                }
                                                            }
                                                        }
                                                        completion?()
                                                    }
                                            }
                                        }
                                    }
                                }
                        }
                    }
                }
        }
    }
    
    
    func loadFaculties(minPoints: Int?, subjects: [String]?, completion: (() -> Void)?) {
            db.collection("Universities")
                .whereField("name", isEqualTo:(Manager.shared.choosed[0] as! University).name)
                .getDocuments { (querySnapshot1, error) in
                if let error = error {
                   print("\(error.localizedDescription)")
                }
                else{
                  for document1 in (querySnapshot1?.documents)! {
                  self.db.collection("Universities")
                      .document(document1.documentID)
                      .collection("\((Manager.shared.choosed[0] as! University).name)faculties")
                      .getDocuments { (querySnapshot2, error) in
                        if let error = error {
                           print("\(error.localizedDescription)")
                           completion?()
                        } else {
                             for document2 in (querySnapshot2?.documents)!{
                                self.db.collection("Universities")
                                    .document("\(document1.documentID)")
                                    .collection("\(document1.data()["name"]!)faculties")
                                    .document("\(document2.documentID)")
                                    .collection("\(document2.data()["name"]!)departments")
                                    .whereField("minPoints", isLessThanOrEqualTo: minPoints ?? 400)
                                    .limit(to: 1)
                                    .getDocuments { (querySnapshot3, error) in
                                       if let error = error {
                                        print("\(error.localizedDescription)")
                                    }
                                    else{
                                        for document3 in (querySnapshot3?.documents)!{
                                            if subjects != nil{
                                          if document3.data()["subjects"] as? [String] == subjects {
                        Manager.shared.UFD[University(dictionary: document1.data())!]?[Faculty(dictionary: document2.data())] = []
                                                }
                                          }else{
                                            Manager.shared.UFD[University(dictionary: document1.data())!]?[Faculty(dictionary: document2.data())] = []

                                            }
                                        completion?()
                                    }
                                        }
                                }
                                }
                            }

                       }
                  }
            }
        }
    }
    
    
    func loadDepartments(subjects: [String]? ,minPoints: Int?, completion: (() -> Void)?) {
         db.collection("Universities")
           .whereField("name", isEqualTo: (Manager.shared.choosed[0] as! University).name)
           .getDocuments { (querySnapshot1, error) in
             if let error = error {
                 print("\(error.localizedDescription)")
             }
                   else{
                     for document1 in (querySnapshot1?.documents)! {
                     self.db.collection("Universities")
                         .document(document1.documentID)
                         .collection("\((Manager.shared.choosed[0] as! University).name)faculties")
                         .getDocuments { (querySnapshot2, error) in
                            if let error = error {
                                print("\(error.localizedDescription)")
                                completion?()
                            }else{
                                 for document2 in (querySnapshot2?.documents)!{
                                    self.db.collection("Universities")
                                        .document("\(document1.documentID)")
                                        .collection("\(document1.data()["name"]!)faculties")
                                        .document("\(document2.documentID)")
                                        .collection("\(document2.data()["name"]!)departments")
                                        .whereField("minPoints", isLessThanOrEqualTo: minPoints ?? 400)
                                        .getDocuments { (querySnapshot3, error) in
                                          var arrayOfDepartmnets = [Department]()
                                          if let error = error {
                                            print("\(error.localizedDescription)")
                                        }
                                             else{
                                                for document3 in (querySnapshot3?.documents)! {
                                                    if subjects != nil{
                                                    if document3.data()["subjects"] as? [String] == subjects {
                                                arrayOfDepartmnets.append(Department(dictionary: document3.data())!)
                                                        }}else{
                                                        arrayOfDepartmnets.append(Department(dictionary: document3.data())!)
                                                    }
                                             Manager.shared.UFD[University(dictionary: document1.data())!]?[Faculty(dictionary: document2.data())] =  arrayOfDepartmnets
                                      }
                                            completion?()
                                }
                                    }
                          }
                     }
                 }
            }
        }
    }
}
    
    func addToWishlist (sender: UIButton){
        let wishlistObject = WishlistObject(university: Manager.shared.choosed[0] as! University, department: Manager.shared.choosed[2] as! Department)
        if !self.realm.objects(WishlistObject.self).contains(wishlistObject){
            do {
                try self.realm.write {
                    self.realm.add(wishlistObject)
                }
            } catch{
                print(error.localizedDescription)
            }
        }
        print("fileURL = \(self.realm.configuration.fileURL)")
        sender.setImage(UIImage(systemName: "star.fill")?.withTintColor(.red), for: .normal)
    }
    
    func deleteFromWishlist (sender: UIButton,setImage: UIImage){
        let wishlistObject = WishlistObject(university: Manager.shared.choosed[0] as! University, department: Manager.shared.choosed[2] as! Department)
        do{
            try self.realm.write {
             // self.realm.deleteAll()
                self.realm.delete(realm.objects(WishlistObject.self).filter("departmentName = '\(wishlistObject.departmentName)'"))
            }
        }
        catch{
            print(error.localizedDescription)
        }
        sender.setImage(setImage, for: .normal)
    }
    
    func departmentStatus(department: Department) -> Bool {
        if Manager.shared.realm.objects(WishlistObject.self).contains(where: { (wishlistObject) -> Bool in
            return wishlistObject.departmentName == department.fullName
        }){
            return false
        } else{
            return true
        }
    }
    
//    func loadFilterSettings() -> Filter {
//        return self.filterSettings
//    }
    
    func filterSettingsChanged(filter: Filter){
        if filter.country == Manager.shared.filterSettings.country && filter.campus == Manager.shared.filterSettings.campus && filter.minPoint == Manager.shared.filterSettings.minPoint && filter.campus == Manager.shared.filterSettings.campus && filter.subjects == Manager.shared.filterSettings.subjects {
            Manager.shared.flagFilterChanged = false
        } else{
            Manager.shared.flagFilterChanged = true
        }
    }
    
    func updateFilterSettings(with newFilter: Filter) {
        if Manager.shared.flagFilterChanged{
            Manager.shared.filterSettings = newFilter
        }
    }
    
    func updateController(controller: UIViewController){
        ((controller as? UITabBarController)?.selectedViewController as? UINavigationController)?.viewControllers[0].viewDidLoad()
//        controller.viewDidLoad()
    }
}
    
   



//             if !Manager.shared.wishlist.keys.contains(Manager.shared.choosed[0] as! University){
//                   Manager.shared.wishlist[Manager.shared.choosed[0] as! University] = [:]
//                Manager.shared.wishlist[Manager.shared.choosed[0] as! University]![Manager.shared.choosed[1] as! Faculty] = []
//                   Manager.shared.wishlist[Manager.shared.choosed[0] as! University]?[Manager.shared.choosed[1] as! Faculty]?.append(Manager.shared.choosed[2] as! Department)
//               }
//               else if  Manager.shared.wishlist[Manager.shared.choosed[0] as! University]?[Manager.shared.choosed[1] as! Faculty] == nil{
//                Manager.shared.wishlist[Manager.shared.choosed[0] as! University]![Manager.shared.choosed[1] as! Faculty] = []
//                Manager.shared.wishlist[Manager.shared.choosed[0] as! University]?[Manager.shared.choosed[1] as! Faculty]?.append(Manager.shared.choosed[2] as! Department)
//        }
//               else {
//                Manager.shared.wishlist[Manager.shared.choosed[0] as! University]?[Manager.shared.choosed[1] as! Faculty]?.append(Manager.shared.choosed[2] as! Department)
//        }
//        if !(Manager.shared.wishlist[Manager.shared.choosed[0] as! University]?[Manager.shared.choosed[1] as! Faculty]?.contains(where: { (Department) -> Bool in
//                   return Department.name == department.name
//               }) ?? false){
//            return true
//               } else {
//                   return false
//               }


//  if Manager.shared.wishlist[Manager.shared.choosed[0] as! University]?[Manager.shared.choosed[1] as! Faculty]!.count == 1{
//            Manager.shared.wishlist[Manager.shared.choosed[0] as! University]?.removeValue(forKey: Manager.shared.choosed[1] as! Faculty)
//        }
//        else  {
//            Manager.shared.wishlist[Manager.shared.choosed[0] as! University]?[Manager.shared.choosed[1] as! Faculty]!.removeAll(where: { (department) -> Bool in
//                return department.name == (Manager.shared.choosed[2] as? Department)?.name
//            })
//        }
