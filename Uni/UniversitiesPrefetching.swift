//
//  UniversitiesPrefetching.swift
//  Uni
//
//  Created by Георгий Куликов on 17.11.2019.
//  Copyright © 2019 DavidS & that's all. All rights reserved.
//

import UIKit

extension TableViewUniversities: UITableViewDataSourcePrefetching {
    

    func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
        print("\(indexPaths)")
            for indexPath in indexPaths {
//                if let _ = loadingOperation[indexPath] { return }
//                if let dataLoader = dataSource.loadImage(at: indexPath.row) {
//                    loadingQueue.addOperation(dataLoader)
//                    loadingOperation[indexPath] = dataLoader
//                }
            }
        }

        func tableView(_ tableView: UITableView, cancelPrefetchingForRowsAt indexPaths: [IndexPath]) {
            for indexPath in indexPaths {
//                if let dataLoader = loadingOperation[indexPath] {
//                    dataLoader.cancel()
//                    loadingOperation.removeValue(forKey: indexPath)
//                }
            }
        }
}
