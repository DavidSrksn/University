//
//  FacultyCellTableViewCell.swift
//  Uni
//
//  Created by David Sarkisyan on 10/10/2019.
//  Copyright © 2019 DavidS & that's all. All rights reserved.
//

import UIKit

final class FacultyCell: UITableViewCell {

    @IBOutlet weak var facultyLabel: UILabel!
    @IBOutlet weak var facultyFullNameLabel: UILabel!
    
    func setFacultyCell(faculty: Faculty){
        self.facultyLabel.text = faculty.name
        self.facultyFullNameLabel.text = faculty.fullName
       }
       
       
       override func awakeFromNib() {
           super.awakeFromNib()
           
       }

       override func setSelected(_ selected: Bool, animated: Bool) {
           super.setSelected(selected, animated: animated)

       }
}
