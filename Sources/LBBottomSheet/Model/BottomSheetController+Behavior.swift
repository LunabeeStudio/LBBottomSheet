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
            /// The bottom sheet will call `preferredHeightInBottomSheet` on the embedded controller to get the needed height.
            ///
            /// If `preferredHeightInBottomSheet` is not declared on the embedded controller, the BottomSheet will calculate a default height to use based on the embedded controller content: if there is a tableView or a collectionView it will use the content size and content insets, otherwise it will use the first view height. If this calculation returns 0 as the height, 75% of the screen height will be used instead.
            /// To declare the preferred height, add this to your embedded controller:
            /// ```swift
            /// @objc var preferredHeightInBottomSheet: CGFloat { /* Do you custom calculation here */ }
            /// ```
            case fitContent
            /// The bottom sheet height will be contained between `minHeight` and `maxHeight` and the bottom sheet will remain where the user releases it.
            /// - Parameters:
            ///     - minHeight: The minimum height to use for the bottom sheet.
            ///     - maxHeight: The maximum height to use for the bottom sheet.
            case free(minHeight: CGFloat? = nil, maxHeight: CGFloat? = nil)
            /// The bottom sheet will have multiple height values. When the user releases it, it will be attached to the nearest provided specific value.
            /// When presented, the bottom sheet will use the minimum value. It can be swipped up to the maximum value. You don't have to take care of the values order, the bottom sheet will sort them to find the matching one.
            /// - Parameters:
            ///     - values: An array of `HeightValue` values to use with the bottom sheet if we need to manage multiple positions.
            case specific(values: [HeightValue])

            internal func minimumHeight(with childHeight: CGFloat, screenHeight: CGFloat) -> CGFloat {
                switch self {
                case .fitContent:
                    return max(childHeight, 0.0)
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

            internal func nextHeight(with childHeight: CGFloat, screenHeight: CGFloat, defaultMaximumHeight: CGFloat, originHeight: CGFloat, goingUp: Bool) -> CGFloat? {
                switch self {
                case let .specific(values):
                    let allValues: [CGFloat] = values.sortedPointValues(screenHeight: screenHeight, childHeight: childHeight)
                    guard let currentIndex = allValues.firstIndex(of: originHeight) else { return nil }
                    let newIndex: Int = goingUp ? currentIndex + 1 : currentIndex - 1
                    return newIndex < 0 ? nil : min(allValues[min(newIndex, allValues.count - 1)], defaultMaximumHeight)
                default:
                    return goingUp ? maximumHeight(with: childHeight, screenHeight: screenHeight, defaultMaximumHeight: defaultMaximumHeight) : minimumHeight(with: childHeight, screenHeight: screenHeight)
                }
            }
        }

        /// An enum describing the available height values for the `specific` HeightMode.
        public enum HeightValue {
            /// Defines an arbitrary height in points.
            /// - Parameters:
            ///     - value: The absolute height value in points.
            case fixed(value: CGFloat)
            /// Defines a height being a ratio of the screen height.
            /// - Parameters:
            ///     - value: A percentage (between 0.0 and 1.0) that will be applied to the screen height to determine the bottom sheet height.
            case screenRatio(value: CGFloat)
            /// Defines a height being a ratio of the embedded controller `preferredHeightInBottomSheet` value.
            /// - Parameters:
            ///     - value: A percentage (between 0.0 and 1.0) that will be applied to the height of the controller embedded in the bottom sheet.
            case childRatio(value: CGFloat)
            /// Defines a height being obtained thanks to a block.
            /// - Parameters:
            ///     - heightBlock: A block that must return the needed height.
            case custom(_ heightBlock: () -> CGFloat)

            /// This is a shortcut allowing you to have in your specific values, one matching the embedded controller `preferredHeightInBottomSheet` value.
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
        /// Defines whether or not the bottom sheet height must be limited under the navigation bar behind it.
        ///
        /// If the controller presenting the bottom sheet is or is embedded in a navigation controller, it might be possible that the bottom sheet will go over the navigation bar.
        ///
        /// Automatically, the bottom sheet will calculate the maximum height it can have not to have a height greater than the screen one.
        ///
        /// If this boolean is set to `true`, the bottom sheet height will be limited under the notch/status bar.
        ///
        /// If set to `false` (the default value) the bottom sheet height will be limited under the navigation bar.
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
        /// Defines whether or not the bottom sheet layout will be updated when the user changes the iOS font size.
        ///
        /// As your embedded controller height might be impacted by a font size change, the bottom sheet will update its height too if you use a <doc:LBBottomSheet/BottomSheetController/Behavior-swift.struct/HeightMode-swift.enum> depending on the embedded controller height.
        ///
        /// If you don't use a <doc:LBBottomSheet/BottomSheetController/Behavior-swift.struct/HeightMode-swift.enum> depending on the embedded controller height, nothing will happen.
        public var updateHeightOnContentSizeCategoryChange: Bool
        /// Defines whether or not the bottom sheet can be dismissed. If set to `false`, it allows the bottom sheet to still be animated while swipping if the <doc:LBBottomSheet/BottomSheetController/Behavior-swift.struct/swipeMode-swift.property> is different from <doc:LBBottomSheet/BottomSheetController/Behavior-swift.struct/SwipeMode-swift.enum/none>.
        public var allowsSwipeToDismiss: Bool
        /// Defines whether or not the bottom sheet can be dismissed by touching the dimming background.
        public var canTouchDimmingBackgroundToDismiss: Bool

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
                    elasticityFunction: @escaping (CGFloat) -> CGFloat = BottomSheetConstant.Animation.Elasticity.logarithmic,
                    updateHeightOnContentSizeCategoryChange: Bool = true,
                    allowsSwipeToDismiss: Bool = true,
                    canTouchDimmingBackgroundToDismiss: Bool = true) {
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
            self.updateHeightOnContentSizeCategoryChange = updateHeightOnContentSizeCategoryChange
            self.allowsSwipeToDismiss = allowsSwipeToDismiss
            self.canTouchDimmingBackgroundToDismiss = canTouchDimmingBackgroundToDismiss
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
            case let .custom(block):
                return block()
            }
        }.sorted()
    }

}
