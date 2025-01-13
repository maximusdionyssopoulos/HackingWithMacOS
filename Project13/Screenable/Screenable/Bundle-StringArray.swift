//
//  Bundle-StringArray.swift
//  Screenable
//
//  Created by Maximus Dionyssopoulos on 13/1/2025.
//
import Foundation


extension Bundle {
    func loadStringArray(from file: String) -> [String] {
        guard let url = self.url(forResource: file, withExtension: nil) else {
            fatalError("Failed to locate \(file) in the bundle")
        }
        guard let string = try? String(contentsOf: url) else {
            fatalError("Failed to load \(file) in the bundle")
        }
        
        return string.trimmingCharacters(in: .whitespacesAndNewlines).components(separatedBy: .newlines)
    }
}
