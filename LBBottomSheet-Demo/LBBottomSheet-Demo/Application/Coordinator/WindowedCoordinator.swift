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
//  WindowedCoordinator.swift
//  LBBottomSheet-Demo
//
//  Created by Lunabee Studio / Date - 22/10/2021 - for the LBBottomSheet-Demo Swift Package.
//

import UIKit

protocol WindowedCoordinator: Coordinator {

    var window: UIWindow! { get set }
    
    func createWindow(for controller: UIViewController)
    
}

extension WindowedCoordinator {
    
    func createWindow(for controller: UIViewController) {
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.backgroundColor = .black
        window?.rootViewController = controller
        window?.alpha = 0.0
        window?.accessibilityViewIsModal = true
        window?.makeKeyAndVisible()
    }
    
}
