//
//  UseHeadphonesViews.swift
//  singl
//
//  Created by Aang Muammar Zein on 18/07/23.
//
import SwiftUI
import AVFoundation
struct UseHeadphonesViews: View {
    @EnvironmentObject var router: Router
    @StateObject var taskManager: TaskManager = TaskManager()
    @StateObject var audioManager: AudioManager = AudioManager()
    var body: some View {
        VStack {
            HStack(spacing: 0) {
                Spacer()
                Button(
                    action: {
                        taskManager.isMenuTrue()
                        taskManager.isSkipTrue()
                        router.popToRoot()
                    }) {
                        Text("Skip checking").font(.callout).foregroundColor(.white).underline()
                    }
            }.padding(.top, 10)
            Spacer()
            VStack(spacing: 40) {
                Image(systemName: "headphones").foregroundColor(.white)  .font(.system(size: 100)).bold()
                Text("Make sure to sing with headphones on for better result").foregroundColor(.white).font(.title3).bold()
                    .multilineTextAlignment(.center)
                if taskManager.isActive {
                    Button(
                        action: {
                            router.path.append(Destination.vocalTypeTestView)
                        }) {
                            Text("Check your vocal range").foregroundColor(Color("Blue")).font(.body).bold().padding(20)
                        }.frame(maxWidth: .infinity).background(.white).cornerRadius(30)
                }
            }.padding(.bottom, 40)
            Spacer()
        }.padding(.horizontal, 30).frame(maxWidth: .infinity, maxHeight: .infinity).background(Color("Blue")).onAppear {
            taskManager.isMenuFalse()
            audioManager.playAudio()
        }
        .navigationBarBackButtonHidden(true)
        .onDisappear {
            audioManager.stopAudio()
        }.onReceive(taskManager.timer) { _ in
            DispatchQueue.main.asyncAfter(deadline: .now() + 4) {
                withAnimation {
                    taskManager.isActiveTrue()
                }
            }
        }
    }
}

struct UseHeadphonesViews_Previews: PreviewProvider {
    static var previews: some View {
        UseHeadphonesViews()
    }
}
