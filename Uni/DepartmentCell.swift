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
             Manager.shared.semaphore.signal()
            return department.name == self.departmentNameLabel.text
        }
        Manager.shared.semaphore.wait()
        if Manager.shared.departmentStatus(department:  Manager.shared.choosed[2] as! Department){
            Manager.shared.addToWishlist(sender: sender)
        } else {
            Manager.shared.deleteFromWishlist(sender: sender, setImage: UIImage(systemName: "star")!)
        }
//        switch sender.currentImage {
//            case UIImage(systemName: "plus"):
//                sender.setImage(UIImage(systemName: "minus")?.withTintColor(.red), for: .normal)
//            case UIImage(systemName: "minus"):
//                sender.setImage(UIImage(systemName: "plus")?.withTintColor(.red), for: .normal)
//            default:
//                print("default")
//                print("hhhh\(sender.currentImage)")
//        }
    }
    func setDepartmentCell(department: Department){
        self.departmentNameLabel.text = department.name
           self.departmentFullNameLabel.text = department.fullName
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
