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
//  UIColor+Extensions.swift
//  LBBottomSheet
//
//  Created by Lunabee Studio / Date - 12/10/2021 - for the LBBottomSheet Swift Package.
//

import UIKit

public extension UIColor {
    static var lbbsDefaultDimmingBackgroundColor: UIColor {
        if #available(iOS 13.0, *) {
            return UIColor.init(dynamicProvider: {
                switch $0.userInterfaceStyle {
                case .dark:
                    return .white.withAlphaComponent(0.1)
                default:
                    return .black.withAlphaComponent(0.4)
                }
            })
        } else {
            return .black.withAlphaComponent(0.4)
        }
    }
    static var lbbsDefaultShadowColor: UIColor {
        if #available(iOS 13.0, *) {
            return UIColor.init(dynamicProvider: {
                switch $0.userInterfaceStyle {
                case .dark:
                    return .gray
                case .light, .unspecified:
                    return .black
                @unknown default:
                    return .black
                }
            })
        } else {
            return .black
        }
    }
    static var lbbsDefaultGrabberColor: UIColor {
        if #available(iOS 13.0, *) {
            return .tertiaryLabel
        } else {
            return .lightGray
        }
    }
}
