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
//  UIColor+Appearance.swift
//  LBBottomSheet-Demo
//
//  Created by Lunabee Studio / Date - 22/10/2021 - for the LBBottomSheet-Demo Swift Package.
//

import UIKit

extension UIColor {
    static var tableViewBackground: UIColor { UIColor(named: "tableViewBackground")! }
    static var buttonBackground: UIColor { UIColor(named: "buttonBackground")! }
    static var blurContainerBackground: UIColor { UIColor(named: "blurContainerBackground")! }
    static var shadow: UIColor { UIColor(named: "shadow")! }

    static var titleColor: UIColor {
        if #available(iOS 13, *) {
            return .label
        } else {
            return .black
        }
    }

    static var subtitleColor: UIColor {
        if #available(iOS 13, *) {
            return .secondaryLabel
        } else {
            return .darkGray
        }
    }

    static var accessoryColor: UIColor {
        if #available(iOS 13, *) {
            return .tertiaryLabel
        } else {
            return .lightGray
        }
    }
}
