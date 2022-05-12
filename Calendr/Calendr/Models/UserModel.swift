//
//  Models.swift
//  Calendr
//
//  Created by Amiel Jireh Cordova on 5/12/22.
//

import Foundation

struct UserModel: Codable {
    let userName: String
    let password: String
    let events: [EventModel]
    
//    init(userName: String, password: String, events: [EventModel]) {
//        self.userName = userName
//        self.password = password
//        self.events = events
//    }
}
