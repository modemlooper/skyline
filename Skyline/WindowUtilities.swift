import SwiftUI
import AppKit

// Helper to resolve the NSWindow from SwiftUI hierarchy
struct WindowAccessor: NSViewRepresentable {
    var onResolve: (NSWindow) -> Void

    func makeNSView(context: Context) -> NSView {
        let view = NSView()
        DispatchQueue.main.async { [weak view] in
            if let window = view?.window {
                onResolve(window)
            }
        }
        return view
    }

    func updateNSView(_ nsView: NSView, context: Context) {}
}

// Window delegate that hides the app instead of closing the window
final class HidingWindowDelegate: NSObject, NSWindowDelegate {
    func windowShouldClose(_ sender: NSWindow) -> Bool {
        // Hide the entire app (Cmd-H behavior)
        NSApp.hide(nil)
        // Prevent the window from actually closing
        return false
    }
}
