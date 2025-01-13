//
//  Project13_ExtensionApp.swift
//  Project13-Extension
//
//  Created by Maximus Dionyssopoulos on 13/1/2025.
//

import SwiftUI

@main
struct Project13_ExtensionApp: App {
    
    init() {
        let dict = [
            "FontSize": 16,
            "ShadowStrength": 1
        ]
        UserDefaults.standard.register(defaults: dict)
    }
    
    var body: some Scene {
        DocumentGroup(newDocument: ScreenableDocument()) { file in
            ContentView(document: file.$document)
        }
        .commands {
            CommandGroup(after: .saveItem) {
                Button("Export...") {
                    NSApp.sendAction(#selector(AppCommands.export), to: nil, from: nil)
                }
                .keyboardShortcut("e")
            }
        }
        
        Settings(content: SettingsView.init)
    }
}
