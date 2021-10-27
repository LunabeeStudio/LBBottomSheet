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
//  URL+Extension.swift
//  LBBottomSheet-Demo
//
//  Created by Lunabee Studio / Date - 24/10/2021 - for the LBBottomSheet-Demo Swift Package.
//

import UIKit
import SafariServices

extension URL {
    func openInSafari(inApp: Bool = true, from controller: UIViewController? = nil) {
        if inApp {
            let safariController: SFSafariViewController = .init(url: self)
            controller?.present(safariController, animated: true)
        } else {
            if UIApplication.shared.canOpenURL(self) { UIApplication.shared.open(self) }
        }
    }
}
