//
//  ContentView.swift
//  Screenable
//
//  Created by Maximus Dionyssopoulos on 13/1/2025.
//

import SwiftUI

@MainActor struct ContentView: View {
    @Binding var document: ScreenableDocument
    
    let fonts = Bundle.main.loadStringArray(from: "Fonts.txt")
    let backgrounds = Bundle.main.loadStringArray(from: "Backgrounds.txt")

    
    var body: some View {
        HStack(spacing: 20) {
            RenderView(document: document)
                .dropDestination(for: URL.self) { items, location in
                    handleDrop(of: items)
                }
                .draggable(snapshotToURL())
            VStack(spacing: 20) {
                
                VStack(alignment: .leading) {
                    Text("Caption")
                        .bold()
    
                    TextEditor(text: $document.caption)
                        .font(.title)
                        .border(.tertiary, width: 1)
                }
                
                VStack(alignment: .leading) {
                    Picker("Select a caption font", selection: $document.font) {
                        ForEach(fonts, id: \.self, content: Text.init)
                    }
                    .labelsHidden()
                    HStack {
                        Picker("Size of caption font", selection: $document.fontSize) {
                            ForEach(Array(stride(from: 12, through: 72, by: 4)), id: \.self) { size in
                                Text("\(size)pt")
                            }
                        }
                        .labelsHidden()
                        ColorPicker("Caption color", selection: $document.captionColor)
                    }
                }

                
                VStack(alignment: .leading) {
                    Text("Background Image")
                        .bold()
                    Picker("Background image", selection: $document.backgroundImage) {
                        Text("No background image").tag("")
                        Divider()
                        ForEach(backgrounds, id: \.self, content: Text.init)
                    }
                } 
                .labelsHidden()
                
                VStack(alignment: .leading) {
                    Text("Background Colour")
                        .bold()
                    Text("If set to non-transparent, this will be drawn over the background image.")
                        .frame(maxWidth: .infinity, alignment: .leading)
                    HStack(spacing: 20) {
                        ColorPicker("Start:", selection: $document.backgroundColorTop)
                        ColorPicker("End:", selection: $document.backgroundColorBottom)
                    }
                }
                
                VStack(alignment: .leading) {
                    Text("Drop shadow")
                        .bold()

                    Picker("Drop shadow location", selection: $document.dropShadowLocation) {
                        Text("None").tag(0)
                        Text("Text").tag(1)
                        Text("Device").tag(2)
                        Text("Both").tag(3)
                    }
                    .pickerStyle(.segmented)
                    .labelsHidden()

                    Stepper("Shadow radius: \(document.dropShadowStrength)pt", value: $document.dropShadowStrength, in: 1...20)
                }
            }
            .frame(width: 250)
        }
        .padding()
        .onCommand(#selector(AppCommands.export)) {
            export()
        }
        .toolbar {
            ToolbarItemGroup {
                Picker("Select a caption font", selection: $document.font) {
                    ForEach(fonts, id: \.self, content: Text.init)
                }
            }
            ToolbarItemGroup {
                Button("Export", action: export)
                
                ShareLink(item: snapshotToURL())
            }
        }
    }
    
    func handleDrop(of urls: [URL]) -> Bool {
        guard let url = urls.first else {return false}
        let loadedImage = try? Data(contentsOf: url)
        document.userImage = loadedImage
        return true
    }
    
    func createSnapshot() -> Data? {
        let renderer = ImageRenderer(content: RenderView(document: document))
        
        guard let tiff = renderer.nsImage?.tiffRepresentation else {
            return nil
        }
        
        let bitmap = NSBitmapImageRep(data: tiff)
        return bitmap?.representation(using: .png, properties: [:])
    }
    
    func export() {
        guard let png = createSnapshot() else { return }

        let panel = NSSavePanel()
        panel.allowedContentTypes = [.png]

        panel.begin { result in
            if result == .OK {
                guard let url = panel.url else { return }

                do {
                    try png.write(to: url)
                } catch {
                    print (error.localizedDescription)
                }
            }
        }
    }
    
    func snapshotToURL() -> URL {
        let url = URL.temporaryDirectory.appending(path: "ScreenableExport").appendingPathExtension("png")
        try? createSnapshot()?.write(to: url)
        return url
    }
}

#Preview {
    ContentView(document: .constant(ScreenableDocument()))
}
