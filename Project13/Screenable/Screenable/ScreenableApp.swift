//
//  ScreenableApp.swift
//  Screenable
//
//  Created by Maximus Dionyssopoulos on 13/1/2025.
//

import SwiftUI

@main
struct ScreenableApp: App {
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

/**
 Examples of other command options
 
 CommandMenu("Export") {
     Button("Export as PNG") {
         NSApp.sendAction(#selector(AppCommands.export), to: nil, from: nil)
     }
     .keyboardShortcut("e")
 
 “.commands {
     CommandMenu("Export") {
         Menu("Options") {
             Button("Ignore Background") {
                 // action code
             }

             Button("Also Render Thumbnail") {
                 // action code
             }
         }

         Button("Export as PNG") {
             // action code
         }
         .keyboardShortcut("e")
     }
 }
 */
