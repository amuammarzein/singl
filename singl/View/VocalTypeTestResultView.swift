//
//  UseHeadphonesViews.swift
//  singl
//
//  Created by Aang Muammar Zein on 18/07/23.
//
import SwiftUI
import AVFoundation
struct VocalTypeTestResultViews: View {
    @EnvironmentObject var router: Router
    @StateObject var taskManager: TaskManager = TaskManager()
    @StateObject var audioManager: AudioManager = AudioManager()
    var body: some View {
        VStack {
            HStack(spacing: 0) {
                Button(
                    action: {
                        router.path.removeLast(1)
                    }) {
                        Image(systemName: "chevron.left").foregroundColor(.white).font(.title3).fontWeight(.bold)
                        Text("Back").font(.body).foregroundColor(.white).fontWeight(.bold)
                    }
                Spacer()
            }.padding(.top, 10)
            Spacer()
            VStack(spacing: 40) {
                Image(systemName: "music.mic").foregroundColor(.white)  .font(.system(size: 100)).bold()
                Text("Let's move on to the next step\nFor a detailed result, click the button below to start this vocal range check").foregroundColor(.white).font(.title3).bold()
                    .multilineTextAlignment(.center)
                if taskManager.isActive {
                    Button(
                        action: {
                            router.path.append(Destination.vocalRangesTestView)
                        }) {
                            Text("Check your vocal range").foregroundColor(Color("Blue")).font(.body).bold().padding(20)
                        }.frame(maxWidth: .infinity).background(.white).cornerRadius(30)
                }
            }.padding(.bottom, 40)
            Spacer()
        }.padding(.horizontal, 30).frame(maxWidth: .infinity, maxHeight: .infinity).background(Color("Blue"))
            .navigationBarBackButtonHidden(true)
            .onReceive(taskManager.timer) { _ in
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                    withAnimation {
                        taskManager.isActiveTrue()
                    }
                }
            }
    }
}
struct VocalTypeTestResultViews_Previews: PreviewProvider {
    static var previews: some View {
        VocalTypeTestResultViews()
    }
}
