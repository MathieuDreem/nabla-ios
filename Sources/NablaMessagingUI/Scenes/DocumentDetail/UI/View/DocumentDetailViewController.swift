import Foundation
import UIKit
import WebKit

final class DocumentDetailViewController: UIViewController, DocumentDetailViewContract {
    // MARK: - Lifecycle
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        setUp()
        presenter?.start()
    }
    
    // MARK: - Public
    
    var presenter: DocumentDetailPresenter?
    
    // MARK: - DocumentDetailViewContract
    
    func configure(with viewModel: DocumentDetailViewModel) {
        pdfView.load(URLRequest(url: viewModel.url))
        fileName = viewModel.fileName
    }
    
    // MARK: - Private
    
    private var fileName: String?
    
    private lazy var pdfView: WKWebView = {
        let view = WKWebView(frame: self.view.bounds)
        view.scrollView.isScrollEnabled = true
        return view
    }()
    
    private func setUp() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .action,
            target: self,
            action: #selector(shareAction)
        )
        view.addSubview(pdfView)
        pdfView.nabla.pinToSuperView()
    }
    
    @objc private func shareAction() {
        guard let url = pdfView.url else {
            return
        }
        
        DispatchQueue.global(qos: .userInitiated).async {
            guard let data = try? Data(contentsOf: url),
                  let fileName = self.fileName else {
                return
            }
            
            let fileUrl = URL(fileURLWithPath: NSTemporaryDirectory() + fileName)
            try? data.write(to: fileUrl)
            
            DispatchQueue.main.async {
                let activityController = UIActivityViewController(activityItems: [fileUrl], applicationActivities: nil)
                activityController.completionWithItemsHandler = { _, _, _, _ in
                    try? FileManager.default.removeItem(at: fileUrl)
                }
                
                self.present(activityController, animated: true)
            }
        }
    }
}
