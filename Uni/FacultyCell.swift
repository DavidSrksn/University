//
//  FacultyCellTableViewCell.swift
//  Uni
//
//  Created by David Sarkisyan on 10/10/2019.
//  Copyright © 2019 DavidS & that's all. All rights reserved.
//

import UIKit

final class FacultyCell: UITableViewCell {

    var facultyLabel = UILabel()
    var facultyFullNameLabel = UILabel()
    
    func setFacultyCell(faculty: Faculty){
        setupFacultyLabel(faculty: faculty)
        setupFacultyFullNameLabel(faculty: faculty)
       }
       
       
    func setupFacultyLabel(faculty: Faculty) {
        self.addSubview(facultyLabel)
        
        facultyLabel.translatesAutoresizingMaskIntoConstraints = false
        
        facultyLabel.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 8).isActive = true
        facultyLabel.heightAnchor.constraint(equalTo: self.heightAnchor, constant: -10).isActive = true
        facultyLabel.widthAnchor.constraint(greaterThanOrEqualToConstant: 10).isActive = true

        facultyLabel.font = UIFont(name: "AvenirNext-Bold", size: 20)!
        self.facultyLabel.text = faculty.name
    }
    
    func setupFacultyFullNameLabel(faculty: Faculty){
        self.addSubview(facultyFullNameLabel)
        
        facultyFullNameLabel.numberOfLines = 0

        facultyFullNameLabel.translatesAutoresizingMaskIntoConstraints = false
        
        facultyFullNameLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 2).isActive = true
        facultyFullNameLabel.leftAnchor.constraint(equalTo: facultyLabel.rightAnchor, constant: 30).isActive = true
        facultyFullNameLabel.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -2).isActive = true
        facultyFullNameLabel.heightAnchor.constraint(greaterThanOrEqualToConstant: 50).isActive = true
        
        facultyFullNameLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        facultyLabel.centerYAnchor.constraint(equalTo: facultyFullNameLabel.centerYAnchor).isActive = true // Центрирование
        
        facultyFullNameLabel.font = UIFont(name: "AvenirNext-Regular", size: 17)!
        self.facultyFullNameLabel.text = faculty.fullName
    }
    
    
       override func awakeFromNib() {
           super.awakeFromNib()
           
       }

       override func setSelected(_ selected: Bool, animated: Bool) {
           super.setSelected(selected, animated: animated)

       }
}
