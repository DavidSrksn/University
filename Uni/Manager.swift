//
//  Manager.swift
//  Uni
//
//  Created by David Sarkisyan on 15.10.2019.
//  Copyright © 2019 DavidS & that's all. All rights reserved.
//

import Foundation
import Firebase
import Alamofire
import RealmSwift
import CircleMenu
import paper_onboarding
import FoldingCell

class Manager {
    
    private init(){}

    static let shared = Manager()
    
    var UFD = [ University : [Faculty? : [Department]?]]()
    
    var choosed: [Any?] = [nil,nil,nil]
    
    let db = Firestore.firestore()
    let realm = try! Realm()
    
    var preference: String?
    
    private var filterSettings = Filter(country: nil, subjects: nil, minPoint: nil, military: nil, campus: nil)
    
    func internetConnectionCheck(viewcontroller: UIViewController ){
        if !NetworkReachabilityManager()!.isReachable{
//          let newVC = viewcontroller.storyboard?.instantiateViewController(identifier: "wishlist")  as! WishlistTableView
//          viewcontroller.navigationController?.pushViewController(newVC, animated: false)
            viewcontroller.tabBarController?.selectedIndex = 1
            let alert = UIAlertController(title: "Alert", message: "There is no internet. You can only use your wishlist info ", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "ok", style: .default, handler: nil))
            viewcontroller.present(alert, animated: true)
        }
    }
    
    func loadUniversities(limit: Int, city: String?, subjects: [String]?, minPoints: Int?, dormitory: Bool?, militaryDepartment: Bool?, completion: (() -> Void)?){
        db.collection("Universities")
            .whereField("city", isEqualTo: city!)
            .whereField("militaryDepartment", isEqualTo: militaryDepartment!)
            .whereField("dormitory", isEqualTo: dormitory!)
            .getDocuments { (querySnapshot1, error) in
                if let error = error {
                    print("\(error.localizedDescription)")
                }
                else{
                    for document1 in (querySnapshot1?.documents)!{
                        self.db.collection("Universities")
                            .document("\(document1.documentID)")
                            .collection("\(document1.data()["name"]!)faculties")
                            .whereField("subjects", isEqualTo: subjects!.sorted())
                            .getDocuments { (querySnapshot2, error) in
                                if !Manager.shared.UFD.keys.contains(University(dictionary: document1.data())!) {
                                    if let error = error {
                                        print("\(error.localizedDescription)")
                                        // добавить комплишены
                                    }
                                    else{
                                        for document2 in (querySnapshot2?.documents)!{
                                            self.db.collection("Universities")
                                                .document("\(document1.documentID)")
                                                .collection("\(document1.data()["name"]!)faculties")
                                                .document("\(document2.documentID)")
                                                .collection("\(document2.data()["name"]!)departments")
                                                .whereField("minPoints", isLessThanOrEqualTo: minPoints!)
                                                .limit(to: 1)
                                                .getDocuments { (querySnapshot3, error) in
                                                    if Manager.shared.UFD.keys.count != limit {
                                                        if let error = error {
                                                            print("\(error.localizedDescription)")
                                                        }
                                                        else{
                                                            
                                                            if !Manager.shared.UFD.keys.contains(University(dictionary: document1.data())!){
                                                                Manager.shared.UFD[University(dictionary: document1.data())!] = [:]
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
                      .whereField("subjects", isEqualTo: subjects!.sorted())
                      .getDocuments { (querySnapshot2, error) in
                        if let error = error {
                           print("\(error.localizedDescription)")
                        } else {
                             for document2 in (querySnapshot2?.documents)!{
                                self.db.collection("Universities")
                                    .document("\(document1.documentID)")
                                    .collection("\(document1.data()["name"]!)faculties")
                                    .document("\(document2.documentID)")
                                    .collection("\(document2.data()["name"]!)departments")
                                    .whereField("minPoints", isLessThanOrEqualTo: minPoints!)
                                    .limit(to: 1)
                                    .getDocuments { (querySnapshot3, error) in
                                       if let error = error {
                                        print("\(error.localizedDescription)")
                                    }
                                    else{
                                        print("Manager \(document2.data())")
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
    
    
    func loadDepartments(minPoints: Int?, completion: (() -> Void)?) {
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
                         .whereField("name", isEqualTo: (Manager.shared.choosed[1] as! Faculty).name)
                         .getDocuments { (querySnapshot2, error) in
                           if let error = error {
                              print("\(error.localizedDescription)")
                           }
                               else{
                                 for document2 in (querySnapshot2?.documents)!{
                                    self.db.collection("Universities")
                                        .document("\(document1.documentID)")
                                        .collection("\(document1.data()["name"]!)faculties")
                                        .document("\(document2.documentID)")
                                        .collection("\(document2.data()["name"]!)departments")
                                        .whereField("minPoints", isLessThanOrEqualTo: minPoints!)
                                        .getDocuments { (querySnapshot3, error) in
                                          var arrayOfDepartmnets = [Department]()
                                          if let error = error {
                                            print("\(error.localizedDescription)")
                                        }
                                             else{
                                                for document3 in (querySnapshot3?.documents)! {
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
    
    func addToWishlist (sender: UIButton){
      let wishlistObject = WishlistObj(university: Manager.shared.choosed[0] as! University, department: Manager.shared.choosed[2] as! Department)
        print("objects = \(self.realm.objects(WishlistObj.self))")
        if !self.realm.objects(WishlistObj.self).contains(wishlistObject){
        do {
            try self.realm.write {
            self.realm.add(wishlistObject)
        }
        } catch{
            print(error.localizedDescription)
        }}
        print("fileURL = \(self.realm.configuration.fileURL)")
        sender.setImage(UIImage(systemName: "star.fill")?.withTintColor(.red), for: .normal)
       }
    
    func deleteFromWishlist (sender: UIButton){
        let wishlistObject = WishlistObj(university: Manager.shared.choosed[0] as! University, department: Manager.shared.choosed[2] as! Department)
            do{
                try self.realm.write {
//                    self.realm.deleteAll()
                     self.realm.delete(realm.objects(WishlistObj.self).filter("departmentName = '\(wishlistObject.departmentName)'"))
                }
            }
            catch{
                print(error.localizedDescription)
            }
        sender.setImage(UIImage(systemName: "star")?.withTintColor(.red), for: .normal)
    }
    
    func departmentStatus(department: Department) -> Bool {
        if Manager.shared.realm.objects(WishlistObj.self).contains(where: { (wishlistObject) -> Bool in
            return wishlistObject.departmentName == department.name
        }){
            return false
        } else{
            return true
        }
    }
    
    func loadFilterSettings() -> Filter {
        return self.filterSettings
    }
    
    func updateFilterSettings(with newFilter: Filter) {
        self.filterSettings = newFilter
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
