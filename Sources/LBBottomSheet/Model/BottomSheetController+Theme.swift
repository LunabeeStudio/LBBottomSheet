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
//  BottomSheetController+Theme.swift
//  LBBottomSheet
//
//  Created by Lunabee Studio / Date - 12/10/2021 - for the LBBottomSheet Swift Package.
//

import UIKit

extension BottomSheetController {
    /// Struct used to define the theme of a BottomSheetController.
    public struct Theme {
        /// Struct used to represent a grabber that can be added to a BottomSheetControllerTheme.
        /// It will be visible at the top of the BottomSheetController.
        /// ![Grabber](Grabber)
        public struct Grabber {
            /// An enum describing the available background types for the Grabber.
            /// ![GrabberBackground](GrabberBackground)
            public enum Background {
                /// Use a simple color as the grabber "zone" background.
                /// - Parameters:
                ///     - color: The color to use as the grabber "zone" background.
                ///     - isTranslucent: If `true`, the embedded view will be extended under the grabber "zone". Otherwise, the embedded view will have its top starting at the bottom of the grabber "zone".
                case color(_ color: UIColor = .clear, isTranslucent: Bool = true)
                /// Use a custom view as the grabber "zone" background.
                /// - Parameters:
                ///     - view: The view to insert as the grabber "zone" background.
                ///     - isTranslucent: If `true`, the embedded view will be extended under the grabber "zone". Otherwise, the embedded view will have its top starting at the bottom of the grabber "zone".
                case view(_ view: UIView, isTranslucent: Bool)
            }

            /// An enum describing the available corner radius types.
            public enum CornerRadiusType {
                /// The grabber corner radius will be the height of the grabber devided by 2.
                case rounded
                /// The grabber corner redius will be the given value.
                /// - Parameters:
                ///     - value: The corner radius value.
                case fixed(_ value: CGFloat)
            }

            /// The size of the grabber.
            public var size: CGSize
            /// Defines whether or not the grabber shoiuld have a corner radius.
            public var cornerRadiusType: CornerRadiusType
            /// These are the corners to apply the radius to.
            public var maskedCorners: CACornerMask
            /// The grabber color.
            public var color: UIColor
            /// The margin between the grabber top and the top of the BottomSheetController view.
            public var topMargin: CGFloat
            /// Defines whether or not the BottomSheetController should be dismissed when tapping the grabber.
            public var canTouchToDismiss: Bool
            /// The background to use behind the grabber. By default it is transparent.
            public var background: Background

            /// Initializes a new Grabber.
            public init(size: CGSize = CGSize(width: 30.0, height: 4.0),
                        cornerRadiusType: BottomSheetController.Theme.Grabber.CornerRadiusType = .rounded,
                        maskedCorners: CACornerMask = .lbbsAll,
                        color: UIColor = .lightGray,
                        topMargin: CGFloat = 20.0,
                        canTouchToDismiss: Bool = false,
                        background: BottomSheetController.Theme.Grabber.Background = .color()) {
                self.size = size
                self.cornerRadiusType = cornerRadiusType
                self.maskedCorners = maskedCorners
                self.color = color
                self.topMargin = topMargin
                self.canTouchToDismiss = canTouchToDismiss
                self.background = background
            }
        }
        
        /// Struct used to represent a shadow that can be added to a BottomSheetControllerTheme.
        /// It will then appear behind the top of the BottomSheetController.
        /// ![Shadow](Shadow)
        public struct Shadow {
            /// The color of the shadow.
            public var color: UIColor
            /// The opacity of the shadow. Specifying a value outside the [0,1] range will give undefined results.
            public var opacity: Float
            /// The shadow offset.
            public var offset: CGSize
            /// The blur radius used to create the shadow.
            public var radius: CGFloat

            /// Initializes a new Shadow.
            public init(color: UIColor = .lbbsDefaultShadowColor,
                        opacity: Float = 0.3,
                        offset: CGSize = .zero,
                        radius: CGFloat = 5) {
                self.color = color
                self.opacity = opacity
                self.offset = offset
                self.radius = radius
            }
        }
        
        /// The BottomSheetController grabber.
        public var grabber: Grabber?
        /// This is the corner radius used for the masked corners of the BottomSheetController view.
        public var cornerRadius: CGFloat
        /// These are the corners to apply the radius to.
        public var maskedCorners: CACornerMask
        /// This is the background color to use all around the BottomSheetController view.
        public var dimmingBackgroundColor: UIColor
        /// The BottomSheetController shadow.
        public var shadow: Shadow?
        /// Leading margin to apply to the bottom sheet in case we don't want it being attached to the left screen edge.
        public var leadingMargin: CGFloat
        /// Trailing margin to apply to the bottom sheet in case we don't want it being attached to the right screen edge.
        public var trailingMargin: CGFloat

        /// Initializes a new Theme.
        public init(grabber: BottomSheetController.Theme.Grabber? = Grabber(),
                    cornerRadius: CGFloat = 25.0,
                    maskedCorners: CACornerMask = .lbbsTop,
                    dimmingBackgroundColor: UIColor = .lbbsDefaultDimmingBackgroundColor,
                    shadow: BottomSheetController.Theme.Shadow? = Shadow(),
                    leadingMargin: CGFloat = 0.0,
                    trailingMargin: CGFloat = 0.0) {
            self.grabber = grabber
            self.cornerRadius = cornerRadius
            self.maskedCorners = maskedCorners
            self.dimmingBackgroundColor = dimmingBackgroundColor
            self.shadow = shadow
            self.leadingMargin = leadingMargin
            self.trailingMargin = trailingMargin
        }
    }
}
