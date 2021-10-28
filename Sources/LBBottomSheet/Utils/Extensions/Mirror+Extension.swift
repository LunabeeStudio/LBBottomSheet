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
//  Mirror+Extension.swift
//  LBBottomSheet
//
//  Created by Lunabee Studio / Date - 14/10/2021 - for the LBBottomSheet Swift Package.
//

import Foundation

internal extension Mirror {
    static func lbbsGetTypesOfProperties(in class: NSObject.Type) -> [String]? {
        var count: UInt32 = UInt32()
        guard let properties = class_copyPropertyList(`class`, &count) else { return nil }
        var names: [String] = []
        for i in 0..<Int(count) {
            let property: objc_property_t = properties[i]
            guard let name = lbbsGetNameOf(property: property) else { continue }
            names.append(name)
        }
        free(properties)
        return names
    }
    static func isPreferredHeightInBottomSheetDeclared(in class: NSObject.Type) -> Bool {
        let propertiesName: [String] = lbbsGetTypesOfProperties(in: `class`) ?? []
        return propertiesName.contains(BottomSheetConstant.preferredHeightVariableName)
    }
}

private extension Mirror {
    static func lbbsGetNameOf(property: objc_property_t) -> String? {
        guard let name: NSString = NSString(utf8String: property_getName(property)) else { return nil }
        return name as String
    }
}
