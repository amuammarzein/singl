import SwiftUI

struct SplashView: View {
    @StateObject var taskManager:TaskManager = TaskManager()
    
    var body: some View {
        if(taskManager.isActive){
            if(taskManager.isSkip){
                HomeView()
            }else{
                GetStartedView()
            }
        } else {
            VStack(spacing:20) {
                
                Image("Logo").resizable().scaledToFit().frame(width: 100)
                Image("LogoText").resizable().scaledToFit().frame(width: 100)
                
            }
            .onAppear {
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                    withAnimation {
                        taskManager.isActiveTrue()
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
