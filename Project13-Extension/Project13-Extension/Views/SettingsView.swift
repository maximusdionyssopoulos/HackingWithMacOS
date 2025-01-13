//
//  SettingsView.swift
//  Project13-Extension
//
//  Created by Maximus Dionyssopoulos on 13/1/2025.
//

import SwiftUI

struct SettingsView: View {
    let fonts = Bundle.main.loadStringArray(from: "Fonts.txt")
    let backgrounds = Bundle.main.loadStringArray(from: "Backgrounds.txt")
    
    @AppStorage("Font") var font = "Helvetica Neue"
    @AppStorage("FontSize") var fontSize = 16
    @AppStorage("BackgroundImage") var backgroundImage = ""
    @AppStorage("ShadowStrength") var shadowStrength = 1
    
    var body: some View {
        TabView {
            Form {
                Picker("Select a caption font", selection: $font) {
                    ForEach(fonts, id: \.self, content: Text.init)
                }
                Picker("Size of caption font", selection: $fontSize) {
                    ForEach(Array(stride(from: 12, through: 72, by: 4)), id: \.self) { size in
                        Text("\(size)pt")
                    }
                }
                
                Picker("Background image", selection: $backgroundImage) {
                    Text("No background image").tag("")
                    Divider()
                    ForEach(backgrounds, id: \.self, content: Text.init)
                }
                
                Stepper("Shadow radius: \(shadowStrength)pt", value: $shadowStrength, in: 1...20)
            }
            .padding()
            .tabItem {
                Label("Settings", systemImage: "gear")
            }
        }
        .frame(width: 400)

    }
}

#Preview {
    SettingsView()
}
