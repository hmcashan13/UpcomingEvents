//
//  Model.swift
//  UpcomingEvents
//
//  Created by Hudson Mcashan on 2/7/20.
//

import Foundation

struct EventUI {
    let title: String
    let start: String
    let end: String
    var isConflict: Bool = false
}
/// Event data structure used to sort
struct EventModel {
    let title: String
    let start: Date
    let end: Date
    var isConflict: Bool = false
}

/// Event data structure used to convert data from json
struct EventData: Codable {
    let title: String
    let start: String
    let end: String
}
