//
//  PrettyPrinting.swift
//  SOP
//
//  Created by Chris Eidhof on 26.11.18.
//  Copyright © 2018 Chris Eidhof. All rights reserved.
//

import Foundation

protocol Pretty {
    var doc: Doc { get }
}

protocol PrettyHelper: Describes {
    func pretty(_ value: Value) -> Doc
}

extension TypeName: PrettyHelper where A: PrettyHelper {
    func pretty(_ value: A.Value) -> Doc {
        return .lines([
            .text("\(name) {"),
            .indent(a.pretty(value)),
            .text("}")
        ])
    }
}

extension Product: PrettyHelper where A: PrettyHelper, B: PrettyHelper {
    func pretty(_ value: (A.Value, B.Value)) -> Doc {
        return .lines([
            a.pretty(value.0),
            b.pretty(value.1)
        ])
    }
}

extension Label: PrettyHelper where A: PrettyHelper {
    func pretty(_ value: A.Value) -> Doc {
        return .lines([
            .text("▷ \(label)"),
            .indent(a.pretty(value))
        ])
    }
}

extension K: PrettyHelper where A: Pretty {
    func pretty(_ value: A) -> Doc {
        return value.doc
    }
}

extension One: PrettyHelper {
    func pretty(_ value: ()) -> Doc {
        return .empty
    }
}

extension String: Pretty { var doc: Doc { return .text(self) } }
extension Int: Pretty { var doc: Doc { return .text("\(self)") } }
extension Bool: Pretty { var doc: Doc { return .text("\(self)") } }

extension Zero: PrettyHelper {
    func pretty(_ value: Never) -> Doc {
        switch value {
            
        }
    }
}

extension Case: PrettyHelper where A: PrettyHelper, OtherCases: PrettyHelper {
    func pretty(_ value: Either<A.Value, OtherCases.Value>) -> Doc {
        switch value {
        case let .l(x): return a.pretty(x)
        case let .r(x): return b.pretty(x)
        }
    }
}
