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
//  MainViewController.swift
//  LBBottomSheet-Demo
//
//  Created by Lunabee Studio / Date - 22/10/2021 - for the LBBottomSheet-Demo Swift Package.
//

import UIKit
import LBBottomSheet

final class MainViewController: CVTableViewController {
    override var prefersStatusBarHidden: Bool { true }
    override var prefersHomeIndicatorAutoHidden: Bool { true }

    private let didFinishLoading: (_ headerImageView: UIImageView?) -> ()
    private weak var headerImageView: UIImageView?

    init(didFinishLoading: @escaping (_ headerImageView: UIImageView?) -> ()) {
        self.didFinishLoading = didFinishLoading
        super.init(style: .plain)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        initBackground()
        reloadUI()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            self.didFinishLoading(self.headerImageView)
        }
    }

    override func createRows() -> [CVRow] {
        makeRows {
            headerImageRow()
            headerTextRow()
            heightDemoCasesRow()
            menuRowsForEntries(demoCases())
            swiftSectionRow()
            infoRows()
        }
    }

    private func initBackground() {
        let backgroundImageView: UIImageView = UIImageView(image: UIImage(named: "mountains"))
        backgroundImageView.contentMode = .scaleAspectFill
        let blurView: UIVisualEffectView
        if #available(iOS 13, *) {
            blurView = UIVisualEffectView(effect: UIBlurEffect(style: .systemUltraThinMaterial))
        } else {
            blurView = UIVisualEffectView(effect: UIBlurEffect(style: .regular))
        }
        let backgroundView: UIView = UIView(frame: UIScreen.main.bounds)
        backgroundView.addConstrainedSubview(backgroundImageView)
        backgroundView.addConstrainedSubview(blurView)
        tableView.backgroundView = backgroundView
    }

    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        if #available(iOS 12, *) {
            guard previousTraitCollection?.userInterfaceStyle != traitCollection.userInterfaceStyle else { return }
            reloadUI()
        }
    }
}

private extension MainViewController {
    func headerImageRow() -> CVRow {
        let imageWidth: CGFloat = UIScreen.main.bounds.width - 2.0 * 90.0 // 90.0 is the imageView leading contraint value in the launchscreen.
        return CVRow(image: UIImage(named: "PackageIcon"),
                     xibName: .imageCell,
                     theme: CVRow.Theme(topInset: 20.0,
                                        bottomInset: 0.0,
                                        imageSize: CGSize(width: imageWidth, height: imageWidth)),
                     willDisplay: { [weak self] cell in
            cell.clipsToBounds = false
            cell.contentView.clipsToBounds = false
            self?.headerImageView = cell.cvImageView
            self?.headerImageView?.layer.shadowColor = UIColor.black.cgColor
            self?.headerImageView?.layer.shadowRadius = 4.0
            self?.headerImageView?.layer.shadowOpacity = 0.8
            self?.headerImageView?.layer.shadowOffset = .zero
            self?.headerImageView?.clipsToBounds = false
        })
    }

    func headerTextRow() -> CVRow {
        CVRow(title: "LBBottomSheet",
              xibName: .textCell,
              theme: CVRow.Theme(topInset: 10.0,
                                 bottomInset: 15.0,
                                 textAlignment: .center,
                                 titleFont: { UIFont.systemFont(ofSize: 30.0, weight: .semibold) }))
    }

    func heightDemoCasesRow() -> CVRow {
        sectionRow(title: "📱 Demo cases 📱")
    }

    func infoRows() -> [CVRow] {
        let menuEntries: [MenuEntry] = [
            MenuEntry(title: "Repository",
                      subtitle: "GitHub - LBBottomSheet",
                      isInverted: true,
                      actionBlock: { [weak self] in
                          guard let self = self else { return }
                          let githubAppUrl: URL = URL(string: "github://")!
                          URL(string: "https://github.com/LunabeeStudio/LBBottomSheet")?.openInSafari(inApp: UIApplication.shared.canOpenURL(githubAppUrl),
                                                                                                      from: self)
                      }),
            MenuEntry(title: "Documentation",
                      subtitle: "LBBottomSheet Swift API documentation",
                      isInverted: true,
                      actionBlock: { [weak self] in
                          guard let self = self else { return }
                          URL(string: "https://lbbottomsheet.lunabee.studio/documentation/lbbottomsheet")?.openInSafari(from: self)
                      }),
            MenuEntry(title: "Author",
                      subtitle: "The iOS team at Lunabee Studio",
                      isInverted: true,
                      actionBlock: { [weak self] in
                          guard let self = self else { return }
                          URL(string: "https://www.lunabee.studio")?.openInSafari(from: self)
                      }),
            MenuEntry(title: "License",
                      subtitle: "LBBottomSheet is available under the Apache 2.0 license. See the LICENSE file for more info.",
                      isInverted: true,
                      actionBlock: { [weak self] in
                          guard let self = self else { return }
                          URL(string: "https://github.com/LunabeeStudio/LBBottomSheet/blob/master/LICENSE")?.openInSafari(from: self)
                      })
        ]
        return menuRowsForEntries(menuEntries)
    }

    func sectionRow(title: String, topInset: CGFloat = 20.0) -> CVRow {
        var row: CVRow = standardCardRow(title: title, topInset: topInset, bottomInset: 8.0)
        row.theme.titleFont = { UIFont.systemFont(ofSize: 20.0, weight: .semibold) }
        row.theme.textAlignment = .center
        return row
    }

    func swiftSectionRow() -> CVRow {
        CVRow(title: "Information",
              image: UIImage(named: "swift"),
              xibName: .swiftSectionCell,
              theme:  CVRow.Theme(backgroundColor: .blurContainerBackground,
                                  topInset: 40.0,
                                  bottomInset: 0.0,
                                  leftInset: Appearance.Cell.leftMargin,
                                  rightInset: Appearance.Cell.leftMargin,
                                  textAlignment: .center,
                                  titleFont: { UIFont.systemFont(ofSize: 20.0, weight: .semibold) },
                                  maskedCorners: .all))
    }

    func menuRowsForEntries(_ entries: [MenuEntry]) -> [CVRow] {
        let rows: [CVRow] = entries.map {
            var row: CVRow = standardCardRow(title: $0.title, subtitle: $0.subtitle, isInverted: $0.isInverted, actionBlock: $0.actionBlock)
            if $0 == entries.first || $0.isHeader {
                row.theme.topInset = 8.0
                row.theme.maskedCorners = .top
                row.theme.separatorLeftInset = 2.0 * Appearance.Cell.leftMargin
                row.theme.separatorRightInset = Appearance.Cell.leftMargin
                if $0.isHeader {
                    row.theme.textAlignment = .center
                    row.theme.titleFont = { UIFont.systemFont(ofSize: 20.0, weight: .semibold) }
                }
            } else if $0 == entries.last || $0.isFooter {
                row.theme.maskedCorners = .bottom
            } else {
                row.theme.maskedCorners = .none
                row.theme.separatorLeftInset = 2.0 * Appearance.Cell.leftMargin
                row.theme.separatorRightInset = Appearance.Cell.leftMargin
            }
            return row
        }
        return rows
    }

    func standardCardRow(title: String, subtitle: String? = nil, topInset: CGFloat = 0.0, bottomInset: CGFloat = 0.0, isInverted: Bool = false, maskedCorners: CACornerMask = .all, actionBlock: (() -> ())? = nil) -> CVRow {
        let standardFont: UIFont = UIFont.systemFont(ofSize: 17.0)
        let smallFont: UIFont = UIFont.systemFont(ofSize: 13.0)
        let subtitleColor: UIColor
        if #available(iOS 13, *) {
            subtitleColor = isInverted ? .label : .secondaryLabel
        } else {
            subtitleColor = .black
        }
        let row: CVRow = CVRow(title: title,
                               subtitle: subtitle,
                               xibName: isInverted ? .invertedCardCell : .cardCell,
                               theme:  CVRow.Theme(backgroundColor: .blurContainerBackground,
                                                   topInset: topInset,
                                                   bottomInset: bottomInset,
                                                   leftInset: Appearance.Cell.leftMargin,
                                                   rightInset: Appearance.Cell.leftMargin,
                                                   textAlignment: .natural,
                                                   titleFont: { isInverted ? smallFont : standardFont },
                                                   subtitleFont: { isInverted ? standardFont : smallFont },
                                                   subtitleColor: subtitleColor,
                                                   maskedCorners: maskedCorners),
                               selectionAction: actionBlock == nil ? nil : {
            actionBlock?()
        })
        return row
    }
}

private extension MainViewController {
    func demoCases() -> [MenuEntry] {
        var fitContentEntries: [MenuEntry] = [
            MenuEntry(title: "Fit content",
                      isHeader: true,
                      subtitle: """
                                The bottom sheet will have a height matching the embedded controller.
                                You can see in the documentation how to customize this behavior.
                                """)
        ]
        fitContentEntries.append(contentsOf: DemoTestCaseFactory.fitContent.map { testCase in
            MenuEntry(title: testCase.menuTitle) { [weak self] in
                let behavior: BottomSheetController.Behavior = testCase.behavior()
                let positionDelegate: BottomSheetPositionDelegate? = behavior.forwardEventsToRearController ? self : nil
                self?.presentAsBottomSheet(DemoViewController(demoTitle: testCase.title,
                                                              explanations: testCase.explanations,
                                                              codeUrl: testCase.codeUrl),
                                           positionDelegate: positionDelegate,
                                           theme: testCase.theme(),
                                           behavior: testCase.behavior())
            }
        })
        var lastEntry: MenuEntry = fitContentEntries.removeLast()
        lastEntry.isFooter = true
        fitContentEntries.append(lastEntry)

        var freeEntries: [MenuEntry] = [
            MenuEntry(title: "Free",
                      isHeader: true,
                      subtitle: """
                                The bottom sheet will have a height between a minimum and a maximum given values.
                                Between these values, the bottom sheet will remain where the user releases it.
                                """)
        ]
        freeEntries.append(contentsOf: DemoTestCaseFactory.free.map { testCase in
            MenuEntry(title: testCase.menuTitle) { [weak self] in
                let behavior: BottomSheetController.Behavior = testCase.behavior()
                let positionDelegate: BottomSheetPositionDelegate? = behavior.forwardEventsToRearController ? self : nil
                self?.presentAsBottomSheet(DemoViewController(demoTitle: testCase.title,
                                                              explanations: testCase.explanations,
                                                              codeUrl: testCase.codeUrl),
                                           positionDelegate: positionDelegate,
                                           theme: testCase.theme(),
                                           behavior: testCase.behavior())
            }
        })
        lastEntry = freeEntries.removeLast()
        lastEntry.isFooter = true
        freeEntries.append(lastEntry)

        var specificEntries: [MenuEntry] = [
            MenuEntry(title: "Specific",
                      isHeader: true,
                      subtitle: """
                                The bottom sheet will have a list of heights to define multiple possible positions.
                                When the user releases the bottom sheet, the nearest heightvalue will be used to update the bottom sheet height.
                                """)
        ]
        specificEntries.append(contentsOf: DemoTestCaseFactory.specific.map { testCase in
            MenuEntry(title: testCase.menuTitle) { [weak self] in
                var behavior: BottomSheetController.Behavior = testCase.behavior()
                behavior.bottomSheetAnimationConfiguration = .init(duration: 0.6,
                                                                   damping: 0.8,
                                                                   velocity: 0.5,
                                                                   options: [.curveEaseInOut])
                let positionDelegate: BottomSheetPositionDelegate? = behavior.forwardEventsToRearController ? self : nil
                self?.presentAsBottomSheet(DemoViewController(demoTitle: testCase.title,
                                                              explanations: testCase.explanations,
                                                              codeUrl: testCase.codeUrl),
                                           positionDelegate: positionDelegate,
                                           bottomSheetInteractionDelegate: self,
                                           theme: testCase.theme(),
                                           behavior: behavior)
            }
        })
        lastEntry = specificEntries.removeLast()
        lastEntry.isFooter = true
        specificEntries.append(lastEntry)
        return fitContentEntries + freeEntries + specificEntries
    }
}

extension MainViewController: BottomSheetPositionDelegate {
    func bottomSheetPositionDidUpdate(y: CGFloat) {
        tableView.contentInset.bottom = tableView.frame.height - y
    }
}

extension MainViewController: BottomSheetInteractionDelegate {
    func bottomSheetInteractionDidTapOutside() {
        print("Did tap dimming background")
    }
}
