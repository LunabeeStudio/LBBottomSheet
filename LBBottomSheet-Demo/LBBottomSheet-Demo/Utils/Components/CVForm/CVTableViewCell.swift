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
//  CVTableViewCell.swift
//  LBBottomSheet-Demo
//
//  Created by Lunabee Studio / Date - 22/10/2021 - for the LBBottomSheet-Demo Swift Package.
//

import UIKit

class CVTableViewCell: UITableViewCell {
    var currentAssociatedRow: CVRow?
    
    @IBOutlet var cvTitleLabel: UILabel?
    @IBOutlet var cvSubtitleLabel: UILabel?
    @IBOutlet var cvAccessoryLabel: UILabel?
    @IBOutlet var cvImageView: UIImageView?
    
    @IBOutlet private var leadingConstraint: NSLayoutConstraint?
    @IBOutlet private var trailingConstraint: NSLayoutConstraint?
    @IBOutlet private var topConstraint: NSLayoutConstraint?
    @IBOutlet private var bottomConstraint: NSLayoutConstraint?
    @IBOutlet private var imageWidthConstraint: NSLayoutConstraint?
    @IBOutlet private var imageHeightConstraint: NSLayoutConstraint?
    
    func setup(with row: CVRow) {
        currentAssociatedRow = row
        cvSubtitleLabel?.text = row.subtitle
        cvAccessoryLabel?.text = row.accessoryText
        cvImageView?.image = row.image
        cvImageView?.tintColor = row.theme.imageTintColor
        setupTheme(with: row)
    }
    
    private func setupTheme(with row: CVRow) {
        selectionStyle = row.selectionAction == nil ? .none : .default
        accessoryType = row.selectionAction == nil ? .none : .disclosureIndicator
        backgroundColor = row.theme.backgroundColor ?? .clear
        
        cvTitleLabel?.isHidden = row.title == nil
        cvTitleLabel?.textAlignment = row.theme.textAlignment
        cvTitleLabel?.adjustsFontForContentSizeCategory = true

        cvTitleLabel?.font = row.theme.titleFont()
        cvTitleLabel?.textColor = row.theme.titleColor
        cvTitleLabel?.text = row.title
        
        cvSubtitleLabel?.isHidden = row.subtitle == nil
        cvSubtitleLabel?.font = row.theme.subtitleFont()
        cvSubtitleLabel?.textColor = row.theme.subtitleColor
        cvSubtitleLabel?.textAlignment = row.theme.textAlignment
        cvSubtitleLabel?.adjustsFontForContentSizeCategory = true
        
        row.theme.titleLinesCount.map { cvTitleLabel?.numberOfLines = $0 }
        row.theme.subtitleLinesCount.map { cvSubtitleLabel?.numberOfLines = $0 }
        
        cvAccessoryLabel?.isHidden = row.accessoryText == nil
        cvAccessoryLabel?.font = row.theme.accessoryTextFont?()
        cvAccessoryLabel?.textColor = row.theme.accessoryTextColor
        cvAccessoryLabel?.textAlignment = row.theme.textAlignment
        cvAccessoryLabel?.adjustsFontForContentSizeCategory = true
        
        cvImageView?.isHidden = row.image == nil
        cvImageView?.tintAdjustmentMode = .normal
        
        leadingConstraint?.constant = row.theme.leftInset ?? 0.0
        trailingConstraint?.constant = row.theme.rightInset ?? 0.0
        if let topInset = row.theme.topInset {
            topConstraint?.constant = topInset
        }
        if let bottomInset = row.theme.bottomInset {
            bottomConstraint?.constant = bottomInset
        }
        if let imageWidthConstraint = imageWidthConstraint, let imageHeightConstraint = imageHeightConstraint {
            if let ratio = row.theme.imageRatio {
                if let imageView = cvImageView {
                    let existingConstraint: NSLayoutConstraint? = imageView.constraints.filter { $0.firstAnchor == imageView.widthAnchor && $0.secondAnchor == imageView.heightAnchor }.first
                    if let constraint = existingConstraint {
                        imageView.removeConstraint(constraint)
                    }
                    imageView.widthAnchor.constraint(equalTo: imageView.heightAnchor, multiplier: ratio, constant: 0.0).isActive = true
                }
                imageHeightConstraint.isActive = false
            } else {
                if let imageView = cvImageView {
                    let existingConstraint: NSLayoutConstraint? = imageView.constraints.filter { $0.firstAnchor == imageView.widthAnchor && $0.secondAnchor == imageView.heightAnchor }.first
                    if let constraint = existingConstraint {
                        imageView.removeConstraint(constraint)
                    }
                }
                imageHeightConstraint.isActive = true
            }
            if let size = row.theme.imageSize {
                imageWidthConstraint.constant = size.width
                imageHeightConstraint.constant = size.height
            }
        }
        let leftInset: CGFloat? = row.theme.separatorLeftInset
        let rightInset: CGFloat? = row.theme.separatorRightInset
        if leftInset == nil && rightInset == nil {
            hideSeparator()
        } else {
            separatorInset = UIEdgeInsets(top: 0.0, left: leftInset ?? 0.0, bottom: 0.0, right: rightInset ?? 0.0)
        }
    }
}
