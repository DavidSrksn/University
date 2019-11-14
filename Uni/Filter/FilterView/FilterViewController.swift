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
    
    private func setupPointsSlider() {
        pointsSlider.frame = CGRect(x: 0, y: 0, width: 0, height: 0)
        
        pointsSlider.minimumValue = 0
        if let countSubjects = presenter.countOfSubjects() {
            pointsSlider.maximumValue = Float(countSubjects * 100)
        } else {
            pointsSlider.maximumValue = 100
        }
        
        pointsSlider.isContinuous = true
        pointsSlider.addTarget(self, action: #selector(changePoints), for: .valueChanged)
        
        contentView.addSubview(pointsSlider)
        
        pointsSlider.translatesAutoresizingMaskIntoConstraints = false
        
        pointsSlider.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: constraints.safeAreaBorder).isActive = true
        pointsSlider.topAnchor.constraint(equalTo: self.view.topAnchor, constant: constraints.pointsSliderY).isActive = true
        pointsSlider.widthAnchor.constraint(equalToConstant: self.view.center.x * 2 - constraints.safeAreaBorder * 2).isActive = true
        pointsSlider.heightAnchor.constraint(equalToConstant: constraints.pointsSliderHeight).isActive = true
    }
    
    private func setupPointsTextField() {
        pointsTextField.frame = CGRect(x: 0, y: 0, width: 0, height: 0)
        
        pointsTextField.layer.cornerRadius = 10
        pointsTextField.layer.borderColor = UIColor.black.cgColor
        pointsTextField.layer.borderWidth = 1
        
        pointsTextField.placeholder = " Минимальный балл "
        pointsTextField.contentHorizontalAlignment = .left
        
        pointsTextField.delegate = self
        
        contentView.addSubview(pointsTextField)
        
        pointsTextField.translatesAutoresizingMaskIntoConstraints = false
        pointsTextField.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: constraints.safeAreaBorder).isActive = true
        pointsTextField.topAnchor.constraint(equalTo: self.view.topAnchor, constant: constraints.pointsTextFieldY).isActive = true
        pointsTextField.heightAnchor.constraint(equalToConstant: constraints.pointsTextFieldHeight).isActive = true
    }
    
    private func setupPoints() {
        setupPointsSlider()
        setupPointsTextField()
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

extension FilterViewController: UITextFieldDelegate {
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if var num = Int(textField.text ?? "non num") {
            num = (Float(num) - pointsSlider.maximumValue) > .ulpOfOne ? 300 : num
            num = num < 0 ? 0 : num
            pointsSlider.value = Float(num)
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
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

