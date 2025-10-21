import SwiftUI

struct MainWindowView: View {
    private let windowDelegate = HidingWindowDelegate()

    var body: some View {
        ContentView()
            .background(
                WindowAccessor { window in
                    window.delegate = windowDelegate
                }
            )
    }
}

#Preview {
    MainWindowView()
}
