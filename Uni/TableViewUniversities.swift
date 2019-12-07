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


final class TableViewUniversities: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    var warning = UILabel()
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    @IBOutlet weak var warningLabel: UILabel!
    private func setupFilterButton() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Фильтры", style: .done, target: self, action: #selector(openFilter))
    }
    
        
    private func reloadData() {
//        if Manager.shared.UFD.keys.count == 0{
        if  Manager.shared.flagFilterChanged {
            view.isSkeletonable = true
            view.showAnimatedGradientSkeleton()
//          let gradient = SkeletonGradient(baseColor: .alizarin, secondaryColor: .alizarin)
//          let animation = SkeletonAnimationBuilder().makeSlidingAnimation(withDirection: .leftRight)
//          view.showAnimatedGradientSkeleton(usingGradient: gradient, animation: animation, transition: .none)
//          navigationController?.view.showAnimatedGradientSkeleton(usingGradient: gradient, animation: animation, transition: .none)
            
            Manager.shared.loadUniversities(tableView: self.tableView, wanrningLabel: warning, viewcontroller: self, city: Manager.shared.filterSettings.country, subjects: Manager.shared.filterSettings.subjects , minPoints: Manager.shared.filterSettings.minPoint, dormitory: Manager.shared.filterSettings.campus, militaryDepartment: Manager.shared.filterSettings.campus, completion: { [weak self] in
                DispatchQueue.main.async{
                self?.tableView.reloadData()
                self?.view.hideSkeleton()
                }
            })
       }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
//        self.filterSettings = Manager.shared.loadFilterSettings()
//        reloadData()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        Manager.shared.internetConnectionCheck(viewcontroller: self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupFilterButton()
        reloadData()
        setTable()
    }
    
    @objc
    private func openFilter() {
        let filterController = FilterViewController()
        self.present(filterController, animated: true, completion: nil)
    }
    
    func setTable(){
        self.title = "University"
        tableView.dataSource = self
        tableView.delegate = self
        tableView.estimatedRowHeight = 68
        tableView.rowHeight = 150 //UITableView.automaticDimension
        tableView.separatorInset = .zero
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






//        db.collection("Universities").addDocument(data: ["name":"МГТУ","dormitory": true]).collection("МГТУfaculties").addDocument(data: ["name":"РК","minPoints": 150])
//        db.collection("Universities").document("6CvTvBl7wcwcMrUW1d6C").collection("МГТУfaculties").addDocument(data: ["name":"ИУ","minPoints": 98])

