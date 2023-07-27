//
//  singlApp.swift
//  singl
//
//  Created by Aang Muammar Zein on 17/07/23.
//

import AudioKit
import AudioKitEX
import AudioKitUI
import AVFoundation
import SwiftUI

@main
struct TrialNavigationStackApp: App {
    @StateObject var router = Router()
    
    init() {
        #if os(iOS)
            do {
                Settings.bufferLength = .short
                try AVAudioSession.sharedInstance().setPreferredIOBufferDuration(Settings.bufferLength.duration)
                try AVAudioSession.sharedInstance().setCategory(.playAndRecord,
                                                                options: [.defaultToSpeaker, .mixWithOthers, .allowBluetoothA2DP])
                try AVAudioSession.sharedInstance().setActive(true)
            } catch let err {
                print(err)
            }
        #endif
    }
    
    var body: some Scene {
        WindowGroup {
            NavigationStack(path: $router.path) {
                SplashView()
//                VocalRangesTestView()
//                TunerView()
                    .navigationDestination(for: Destination.self) { destination in
                        // logic to handle destination can be here...
                        if destination == .HomeView {
                            HomeView()
                        } else {
                            // or separate it to a separate View Builder class
                            ViewFactory.viewForDestination(destination)
                        }
                        
                        
                    }
            }.preferredColorScheme(.light)
            .environmentObject(router)
        }
    }
}


class Router: ObservableObject {
    @Published var path = NavigationPath()
    
    // example function inside router
    func popToRoot() {
        path.removeLast(path.count)
    }
    
}

// custom page
enum Destination: Hashable {
    case HomeView
    case UseHeadphonesViews
}

class ViewFactory {
    @ViewBuilder
    static func viewForDestination(_ destination: Destination) -> some View {
        switch destination {
        case .HomeView:
            HomeView()
        case .UseHeadphonesViews:
            UseHeadphonesViews()
        }
    }
}

