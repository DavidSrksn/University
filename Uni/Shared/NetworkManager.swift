//
//  File.swift
//  Uni
//
//  Created by David Sarkisyan on 26.12.2019.
//  Copyright © 2019 DavidS & that's all. All rights reserved.
//

import Foundation
import UIKit
import Firebase

class NetworkManager{
    
    let db = Firestore.firestore()
    
    private init(){}
    
    static var shared = NetworkManager()
    
     func loadUniversities(tableView: UITableView, warningLabel: UILabel, viewcontroller: UIViewController, city: String?, subjects: [String]?, minPoints: Int?, dormitory: Bool?, militaryDepartment: Bool?, completion: (() -> Void)?){
            Manager.shared.UFD.removeAll()
            db.collection("Universities")
            .getDocuments { (querySnapshot1, error) in
             if let error = error {
                print("\(error.localizedDescription)")
             }else{
                for document1 in (querySnapshot1?.documents)!{
                    if ( (document1.data()["city"] as? String == city) || (city == nil) ) && ( (document1.data()["militaryDepartment"] as? Bool == militaryDepartment) || (militaryDepartment == nil) ) && ( (document1.data()["dormitory"] as? Bool == dormitory) || (dormitory == nil) ){
                        self.db.collection("Universities")
                            .document("\(document1.documentID)")
                            .collection("\(document1.data()["name"]!)faculties")
                            .getDocuments { (querySnapshot2, error) in
                                if !Manager.shared.UFD.keys.contains(University(dictionary: document1.data())!) {
                                    if let error = error {
                                        print("\(error.localizedDescription)")
                                        completion?()
                                    }else{
                                        Manager.shared.warningCheck(parameter: querySnapshot2?.documents.count ?? 0, viewController: viewcontroller, warningLabel: warningLabel, tableView: tableView)
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
                                                        completion?()
                                                    }
                                                    else{
                                                        Manager.shared.warningCheck(parameter: querySnapshot3?.documents.count ?? 0, viewController: viewcontroller, warningLabel: warningLabel, tableView: tableView)
                                                        for document3 in (querySnapshot3?.documents)!{
                                                            if (subjects != nil) && ( document3.data()["subjects"] as? [String] == subjects) {
                                                                Manager.shared.UFD[University(dictionary: document1.data())!] = [:]
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
                                        completion?()
                                    }
                                }
                            }
                        }else{
                        Manager.shared.warningCheck(parameter: 0, viewController: viewcontroller, warningLabel: warningLabel, tableView: tableView)
                        completion?()
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
                }else{
                   for document1 in (querySnapshot1?.documents)! {
                    self.db.collection("Universities")
                        .document(document1.documentID)
                        .collection("\((Manager.shared.choosed[0] as! University).name)faculties")
                        .getDocuments { (querySnapshot2, error) in
                        if let error = error {
                          print("\(error.localizedDescription)")
                          completion?()
                        }else {
                          for document2 in (querySnapshot2?.documents)!{
                          self.db.collection("Universities")
                              .document("\(document1.documentID)")
                              .collection("\(document1.data()["name"]!)faculties")
                              .document("\(document2.documentID)")
                              .collection("\(document2.data()["name"]!)departments")
    //                        .whereField("minPoints", isLessThanOrEqualTo: minPoints ?? 400)
                              .limit(to: 1)
                              .getDocuments { (querySnapshot3, error) in
                                if let error = error {
                                   print("\(error.localizedDescription)")
                                }else{
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
                 }else{
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
                                            }else{
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
}
