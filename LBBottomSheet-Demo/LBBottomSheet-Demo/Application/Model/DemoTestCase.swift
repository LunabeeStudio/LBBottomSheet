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
//  DemoText.swift
//  LBBottomSheet-Demo
//
//  Created by Lunabee Studio / Date - 26/10/2021 - for the LBBottomSheet-Demo Swift Package.
//

import Foundation
import LBBottomSheet

struct DemoTestCase {
    let title: String
    let menuTitle: String
    let explanations: String
    var codeUrl: URL?
    var theme: () -> BottomSheetController.Theme = { .init() }
    var behavior: () -> BottomSheetController.Behavior = { .init() }
}
