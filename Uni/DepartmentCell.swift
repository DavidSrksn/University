//
//  DepartmentCell.swift
//  Uni
//
//  Created by David Sarkisyan on 13/10/2019.
//  Copyright © 2019 DavidS & that's all. All rights reserved.
//

import UIKit

final class DepartmentCell: UITableViewCell {

    @IBOutlet weak var addToWishlistButtonStatus: UIButton!
    @IBOutlet weak var departmentNameLabel: UILabel!
    @IBOutlet weak var departmentFullNameLabel: UILabel!
    var minPointsLabel = UILabel()
    var subjectsDifferenceLabel = UILabel()
    
    var followersLabel = UILabel()
    
    @IBAction func addToWishlistButton(_ sender: UIButton) {
         Manager.shared.choosed[2] = (Manager.shared.UFD[Manager.shared.choosed[0] as! University]?[Manager.shared.choosed[1] as? Faculty]!)!.first { (department) -> Bool in
            return department.fullName == self.departmentFullNameLabel.text
        }
        if Manager.shared.departmentStatus(department:  Manager.shared.choosed[2] as! Department){
            Manager.shared.addToWishlist(sender: sender)
        } else {
            Manager.shared.deleteFromWishlist(sender: sender, setImage: UIImage(systemName: "star")!, departmentFullName: (Manager.shared.choosed[2] as! Department).fullName)
        }
    }
    
    func setDepartmentCell(department: Department){
        setupDepartmentNameLabel(department: department)
        setupAddToWishlistButton(department: department)
        setupMinPoints(department: department)
        setupFollowersLabel(department: department)
        setupDepartmentFullNameLabel(department: department)
        setupSubjectsDifferenceLabel(department: department)
        setupMinPoints(department: department)
    }
    
    
    func setupSubjectsDifferenceLabel(department: Department){
        self.addSubview(subjectsDifferenceLabel)
        
        subjectsDifferenceLabel.translatesAutoresizingMaskIntoConstraints = false

        subjectsDifferenceLabel.topAnchor.constraint(equalTo: departmentFullNameLabel.bottomAnchor, constant: 5).isActive = true
        subjectsDifferenceLabel.leftAnchor.constraint(equalTo: departmentNameLabel.leftAnchor).isActive = true
        subjectsDifferenceLabel.widthAnchor.constraint(equalToConstant: 170).isActive = true
        subjectsDifferenceLabel.heightAnchor.constraint(equalToConstant: 20 ).isActive = true
        
        subjectsDifferenceLabel.font = UIFont(name: "AvenirNext-Regular", size: 15)!
        subjectsDifferenceLabel.text = "ПРИВЕТ"
//        subjectsDifferenceLabel.attributedText = findDifferenеSubjects(department: department)
    }
    
//    func findDifferenеSubjects(department: Department)-> NSAttributedString?{
//        var result: NSMutableAttributedString?
//
//        var subjectsDifference: String
//        var lastLetter = 0
//
//        let positiveDifference: [NSAttributedString.Key: Any] = [
//            .foregroundColor:  UIColor(red: 255/256, green: 0, blue: 0, alpha: 1),
//            .backgroundColor: self.backgroundColor!]
//        let negativesecondAttributes: [NSAttributedString.Key: Any] = [
//            .foregroundColor: UIColor(red: 0, green: 128/256, blue: 0, alpha: 1),
//            .backgroundColor: self.backgroundColor!]
//
////        result?.addAttributes(firstAttributes, range: NSRange(location: 0, length: 1))
////        result?.addAttributes(secondAttributes, range: NSRange(location: 13, length: 1))
////
//        if Manager.shared.filterSettings.subjects != nil{
//            for subject in Manager.shared.filterSettings!.subjects{
//                if !department.subjects.contains(subject){
//                    result += subject
//                }
//            }
//        } else{
//            department.subjects.forEach { (subject) in
//                result NSMutableAttributedString(string: "+ \(subject)" )
//            }
//        }
//
//        if result != nil{
//            return result!
//        } else{ return NSAttributedString(string: "")}
//    }
    
    func setupMinPoints(department: Department){
        self.addSubview(minPointsLabel)
        
        minPointsLabel.translatesAutoresizingMaskIntoConstraints = false
        
        minPointsLabel.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        minPointsLabel.topAnchor.constraint(equalTo: subjectsDifferenceLabel.bottomAnchor).isActive = true
        minPointsLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        minPointsLabel.widthAnchor.constraint(equalToConstant: 170).isActive = true
        
        minPointsLabel.font = UIFont(name: "AvenirNext-Regular", size: 15)!
        minPointsLabel.textColor = .black
        minPointsLabel.text = "Проходной балл: \(department.minPoints)"
    }
    
    func setupDepartmentNameLabel(department: Department){

        departmentNameLabel.translatesAutoresizingMaskIntoConstraints = false
        
        departmentNameLabel.widthAnchor.constraint(greaterThanOrEqualToConstant: 50).isActive = true
        departmentNameLabel.heightAnchor.constraint(equalToConstant: 40).isActive = true
        departmentNameLabel.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 5).isActive = true
        departmentNameLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 2).isActive = true
        
        departmentNameLabel.font = UIFont(name: "AvenirNext-Regular", size: 20)!
        departmentNameLabel.textAlignment = .center
        
        departmentNameLabel.text = department.name
        
    }
    
    func setupFollowersLabel(department: Department){
         
        addToWishlistButtonStatus.addSubview(followersLabel)
        
        followersLabel.translatesAutoresizingMaskIntoConstraints = false
        
        followersLabel.topAnchor.constraint(equalTo: addToWishlistButtonStatus.imageView!.topAnchor, constant: 5).isActive = true
        followersLabel.bottomAnchor.constraint(equalTo: addToWishlistButtonStatus.bottomAnchor).isActive = true
        followersLabel.widthAnchor.constraint(equalTo: addToWishlistButtonStatus.widthAnchor).isActive = true
        followersLabel.centerXAnchor.constraint(equalTo: addToWishlistButtonStatus.centerXAnchor).isActive = true
        
//        followersLabel.topAnchor.constraint(equalTo: minPointsLabel.topAnchor).isActive = true
//        followersLabel.bottomAnchor.constraint(equalTo:minPointsLabel.bottomAnchor).isActive = true
//        followersLabel.widthAnchor.constraint(equalTo: addToWishlistButtonStatus.widthAnchor).isActive = true
//        followersLabel.centerXAnchor.constraint(equalTo: addToWishlistButtonStatus.centerXAnchor).isActive = true
//
        followersLabel.font = UIFont(name: "AvenirNext-Regular", size: 15)!
        followersLabel.textAlignment = .center
        
        followersLabel.text = "\(department.followers)"
        
        NetworkManager.shared.listenFollowers(universityName: (Manager.shared.choosed[0] as? University)!.name, facultyFullName: (Manager.shared.choosed[1] as? Faculty)!.fullName, departmentFullName: department.fullName) { (followers) in
            self.followersLabel.text = "\(followers)"
            if Int(self.followersLabel.text ?? "1") != 0{
                self.followersLabel.textColor = UIColor(red: 0, green: 128/256, blue: 0, alpha: 1)
            }else{
                self.followersLabel.textColor = UIColor(red: 255/256, green: 0, blue: 0, alpha: 1)
            }
        }
    }
    
    func setupDepartmentFullNameLabel(department: Department){

        departmentFullNameLabel.translatesAutoresizingMaskIntoConstraints = false
        
        departmentFullNameLabel.leftAnchor.constraint(equalTo: departmentNameLabel.rightAnchor, constant: 10).isActive = true
        departmentFullNameLabel.topAnchor.constraint(equalTo: departmentNameLabel.topAnchor).isActive = true
        departmentFullNameLabel.heightAnchor.constraint(greaterThanOrEqualToConstant: 50).isActive = true
        departmentFullNameLabel.rightAnchor.constraint(equalTo: addToWishlistButtonStatus.leftAnchor).isActive = true
        
//        departmentNameLabel.centerYAnchor.constraint(equalTo: departmentFullNameLabel.centerYAnchor).isActive = true // Ровняем  по высоте (для удобства)
        
        departmentFullNameLabel.numberOfLines = 0
        departmentFullNameLabel.font = UIFont(name: "AvenirNext-Regular", size: 18)!
        departmentFullNameLabel.textColor = .black
        departmentFullNameLabel.textAlignment = .center
        departmentFullNameLabel.text = department.fullName

    }
    
    func setupAddToWishlistButton(department: Department) {
        
        addToWishlistButtonStatus.translatesAutoresizingMaskIntoConstraints = false
        
        addToWishlistButtonStatus.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -5).isActive = true
        addToWishlistButtonStatus.topAnchor.constraint(equalTo: self.topAnchor, constant: 2).isActive = true
        addToWishlistButtonStatus.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -2).isActive = true
        addToWishlistButtonStatus.widthAnchor.constraint(equalToConstant: 40).isActive = true
        addToWishlistButtonStatus.centerYAnchor.constraint(equalTo: self.centerYAnchor, constant: 0).isActive = true
        
        if !Manager.shared.departmentStatus(department: department){
            self.addToWishlistButtonStatus.setImage(UIImage(systemName: "star.fill"), for: .normal)
        }
        else{
            self.addToWishlistButtonStatus.setImage(UIImage(systemName: "star"), for: .normal)
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
