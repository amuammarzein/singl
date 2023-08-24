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
                    .navigationDestination(for: Destination.self) { destination in
                        // logic to handle destination can be here...
                        if destination == .homeView {
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
    case homeView
    case splashView
    case getStartedView
    case useHeadphonesViews
    case vocalTypeTestView
    case vocalTypeTestResultView
    case vocalRangesTestView
    case vocalRangesTestResultView
    case songConverterView
    case dashboardView
    case songRecomendationView(Bool)
    case songRecomendationShareView(Bool)
}
class ViewFactory {
    var isTrue = true
    var isFalse = false
    @ViewBuilder
    static func viewForDestination(_ destination: Destination) -> some View {
        switch destination {
        case .homeView:
            HomeView()
        case .dashboardView:
            DashboardView()
        case .useHeadphonesViews:
            UseHeadphonesViews()
        case .splashView:
            SplashView()
        case .getStartedView:
            GetStartedView()
        case .vocalTypeTestView:
            VocalTypeTestView()
        case .vocalTypeTestResultView:
            VocalTypeTestResultViews()
        case .vocalRangesTestView:
            VocalRangesTestView()
        case .vocalRangesTestResultView:
            VocalRangesTestResultView()
        case .songConverterView:
            SongConverterView()
        case .songRecomendationView(let isSinger):
            SongRecomendationView(isSinger: isSinger)
        case .songRecomendationShareView(let isSinger):
            SongRecomendationShareView(isSinger: isSinger)
        }
    }
}
