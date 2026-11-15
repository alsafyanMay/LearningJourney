import SwiftUI

@main   // نقطة البداية، مثل main() في Java
struct MyApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
                .preferredColorScheme(.dark)   // التطبيق كله Dark
        }
    }
}
