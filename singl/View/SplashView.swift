import SwiftUI
struct SplashView: View {
    @EnvironmentObject var router: Router
    @StateObject var taskManager: TaskManager = TaskManager()
    var body: some View {
        VStack(spacing: 20) {
            Image("Logo").resizable().scaledToFit().frame(width: 100)
            Image("LogoText").resizable().scaledToFit().frame(width: 100)
        }
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                withAnimation {
                    if taskManager.isSkip {
                        router.path.append(Destination.homeView)
                    } else {
                        router.path.append(Destination.getStartedView)
                    }
                }
            }
        }
    }
}
struct SplashView_Previews: PreviewProvider {
    static var previews: some View {
        SplashView()
    }
}
