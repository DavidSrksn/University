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
    
    private var filterSettings = Filter(country: nil, subjects: nil, minPoint: nil, military: nil, campus: nil)
    
    private let filterButton = UIButton()
    
//    @IBAction func wishlistButton(_ sender: UIButton) {
//        let viewController = storyboard?.instantiateViewController(identifier: "wishlist") as! WishlistTableView
//        navigationController?.pushViewController(viewController, animated: true)
//    }
    
    private func setupFilterButton() {
        self.navigationController?.view.addSubview(filterButton)
        
        filterButton.frame = CGRect(origin: CGPoint(x: self.view.frame.width - 100, y: self.view.frame.height - 180), size: CGSize(width: 80, height: 80))
        filterButton.layer.cornerRadius = filterButton.frame.width / 2
        filterButton.backgroundColor = UIColor.black
        
        filterButton.addTarget(self, action: #selector(openFilter), for: .touchUpInside)
    }
    
    private func setupNavigationItem() {
        navigationItem.title = "University"
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
        let searchField = UITextField()
        
        navigationItem.titleView = searchField
    }
    
    private func reloadData() {
        let city: String? = self.filterSettings.country ?? "Moscow"
        let subjects: [String]? = self.filterSettings.subjects ?? ["математика","русский", "физика"]
        let minPoints: Int? = self.filterSettings.minPoint ?? 200
        let dormitory: Bool? = self.filterSettings.campus ?? true
        let militaryDepartment: Bool? = self.filterSettings.military ?? true
        
        if Manager.shared.UFD.keys.count == 0 {
            view.showAnimatedGradientSkeleton()
            
//          let gradient = SkeletonGradient(baseColor: .alizarin, secondaryColor: .alizarin)
//          let animation = SkeletonAnimationBuilder().makeSlidingAnimation(withDirection: .leftRight)
//          view.showAnimatedGradientSkeleton(usingGradient: gradient, animation: animation, transition: .none)
//          navigationController?.view.showAnimatedGradientSkeleton(usingGradient: gradient, animation: animation, transition: .none)
            
            Manager.shared.loadUniversities(limit: Int.max , city: city, subjects: subjects, minPoints: minPoints, dormitory: dormitory, militaryDepartment: militaryDepartment, completion: { [weak self] in
                DispatchQueue.main.async{
                self?.tableView.reloadData()
                self?.view.hideSkeleton()
                }
            })
        }
        
        Manager.shared.dataUFD = Manager.shared.UFD;
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
        
        tableView.dataSource = self
        tableView.delegate = self
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        filterButton.isHidden = true
    }
    
    @objc private func openFilter() {
        let filterController = FilterViewController()
        navigationController?.pushViewController(filterController, animated: true)
    }
    
    @objc private func search() {
        navigationItem.rightBarButtonItem?.tintColor = .clear
        navigationItem.rightBarButtonItem?.isEnabled = false
        
        navigationItem.leftBarButtonItem?.isEnabled = true
        navigationItem.leftBarButtonItem?.tintColor = .white
    }
    
    @objc private func endSearching() {
        navigationItem.rightBarButtonItem?.isEnabled = true
        navigationItem.rightBarButtonItem?.tintColor = .white
        
        navigationItem.leftBarButtonItem?.tintColor = .clear
        navigationItem.leftBarButtonItem?.isEnabled = false
    }
}

extension TableViewUniversities :  SkeletonTableViewDataSource, SkeletonTableViewDelegate{
    
    func collectionSkeletonView(_ skeletonView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
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






//        db.collection("Universities").addDocument(data: ["name":"МГТУ","dormitory": true]).collection("МГТУfaculties").addDocument(data: ["name":"РК","minPoints": 150])
//        db.collection("Universities").document("6CvTvBl7wcwcMrUW1d6C").collection("МГТУfaculties").addDocument(data: ["name":"ИУ","minPoints": 98])
