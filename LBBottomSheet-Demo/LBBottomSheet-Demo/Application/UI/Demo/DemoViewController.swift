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
//  DemoViewController.swift
//  LBBottomSheet-Demo
//
//  Created by Lunabee Studio / Date - 26/10/2021 - for the LBBottomSheet-Demo Swift Package.
//

import UIKit
import LBBottomSheet

final class DemoViewController: CVTableViewController {

    private let demoTitle: String
    private let explanations: String
    private let codeUrl: URL?

    init(demoTitle: String, explanations: String, codeUrl: URL?) {
        self.demoTitle = demoTitle
        self.explanations = explanations
        self.codeUrl = codeUrl
        super.init(style: .plain)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        initTableView()
        reloadUI()
    }

    override func createRows() -> [CVRow] {
        makeRows {
            titleRow()
            explanationsRow()
            if codeUrl != nil { codeUrlRow() }
        }
    }

    private func initTableView() {
        let isGrabberBackgroundTranslucent: Bool = bottomSheetController?.theme.grabber?.background.isTranslucent ?? true
        let headerHeight: CGFloat = isGrabberBackgroundTranslucent ? bottomSheetController?.topInset ?? 0.0 : 0.0
        addHeaderView(height: headerHeight)
        tableView.backgroundColor = .tableViewBackground
    }
}

private extension DemoViewController {
    func titleRow() -> CVRow {
        CVRow(title: demoTitle,
              xibName: .textCell,
              theme: CVRow.Theme(backgroundColor: .clear,
                                 topInset: 0.0,
                                 bottomInset: 15.0,
                                 textAlignment: .center,
                                 titleFont: { UIFont.systemFont(ofSize: 30.0, weight: .semibold) }))
    }

    func explanationsRow() -> CVRow {
        let subtitleColor: UIColor
        if #available(iOS 13, *) {
            subtitleColor = .label
        } else {
            subtitleColor = .black
        }
        return CVRow(subtitle: explanations,
                     xibName: .textCell,
                     theme:  CVRow.Theme(backgroundColor: .clear,
                                         topInset: 0.0,
                                         bottomInset: 0.0,
                                         leftInset: Appearance.Cell.leftMargin,
                                         rightInset: Appearance.Cell.leftMargin,
                                         textAlignment: .natural,
                                         subtitleColor: subtitleColor))
    }

    func codeUrlRow() -> CVRow {
        CVRow(title: "See configuration code",
              image: UIImage(named: "swift"),
              xibName: .swiftSectionCell,
              theme:  CVRow.Theme(backgroundColor: .buttonBackground,
                                  topInset: 20.0,
                                  bottomInset: 0.0,
                                  leftInset: Appearance.Cell.leftMargin,
                                  rightInset: Appearance.Cell.leftMargin,
                                  textAlignment: .center,
                                  maskedCorners: .all),
              selectionAction: { [weak self] in
            guard let self = self else { return }
            let githubAppUrl: URL = URL(string: "github://")!
            self.codeUrl?.openInSafari(inApp: UIApplication.shared.canOpenURL(githubAppUrl), from: self)
        })
    }
}
