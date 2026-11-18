import SwiftUI

@main   // نقطة البداية، مثل main() في Java
struct MyApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()   // the colors follow the device setting (Light or Dark)
        }
    }
}
