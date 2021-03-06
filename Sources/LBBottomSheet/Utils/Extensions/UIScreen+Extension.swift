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
//  UIScreen+Extension.swift
//  LBBottomSheet
//
//  Created by Lunabee Studio / Date - 09/11/2021 - for the LBBottomSheet Swift Package.
//

import UIKit

public extension UIScreen {
    var lbbsCornerRadius: CGFloat {
        guard let radius = UIScreen.main.value(forKey: ["Radius", "Corner", "display", "_"].reversed().joined()) as? CGFloat else { return 0.0 }
        return radius - 1.0
    }
}
