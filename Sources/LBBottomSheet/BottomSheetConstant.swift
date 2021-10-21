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
//  BottomSheetConstant.swift
//  LBBottomSheet
//
//  Created by Lunabee Studio / Date - 12/10/2021 - for the LBBottomSheet Swift Package.
//

import CoreGraphics

/// Botttom sheet constants.
public enum BottomSheetConstant {
    /// Bottom sheet animation constants.
    public enum Animation {
        /// Bottom sheet animation elasticity functions.
        public enum Elasticity {
            /// Bottom sheet logarithmic animation function.
            ///
            /// Here is the implementation of this function:
            /// ```swift
            /// let baseFunction: (_ x: CGFloat) -> CGFloat = { (2.0 * log($0 + 3.0) / log(2.0)) }
            /// return baseFunction(x) - baseFunction(0.0)
            /// ```
            ///
            /// - Parameters:
            ///     - x: The abscissa: The bottom sheet will give the height slice that has to be computed to create the elacticity effect.
            /// - Returns: The ordonate: The height value to be applied to be used by the bottom sheet to calculate its full height.
            public static let logarithmic: (_ x: CGFloat) -> CGFloat = { x -> CGFloat in
                let baseFunction: (_ x: CGFloat) -> CGFloat = { (2.0 * log($0 + 3.0) / log(2.0)) }
                return baseFunction(x) - baseFunction(0.0)
            }
        }
    }

    internal static let preferredHeightVariableName: String = "preferredHeightInBottomSheet"
}
