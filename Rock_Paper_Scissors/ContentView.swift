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
        VStack {
            Spacer()
            
            Text("Rock, Paper, Scissors")
                .font(.largeTitle)
                .fontWeight(.bold)
            
            Spacer()
            
            HStack {
                ForEach(Move.allCases, id: \.self) { move in
                    Button(action: {
                        userMove = move
                        playGame()
                    }) {
                        Text(move.rawValue)
                            .font(.system(size: 50))
                    }
                    .disabled(showResult)
                }
            }
            
            Spacer()
            
            if isAnimating {
                Text(randomEmoji)
                    .font(.system(size: 50))
                    .onAppear {
                        animateCPUChoice()
                    }
            } else if let cpuMove = cpuMove {
                Text(cpuMove.rawValue)
                    .font(.system(size: 50))
            } else {
                Text("❓")
                    .font(.system(size: 50))
            }
            
            Spacer()
            
            if showResult {
                Text(result)
                    .font(.title)
                    .fontWeight(.bold)
                    .padding()
                
                Button(action: {
                    resetGame()
                }) {
                    Text("Start New Game")
                        .font(.title2)
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
            }
            
            Spacer()
        }
        .padding()
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

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

