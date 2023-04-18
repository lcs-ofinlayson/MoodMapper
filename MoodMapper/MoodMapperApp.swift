//
// MoodMapperApp.swift
// MoodMapper
//
// Created by Oliver Finlayson on 2023-04-06.
//

import Blackbird
import SwiftUI

@main
struct MoodMapperApp: App {
    var body: some Scene {
        WindowGroup {
            ListView()
            
            
                .environment(\.blackbirdDatabase, AppDatabase.instance)
        }
    }
}
