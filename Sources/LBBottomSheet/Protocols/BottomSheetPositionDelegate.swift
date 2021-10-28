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
//  BottomSheetPositionDelegate.swift
//  LBBottomSheet
//
//  Created by Lunabee Studio / Date - 12/10/2021 - for the LBBottomSheet Swift Package.
//

import UIKit

/// Implement this protocol to dynamically get bottom sheet offset changes.
/// Only view controllers can implement this protocol.
public protocol BottomSheetPositionDelegate: UIViewController {
    /// This method is called at each bottom sheet offset change during the layout process.
    /// This way you can dynamically align the components being at the bottom of the controller behind the bottom sheet.
    /// - Parameters:
    ///     - y: This is the vertical bottom sheet coordinate (0.0 behing the top of the screen).
    func bottomSheetPositionDidUpdate(y: CGFloat)
}
