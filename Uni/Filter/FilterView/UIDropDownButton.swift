//
//  DropDownButton.swift
//  university
//
//  Created by Георгий Куликов on 20.10.2019.
//  Copyright © 2019 Георгий Куликов. All rights reserved.
//

import UIKit

class UIDropDownButton: UIButton, DropDownDelegate {
//    var changeConstraints: ((CGFloat) -> (Void))?
    var dropView = DropDownView()
    var isOpen: Bool = false
    var height = NSLayoutConstraint()
    
    private var constraintHeight: CGFloat = 150
    
    internal func setUpDropView() {
        dropView.frame = CGRect(x: 0, y: 0, width: 0, height: 0)
        
        self.superview?.addSubview(dropView)
        self.superview?.bringSubviewToFront(dropView)
        
        self.dropView.delegate = self
        
        dropView.translatesAutoresizingMaskIntoConstraints = false
    }
    
    internal func dropDownPressed(on title: String) {
        self.setTitle(title, for: .normal)
        self.dismissDropDown()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUpDropView()
    }
    
    init(constraintClosure: @escaping (CGFloat)->(Void)) {
        super.init(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
//        self.changeConstraints = constraintClosure
        setUpDropView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has no been implemented")
    }
    
    override func didMoveToSuperview() {
        self.superview?.addSubview(dropView)
        self.superview?.bringSubviewToFront(dropView)
        
        dropView.topAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        dropView.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        dropView.widthAnchor.constraint(equalTo: self.widthAnchor).isActive = true
        height = dropView.heightAnchor.constraint(equalToConstant: 0)
    }
    
    func dismissDropDown() {
        isOpen = false
        
        NSLayoutConstraint.deactivate([self.height])
        self.height.constant = 0
        NSLayoutConstraint.activate([self.height])
        
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.5, options: .curveEaseIn, animations: {
            self.dropView.center.y -= self.dropView.frame.height / 2
            self.dropView.layoutIfNeeded()
        }, completion: nil)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if !isOpen {
            isOpen = true
//            (changeConstraints ?? {_ in})(constraintHeight)
            
            NSLayoutConstraint.deactivate([self.height])
            
            if self.dropView.tableView.contentSize.height > constraintHeight {
                self.height.constant = constraintHeight
            } else {
                self.height.constant = self.dropView.tableView.contentSize.height
            }
            NSLayoutConstraint.activate([self.height])
            
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.5, options: .curveEaseIn, animations: {
                self.dropView.layoutIfNeeded()
                self.dropView.center.y += self.dropView.frame.height / 2
            }, completion: nil)
        } else {
//            (changeConstraints ?? {_ in})(-constraintHeight)
            self.dismissDropDown()
        }
    }
}
