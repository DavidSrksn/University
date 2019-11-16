//
//  dropDownDelegate.swift
//  university
//
//  Created by Георгий Куликов on 27.10.2019.
//  Copyright © 2019 Георгий Куликов. All rights reserved.
//

import UIKit


protocol DropDownDelegate {
    var dropView: DropDownView { get set }
    var changeConstraints: ((_ y: CGFloat)->(Void))? { get set }
    
    func setUpDropView()
    
    func dropDownPressed(on title: String)
    
    func dismissDropDown()
}
