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
//  CVRowsBuilder.swift
//  LBBottomSheet-Demo
//
//  Created by Lunabee Studio / Date - 22/10/2021 - for the LBBottomSheet-Demo Swift Package.
//

import Foundation

@resultBuilder
struct CVRowsBuilder {
    static func buildBlock(_ rows: CVRowConvertible...) -> [CVRow] { rows.flatMap { $0.asRows() } }
    static func buildIf(_ value: CVRowConvertible?) -> CVRowConvertible { value ?? [] }
    static func buildEither(first: CVRowConvertible) -> CVRowConvertible { first }
    static func buildEither(second: CVRowConvertible) -> CVRowConvertible { second }
}

protocol CVRowConvertible {
    func asRows() -> [CVRow]
}

extension CVRow: CVRowConvertible {
    func asRows() -> [CVRow] { [self] }
}

extension Array: CVRowConvertible where Element == CVRow {
    func asRows() -> [CVRow] { self }
}
