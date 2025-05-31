import SwiftUI

struct ScannerView: UIViewControllerRepresentable {
    @Binding var scannedCode: String?
    var onScan: (String) -> Void

    func makeCoordinator() -> Coordinator {
        Coordinator(parent: self, onScan: onScan)
    }

    func makeUIViewController(context: Context) -> ScannerViewController {
        let controller = ScannerViewController()
        controller.delegate = context.coordinator
        return controller
    }

    func updateUIViewController(_ uiViewController: ScannerViewController, context: Context) {}

    class Coordinator: NSObject, ScannerViewControllerDelegate {
        let parent: ScannerView
        let onScan: (String) -> Void

        init(parent: ScannerView, onScan: @escaping (String) -> Void) {
            self.parent = parent
            self.onScan = onScan
        }

        func didFind(code: String) {
            parent.scannedCode = code
            onScan(code)
        }
    }
}
