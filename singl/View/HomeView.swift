//
//  HomeView.swift
//  singl
//
//  Created by Aang Muammar Zein on 18/07/23.
//


import SwiftUI

struct HomeView: View {
    @StateObject var taskManager:TaskManager = TaskManager()
    @State private var selectedTab: TabBarItem = .menu1
//    @EnvironmentObject var router: Router
    var body: some View {
        TabBarContainer(selection: $selectedTab) {
            ForEach(TabBarItem.allCases) { item in
                if(item.title == "Dashboard"){
                    VStack(){
                        if(selectedTab == .menu1){
                            DashboardView()
                        }
                    }.tabBarItem(tab: item, selection: $selectedTab)
                }else if(item.title == "Vocal Test"){
                    VStack(){
                        if(selectedTab == .menu2){
                            UseHeadphonesViews()
                        }
                    }.tabBarItem(tab: item, selection: $selectedTab)
                }else if(item.title == "Singer & Song"){
                    VStack(){
                        if(selectedTab == .menu3){
                            SongRecomendationView()
                        }
                    }.tabBarItem(tab: item, selection: $selectedTab)
                }else{
                    VStack(){
                        if(selectedTab == .menu4){
                            SongConverterView()
                        }
                    }.tabBarItem(tab: item, selection: $selectedTab)
                }
                    
            }
        }.onAppear{
            taskManager.isDashboardTrue()
//            print("***")
//            print(router.path)
//            print(router.path.count)
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}

struct TabBarView: View {
    
    let tabs: [TabBarItem]
    @Binding  var selection: TabBarItem
    @Namespace private var namespace
    @State var localSelection: TabBarItem
    
    var body: some View {
        //tabBarVersion1
        tabBarVersion2
            .onChange(of: selection) { newValue in
                withAnimation(.easeInOut) {
                    localSelection = newValue
                }
            }
    }
}

extension TabBarView {
    private func switchToTab(tab: TabBarItem) {
        selection = tab
    }
}

extension TabBarView {
    private func tabView1(tab: TabBarItem) -> some View {
        VStack {
            Image(tab.image)
                .font(.subheadline)
            Text(tab.title)
                .font(.system(size: 10, weight: .semibold, design: .rounded))
        }
        .foregroundColor(selection == tab ? tab.color : Color.gray)
        .padding(.vertical, 8)
        .frame(maxWidth: .infinity)
        .background(selection == tab ? tab.color.opacity(0.2) : Color.clear)
        .cornerRadius(10)
    }
    
    private var tabBarVersion1: some View {
        HStack {
            ForEach(tabs) { tab in
                tabView1(tab: tab)
                    .onTapGesture {
                        switchToTab(tab: tab)
                    }
            }
        }
    }
}

// tabBarVersion2
extension TabBarView {
    private func tabView2(tab: TabBarItem) -> some View {
        VStack {
            Image(localSelection == tab ? tab.imageSel : tab.image)
                .resizable()
                .scaledToFit()
                .frame(height:30)
                
            Text(tab.title)
                .font(.system(size: 10, weight: .semibold, design: .rounded))
        }
        .foregroundColor(localSelection == tab ? Color.white : tab.color)
        .padding(.vertical, 8)
        .frame(maxWidth: .infinity)
        .background(
            ZStack {
                if localSelection == tab {
                    RoundedRectangle(cornerRadius: 10)
                        .fill(tab.color)
                        .matchedGeometryEffect(id: "background_rectangle", in: namespace)
                }
            }
        )
    }
    
    private var tabBarVersion2: some View {
        HStack {
            ForEach(tabs) { tab in
                tabView2(tab: tab)
                    .onTapGesture {
                        switchToTab(tab: tab)
                    }
            }
        }
        .padding(6)
        .background(Color.white)
        .cornerRadius(10)
        .shadow(color: Color.black.opacity(0.3), radius: 10, x: 0, y: 5)
        .padding(.horizontal).opacity(1)
    }
}

struct TabBarView_Previews: PreviewProvider {
    
    static let tabs: [TabBarItem] = [.menu1, .menu2, .menu3, .menu4]
    
    static var previews: some View {
        VStack {
            Spacer()
            TabBarView(tabs: tabs, selection: .constant(tabs.first!), localSelection: tabs.first!)
        }
    }
}

struct TabBarContainer<Content:View>: View {
    
    @Binding var selection: TabBarItem
    let content: Content
    @State private var tabs: [TabBarItem] = []
    
    init(selection: Binding<TabBarItem>, @ViewBuilder content: () -> Content) {
        self._selection = selection
        self.content = content()
    }
    
    var body: some View {
        ZStack(alignment: .bottom) {
            content
            TabBarView(tabs: tabs, selection: $selection, localSelection: selection)
        }
        .onPreferenceChange(TabBarItemsPreferenceKey.self) { value in
            tabs = value
        }
    }
}

enum TabBarItem: Identifiable, Hashable, CaseIterable {
    
    case menu1, menu2, menu3, menu4
    
    var id: Self {
        return self
    }
    var imageSel: String {
        switch self{
        case .menu1: return "dashboard"
        case .menu2: return "vocal"
        case .menu3: return "music"
        case .menu4: return "convert"
        }
    }
    
    var image: String {
        switch self {
        case .menu1: return "Menu1"
        case .menu2: return "Menu2"
        case .menu3: return "Menu3"
        case .menu4: return "Menu4"
        }
    }
    
    var title: String {
        switch self {
        case .menu1: return "Dashboard"
        case .menu2: return "Vocal Test"
        case .menu3: return "Singer & Song"
        case .menu4: return "Converter"
        }
    }
    
    var color: Color {
        switch self {
        case .menu1: return Color("Blue")
        case .menu2: return Color("Blue")
        case .menu3: return Color("Blue")
        case .menu4: return Color("Blue")
        }
    }
}

struct TabBarItemsPreferenceKey: PreferenceKey {
    
    static var defaultValue: [TabBarItem] = []
    
    static func reduce(value: inout [TabBarItem], nextValue: () -> [TabBarItem]) {
        value += nextValue()
    }
}

struct TabBarItemModifier: ViewModifier {
    
    let tab: TabBarItem
    @Binding var selection: TabBarItem
    
    func body(content: Content) -> some View {
        content
            .opacity(selection == tab ? 1.0 : 0.0)
            .preference(key: TabBarItemsPreferenceKey.self, value: [tab])
    }
}

extension View {
    func tabBarItem(tab: TabBarItem, selection: Binding<TabBarItem>) -> some View {
        self
            .modifier(TabBarItemModifier(tab: tab, selection: selection))
    }
}
