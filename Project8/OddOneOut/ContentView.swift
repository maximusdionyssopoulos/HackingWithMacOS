//
//  ContentView.swift
//  OddOneOut
//
//  Created by Maximus Dionyssopoulos on 22/7/2023.
//

import SwiftUI

struct ContentView: View {
    static let gridSize = 10
    @State var images = ["elephant", "giraffe", "hippo", "monkey", "panda",
                         "parrot", "penguin", "pig", "rabbit", "snake"]
    @State var layout = Array(repeating: "penguin", count: gridSize * gridSize)
    @State var currentLevel = 1
    @State var wrongAnswers = 0
    enum GameState {
        case start, inGame, won, lost
    }
    @State var gameState = GameState.start
    
    
    func image(_ row: Int, _ column: Int) -> String {
        layout[row * Self.gridSize + column]
    }
    
    func generateLayout(items: Int) {
        layout.removeAll(keepingCapacity: true)
        images.shuffle()
        
        layout.append(images[0])
        
        var numUsed = 0
        var itemCount = 1
        
        for _ in 1 ..< items {
            layout.append(images[itemCount])
            numUsed += 1
            
            if numUsed == 2 {
                numUsed = 0
                itemCount += 1
            }
            
            if itemCount == images.count {
                itemCount = 1
            }
        }
        
        layout += Array(repeating: "empty", count: 100-layout.count)
        layout.shuffle()
        
        
    }
    
    func createLevel() {
        if currentLevel == 9 {
            withAnimation {
                gameState = .won
            }
        } else {
            let numbersOfItems = [0, 5, 15, 25, 35, 49, 46, 81, 100]
            generateLayout(items: numbersOfItems[currentLevel])
        }
    } 
    
    func processAnswer(at row: Int, _ column: Int) {
        if image(row, column) == images[0] {
            currentLevel += 1
            wrongAnswers = 0
            withAnimation {
                createLevel()
            }
        } else {
            wrongAnswers += 1
            if currentLevel > 1 && wrongAnswers == 3 {
                gameState = .lost
            }
        }
    }
    
    var body: some View {
        ZStack {
            if gameState == .start {
                VStack {
                    Text("Odd One Out")
                        .font(.system(size: 36, weight: .thin))
                        .fixedSize()
                    Text("Choose the lone animal to advance to the next round.\nBe warned three strikes and you're out!")
                        .multilineTextAlignment(.center)
                        .padding()
                    
                    Button("Start Game") {
                        withAnimation {
                            gameState = .inGame
//                            createLevel()
                        }
                        
                    }
                    .font(.headline)
                    .foregroundColor(.white)
                    .buttonStyle(.borderless)
                    .padding(15)
                    .background(.blue)
                    .clipShape(Capsule())
                }
            }
            
            
            VStack {
                Text("Odd One Out")
                    .font(.system(size: 36, weight: .thin))
                    .fixedSize()
                Text("Level: \(currentLevel)/9")
                    .font(.subheadline)
                ForEach(0..<Self.gridSize, id: \.self) { row in
                    HStack {
                        ForEach(0..<Self.gridSize, id: \.self) {column in
                            Button {
                                processAnswer(at: row, column)
                            } label: {
                                if image(row, column) == "empty" {
                                    Rectangle()
                                        .fill(.clear)
                                        .frame(width: 64, height: 64)
                                }
                                else  {
                                    Image(image(row, column))
                                }
                            }
                            .buttonStyle(.borderless)
                        }
                    }
                }
            }
//            .animation()
            .opacity(gameState == .start ? 0.0 : gameState != .inGame ? 0.2 : 1)
            .animation(
                Animation.easeInOut(duration: 0.20),
                value: gameState)
            
            if gameState == .won || gameState == .lost {
                VStack {
                    
                    Text("Game Over")
                        .font(.largeTitle)
                    Text(gameState == .won ? "You Won!" : "You Lost")
                        .font(.title2)
                        .padding()
                    HStack {
                        Button("Play Again") {
                            currentLevel = 1
                            withAnimation {
                                gameState = .inGame
                                createLevel()
                            }
                            
                        }
                        .font(.headline)
                        .foregroundColor(.white)
                        .buttonStyle(.borderless)
                        .padding(15)
                        .background(.blue)
                        .clipShape(Capsule())
                        
                        Button("Go Home") {
                            currentLevel = 1
                            withAnimation {
                                gameState = .start
                                createLevel()
                            }
                            
                        }
                        .font(.headline)
                        .foregroundColor(.white)
                        .buttonStyle(.borderless)
                        .padding(15)
                        .background(.blue)
                        .clipShape(Capsule())
                    }
                }
            }
        }
        .onAppear(perform: createLevel)
        .padding()
        .contentShape(Rectangle())
        .contextMenu {
            Button("Home") {
                currentLevel = 1
                withAnimation {
                    gameState = .start
                    createLevel()
                }
            }
            Button("Start New Game") {
                currentLevel = 1
                withAnimation {
                    let originalState = gameState
                    gameState = .inGame
                    if originalState != .start {
                        createLevel()
                    }
                }
            }

        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
