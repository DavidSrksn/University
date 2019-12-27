//
//  UniversityCell.swift
//  Uni
//
//  Created by David Sarkisyan on 08/10/2019.
//  Copyright © 2019 DavidS & that's all. All rights reserved.
//

import UIKit

final class UniversityCell: UITableViewCell {

    let imageViewWidth: CGFloat = 130 // Задаем ширину картинки
    
    var universityImage = UIImageView()
    
    var universityLabel = UILabel()
    
    func setupUniversityCell(university: University){
        setupUniversityImage(university: university)
        setupUniversityLabel(university: university)
    }
    
    func setupUniversityImage(university: University){
        self.addSubview(universityImage)
        
        let image = UIImage(named: "\(university.name).jpg")
        
        let heightRatio = CGFloat((image?.size.height)!) / CGFloat((image?.size.width)!)
        
        universityImage.translatesAutoresizingMaskIntoConstraints = false
        
        universityImage.centerXAnchor.constraint(equalTo: self.rightAnchor, constant: -imageViewWidth/2).isActive = true
        
        if heightRatio >= 1{
            universityImage.heightAnchor.constraint(equalTo: self.heightAnchor, constant: -5).isActive = true
            universityImage.widthAnchor.constraint(equalToConstant: imageViewWidth / heightRatio).isActive = true
        }else{
            universityImage.widthAnchor.constraint(equalToConstant: imageViewWidth).isActive = true
            universityImage.heightAnchor.constraint(equalToConstant: imageViewWidth * heightRatio).isActive = true
        }
        
        universityImage.layer.cornerRadius = 15
        universityImage.image = image
        
    }
    
    func setupUniversityLabel(university: University){
        
        self.addSubview(universityLabel)
        
        self.universityLabel.numberOfLines = 0
        
        universityLabel.translatesAutoresizingMaskIntoConstraints = false
        
        universityLabel.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 5).isActive = true
        universityLabel.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -imageViewWidth).isActive = true
        universityLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 2).isActive = true
        universityLabel.heightAnchor.constraint(greaterThanOrEqualToConstant: 40).isActive = true
        
        universityLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        universityImage.centerYAnchor.constraint(equalTo: universityLabel.centerYAnchor, constant: 0).isActive = true
        
        universityLabel.textColor = .black
        universityLabel.layer.cornerRadius = 15
        universityLabel.font = UIFont(name: "AvenirNext-Regular", size: 20)
        universityLabel.textAlignment = .center
        self.universityLabel.text = university.fullName
        
    }
    
      override func awakeFromNib() {
          super.awakeFromNib()
          
      }

      override func setSelected(_ selected: Bool, animated: Bool) {
          super.setSelected(false, animated: false)
      }
    
}
