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
//  ForwardingEventsView.swift
//  LBBottomSheet
//
//  Created by Lunabee Studio / Date - 12/10/2021 - for the LBBottomSheet Swift Package.
//

import UIKit

/// This view implementation makes us able to forward events not happening on the bottom sheet itself to the controller behind the bottom sheet.
public final class ForwardingEventsView: UIView {

    /// The view which must be the destination of the detected touch events.
    var destinationView: UIView?
    /// This is the view for which (children included) we must not forward the touch event to the view behind it.
    var excludedParentView: UIView?

    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        // Here we get the original result of the hit test.
        let hitTest: UIView? = super.hitTest(point, with: event)
        
        // We will recursivly go up along the hitTest result superviews to detect if the touched view is the excluded one or contained in the excluded one.
        // Recursively, each superview will be stored in currentView.
        var currentView: UIView? = hitTest
        var isChildOfExcludedParentView: Bool = hitTest == excludedParentView
        
        // Now we will go up along the superviews until the root one to check if the touched view is not contained in the excluded one.
        while let superview = currentView?.superview {
            currentView = superview
            if currentView == excludedParentView {
                isChildOfExcludedParentView = true
                break
            }
        }
        
        if isChildOfExcludedParentView {
            // In the case the touch event was made on the excluded view or on one of its children, we don't forward the touch event to the view behind, so we keep the initial hit test result.
            return hitTest
        } else {
            // If we didn't find the excluded view in the touched view hierarchy, we forward the hitTest to the destination view which can be, for example, the view of the controller being behind the bottom sheet.
            // If no destination view was defined, we just return the initial hit test result.
            let destinationPoint: CGPoint = convert(point, to: destinationView)
            return destinationView?.hitTest(destinationPoint, with: event) ?? hitTest
        }
    }

}
