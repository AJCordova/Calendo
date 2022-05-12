//
//  Reactive+Extensions.swift
//  Calendr
//
//  Created by Amiel Jireh Cordova on 5/11/22.
//

import Foundation
import RxSwift

extension Reactive where Base: UITextField {
    public var borderColor: Binder<CGColor> {
        return Binder(base, binding: { textField, active in
            textField.layer.borderColor = active
        })
    }
}
