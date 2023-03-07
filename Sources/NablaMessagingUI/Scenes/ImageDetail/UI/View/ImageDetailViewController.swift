import Foundation
import LinkPresentation
import NablaCore
import UIKit

final class ImageDetailViewController: UIPanViewController, ImageDetailViewContract {
    var presenter: ImageDetailPresenter?
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUp()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        presenter?.start()
    }
    
    // MARK: - ImageDetailViewContract
    
    func configure(with viewModel: ImageDetailViewModel) {
        // Here
        imageView.source = viewModel.image
        fileName = viewModel.fileName
    }
    
    // MARK: - Private
    
    private var fileName: String?
    
    private lazy var imageView: NablaViews.ImageView = makeImageView()
    
    private func setUp() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .action,
            target: self,
            action: #selector(shareAction)
        )
        view.backgroundColor = NablaTheme.ImageDetail.backgroundColor
        view.addSubview(imageView)
        setUpPan(with: imageView)
        imageView.nabla.pinToSuperView()
    }
    
    private func makeImageView() -> NablaViews.ImageView {
        let imageView = NablaViews.ImageView(frame: .zero)
        imageView.contentMode = .scaleAspectFit
        return imageView
    }
    
    @objc private func shareAction() {
        guard let image = imageView.image else {
            return
        }
        present(
            UIActivityViewController(activityItems: [image, self], applicationActivities: nil),
            animated: true
        )
    }
}

extension ImageDetailViewController: UIActivityItemSource {
    func activityViewControllerPlaceholderItem(_: UIActivityViewController) -> Any {
        ""
    }
    
    func activityViewController(
        _: UIActivityViewController,
        itemForActivityType _: UIActivity.ActivityType?
    ) -> Any? {
        nil
    }
    
    func activityViewControllerLinkMetadata(
        _: UIActivityViewController
    ) -> LPLinkMetadata? {
        guard let image = imageView.image else { return nil }
        let imageProvider = NSItemProvider(object: image)
        let metadata = LPLinkMetadata()
        metadata.imageProvider = imageProvider
        return metadata
    }
}
//
//final class ImageDetailViewController: UIViewController, ImageDetailViewContract {
//    var presenter: ImageDetailPresenter?
//
//    // MARK: - Lifecycle
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        setUp()
//    }
//
//    override func viewWillAppear(_ animated: Bool) {
//        super.viewWillAppear(animated)
//        presenter?.start()
//    }
//
//    override func viewDidAppear(_ animated: Bool) {
//        originalPosition = imageView.center
//    }
//
//    // MARK: - ImageDetailViewContract
//
//    func configure(with viewModel: ImageDetailViewModel) {
//        // Here
//        imageView.source = viewModel.image
//        fileName = viewModel.fileName
//    }
//
//    // MARK: - Private
//
//    private var fileName: String?
//
//    private var originalPosition: CGPoint!
//    private lazy var imageView: NablaViews.ImageView = makeImageView()
//    private lazy var background: UIView = makeBackground()
//    private lazy var quitButton: UIButton = makeQuitButton()
//
//    private func setUp() {
//        navigationItem.rightBarButtonItem = UIBarButtonItem(
//            barButtonSystemItem: .action,
//            target: self,
//            action: #selector(shareAction)
//        )
//
//        view.addSubview(background)
//        view.addSubview(imageView)
//        view.addSubview(quitButton)
//
//        quitButton.translatesAutoresizingMaskIntoConstraints = false
//        quitButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 12).isActive = true
//        quitButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -24).isActive = true
//
//        let panGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(didPanImage(_:)))
//        imageView.addGestureRecognizer(panGestureRecognizer)
//        imageView.isUserInteractionEnabled = true
//        imageView.nabla.pinToSuperView()
//    }
//
//    private func makeImageView() -> NablaViews.ImageView {
//        let imageView = NablaViews.ImageView(frame: .zero)
//        imageView.contentMode = .scaleAspectFit
//        return imageView
//    }
//
//    private func makeBackground() -> UIView {
//        let blurEffect = UIBlurEffect(style: UIBlurEffect.Style.dark)
//        let blurEffectView = UIVisualEffectView(effect: blurEffect)
//        blurEffectView.frame = view.bounds
//        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
//        return blurEffectView
//    }
//
//    private func makeQuitButton() -> UIButton {
//        let crossImage = UIImage(systemName: "xmark")!
//        let crossButton = UIButton(type: .custom)
//        crossButton.setImage(crossImage, for: .normal)
//        crossButton.addTarget(self, action: #selector(crossButtonTapped(_:)), for: .touchUpInside)
//        crossButton.tintColor = .white
//        return crossButton
//    }
//
//    @objc private func crossButtonTapped(_ sender: UIButton) {
//        dismiss(animated: true, completion: nil)
//    }
//
//    @objc private func shareAction() {
//        guard let image = imageView.image else {
//            return
//        }
//        present(
//            UIActivityViewController(activityItems: [image, self], applicationActivities: nil),
//            animated: true
//        )
//    }
//
//    @objc func didPanImage(_ sender: UIPanGestureRecognizer) {
//        let translation = sender.translation(in: view)
//        let panBeforeDismiss = view.frame.height / 4
//
//        UIView.animate(withDuration: 0.333) { [unowned self] in
//            quitButton.transform = CGAffineTransform(scaleX: 0.25, y: 0.25)
//            quitButton.alpha = 0.01
//        }
//
//        switch sender.state {
//        case .changed:
//            imageView.center = CGPoint(x: originalPosition.x + translation.x, y: originalPosition.y + translation.y)
//            let progress = 1 - abs(translation.y) / (view.frame.height / 2)
//            background.alpha = progress
//            UIView.animate(withDuration: 0.333) { [unowned self] in
//                imageView.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
//            }
//        case .ended:
//            if abs(translation.y) > panBeforeDismiss {
//                UIView.animate(
//                    withDuration: 0.2,
//                    animations: { [unowned self] in
//                        imageView.alpha = 0.01
//                        imageView.transform = CGAffineTransform(scaleX: 0.01, y: 0.01)
//                    },
//                    completion: { [unowned self] _ in
//                        modalTransitionStyle = .crossDissolve
//                        dismiss(animated: true, completion: nil)
//                    }
//                )
//            }  else {
//                UIView.animate(withDuration: 0.333) { [unowned self] in
//                    background.alpha = 1
//                    imageView.center = originalPosition
//                    imageView.transform = CGAffineTransform(scaleX: 1, y: 1)
//                    quitButton.transform = CGAffineTransform(scaleX: 1, y: 1)
//                    quitButton.alpha = 1
//                }
//            }
//        default:
//            break
//        }
//    }
//}
