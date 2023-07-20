import SwiftUI

struct ShimmerView: View {
    @State private var isAnimating = false
    
    var body: some View {
        Rectangle()
            .background(.white)
            .overlay(
                RoundedRectangle(cornerRadius: 8)
                    .fill(.white)
                    .opacity(0.3)
                    .mask(
                        Rectangle()
                            .fill(
                                LinearGradient(
                                    gradient: Gradient(colors: [.clear, .white, .clear]),
                                    startPoint: .leading,
                                    endPoint: .trailing
                                )
                            )
                            .offset(x: isAnimating ? 200 : -200)
                    )
            )
            .onAppear {
                withAnimation(Animation.linear(duration: 1.5).repeatForever()) {
                    isAnimating = true
                }
            }
    }
}
