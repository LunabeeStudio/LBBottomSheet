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
//  CVRow.swift
//  LBBottomSheet-Demo
//
//  Created by Lunabee Studio / Date - 22/10/2021 - for the LBBottomSheet-Demo Swift Package.
//

import UIKit

struct CVRow {

    struct Theme {
        var backgroundColor: UIColor?
        var topInset: CGFloat?
        var bottomInset: CGFloat?
        var leftInset: CGFloat?
        var rightInset: CGFloat?
        var textAlignment: NSTextAlignment = .center
        var titleFont: (() -> UIFont) = { UIFont.systemFont(ofSize: 17.0) }
        var titleColor: UIColor = .titleColor
        var titleLinesCount: Int?
        var subtitleFont: (() -> UIFont) = { UIFont.systemFont(ofSize: 15.0) }
        var subtitleColor: UIColor = .subtitleColor
        var subtitleLinesCount: Int?
        var accessoryTextFont: (() -> UIFont?)?
        var accessoryTextColor: UIColor = .accessoryColor
        var imageTintColor: UIColor?
        var imageSize: CGSize?
        var imageRatio: CGFloat?
        var separatorLeftInset: CGFloat?
        var separatorRightInset: CGFloat?
        var maskedCorners: CACornerMask = .all
    }
    
    var title: String?
    var subtitle: String?
    var placeholder: String?
    var accessoryText: String?
    var footerText: String?
    var image: UIImage?
    var secondaryImage: UIImage?
    var xibName: XibName
    var theme: Theme = Theme()
    var enabled: Bool = true
    var associatedValue: Any? = nil
    var selectionActionWithCell: ((_ cell: CVTableViewCell) -> ())?
    var selectionAction: (() -> ())?
    var secondarySelectionAction: (() -> ())?
    var tertiarySelectionAction: (() -> ())?
    var quaternarySelectionAction: (() -> ())?
    var quinarySelectionAction: (() -> ())?
    var senarySelectionAction: (() -> ())?
    var willDisplay: ((_ cell: CVTableViewCell) -> ())?

}
