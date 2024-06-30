import SwiftUI

enum Move: String, CaseIterable {
    case rock = "✊"
    case paper = "✋"
    case scissors = "✌️"
}

struct ContentView: View {
    @State private var userMove: Move?
    @State private var cpuMove: Move?
    @State private var result: String = ""
    @State private var showResult = false
    @State private var isAnimating = false
    @State private var randomEmoji = "❓"
    
    var body: some View {
        ZStack {
            Color.blue.ignoresSafeArea() // Full screen background color
            
            VStack {
                Spacer()
                
                StyledText(text: "Rock, Paper, Scissors")
                Spacer()
                
                Text("Make your selection").foregroundColor(.white)
                HStack {
                  
                    ForEach(Move.allCases, id: \.self) { move in
                        Button(action: {
                            userMove = move
                            playGame()
                        }) {
                            Text(move.rawValue)
                        }
                        .customButtonStyle()
                        .disabled(showResult)
                    }
                }
                
                Spacer()
                
                if isAnimating {
                    Text(randomEmoji)
                        .font(.system(size: 50))
                        .padding()
                        .background(Color.gray.opacity(0.3))
                        .cornerRadius(10)
                        .shadow(radius: 10)
                        .onAppear {
                            animateCPUChoice()
                        }
                } else if let cpuMove = cpuMove {
                    Text(cpuMove.rawValue)
                        .font(.system(size: 50))
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                        .shadow(radius: 10)
                } else {
                    Text("❔")
                        .font(.system(size: 50))
                        .padding()
                        .foregroundColor(.white) // Change the color of the question mark to white
                        .cornerRadius(10)
                        .shadow(radius: 10)
                }
                
                Spacer()
                
                if showResult {
                    Text(result)
                        .font(.title)
                        .fontWeight(.bold)
                        .padding()
                        .background(Color.orange)
                        .cornerRadius(10)
                        .shadow(radius: 10)
                    
                    Button(action: {
                        resetGame()
                    }) {
                        Text("Start New Game")
                            .font(.title2)
                            .padding()
                            .background(Color.red)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                            .shadow(radius: 10)
                    }
                    .padding(.top, 20)
                }
                
                Spacer()
            }
            .padding()
        }
    }
    
    func playGame() {
        showResult = false
        isAnimating = true
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            cpuMove = Move.allCases.randomElement()
            determineWinner()
            isAnimating = false
        }
    }
    
    func animateCPUChoice() {
        guard isAnimating else { return }
        
        let allMoves = Move.allCases.map { $0.rawValue }
        var currentIndex = 0
        
        Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { timer in
            if !isAnimating {
                timer.invalidate()
            } else {
                randomEmoji = allMoves[currentIndex]
                currentIndex = (currentIndex + 1) % allMoves.count
            }
        }
    }
    
    func determineWinner() {
        guard let userMove = userMove, let cpuMove = cpuMove else { return }
        
        if userMove == cpuMove {
            result = "It's a draw!"
        } else if (userMove == .rock && cpuMove == .scissors) ||
                    (userMove == .paper && cpuMove == .rock) ||
                    (userMove == .scissors && cpuMove == .paper) {
            result = "You win!"
        } else {
            result = "You lose!"
        }
        
        showResult = true
    }
    
    func resetGame() {
        userMove = nil
        cpuMove = nil
        result = ""
        showResult = false
        randomEmoji = "❓"
    }
}

struct StyledText: View {
    let text: String

    var body: some View {
        Text(text)
            .font(.largeTitle)
            .multilineTextAlignment(.center)
            .fontWeight(.bold)
            .padding()
            .background(Color.yellow)
            .cornerRadius(10)
            .shadow(radius: 10)
    }
}

struct CustomButtonStyle: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.system(size: 50))
            .padding()
            .background(Color.green)
            .foregroundColor(.white)
            .cornerRadius(10)
            .shadow(radius: 10)
    }
}

extension View {
    func customButtonStyle() -> some View {
        self.modifier(CustomButtonStyle())
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

@main
struct RockPaperScissorsApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
