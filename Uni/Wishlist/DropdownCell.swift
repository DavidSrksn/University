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
    
    let leftConstraint: CGFloat = 5
    
    @IBOutlet weak var open: UIButton!
    
    @IBOutlet weak var subjectsLabel: UILabel!
    
    @IBOutlet weak var followers: UILabel!
    
    @IBAction func deleteButton(_ sender: UIButton){
        
        do {
            try Manager.shared.realm.write {
                Manager.shared.realm.delete(Manager.shared.realm.objects(RealmWishlistObject.self).filter("departmentName = '\((self.departmentNameLabel.text)!)'"))
            }
        } catch{
            print(error.localizedDescription)
        }
        Manager.shared.notificationCentre.post(Notification(name: Notification.Name(rawValue: "Department Deleted")))
        Manager.shared.wishlistQueue.async(execute: Manager.shared.workItem)
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
    
    func setWishlistCell(universityName: String, departmentName:String, subjects: [String?], cell: UITableViewCell) {
        
        cell.preservesSuperviewLayoutMargins = false
        cell.separatorInset = UIEdgeInsets.zero
        cell.layoutMargins = UIEdgeInsets.zero
        
        setDeleteButton(cell: cell)
        setMapButton()
        setDepartmentLable(departmentName: departmentName)
        setUniversityName(universityName: universityName)
        setOpenView(cell: cell)
        setView(cell: cell)
        setSubjects(subjects: subjects)
        setFollowersLabel(departmentName: departmentName, followersCount: 2)
        
        open.setTitle("", for: .normal)
    }
    
    func setDeleteButton(cell: UITableViewCell){
        deleteButton.layer.cornerRadius = 5
        deleteButton.setTitle("Удалить", for: .normal)
        deleteButton.setTitleColor(.black, for: .normal)
        deleteButton.backgroundColor = UIColor.alizarin
        
        deleteButton.translatesAutoresizingMaskIntoConstraints = false
        
        deleteButton.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        deleteButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        deleteButton.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        deleteButton.widthAnchor.constraint(equalToConstant: 100).isActive = true
        
    }
    
    func setDepartmentLable(departmentName: String){
        
//        departmentNameLabel.translatesAutoresizingMaskIntoConstraints = false

//        departmentNameLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 2).isActive = true
//        departmentNameLabel.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -5).isActive = true
//        departmentNameLabel.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 5).isActive = true
//        departmentNameLabel.bottomAnchor.constraint(greaterThanOrEqualTo: self.bottomAnchor, constant: -2 ).isActive = true
        
//        departmentNameLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        
        departmentNameLabel.numberOfLines = 0
        departmentNameLabel.textAlignment = .center
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
//        openView.translatesAutoresizingMaskIntoConstraints = false

//        view.translatesAutoresizingMaskIntoConstraints = false
        
        
        
        view.frame = CGRect(x: openView.frame.minX, y: openView.frame.maxY, width: cell.bounds.size.width - 8, height: 210)
        view.frame.size.width = openView.frame.size.width
        self.view.backgroundColor = #colorLiteral(red: 0.7747164369, green: 0.9268901944, blue: 0.880443871, alpha: 1)
    }
    
    func setUniversityName(universityName: String){
        self.universityName.text = universityName
    }
    
    func setMapButton() {
        mapButtonOutlet.layer.cornerRadius = 5
        mapButtonOutlet.backgroundColor = UIColor(red: 106/256, green: 166/256, blue: 211/256, alpha: 1)
        mapButtonOutlet.setTitle("Построить маршрут", for: .normal)
        mapButtonOutlet.setTitleColor(.black, for: .normal)
        mapButtonOutlet.titleLabel?.font = UIFont(name: "AvenirNext-Regular", size: 15)
        
        mapButtonOutlet.translatesAutoresizingMaskIntoConstraints = false
        
        mapButtonOutlet.topAnchor.constraint(equalTo: deleteButton.topAnchor).isActive = true
        mapButtonOutlet.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        mapButtonOutlet.rightAnchor.constraint(equalTo: deleteButton.leftAnchor, constant: -10).isActive = true
        mapButtonOutlet.widthAnchor.constraint(equalToConstant: 150).isActive = true
    }
    
    func setSubjects(subjects: [String?]) {
        subjectsLabel.backgroundColor = view.backgroundColor
        subjectsLabel.numberOfLines = 4
        subjectsLabel.font = UIFont(name: "AvenirNext-Regular", size: 15)
        subjectsLabel.textColor = .black
        subjectsLabel.text = {(subjects: [String?])->String in
            var text: String = "Предметы:"
            for string in  subjects{
                if string != nil{
                    text.append("\n\(string!)")
                }
            }
            return text
        }(subjects)

        subjectsLabel.translatesAutoresizingMaskIntoConstraints = false

        subjectsLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: leftConstraint).isActive = true
        subjectsLabel.topAnchor.constraint(equalTo: universityName.bottomAnchor, constant: 10).isActive = true
        subjectsLabel.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 5).isActive = true
        subjectsLabel.widthAnchor.constraint(equalToConstant: 150).isActive = true
    }
    
    func setFollowersLabel(departmentName: String,followersCount: Int){
        followers.backgroundColor = view.backgroundColor
        followers.font = UIFont(name: "AvenirNext-Regular", size: 15)
        var textColor = UIColor()
        if followersCount == 0{
                   textColor = .red
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
        
        followers.translatesAutoresizingMaskIntoConstraints = false
        
        followers.topAnchor.constraint(equalTo: universityName.bottomAnchor, constant: 5).isActive = true
        followers.leftAnchor.constraint(equalTo: subjectsLabel.rightAnchor, constant: 10).isActive = true
        followers.widthAnchor.constraint(equalToConstant: 150).isActive = true
        followers.heightAnchor.constraint(equalToConstant: 20).isActive = true
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
