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
    
    private func setupCountry(country: UIDropDownButton) {
        country.frame = CGRect(x: 0, y: 0, width: 0, height: 0)
        country.backgroundColor = dataView.FilterDropDownColor
        country.setTitle("Город", for: .normal)
        country.layer.cornerRadius = dataView.cornerRadius
        
        country.translatesAutoresizingMaskIntoConstraints = false
        
        country.widthAnchor.constraint(equalToConstant: self.view.center.x * 2 - constraints.safeAreaBorder).isActive = true
        
        country.dropView.dropDownOptions = dataSourceCountry
    }
    
    private func setupSubjects(subject: UIDropDownButton) {
        subject.frame = CGRect(x: 0, y: 0, width: 0, height: 0)
        subject.backgroundColor = dataView.FilterDropDownColor
        subject.setTitle("Предметы", for: .normal)
        subject.layer.cornerRadius = dataView.cornerRadius
        
        subject.translatesAutoresizingMaskIntoConstraints = false
        
        subject.widthAnchor.constraint(equalToConstant: self.view.center.x * 2 - constraints.safeAreaBorder).isActive = true
        
        subject.dropView.dropDownOptions = dataSourceSubject
    }
    
    private func setupDataContentTable() {
        view.addSubview(contentTable)
        
        dataContentTable.append([])
        dataContentTable.append([])
        pushCountry()
        pushSubject()
        
        dataHeaderTitle.append(countryHeaderTitle)
        dataHeaderTitle.append(subjectsHeaderTitle)
        
        contentTable.translatesAutoresizingMaskIntoConstraints = false
        
        contentTable.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        contentTable.topAnchor.constraint(equalTo: self.view.topAnchor, constant: constraints.countryButtonY).isActive = true
        contentTable.widthAnchor.constraint(equalToConstant: self.view.center.x * 2 - constraints.safeAreaBorder).isActive = true
        contentTable.heightAnchor.constraint(equalToConstant: constraints.countryButtonHeight * 4).isActive = true
        
        contentTable.delegate = self
        contentTable.dataSource = self
    }
    
    private func setupContentView() {
        view.addSubview(contentView)
        
        contentView.frame = CGRect(x: 0, y: 0, width: 0, height: 0)
        
        contentView.translatesAutoresizingMaskIntoConstraints = false
        
        contentView.topAnchor.constraint(equalTo: view.topAnchor, constant: constraints.contentViewY).isActive = true
        contentView.heightAnchor.constraint(equalToConstant: constraints.contentViewHeight).isActive = true
        contentView.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
    }
    
    private func setupPoints() {
        
    }
    
    private func setupMilitary() {
        
    }
    
    private func setupCampus() {
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = dataView.FilterViewColor
        
        setupContentView()
        
        setupPoints()
        setupMilitary()
        setupCampus()
        
        setupDataContentTable()
    }
    
    @objc
    private func pushCountry() {
        let countryButton = UIDropDownButton()
        setupCountry(country: countryButton)
        
        dataContentTable[0].append(countryButton)
    }
    
    private func popCountry() {
        dataContentTable[0].removeLast()
    }
    
    @objc
    private func pushSubject() {
        let subjectButton = UIDropDownButton()
        setupSubjects(subject: subjectButton)
        
        dataContentTable[1].append(subjectButton)
    }
    
    private func popSubject() {
        dataContentTable[1].removeLast()
    }
}

extension FilterViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataContentTable[section].count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        cell.addSubview(dataContentTable[indexPath.section][indexPath.row])
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return dataHeaderTitle[section]
    }
}

extension FilterViewController: UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return dataContentTable.count
    }
}

