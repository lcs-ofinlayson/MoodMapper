//
// MoodItem.swift
// MoodMapper
//
// /Users/OFinlayson/Downloads/db.sqliteCreated by Oliver Finlayson on 2023-04-06.
//

import Blackbird
import Foundation

struct MoodItem: BlackbirdModel {
    @BlackbirdColumn var id: Int
    @BlackbirdColumn var description: String
    @BlackbirdColumn var emoji: String
}
