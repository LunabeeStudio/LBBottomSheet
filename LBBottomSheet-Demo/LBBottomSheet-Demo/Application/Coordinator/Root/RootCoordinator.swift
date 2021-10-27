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
//  RootCoordinator.swift
//  LBBottomSheet-Demo
//
//  Created by Lunabee Studio / Date - 22/10/2021 - for the LBBottomSheet-Demo Swift Package.
//

import UIKit

final class RootCoordinator: Coordinator {

    enum State {
        case main
        case unknown
    }

    weak var parent: Coordinator?
    var childCoordinators: [Coordinator] = []

    private var state: State = .unknown
    private weak var currentCoordinator: WindowedCoordinator?

    func start() {
        switchTo(state: .main)
    }

    private func switchTo(state: State) {
        self.state = state
        if let newCoordinator: WindowedCoordinator = coordinator(for: state) {
            if currentCoordinator != nil {
                processCrossFadingAnimation(newCoordinator: newCoordinator)
            } else {
                currentCoordinator = newCoordinator
                currentCoordinator?.window.alpha = 1.0
                addChild(coordinator: newCoordinator)
            }
        } else {
            childCoordinators.removeAll()
        }
    }

    private func coordinator(for state: State) -> WindowedCoordinator? {
        let coordinator: WindowedCoordinator?
        switch state {
        case .main:
            coordinator = MainCoordinator(parent: self)
        default:
            return nil
        }
        return coordinator
    }

}

extension RootCoordinator {
    
    private func processCrossFadingAnimation(newCoordinator: WindowedCoordinator) {
        guard let currentCoordinator = currentCoordinator else { return }
        newCoordinator.window.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
        UIView.animate(withDuration: 0.3, animations: {
            newCoordinator.window.alpha = 1.0
            newCoordinator.window.transform = .identity
            currentCoordinator.window.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
            currentCoordinator.window.alpha = 0.0
        }) { _ in
            currentCoordinator.window?.isHidden = true
            currentCoordinator.window?.resignKey()
            currentCoordinator.window = nil
            self.currentCoordinator = newCoordinator
            self.removeChild(coordinator: currentCoordinator)
            self.addChild(coordinator: newCoordinator)
        }
    }
    
}
