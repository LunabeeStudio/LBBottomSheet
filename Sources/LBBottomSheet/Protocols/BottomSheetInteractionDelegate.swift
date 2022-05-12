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
//  BottomSheetInteractionDelegate.swift
//  LBBottomSheet
//
//  Created by Lunabee Studio / Date - 12/05/2022 - for the LBBottomSheet Swift Package.
//

import UIKit

/// Implement this protocol to get bottom sheet user's interactions.
/// Only view controllers can implement this protocol.
public protocol BottomSheetInteractionDelegate: UIViewController {
    /// This method is called when a tap is detected outside the bottom sheet (which makes it dimsissing).
    /// This way you can run some custom actions when this will happen.
    func bottomSheetInteractionDidTapOutside()
}
