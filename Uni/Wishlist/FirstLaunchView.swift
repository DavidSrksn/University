//
//  FirstLaunchView.swift
//  Uni
//
//  Created by David Sarkisyan on 07.11.2019.
//  Copyright © 2019 DavidS & that's all. All rights reserved.
//

import UIKit
import paper_onboarding
import CircleMenu
import QuartzCore

final class FirstLaunchView: UIViewController, PaperOnboardingDataSource, PaperOnboardingDelegate,CircleMenuDelegate {

    @IBOutlet weak var getStartedButton: UIButton!
    @IBOutlet weak var onboardingView: OnboardingView!
    
    @IBAction func getStartedButtonAction(_ sender: UIButton) {
        let userDefaults = UserDefaults.standard
        userDefaults.set(true, forKey: "Onboarding Complete")
        userDefaults.synchronize()
    }
    
    let circleButton = CircleMenu(
            frame: CGRect(origin:  CGPoint(x: 180, y: 250), size: CGSize(width: 70, height: 70)),
            normalIcon:"icon_menu",
            selectedIcon:"icon_close",
            buttonsCount: 2,
            duration: 2,
            distance: 150)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        onboardingView.dataSource = self
        onboardingView.delegate = self
    }
    
    
    func onboardingItemsCount() -> Int {
        return 4
    }
    
    func onboardingItem(at index: Int) -> OnboardingItemInfo {
        let backgroundColourOne = UIColor(red: 217/256, green: 72/256, blue: 89/256, alpha: 1)
        let backgroundColourTwo = UIColor(red: 106/256, green: 166/256, blue: 211/256, alpha: 1)
        let backgroundColourThree = UIColor(red: 168/256, green: 200/256, blue: 78/256, alpha: 1)
        
        let titleFont = UIFont(name: "AvenirNext-Bold", size: 24)!
        let descriptionFont = UIFont(name: "AvenirNext-Regular", size: 18)!
        
        let transparentImage =  UIImageView(image: UIImage(named: "Transparent.jpg"))
        
        return[OnboardingItemInfo(informationImage: UIImage(named: "МГТУ.jpg")!, title: "Выбери университет на свой вкус", description: "Выбери университет, основываясь на личных требованиях и предпочтениях", pageIcon: transparentImage.image!, color: backgroundColourOne, titleColor: UIColor.white, descriptionColor: UIColor.white, titleFont: titleFont, descriptionFont: descriptionFont),
            OnboardingItemInfo(informationImage: UIImage(named: "МФТИ.jpg")!, title: "Test", description: "Test", pageIcon: transparentImage.image!, color: backgroundColourTwo, titleColor: UIColor.white, descriptionColor: UIColor.white, titleFont: titleFont, descriptionFont: descriptionFont),
            OnboardingItemInfo(informationImage: UIImage(named: "РУДН.jpg")!, title: "Testing", description: "Плохой альбом", pageIcon: transparentImage.image!, color: backgroundColourThree, titleColor: UIColor.white, descriptionColor: UIColor.white, titleFont: titleFont, descriptionFont: descriptionFont),
            OnboardingItemInfo(informationImage: transparentImage.image!, title: "Выбери свои предпочтения", description: "черная - технарь \n белая - гумманитарий \n (пример)", pageIcon: transparentImage.image!, color: .carrot, titleColor: UIColor.white, descriptionColor: UIColor.white, titleFont: titleFont, descriptionFont: descriptionFont)
            ][index]
    }

    func onboardingConfigurationItem(_: OnboardingContentViewItem, index _: Int) {
        
    }
    
    func onboardinPageItemRadius() -> CGFloat {
        return CGFloat(integerLiteral: 5)
    }
    
    func onboardingPageItemSelectedRadius() -> CGFloat {
        return CGFloat(integerLiteral: 10)
    }
    
    func onboardingWillTransitonToIndex(_ index: Int) {
        if index != 3{
        if Manager.shared.preference == nil{
        if self.getStartedButton.alpha == 1{
            UIView.animate(withDuration: 0.4) {
                           self.getStartedButton.alpha = 0
                       }
              }
            }
        }
        UIView.animate(withDuration: 0.3) {
        self.circleButton.alpha = 0
        }
    }
    
    func onboardingDidTransitonToIndex(_ index: Int) {
        if index == 3{
       circleButton.backgroundColor = .midnightBlue
       circleButton.delegate = self
       circleButton.layer.cornerRadius = circleButton.frame.size.width / 2
       circleButton.center = self.view.center
            circleButton.titleLabel?.text = "f(x)"
            circleButton.titleLabel?.textColor = .black
       self.view.addSubview(circleButton)
       UIView.animate(withDuration: 0.3) {
        self.circleButton.alpha = 1
     }
    }
    }
    
    func circleMenu(_ circleMenu: CircleMenu, willDisplay button: UIButton, atIndex: Int) {
        if atIndex == 1{
            button.backgroundColor = .black
            button.setImage(UIImage(systemName: "book"), for: .normal)
        } else{
            button.backgroundColor = .white
            button.setTitle("f(x)", for: .normal)
            button.setTitleColor(.black, for: .normal)
//            button.setImage(UIImage(named: "laptop"), for: .normal)
        }
}
    
    func circleMenu(_ circleMenu: CircleMenu, buttonDidSelected button: UIButton, atIndex: Int) {
        if atIndex == 1{
        Manager.shared.preference = "Гуманитарий"
        }else{
            Manager.shared.preference = "Технарь"
        }
        circleButton.setTitle(button.titleLabel!.text, for: .normal)
        UIView.animate(withDuration: 0.5) {
        self.getStartedButton.alpha = 1
        }
        self.view.reloadInputViews()
        print("preferenc - \(Manager.shared.preference)")
    }
}
