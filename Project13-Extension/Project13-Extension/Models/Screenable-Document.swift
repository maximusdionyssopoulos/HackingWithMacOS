//
//  Screenable-Document.swift
//  Project13-Extension
//
//  Created by Maximus Dionyssopoulos on 13/1/2025.
//

import SwiftUI
import UniformTypeIdentifiers

struct ScreenableDocument: FileDocument, Codable {
    static var readableContentTypes = [UTType(exportedAs: "com.maximus-dionyssopoulos.screenable")]
    var caption = ""
    var font = UserDefaults.standard.string(forKey: "Font") ?? "Helvetica Neue"
    var fontSize = UserDefaults.standard.integer(forKey: "FontSize") 
    var backgroundImage =  UserDefaults.standard.string(forKey: "BackgroundImage") ?? ""
    var userImage: Data?
    
    var captionColor = Color.black
    var backgroundColorTop = Color.clear
    var backgroundColorBottom = Color.clear
    
    var dropShadowLocation = 0
    var dropShadowStrength = UserDefaults.standard.integer(forKey: "ShadowStrength") 
    
    
    init(configuration: ReadConfiguration) throws {
        if let data = configuration.file.regularFileContents {
            self = try JSONDecoder().decode(ScreenableDocument.self, from: data)
        }
    }
    
    func fileWrapper(configuration: WriteConfiguration) throws -> FileWrapper {
        let data = try JSONEncoder().encode(self)
        return FileWrapper(regularFileWithContents: data)
    }
    
    init() {}
}

