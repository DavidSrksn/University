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
    
    @IBAction func addToWishlistButton(_ sender: UIButton) {
         Manager.shared.choosed[2] = (Manager.shared.UFD[Manager.shared.choosed[0] as! University]?[Manager.shared.choosed[1] as? Faculty]!)!.first { (department) -> Bool in
            return department.name == self.departmentNameLabel.text
        }
        if Manager.shared.departmentStatus(department:  Manager.shared.choosed[2] as! Department){
            Manager.shared.addToWishlist(sender: sender)
        } else {
            Manager.shared.deleteFromWishlist(sender: sender, setImage: UIImage(systemName: "star")!)
        }
    }
    
    func setDepartmentCell(department: Department){
        setupDepartmentNameLabel(department: department)
        setupDepartmentFullNameLabel(department: department)
        setupAddToWishlistButton(department: department)
    }
    
    func setupDepartmentNameLabel(department: Department){

        departmentNameLabel.translatesAutoresizingMaskIntoConstraints = false
        
        departmentNameLabel.widthAnchor.constraint(greaterThanOrEqualToConstant: 40).isActive = true
        departmentNameLabel.heightAnchor.constraint(equalTo: self.heightAnchor).isActive = true
        departmentNameLabel.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 5).isActive = true
        departmentNameLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 2).isActive = true
        
        departmentNameLabel.font = UIFont(name: "AvenirNext-Regular", size: 20)!
        departmentNameLabel.textAlignment = .center
        
        departmentNameLabel.text = department.name
        
    }
    
    func setupDepartmentFullNameLabel(department: Department){

        departmentFullNameLabel.translatesAutoresizingMaskIntoConstraints = false
        
        departmentFullNameLabel.leftAnchor.constraint(equalTo: departmentNameLabel.rightAnchor, constant: 10).isActive = true
        departmentFullNameLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 2).isActive = true
        departmentFullNameLabel.heightAnchor.constraint(greaterThanOrEqualToConstant: 40).isActive = true
        departmentFullNameLabel.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -60).isActive = true
        
        departmentNameLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor, constant: 0).isActive = true

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
        addToWishlistButtonStatus.leftAnchor.constraint(equalTo: departmentFullNameLabel.rightAnchor, constant: 5).isActive = true
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
