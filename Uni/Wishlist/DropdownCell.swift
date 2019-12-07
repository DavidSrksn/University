//
//  DropdownCell.swift
//  Uni
//
//  Created by David Sarkisyan on 26.11.2019.
//  Copyright © 2019 DavidS & that's all. All rights reserved.
//

import Foundation
import UIKit
import MapKit
import CoreLocation

class DropdownCell: UITableViewCell{
    
    var cellExists: Bool = false
    
    @IBOutlet weak var open: UIButton!
    
    @IBOutlet weak var subjectsLabel: UILabel!
    
    @IBOutlet weak var followers: UILabel!
    
    @IBAction func deleteButton(_ sender: UIButton){
        
        do {
            try Manager.shared.realm.write {
                Manager.shared.realm.delete(Manager.shared.realm.objects(WishlistObject.self).filter("departmentName = '\((self.departmentNameLabel.text)!)'"))
            }
        } catch{
            print(error.localizedDescription)
        }
        Manager.shared.notificationCentre.post(Notification(name: Notification.Name(rawValue: "Department Deleted")))
        Manager.shared.queue.async(execute: Manager.shared.workItem)
    }
    
    @IBOutlet weak var deleteButton: UIButton!
    
    @IBOutlet weak var mapButtonOutlet: UIButton!
    
    @IBAction func mapButton(_ sender: UIButton) {
        
    }
    
    @IBOutlet weak var openView: UIView!
    
    @IBOutlet weak var departmentNameLabel: UILabel!
    
    @IBOutlet weak var universityName: UILabel!
    
    @IBOutlet weak var view: UIView!{
        didSet{
            view.isHidden = true
            view.alpha = 0
        }
    }
    
    func animate(duration:Double, c: @escaping () -> Void) {
        UIView.animateKeyframes(withDuration: duration, delay: 0, options: .calculationModePaced, animations: {
            UIView.addKeyframe(withRelativeStartTime: 0, relativeDuration: duration, animations: {
                self.view.isHidden = !self.view.isHidden
                if self.view.alpha == 1 {
                    self.view.alpha = 0.5
                } else {
                    self.view.alpha = 1
                }
            })
        }, completion: {  (finished: Bool) in
            c()
        })
    }
    
    func setWishlistCell(universityName: String, departmentName:String, firstSubject: String, secondSubject: String, thirdSubject: String, cell: UITableViewCell) {
        cell.preservesSuperviewLayoutMargins = false
        cell.separatorInset = UIEdgeInsets.zero
        cell.layoutMargins = UIEdgeInsets.zero
        setDeleteButton(cell: cell)
        setMapButton()
        setDepartmentLable(departmentName: departmentName)
        setUniversityName(universityName: universityName)
        setOpenView(cell: cell)
        setView(cell: cell)
        setSubjects(firstSubject: firstSubject, secondSubject: secondSubject, thirdSubject: thirdSubject)
        setFollowersLabel(departmentName: departmentName, followersCount: 2)
        open.setTitle("", for: .normal)
        
    }
    
    func setDeleteButton(cell: UITableViewCell){
        deleteButton.frame = CGRect(x: view.bounds.maxX - deleteButton.frame.size.width*2/3 , y: view.bounds.maxY - deleteButton.frame.size.height*1/2, width: mapButtonOutlet.frame.size.width, height: mapButtonOutlet.frame.size.height)
        deleteButton.layer.cornerRadius = 2
        deleteButton.setTitle("Удалить", for: .normal)
        deleteButton.setTitleColor(.black, for: .normal)
        deleteButton.backgroundColor = UIColor.alizarin
    }
    
    func setDepartmentLable(departmentName: String){
        self.departmentNameLabel.text = departmentName
        departmentNameLabel.textColor = UIColor.white
    }
    
    func setOpenView(cell: UITableViewCell){
        openView.frame = cell.bounds
        openView.layer.masksToBounds = true
        openView.translatesAutoresizingMaskIntoConstraints = false
        openView.frame = CGRect(x: cell.bounds.origin.x, y: cell.bounds.origin.y, width: cell.bounds.size.width, height: cell.bounds.size.height)
        self.openView.backgroundColor = .darkGray
    }
    
    func setView(cell: UITableViewCell){
        view.layer.masksToBounds = true
//        view.layer.cornerRadius = 15
        openView.translatesAutoresizingMaskIntoConstraints = false
        view.frame = CGRect(x: openView.frame.minX, y: openView.frame.maxY, width: cell.bounds.size.width - 8, height: 210)
        view.frame.size.width = openView.frame.size.width
        self.view.backgroundColor = #colorLiteral(red: 0.7747164369, green: 0.9268901944, blue: 0.880443871, alpha: 1)
    }
    
    func setUniversityName(universityName: String){
        self.universityName.text = universityName
    }
    
    func setMapButton() {
        mapButtonOutlet.frame = CGRect(x: deleteButton.frame.origin.x - 120 - 40, y: deleteButton.frame.origin.y , width: 150, height: 50)
        mapButtonOutlet.layer.masksToBounds = true
        mapButtonOutlet.layer.cornerRadius = 2
        mapButtonOutlet.backgroundColor = UIColor(red: 106/256, green: 166/256, blue: 211/256, alpha: 1)
        mapButtonOutlet.setTitle("Построить маршрут", for: .normal)
        mapButtonOutlet.setTitleColor(.black, for: .normal)
        mapButtonOutlet.titleLabel?.font = UIFont(name: "AvenirNext-Regular", size: 15)
    }
    
    func setSubjects(firstSubject: String, secondSubject: String, thirdSubject: String) {
        subjectsLabel.backgroundColor = view.backgroundColor
        subjectsLabel.numberOfLines = 4
        subjectsLabel.font = UIFont(name: "AvenirNext-Regular", size: 15)
        subjectsLabel.textColor = .black
        subjectsLabel.text = "Предметы:\n\(firstSubject)\n\(secondSubject)\n\(thirdSubject)"
        subjectsLabel.frame = CGRect(x: 10, y: 10, width: 150, height: 200)
    }
    
    func setFollowersLabel(departmentName: String,followersCount: Int){
        followers.backgroundColor = view.backgroundColor
        followers.font = UIFont(name: "AvenirNext-Regular", size: 15)
        var textColor = UIColor()
        if followersCount == 0{
                   textColor = .red
               }else if followersCount == 1 {
                   textColor = .darkGray
               }else{
                   textColor = .black
               }
        let atributedString =  NSMutableAttributedString(string: "Подписчиков : \(followersCount)")
        let firstAttributes: [NSAttributedString.Key: Any] = [
            .foregroundColor: UIColor.black,
            .backgroundColor: view.backgroundColor!]
        let secondAttributes: [NSAttributedString.Key: Any] = [
            .foregroundColor: textColor,
            .backgroundColor: view.backgroundColor!]
        atributedString.addAttributes(firstAttributes, range: NSRange(location: 0, length: 13))
        atributedString.addAttributes(secondAttributes, range: NSRange(location: 13, length: 2))
        followers.attributedText = atributedString
        followers.frame = CGRect(x: universityName.frame.minX + subjectsLabel.bounds.width + 10, y: universityName.frame.maxY + 10, width: 150, height: 20)
    }
    
//    func openMaps(adress: String) {
//        let geocoder = CLGeocoder()
//        let str = adress // A string of the address info you already have
//        geocoder.geocodeAddressString(str) { (placemarksOptional, error) -> Void in
//          if let placemarks = placemarksOptional {
//            print("placemark| \(String(describing: placemarks.first))")
//            if let location = placemarks.first?.location {
//              let query = "?ll=\(location.coordinate.latitude),\(location.coordinate.longitude)"
//              let path = "http://maps.apple.com/" + query
//              if let url = NSURL(string: path) {
//                UIApplication.shared.open(url as URL, options: nil, completionHandler: nil)              } else {
//                // Could not construct url. Handle error.
//              }
//            } else {
//              // Could not get a location from the geocode request. Handle error.
//            }
//          } else {
//            // Didn't get any placemarks. Handle error.
//          }
//        }
//    }
//
    override func awakeFromNib() {
    }
    
}
