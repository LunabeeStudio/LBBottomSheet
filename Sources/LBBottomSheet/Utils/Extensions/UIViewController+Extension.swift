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
//  UIViewController+Extension.swift
//  LBBottomSheet
//
//  Created by Lunabee Studio / Date - 12/10/2021 - for the LBBottomSheet Swift Package.
//

import UIKit

// MARK: - Public extensions -
public extension UIViewController {
    /// Find the BottomSheetController embedding the current controller.
    /// It is working like `navigationController` or others.
    var bottomSheetController: BottomSheetController? {
        var parentController: UIViewController? = self
        while let controller = parentController?.parent {
            parentController = controller
            if parentController is BottomSheetController {
                break
            }
        }
        return parentController as? BottomSheetController
    }

    /// Presents a given controller as a bottom sheet.
    /// - Parameters:
    ///   - controller: The controller to present in a bottom sheet.
    ///   - positionDelegate: A `UIViewController` being a <doc:LBBottomSheet/BottomSheetPositionDelegate> to get the bottom sheet position updates if it needs to update its content bottom inset.
    ///   - theme: A Theme to customize the bottom sheet appearance.
    ///   - behavior: A Behavior to customize the way the bottom sheet behaves.
    /// - Returns: A reference to the created `BottomSheetController`.
    @discardableResult
    func presentAsBottomSheet(_ controller: UIViewController,
                              positionDelegate: BottomSheetPositionDelegate? = nil,
                              theme: BottomSheetController.Theme = BottomSheetController.Theme(),
                              behavior: BottomSheetController.Behavior = BottomSheetController.Behavior()) -> BottomSheetController {
        let bottomSheetController: BottomSheetController = BottomSheetController.controller(bottomSheetChild: controller, bottomSheetPositionDelegate: positionDelegate, theme: theme, behavior: behavior)
        present(bottomSheetController, animated: false, completion: nil)
        return bottomSheetController
    }
    
    /// Use this function to dismiss the top presented bottom sheet.
    /// If the top presented controller is not a bottom sheet, nothing will happen.
    /// - Parameters:
    ///   - completion: A completion handler to be called when the bottom sheet is dismissed.
    func dismissBottomSheet(_ completion: (() -> Void)? = nil) {
        guard let controller = lbbsTopPresentedController as? BottomSheetController else {
            completion?()
            return
        }
        controller.dismiss(completion)
    }
}

// MARK: - Internal extensions -
internal extension UIViewController {
    var lbbsTopPresentedController: UIViewController {
        var presentedController: UIViewController = self
        while let controller = presentedController.presentedViewController {
            presentedController = controller
        }
        return presentedController
    }
    
    func lbbsRearControllerTopInset(includeNavigationBar: Bool = true) -> CGFloat {
        var topInset: CGFloat = UIApplication.shared.lbbsKeySceneWindow?.safeAreaInsets.top ?? 0.0
        if let navController = presentingViewController as? UINavigationController ?? presentingViewController?.navigationController, !navController.isNavigationBarHidden && includeNavigationBar {
            topInset = navController.navigationBar.frame.maxY + 8.0
        }
        return topInset
    }

    func lbbsAddChildViewController(_ childController: UIViewController, containerView: UIView) {
        addChild(childController)
        containerView.lbbsAddFullSubview(childController.view)
        childController.didMove(toParent: self)
    }

    func lbbsFindControllerDeclaringPreferredHeightInBottomSheet() -> UIViewController? {
        if Mirror.isPreferredHeightInBottomSheetDeclared(in: type(of: self)) {
            return self
        } else {
            return children.first { Mirror.isPreferredHeightInBottomSheetDeclared(in: type(of: $0)) }
        }
    }
}
