//
//  ViewController.swift
//  university
//
//  Created by Георгий Куликов on 11.10.2019.
//  Copyright © 2019 Георгий Куликов. All rights reserved.
//

import UIKit

class FilterViewController: UIViewController {
    
    private var presenter = FilterPresenter()
    
    private let constraints = Size()
    private let dataView = FilterViewData()
    
    private let dataSourceCountry = ["Москва", "Санкт-Петербург", "Омск", "Волгоград", "Владимир", "Екатеринбург", "Уфа", "Владивосток"]
    private let dataSourceSubject = ["Математика", "Русский", "Информатика", "Физика"]
    
    private var contentView = UIView()
    private var contentTable = UITableView()
    
    private let countryHeaderTitle: String = "Города"
    private var countryButton = UIDropDownButton()
    
    private let subjectsHeaderTitle: String = "Предметы"
    private var subjectsButton = UIDropDownButton()
    
    private var dataContentTable: [[UIDropDownButton]] = []
    private var dataHeaderTitle: [String] = []
    
    private let pointsSlider = UISlider()
    private let pointsTextField = UITextField()
    
    private let militaryLabel = UILabel()
    private let militaryButton = UISwitch()
    
    private let campusLabel = UILabel()
    private let campusButton = UISwitch()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}
