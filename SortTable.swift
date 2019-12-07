//
//  SortTable.swift
//  Uni
//
//  Created by David Sarkisyan on 01.12.2019.
//  Copyright © 2019 DavidS & that's all. All rights reserved.
//

import Foundation
import UIKit

//class Sort: UIViewController{
//    
//    let tableView = UITableView()
//    
//    let occasions: [String]?  = nil
//        
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        setTable()
//    }
//    
//    
////    func animate(duration: Int){
////        UIView.animateKeyframes(withDuration: duration, delay: 0, options: .allowUserInteraction, animations: , completion: <#T##((Bool) -> Void)?##((Bool) -> Void)?##(Bool) -> Void#>)
////    }
////
//}
//
//
//extension Sort: UITableViewDelegate, UITableViewDataSource{
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return occasions?.count ?? 0
//    }
//    
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = tableView.dequeueReusableCell(withIdentifier: "SortCell") as! SortCell
//        cell.setCell(index: indexPath.row, occasions: occasions!)
//        return cell
//    }
//    
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        Manager.shared.sortType = occasions![indexPath.row]
//    }
//    
//    func setTable(view: UIViewController){
//        tableView.delegate = self
//        tableView.dataSource = self
//        tableView.separatorColor = .black
////        tableView.frame = CGRect(x: view. , y: <#T##CGFloat#>, width: <#T##CGFloat#>, height: <#T##CGFloat#>)
//        self.view.addSubview(tableView)
//    }
//    
//}
