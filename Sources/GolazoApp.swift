import SwiftUI

@main
struct GolazoApp: App {
    init() {
        #if DEBUG
        MockData.selfCheck()
        #endif
    }
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
