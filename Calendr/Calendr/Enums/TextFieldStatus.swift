//
//  TextFieldStatus.swift
//  Calendr
//
//  Created by Amiel Jireh Cordova on 5/10/22.
//

import Foundation
import UIKit

enum TextFieldStatus {
    case valid, invalid
    
    var borderColor: CGColor {
        switch self {
        case .valid: return UIColor.lightGray.cgColor
        default:
            return UIColor.systemRed.cgColor
        }
    }
    
    var isValid: Bool {
        switch self {
        case .valid: return true
        default:
            return false
        }
    }
}
