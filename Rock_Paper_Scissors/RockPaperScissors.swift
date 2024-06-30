import SwiftUI

struct RockPaperScissorsView: View {
    @State private var cpuChoice: String = "❓"
    @State private var emojis = ["✊", "✋", "✌️"]
    @State private var isAnimating = false
    @State private var timer: Timer?
    
    var body: some View {
        VStack {
            Text("CPU's Choice")
                .font(.largeTitle)
            Text(cpuChoice)
                .font(.system(size: 100))
                .padding()
                .transition(.scale)
                .id(cpuChoice)
                .onAppear {
                    startAnimation()
                }
            Button(action: {
                stopAnimation()
            }) {
                Text("Stop")
                    .font(.title)
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
        }
    }
    
    func startAnimation() {
        isAnimating = true
        timer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { _ in
            withAnimation {
                cpuChoice = emojis.randomElement() ?? "❓"
            }
        }
    }
    
    func stopAnimation() {
        timer?.invalidate()
        isAnimating = false
        cpuChoice = emojis.randomElement() ?? "❓"
    }
}

struct RockPaperScissorsView_Previews: PreviewProvider {
    static var previews: some View {
        RockPaperScissorsView()
    }
}
