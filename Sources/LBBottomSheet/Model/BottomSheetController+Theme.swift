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
        // TODO: Add comment.
        public enum CornerRadiusType {
            case rounded
            case fixed(_ value: CGFloat)
        }

        /// Struct used to represent a grabber that can be added to a BottomSheetControllerTheme.
        /// It will be visible at the top of the BottomSheetController.
        public struct Grabber {
            // TODO: Add comment.
            public enum Background {
                case color(_ color: UIColor = .clear, isTranslucent: Bool = true)
                case view(_ view: UIView, isTranslucent: Bool)
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
            /// Defines whether or not the BottomSheetController should be dismissed when tapping the grabber (in addition to swipping it up).
            public var canTouchToDismiss: Bool
            // TODO: Add comment.
            public var background: Background

            public init(size: CGSize = CGSize(width: 30.0, height: 4.0),
                        cornerRadiusType: BottomSheetController.Theme.CornerRadiusType = .rounded,
                        maskedCorners: CACornerMask = .all,
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
        public struct Shadow {
            ///The color of the shadow.
            public var color: UIColor
            /// The opacity of the shadow. Specifying a value outside the [0,1] range will give undefined results.
            public var opacity: Float
            /// The shadow offset.
            public var offset: CGSize
            /// The blur radius used to create the shadow.
            public var radius: CGFloat

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

        public init(grabber: BottomSheetController.Theme.Grabber? = Grabber(),
                    cornerRadius: CGFloat = 25.0,
                    maskedCorners: CACornerMask = .top,
                    dimmingBackgroundColor: UIColor = UIColor.black.withAlphaComponent(0.4),
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
