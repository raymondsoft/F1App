//
//  F1AppApp.swift
//  F1App
//
//  Created by Raymond GUITTONNEAU on 18/02/2026.
//

import SwiftUI

@main
struct F1AppApp: App {
    private let container = AppCompositionRoot()

    var body: some Scene {
        WindowGroup {
            ContentView(container: container)
        }
    }
}
