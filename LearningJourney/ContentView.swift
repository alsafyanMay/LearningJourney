import SwiftUI
import Playgrounds

struct ContentView: View {
    var body: some View {
        Text("Hello, world!")
            .padding()
        Button("Save") { }
            .buttonStyle(.glassProminent)
            .tint(.gray)
    }
}

#Preview {
    ContentView()
}

#Playground {
    _ = 1 + 2
}
