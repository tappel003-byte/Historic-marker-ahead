import SwiftUI

struct ContentView: View {
    var body: some View {
        TabView {
            HomeView()
                .tabItem { Label("Drive", systemImage: "car.fill") }
            RecentHistoryView()
                .tabItem { Label("Recent", systemImage: "clock") }
            DebugView()
                .tabItem { Label("Debug", systemImage: "wrench.and.screwdriver") }
            SettingsView()
                .tabItem { Label("Settings", systemImage: "gearshape") }
        }
    }
}
