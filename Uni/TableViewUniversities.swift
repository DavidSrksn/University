//
//  TableViewController1ViewController.swift
//  Uni
//
//  Created by David Sarkisyan on 09/10/2019.
//  Copyright © 2019 DavidS & that's all. All rights reserved.
//

import UIKit
import Firebase
import SkeletonView


class TableViewUniversities: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    var warning = UILabel()
    
    private var filterSettings = Filter(country: nil, subjects: nil, minPoint: nil, military: nil, campus: nil)
    
    private let filterButton = UIButton()
    
    private let searchField = UISearchBar()
    private let searchTitle = UILabel()
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    private func setupFilterButton() {
        self.navigationController?.view.addSubview(filterButton)
        
        filterButton.frame = CGRect(origin: CGPoint(x: self.view.frame.width - 100, y: self.view.frame.height - 180), size: CGSize(width: 80, height: 80))
        filterButton.layer.cornerRadius = filterButton.frame.width / 2
        filterButton.backgroundColor = UIColor.black
        
        filterButton.addTarget(self, action: #selector(openFilter), for: .touchUpInside)
    }
    
    private func setupNavigationItem() {
        searchTitle.text = "University"
        searchTitle.textColor = .white
        searchTitle.font = UIFont(name: "Baskerville-Bold", size: 24)
        
        navigationItem.titleView = searchTitle
    }
    
    private func setupSearchButton() {
        let searchButton = UIBarButtonItem(barButtonSystemItem: .search, target: self, action: #selector(search))
        searchButton.tintColor = .white
        navigationItem.rightBarButtonItem = searchButton
    }
    
    private func setupEndSearchingButton() {
        let endSearchingButton = UIBarButtonItem(barButtonSystemItem: .stop, target: self, action: #selector(endSearching))
        endSearchingButton.tintColor = .clear
        endSearchingButton.isEnabled = false
        navigationItem.leftBarButtonItem = endSearchingButton
    }
    
    private func setupSearchField() {
        searchField.placeholder = "Введите университет"
        
        if let textField = searchField.value(forKey: "searchField") as? UITextField {
            textField.textColor = .white
        }
        
        searchField.delegate = self
        searchField.isHidden = false
    }
    
    private func reloadData() {
        if  Manager.shared.flagFilterChanged {
            view.isSkeletonable = true
            view.showAnimatedGradientSkeleton()
//          let gradient = SkeletonGradient(baseColor: .alizarin, secondaryColor: .alizarin)
//          let animation = SkeletonAnimationBuilder().makeSlidingAnimation(withDirection: .leftRight)
//          view.showAnimatedGradientSkeleton(usingGradient: gradient, animation: animation, transition: .none)
//          navigationController?.view.showAnimatedGradientSkeleton(usingGradient: gradient, animation: animation, transition: .none)
            Manager.shared.loadUniversities(tableView: self.tableView, wanrningLabel: warning, viewcontroller: self, city: Manager.shared.filterSettings.country, subjects: Manager.shared.filterSettings.subjects , minPoints: Manager.shared.filterSettings.minPoint, dormitory: Manager.shared.filterSettings.campus, militaryDepartment: Manager.shared.filterSettings.campus, completion: { [weak self] in
                DispatchQueue.main.async{
                    Manager.shared.dataUFD = Manager.shared.UFD
                    self?.tableView.reloadData()
                    self?.view.hideSkeleton()
                }
            })
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        filterButton.isHidden = false
    }
    
    override func viewDidAppear(_ animated: Bool) {
        Manager.shared.internetConnectionCheck(viewcontroller: self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNavigationItem()
        setupSearchButton()
        setupEndSearchingButton()
        setupSearchField()
        
        setupFilterButton()
        
        reloadData()
        setTable()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        filterButton.isHidden = true
    }
  
    func setTable(){
        self.title = "University"
        tableView.dataSource = self
        tableView.delegate = self
        tableView.estimatedRowHeight = 68
        tableView.rowHeight = 150 //UITableView.automaticDimension
        tableView.separatorInset = .zero
    }
    
    @objc private func openFilter() {
        let filterController = FilterViewController()
        navigationController?.pushViewController(filterController, animated: true)
    }
    
    @objc private func search() {
        navigationItem.titleView = searchField
        
        navigationItem.rightBarButtonItem = nil
        
        navigationItem.leftBarButtonItem?.isEnabled = true
        navigationItem.leftBarButtonItem?.tintColor = .white
    }
    
    @objc private func endSearching() {
        navigationItem.titleView = searchTitle
        
        setupSearchButton()
        
        navigationItem.leftBarButtonItem?.tintColor = .clear
        navigationItem.leftBarButtonItem?.isEnabled = false
    }
}

extension TableViewUniversities :  SkeletonTableViewDataSource, SkeletonTableViewDelegate{
    
    func collectionSkeletonView(_ skeletonView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
    func collectionSkeletonView(_ skeletonView: UITableView, cellIdentifierForRowAt indexPath: IndexPath) -> ReusableCellIdentifier {
        return "UniversityCell"
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Manager.shared.UFD.keys.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let university = Array(Manager.shared.UFD.keys)[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "UniversityCell") as! UniversityCell
        cell.setUniversityCell(university: university)
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            Manager.shared.choosed[0] = Array(Manager.shared.UFD.keys)[indexPath.row]
            let viewController = storyboard?.instantiateViewController(identifier: "факультет") as! FacultiesTableView
            navigationController?.pushViewController(viewController, animated: true)
        }
}

extension TableViewUniversities: UISearchBarDelegate {
    
    // called when text changes (including clear)
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if (searchText == "") {
            Manager.shared.UFD = Manager.shared.dataUFD
        } else {
            Manager.shared.UFD = Manager.shared.dataUFD.filter {
                return $0.key.fullName.contains(searchText)
            }
        }
        tableView.reloadData()
    }
}





//        db.collection("Universities").addDocument(data: ["name":"МГТУ","dormitory": true]).collection("МГТУfaculties").addDocument(data: ["name":"РК","minPoints": 150])
//        db.collection("Universities").document("6CvTvBl7wcwcMrUW1d6C").collection("МГТУfaculties").addDocument(data: ["name":"ИУ","minPoints": 98])
