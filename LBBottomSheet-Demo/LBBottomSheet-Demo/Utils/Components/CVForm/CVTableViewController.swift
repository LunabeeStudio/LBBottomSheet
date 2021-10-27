//  Copyright © 2021 Lunabee Studio
//
//  Licensed under the Apache License, Version 2.0 (the "License");
//  you may not use this file except in compliance with the License.
//  You may obtain a copy of the License at
//
//    http://www.apache.org/licenses/LICENSE-2.0
//
//  Unless required by applicable law or agreed to in writing, software
//  distributed under the License is distributed on an "AS IS" BASIS,
//  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//  See the License for the specific language governing permissions and
//  limitations under the License.
//
//  CVTableViewController.swift
//  LBBottomSheet-Demo
//
//  Created by Lunabee Studio / Date - 22/10/2021 - for the LBBottomSheet-Demo Swift Package.
//

import UIKit

class CVTableViewController: UITableViewController {

    var rows: [CVRow] = []
    private var cellHeights: [IndexPath: CGFloat] = [:]

    override func viewDidLoad() {
        super.viewDidLoad()
        addHeaderView()
        addFooterView()
        tableView.showsVerticalScrollIndicator = false
        tableView.backgroundColor = UIColor(named: "cardTableViewBackground")
    }
    
    func createRows() -> [CVRow] { [] }
    func makeRows(@CVRowsBuilder _ content: () -> [CVRow]) -> [CVRow] { content() }

    func reloadUI(animated: Bool = false, animatedView: UIView? = nil, completion: (() -> ())? = nil) {
        rows = createRows()
        registerXibs()
        if #available(iOS 13.0, *) {
            if animated {
                UIView.transition(with: animatedView ?? tableView, duration: 0.2, options: [.transitionCrossDissolve], animations: {
                    self.tableView.reloadData()
                }) { _ in
                    completion?()
                }
            } else {
                tableView.reloadData()
                completion?()
            }
        } else {
            tableView.reloadData()
            completion?()
        }
    }
    
    func rowObject(at indexPath: IndexPath) -> CVRow {
        rows[indexPath.row]
    }

    private func registerXibs() {
        var xibNames: Set<String> = Set<String>()
        rows.forEach { xibNames.insert($0.xibName.rawValue) }
        xibNames.forEach{ tableView.register(UINib(nibName: $0, bundle: nil), forCellReuseIdentifier: $0) }
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int { 1 }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        rows.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let row: CVRow = rowObject(at: indexPath)
        let identifier: String = row.xibName.rawValue
        let cell: CVTableViewCell = tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath) as! CVTableViewCell
        cell.setup(with: row)
        cell.layoutSubviews()
        return cell
    }
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cellHeights[indexPath] = cell.frame.size.height
        guard let cell = cell as? CVTableViewCell else { return }
        let row: CVRow = rowObject(at: indexPath)
        row.willDisplay?(cell)
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let row: CVRow = rowObject(at: indexPath)
        row.selectionAction?()
    }
    
    override func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        cellHeights[indexPath] ?? UITableView.automaticDimension
    }


    override func accessibilityPerformEscape() -> Bool {
        if let navigationController = navigationController, navigationController.viewControllers.first !== self {
            navigationController.popViewController(animated: true)
        } else {
            dismiss(animated: true)
        }
        return true
    }
    
}

// MARK: - Header/Bottom View Management-
extension CVTableViewController {
    func addHeaderView(height: CGFloat = 0.0) {
        tableView.tableHeaderView = UIView(frame: CGRect(x: 0.0, y: 0.0, width: 0.0, height: height))
    }

    func addFooterView(height: CGFloat = 20.0) {
        tableView.tableFooterView = UIView(frame: CGRect(x: 0.0, y: 0.0, width: 0.0, height: height))
    }
}
