//
//  singlApp.swift
//  singl
//
//  Created by Aang Muammar Zein on 17/07/23.
//

import SwiftUI

@main
struct TrialNavigationStackApp: App {
    @StateObject var router = Router()
    
    
    var body: some Scene {
        WindowGroup {
            NavigationStack(path: $router.path) {
                SplashView()
                    .navigationDestination(for: Destination.self) { destination in
                        // logic to handle destination can be here...
                        if destination == .HomeView {
                            HomeView()
                        } else {
                            // or separate it to a separate View Builder class
                            ViewFactory.viewForDestination(destination)
                        }
                        
                        
                    }
            }
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

