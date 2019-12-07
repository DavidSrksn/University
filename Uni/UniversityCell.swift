//
//  UniversityCell.swift
//  Uni
//
//  Created by David Sarkisyan on 08/10/2019.
//  Copyright © 2019 DavidS & that's all. All rights reserved.
//

import UIKit

final class UniversityCell: UITableViewCell {

    
    var universityImage = UIImageView()
    
    var universityLabel = UILabel()
    
    func setUniversityCell(university: University){
        setUniversityLabel(university: university)
        setUniversityImage(university: university)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(false, animated: false)
    }
    
    func setUniversityImage(university: University){
        let image = UIImage(named: "\(university.name).jpg")
        let widthRatio = Float((image?.size.width)!) / Float((image?.size.height)!)
        let heightRatio = Float((image?.size.height)!) / Float((image?.size.width)!)
        self.addSubview(universityImage)
        
        if widthRatio >= 1{
             universityImage.frame = CGRect(x: self.bounds.maxX - universityImage.bounds.width, y: self.bounds.minY , width: self.bounds.width * 2/6, height: CGFloat(100/widthRatio))
        }else{
            universityImage.frame = CGRect(x: self.bounds.maxX - universityImage.bounds.width, y: self.bounds.minY , width: CGFloat((Float(self.bounds.width) * 2/6)/heightRatio), height: (image?.size.height)!)
        }
        universityImage.center = CGPoint(x: self.bounds.maxX - universityImage.bounds.width/2, y: self.bounds.maxY/2)
        universityImage.layer.cornerRadius = 15
        universityImage.image = image

    }
    
    func setUniversityLabel(university: University){
        self.universityLabel.numberOfLines = 0
        universityLabel.font = UIFont(name: "AvenirNext-Regular", size: 20)
        self.universityLabel.text = university.fullName
        universityLabel.frame = CGRect(x: self.bounds.minX + 8, y: self.bounds.minY, width: self.bounds.width * 3.5/6, height: 10)
        universityLabel.textColor = .black
        self.universityLabel.sizeToFit()
        universityLabel.layer.cornerRadius = 50
        universityLabel.center = CGPoint(x: self.bounds.minX + universityLabel.bounds.width/2 + 8, y: self.bounds.height/2)
//        universityLabel.lineBreakMode = .byWordWrapping
        self.addSubview(universityLabel)
    }
    
}
