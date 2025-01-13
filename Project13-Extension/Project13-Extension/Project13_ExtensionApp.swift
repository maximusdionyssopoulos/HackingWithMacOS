//
//  Project13_ExtensionApp.swift
//  Project13-Extension
//
//  Created by Maximus Dionyssopoulos on 13/1/2025.
//

import SwiftUI

@main
struct Project13_ExtensionApp: App {
    var body: some Scene {
        DocumentGroup(newDocument: ScreenableDocument()) { file in
            ContentView(document: file.$document)
        }
        .windowResizability(.contentSize)
        .commands {
            CommandGroup(after: .saveItem) {
                Button("Export...") {
                    NSApp.sendAction(#selector(AppCommands.export), to: nil, from: nil)
                }
                .keyboardShortcut("e")
            }
        }
    }
}
