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
//  UIView+Extension.swift
//  LBBottomSheet
//
//  Created by Lunabee Studio / Date - 14/10/2021 - for the LBBottomSheet Swift Package.
//

import UIKit

extension UIView {

    internal func lbbsAddFullSubview(_ subview: UIView, belowSubview: UIView? = nil) {
        if let belowSubview = belowSubview {
            insertSubview(subview, belowSubview: belowSubview)
        } else {
            addSubview(subview)
        }
        subview.translatesAutoresizingMaskIntoConstraints = false
        subview.topAnchor.constraint(equalTo: topAnchor, constant: 0.0).isActive = true
        subview.bottomAnchor.constraint(equalTo: bottomAnchor, constant: 0.0).isActive = true
        subview.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 0.0).isActive = true
        subview.trailingAnchor.constraint(equalTo: trailingAnchor, constant: 0.0).isActive = true
    }

}
