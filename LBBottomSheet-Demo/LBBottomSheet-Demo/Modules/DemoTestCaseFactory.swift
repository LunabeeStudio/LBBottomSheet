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
//  DemoTestCaseFactory.swift
//  LBBottomSheet-Demo
//
//  Created by Lunabee Studio / Date - 26/10/2021 - for the LBBottomSheet-Demo Swift Package.
//

import Foundation
import LBBottomSheet

final class DemoTestCaseFactory {
    static let fitContent: [DemoTestCase] = [
        DemoTestCase(title: "FitContent",
                     menuTitle: "Fit content - Example #1",
                     explanations: """
                                   Here you have an example of a \"small\" BottomSheet which is fitting the embedded controller height.

                                   👉 This BottomSheet is using all the default values for the `Theme` and the `Behavior`.

                                   👉 The grabber background is completly transparent so if you scroll this tableView, you'll see it directly under the grabber.
                                   """),
        DemoTestCase(title: "FitContent",
                     menuTitle: "Fit content - Example #2",
                     explanations: """
                                   Here you have an example of a BottomSheet which is fitting the embedded controller height.

                                   👉 The grabber background is translucent so if you scroll this tableView, you'll see it under the grabber background color.

                                   👉 If you swipe up from the grabber zone, you'll directly see the elasticity effect.

                                   👉 If you swipe down from the grabber zone the BottomSheet will be moved down.

                                   👉 If you swipe down from this tableView, if the tableView is at its top, the BottomSheet will be moved down.
                                   Otherwise, the tableView will be scrolled.

                                   👉 This swipe behavior is due to the `swipeMode` being set to `.full` in the `BottomSheetController.Behavior` configuration struct.
                                   This is the default behavior.
                                   You can have a look at the documentation to check the possible values.
                                   """,
                     codeUrl: URL(string: "https://github.com/LunabeeStudio/LBBottomSheet/blob/4c4273fbd9a2a44ca7802d3149b2f68e88f8f725/LBBottomSheet-Demo/LBBottomSheet-Demo/Modules/DemoTestCaseFactory.swift#L55"),
                     theme: {
                         let grabberBackground: BottomSheetController.Theme.Grabber.Background = .color(.tableViewBackground.withAlphaComponent(0.9), isTranslucent: true)
                         let grabber: BottomSheetController.Theme.Grabber = .init(background: grabberBackground)
                         return BottomSheetController.Theme(grabber: grabber)
                     }),
        DemoTestCase(title: "FitContent",
                     menuTitle: "Fit content - Example #3",
                     explanations: """
                                   Here you have an example of a BottomSheet which is fitting the embedded controller height.

                                   👉 The grabber background is completly opaque so if you scroll this tableView, you'll not see it under the grabber.

                                   👉 The grabber background can be configured in the `BottomSheetController.Theme.Grabber` configuration struct.
                                   The default behavior is to have a grabber with no background.
                                   You can have a look at the documentation to check the possible values.

                                   👉 This BottomSheet has a `swipeMode` set to `.top`. It means that the dismiss swipe down gesture is only working when you start it from the grabber zone.
                                   """,
                     codeUrl: URL(string: "https://github.com/LunabeeStudio/LBBottomSheet/blob/4c4273fbd9a2a44ca7802d3149b2f68e88f8f725/LBBottomSheet-Demo/LBBottomSheet-Demo/Modules/DemoTestCaseFactory.swift#L74"),
                     theme: {
                         let grabberBackground: BottomSheetController.Theme.Grabber.Background = .color(.tableViewBackground, isTranslucent: false)
                         let grabber: BottomSheetController.Theme.Grabber = .init(background: grabberBackground)
                         return BottomSheetController.Theme(grabber: grabber)
                     }, behavior: {
                         BottomSheetController.Behavior(swipeMode: .top)
                     }),
        DemoTestCase(title: "FitContent",
                     menuTitle: "Fit content - Example #4",
                     explanations: """
                                   Here you have an example of a BottomSheet which is fitting the embedded controller height.

                                   👉 In addition to others, you can still interact with the controller behind it.

                                   👉 You can also see that the tableView behind the BottomSheet has its bottom inset updated to not have its content hidden by the BottomSheet.
                                   To do this, you just have to implement the `BottomSheetPositionDelegate` on the controller needing a bottom inset update, and to give this controller to the `presentAsBottomSheet` method.
                                   """,
                     codeUrl: URL(string: "https://github.com/LunabeeStudio/LBBottomSheet/blob/4c4273fbd9a2a44ca7802d3149b2f68e88f8f725/LBBottomSheet-Demo/LBBottomSheet-Demo/Modules/DemoTestCaseFactory.swift#L92"),
                     theme: {
                         let grabberBackground: BottomSheetController.Theme.Grabber.Background = .color(.tableViewBackground, isTranslucent: false)
                         let grabber: BottomSheetController.Theme.Grabber = .init(background: grabberBackground)
                         return BottomSheetController.Theme(grabber: grabber, dimmingBackgroundColor: .clear)
                     }, behavior: {
                         BottomSheetController.Behavior(forwardEventsToRearController: true)
                     })
    ]

    static let free: [DemoTestCase] = [
        DemoTestCase(title: "Free",
                     menuTitle: "Free - Example #1",
                     explanations: """
                                   Here you have an example of a BottomSheet with a height being between 300pts and 600pts of the screen height.

                                   👉 If you release the BottomSheet at any point between the min and max height, it will remains there.
                                   """,
                     codeUrl: URL(string: "https://github.com/LunabeeStudio/LBBottomSheet/blob/4c4273fbd9a2a44ca7802d3149b2f68e88f8f725/LBBottomSheet-Demo/LBBottomSheet-Demo/Modules/DemoTestCaseFactory.swift#L112"),
                     theme: {
                         let grabberBackground: BottomSheetController.Theme.Grabber.Background = .color(.tableViewBackground, isTranslucent: false)
                         let grabber: BottomSheetController.Theme.Grabber = .init(background: grabberBackground)
                         return BottomSheetController.Theme(grabber: grabber)
                     }, behavior: {
                         BottomSheetController.Behavior(heightMode: .free(minHeight: 300.0, maxHeight: 600.0))
                     })
    ]

    static let specific: [DemoTestCase] = [
        DemoTestCase(title: "Specific",
                     menuTitle: "Specific - Example #1",
                     explanations: """
                                   Here you have an example of a BottomSheet with specific heights.
                                   This allows you to define multiple positions for your BottomSheet.

                                   👉 This bottom sheet has different height values: 200.0pts, 50%, 75% and 100% of the screen height.
                                   When the user releases the bottom sheet, its height will be updated to the predefined nearest one.

                                   👉 The height limit is defined to `.screen` to allow the bottom sheet to cover the full screen height.
                                   """,
                     codeUrl: URL(string: "https://github.com/LunabeeStudio/LBBottomSheet/blob/4c4273fbd9a2a44ca7802d3149b2f68e88f8f725/LBBottomSheet-Demo/LBBottomSheet-Demo/Modules/DemoTestCaseFactory.swift#L133"),
                     theme: {
                         let grabberBackground: BottomSheetController.Theme.Grabber.Background = .color(.tableViewBackground, isTranslucent: false)
                         let grabber: BottomSheetController.Theme.Grabber = .init(background: grabberBackground)
                         return BottomSheetController.Theme(grabber: grabber)
                     }, behavior: {
                         BottomSheetController.Behavior(heightMode: .specific(values: [
                            .fixed(value: 200.0),
                            .screenRatio(value: 0.5),
                            .screenRatio(value: 0.75),
                            .screenRatio(value: 1.0)
                         ], heightLimit: .screen))
                     })
    ]
}
