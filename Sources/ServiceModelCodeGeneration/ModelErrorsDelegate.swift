// Copyright 2019 Amazon.com, Inc. or its affiliates. All Rights Reserved.
//
// Licensed under the Apache License, Version 2.0 (the "License").
// You may not use this file except in compliance with the License.
// A copy of the License is located at
//
//     http://www.apache.org/licenses/LICENSE-2.0
//
// or in the "license" file accompanying this file. This file is distributed
// on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either
// express or implied. See the License for the specific language governing
// permissions and limitations under the License.
//
// ModelErrorsDelegate.swift
// ServiceModelCodeGeneration
//

import Foundation

/**
 Delegate protocol that can customize the generation of errors
 from the Service Model.
 */
public protocol ModelErrorsDelegate {
    /// Specifies what generation to use for the error option set.
    var optionSetGeneration: ErrorOptionSetGeneration { get }
    /// If Encodable conformance for the error type should be generated
    var generateEncodableConformance: Bool { get }
    /// If the CustomStringConvertible conformance for the error type should be generated.
    var generateCustomStringConvertibleConformance: Bool { get }
    /// If the error type should detect and decode validation errors
    var canExpectValidationError: Bool { get }
    
    /**
     Generator for the error type initializer.
 
     - Parameters:
        - fileBuilder: The FileBuilder to output to.
        - errorTypes: The sorted list of error types.
     - codingErrorUnknownError: the error that can be thrown for an unknown error.
     */
    func errorTypeInitializerGenerator(fileBuilder: FileBuilder,
                                       errorTypes: [String],
                                       codingErrorUnknownError: String)

}

public extension ModelErrorsDelegate {
    public var errorOptionSetConformance: String {
        switch optionSetGeneration {
        case .generateWithCustomConformance(_, conformanceType: let conformanceType):
            return conformanceType
        default:
            return "CustomStringConvertible"
        }
    }
}

/**
 Enumeration specifying the options for error option set generation.
 */
public enum ErrorOptionSetGeneration {
    /// Conforms the error option set to CustomStringConvertible.
    case generateWithCustomStringConvertibleConformance
    /// Conforms the error option set a custom protocol with the specified
    /// library import and type
    case generateWithCustomConformance(libraryImport: String, conformanceType: String)
    case noGeneration
}