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
//  BottomSheetController+Behavior.swift
//  LBBottomSheet
//
//  Created by Lunabee Studio / Date - 12/10/2021 - for the LBBottomSheet Swift Package.
//

import CoreGraphics

extension BottomSheetController {
    /// Struct used to define the behavior of a BottomSheetController.
    public struct Behavior {
        /// An enum describing the available swipe modes.
        /// It impacts the way the swipe down gesture is detected.
        public enum SwipeMode {
            /// Swipe down only detected from the grabber zone. (the top of the bottom sheet)
            case top
            /// Swipe down detected from the whole bottom sheet.
            case full
            /// Swipe down gesture blocked to prevent bottom sheet dismissal.
            case none
        }

        /// An enum describing the available height modes.
        public enum HeightMode {
            /// The bottom sheet will call `preferredHeightInBottomSheet on the embeded controller to get the needed height.
            case fitContent
            /// The bottom sheet height will be contained between `minHeight` and `maxHeight` and the bottom sheet will remains where the user released it.
            case free(minHeight: CGFloat? = nil, maxHeight: CGFloat? = nil)
            /// The bottom sheet will have multiple height values. When the user releases it, it will be attached to the nearest provided specific value.
            /// When presented, the bottom sheet will use the minimum value. It can be swipped up to the maximum value. You don't have to take care of the values order, the bottom sheet will sort them to find the matching one.
            case specific(values: [HeightValue])

            internal func minimumHeight(with childHeight: CGFloat, screenHeight: CGFloat) -> CGFloat {
                switch self {
                case .fitContent:
                    return childHeight
                case let .free(minHeight , _):
                    return minHeight ?? 0.0
                case let .specific(values):
                    return values.sortedPointValues(screenHeight: screenHeight, childHeight: childHeight).first ?? 0.0
                }
            }

            internal func maximumHeight(with childHeight: CGFloat, screenHeight: CGFloat, defaultMaximumHeight: CGFloat) -> CGFloat {
                switch self {
                case .fitContent:
                    return min(childHeight, defaultMaximumHeight)
                case let .free(_ , maxHeight):
                    guard let maxHeight = maxHeight else { return defaultMaximumHeight }
                    return min(maxHeight, defaultMaximumHeight)
                case let .specific(values):
                    guard let maxHeight = values.sortedPointValues(screenHeight: screenHeight, childHeight: childHeight).last else { return defaultMaximumHeight }
                    return min(maxHeight, defaultMaximumHeight)
                }
            }
        }

        /// An enum describing the available height values for the `specific` HeightMode.
        public enum HeightValue {
            /// It takes an arbitrary height in points.
            case fixed(value: CGFloat)
            /// It takes a percentage (between 0.0 and 1.0) that will be applied to the screen height to determine the bottom sheet height.
            case screenRatio(value: CGFloat)
            /// It takes a percentage (between 0.0 and 1.0) that will be applied to the height of the controller embeded in the bottom sheet.
            case childRatio(value: CGFloat)

            /// This is a shortcut allowing you to have in your specific values, one matching the needed height.
            public static let fitContent: HeightValue = .childRatio(value: 1.0)
        }

        /// The duration of the appearing animation.
        public var appearingAnimationDuration: Double = 0.5
        /// The duration of the disappearing animation.
        public var disappearingAnimationDuration: Double = 0.5
        /// Defines how the bottom sheet is swippable.
        public var swipeMode: SwipeMode = .full
        /// Defines whether or not the touch events detected out of the bottom sheet should be forwarded
        /// to the view behind the bottom sheet.
        public var forwardEventsToRearController: Bool = false
        /// Defines the percentage of the bottom sheet height that should be swipped down to dismiss it when releasing it
        /// instead of putting it back to its previous position.
        public var heightPercentageThresholdToDismiss: CGFloat = 0.5
        /// The minimum velocity (in points/second) when swipping the bottom sheet down to dismiss it when released,
        /// even if `heightPercentageThresholdToDismiss` was not reached.
        public var velocityThresholdToDismiss: CGFloat = 700
        /// The minimum velocity (in points/second) when swipping the bottom sheet up to open it at its maximum height.
        public var velocityThresholdToOpenAtMaxHeight: CGFloat = 700
        /// Allowing or not the bottom sheet to go over the navigation bar behind it.
        public var shouldShowAboveNavigationBar: Bool = false
        /// The mode used to calculate the bottom sheet height.
        public var heightMode: HeightMode = .fitContent {
            didSet {
                switch heightMode {
                case let .specific(values):
                    guard !values.isEmpty else { fatalError("❌ [LBBottomSheet] ❌: You must provide an HeightValue array containing at least one value for the specific HeightMode.") }
                default:
                    break
                }
            }
        }
        /// This is a block allowing you to customize how the elasticity effect is calculated (when you are trying to swipe the BottomSheetController view up, above its maximum height).
        public var elasticityFunction: (_ x: CGFloat) -> CGFloat

        /// Initializes a new Behavior.
        public init(appearingAnimationDuration: Double = 0.5,
                    disappearingAnimationDuration: Double = 0.5,
                    swipeMode: BottomSheetController.Behavior.SwipeMode = .full,
                    forwardEventsToRearController: Bool = false,
                    heightPercentageThresholdToDismiss: CGFloat = 0.5,
                    velocityThresholdToDismiss: CGFloat = 700,
                    velocityThresholdToOpenAtMaxHeight: CGFloat = 700,
                    shouldShowAboveNavigationBar: Bool = false,
                    heightMode: BottomSheetController.Behavior.HeightMode = .fitContent,
                    elasticityFunction: @escaping (CGFloat) -> CGFloat = BottomSheetConstant.Animation.Elasticity.logarithmic) {
            self.appearingAnimationDuration = appearingAnimationDuration
            self.disappearingAnimationDuration = disappearingAnimationDuration
            self.swipeMode = swipeMode
            self.forwardEventsToRearController = forwardEventsToRearController
            self.heightPercentageThresholdToDismiss = heightPercentageThresholdToDismiss
            self.velocityThresholdToDismiss = velocityThresholdToDismiss
            self.velocityThresholdToOpenAtMaxHeight = velocityThresholdToOpenAtMaxHeight
            self.shouldShowAboveNavigationBar = shouldShowAboveNavigationBar
            self.heightMode = heightMode
            self.elasticityFunction = elasticityFunction
        }
    }
}

extension Array where Element == BottomSheetController.Behavior.HeightValue {

    internal func sortedPointValues(screenHeight: CGFloat, childHeight: CGFloat) -> [CGFloat] {
        map {
            switch $0 {
            case let .fixed(value):
                return Swift.min(Swift.max(value, 0.0), screenHeight)
            case let .screenRatio(value):
                return screenHeight * Swift.min(Swift.max(value, 0.0), 1.0)
            case let .childRatio(value):
                return childHeight * Swift.min(Swift.max(value, 0.0), 1.0)
            }
        }.sorted()
    }

}
