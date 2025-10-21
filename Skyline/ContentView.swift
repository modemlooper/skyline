import SwiftUI
import WebKit

// MARK: - WebView Wrapper
struct WebView: NSViewRepresentable {
    let url: URL
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    func makeNSView(context: Context) -> WKWebView {
        let config = WKWebViewConfiguration()
        let webView = WKWebView(frame: .zero, configuration: config)
        webView.navigationDelegate = context.coordinator
        webView.uiDelegate = context.coordinator  // <-- ADD THIS LINE
        return webView
    }
    
    func updateNSView(_ webView: WKWebView, context: Context) {
        // Only load if the URL is different from what's currently loaded
        if webView.url != url {
            let request = URLRequest(url: url)
            webView.load(request)
        }
    }
    
    // MARK: - Coordinator
    class Coordinator: NSObject, WKNavigationDelegate, WKUIDelegate { // <-- ADD WKUIDelegate
        var parent: WebView
            
        init(_ parent: WebView) {
            self.parent = parent
        }
            
        // YOUR EXISTING FUNCTION (Keep this)
        func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
            
            guard let url = navigationAction.request.url else {
                decisionHandler(.allow)
                return
            }

            // Handle standard user link clicks
            if navigationAction.navigationType == .linkActivated {
                if url.scheme == "http" || url.scheme == "https" {
                    decisionHandler(.cancel)
                    return
                }
            }
            
            decisionHandler(.allow)
        }
        
        // --- ADD THIS NEW FUNCTION ---
        // This handles window.open() and target="_blank" links
        func webView(_ webView: WKWebView,
                     createWebViewWith configuration: WKWebViewConfiguration,
                     for navigationAction: WKNavigationAction,
                     windowFeatures: WKWindowFeatures) -> WKWebView? {
            
            // Check if this new window request has a URL
            if let url = navigationAction.request.url {
                // If it does, send it to the system's external browser
                print(url)
                NSWorkspace.shared.open(url)
            }
            
            // Tell WebKit we've handled it and not to create a new webview
            return nil
        }
    }
}

// MARK: - Content View
struct ContentView: View {
    @State private var urlString = "https://bsky.app"
    
    var body: some View {
        // WebView
        if let url = URL(string: urlString) {
            WebView(url: url)
        } else {
            Text("Invalid URL")
                .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
    }
}
