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
//  HomeCoordinator.swift
//  LBBottomSheet-Demo
//
//  Created by Lunabee Studio / Date - 22/10/2021 - for the LBBottomSheet-Demo Swift Package.
//

import UIKit

final class MainCoordinator: WindowedCoordinator {

    weak var parent: Coordinator?
    var childCoordinators: [Coordinator]
    var window: UIWindow!
    
//    private weak var navigationController: UINavigationController?
    private weak var launchScreenController: UIViewController?
    private var launchScreenWindow: UIWindow?

    init(parent: Coordinator) {
        self.parent = parent
        self.childCoordinators = []
        start()
    }
    
    private func start() {
        let controller: UIViewController = MainViewController(didFinishLoading: { [weak self] headerImageView in
            if let headerImageView = headerImageView {
                self?.animateLaunchScreen(headerImageView: headerImageView)
            } else {
                self?.hideLaunchScreen()
            }
        })
//        let navigationController: UINavigationController = UINavigationController(rootViewController: controller)
//        self.navigationController = navigationController
//        createWindow(for: navigationController)
        createWindow(for: controller)
        loadLaunchScreen()
    }

}

extension MainCoordinator {

    private func loadLaunchScreen() {
        guard let launchScreen = UIStoryboard(name: "LaunchScreen", bundle: nil).instantiateInitialViewController() else { return }
        self.launchScreenController = launchScreen
        let window: UIWindow = UIWindow(frame: UIScreen.main.bounds)
        launchScreenWindow = window
        window.windowLevel = .statusBar
        window.rootViewController = launchScreen
        window.makeKeyAndVisible()
    }

    private func hideLaunchScreen() {
        UIView.animate(withDuration: 0.3, animations: {
            self.launchScreenWindow?.alpha = 0.0
        }) { _ in
            self.launchScreenWindow?.resignKey()
            self.launchScreenWindow = nil
            self.window.makeKeyAndVisible()
        }
    }

    private func animateLaunchScreen(headerImageView: UIImageView) {
        guard let launchScreenImageView = launchScreenController?.view.viewWithTag(99) as? UIImageView else { return }
        let originRect: CGRect = window.convert(launchScreenImageView.frame, from: launchScreenImageView.superview)
        let destinationRect: CGRect = window.convert(headerImageView.frame, from: headerImageView.superview)
        let translationY: CGFloat = destinationRect.midY - originRect.midY
        UIView.animate(withDuration: 1.0,
                       delay: 0.0,
                       usingSpringWithDamping: 0.8,
                       initialSpringVelocity: 0.1,
                       options: [.curveEaseInOut]) {
            launchScreenImageView.transform = CGAffineTransform(translationX: 0.0, y: translationY)
        } completion: { [weak self] _ in
            self?.hideLaunchScreen()
        }

    }

}
