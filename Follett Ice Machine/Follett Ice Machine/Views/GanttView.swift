//
//  GanttView.swift
//  Follett Ice Machine
//
//  Created by Wei Zheng on 5/3/22.
//
import SwiftUI
import WebKit

struct GanttView: UIViewRepresentable {
    
    @Binding var htmlString: String
    var webView: WKWebView?
    
    class Coordinator: NSObject, UIScrollViewDelegate {
        var parent: GanttView

        init(_ parent: GanttView) {
            self.parent = parent
        }

        func scrollViewDidScroll(_ scrollView: UIScrollView) {
            if (scrollView.contentOffset.x > 0){
                scrollView.contentOffset = CGPoint(x: 0, y: scrollView.contentOffset.y)
            }
         }
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    init (htmlString: Binding<String>) {
        self.webView = WKWebView()
        self._htmlString = htmlString
        webView?.scrollView.showsHorizontalScrollIndicator = false
        webView?.scrollView.showsVerticalScrollIndicator = false
        webView?.scrollView.pinchGestureRecognizer?.isEnabled = false
        webView?.scrollView.bounces = false
    }
    
    func makeUIView(context: Context) -> WKWebView {
        webView?.scrollView.delegate = context.coordinator
        return webView!
    }
   
    func updateUIView(_ uiView: WKWebView, context: Context) {
        uiView.loadHTMLString(htmlString, baseURL: nil)
    }
}
