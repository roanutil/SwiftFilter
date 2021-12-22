// Closure+OptionalEquatablePredicate.swift
// SwiftFilter
//
//
// MIT License
//
// Copyright © 2021 Andrew Roan

import Foundation
import SwiftFilter

extension Closure: OptionalEquatablePredicate where Value: Equatable {
    /// Creates a closure `(Self) -> Bool` from a EquatableFilter
    ///
    /// - Parameter filter: An instance of EquatableFilter representing the logic of the resulting NSPredicate.
    public static func build(from filter: EquatableFilter<Value>.Optional,
                             on keyPath: KeyPath<Root, Value?>) -> ((Root) -> Bool)
    {
        switch filter {
        case let .orNil(subFilter):
            return { value in
                guard let value = value[keyPath: keyPath] else { return true }
                return Closure<Value, Value>.build(from: subFilter)(value)
            }
        case let .notNil(subFilter):
            return { value in
                guard let value = value[keyPath: keyPath] else { return false }
                return Closure<Value, Value>.build(from: subFilter)(value)
            }
        case .isNil:
            return { $0[keyPath: keyPath] == nil }
        }
    }
}