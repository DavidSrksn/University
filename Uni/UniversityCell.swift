//
//  UniversityCell.swift
//  Uni
//
//  Created by David Sarkisyan on 08/10/2019.
//  Copyright © 2019 DavidS & that's all. All rights reserved.
//

import UIKit

class UniversityCell: UITableViewCell {

    
    @IBOutlet weak var universityImage: UIImageView!
    
    @IBOutlet weak var universityLabel: UILabel!
    
    func setUniversityCell(university: University){
        self.universityImage.image = UIImage(named: "\(university.name).jpg")
        self.universityLabel.text = university.name
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(false, animated: false)

    }

}
