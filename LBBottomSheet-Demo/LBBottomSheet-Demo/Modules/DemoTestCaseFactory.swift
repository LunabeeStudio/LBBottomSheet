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
                     codeUrl: URL(string: "https://github.com/LunabeeStudio/LBBottomSheet/blob/72ffd1c6a36906e4caba94334746bf48a09f5f14/LBBottomSheet-Demo/LBBottomSheet-Demo/Modules/DemoTestCaseFactory.swift#L52"),
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
                     codeUrl: URL(string: "https://github.com/LunabeeStudio/LBBottomSheet/blob/72ffd1c6a36906e4caba94334746bf48a09f5f14/LBBottomSheet-Demo/LBBottomSheet-Demo/Modules/DemoTestCaseFactory.swift#L70"),
                     theme: {
                         let grabberBackground: BottomSheetController.Theme.Grabber.Background = .color(.tableViewBackground, isTranslucent: false)
                         let grabber: BottomSheetController.Theme.Grabber = .init(background: grabberBackground)
                         return BottomSheetController.Theme(grabber: grabber)
                     },behavior: {
                         BottomSheetController.Behavior(swipeMode: .top)
                     }),
        DemoTestCase(title: "FitContent",
                     menuTitle: "Fit content - Example #4",
                     explanations: """
                                   Here you have an example of a BottomSheet which is fitting the embedded controller height.

                                   👉 In addition to others, you can still interact with the controller behind it.

                                   👉 You can also see that the tableView behind the BottomSheet has its bottom inset updated to not have its content hidden by the BottomSheet.
                                   """,
                     codeUrl: URL(string: "https://github.com/LunabeeStudio/LBBottomSheet/blob/72ffd1c6a36906e4caba94334746bf48a09f5f14/LBBottomSheet-Demo/LBBottomSheet-Demo/Modules/DemoTestCaseFactory.swift#L86"),
                     theme: {
                         let grabberBackground: BottomSheetController.Theme.Grabber.Background = .color(.tableViewBackground, isTranslucent: false)
                         let grabber: BottomSheetController.Theme.Grabber = .init(background: grabberBackground)
                         return BottomSheetController.Theme(grabber: grabber, dimmingBackgroundColor: .clear)
                     },behavior: {
                         BottomSheetController.Behavior(forwardEventsToRearController: true)
                     })
    ]
}
