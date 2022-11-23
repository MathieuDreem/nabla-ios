import AVFoundation
import AVKit
import Foundation
import UIKit

final class VideoMessageContentView: UIView, MessageContentView {
    // MARK: - Internal
        
    weak var viewController: UIViewController? {
        didSet { setUpPlayerController() }
    }
    
    // MARK: Init

    init() {
        super.init(frame: .zero)
        setUp()
    }
    
    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: MessageContentView

    func configure(with viewModel: VideoMessageContentViewModel) throws {
        playerViewController.player = AVPlayer(playerItem: AVPlayerItem(asset: try DataAVAsset(source: viewModel.videoSource)))
        widthConstraint?.isActive = false
        heightConstraint?.isActive = false
        (widthConstraint, heightConstraint) = nabla.constraintToSize(idealSize(contentSize: viewModel.originalVideoSize))
    }
    
    func configure(sender _: ConversationMessageSender) {}
    
    func prepareForReuse() {
        playerViewController.player = nil
    }
    
    // MARK: - Private

    private lazy var playerViewController: AVPlayerViewController = makePlayerViewController()
    private var widthConstraint: NSLayoutConstraint?
    private var heightConstraint: NSLayoutConstraint?

    private func setUp() {
        if #available(iOS 16, *) {
            let overlay = PassthroughiOS16Overlay()
            addSubview(overlay)
            overlay.nabla.constraintToCenterInSuperView()
        }
    }
    
    private func setUpPlayerController() {
        guard playerViewController.view.superview == nil else { return }
        viewController?.addChild(playerViewController)
        insertSubview(playerViewController.view, at: 0)
        playerViewController.view.nabla.pinToSuperView()
        playerViewController.didMove(toParent: viewController)
    }
    
    private func makePlayerViewController() -> AVPlayerViewController {
        let playerViewController = AVPlayerViewController()
        playerViewController.entersFullScreenWhenPlaybackBegins = true
        playerViewController.exitsFullScreenWhenPlaybackEnds = true
        playerViewController.videoGravity = .resizeAspectFill
        return playerViewController
    }
}

private enum Constants {
    static let defaultSize = CGSize(width: 172, height: 172)
    static let maxWidth: CGFloat = 288
    static let maxHeight: CGFloat = 288
}

extension MessageContentView {
    func idealSize(contentSize: CGSize?) -> CGSize {
        guard let size = contentSize else { return Constants.defaultSize }
        let ratio = size.width / size.height
        if ratio > 1 {
            let width = min(Constants.maxWidth, size.width)
            return CGSize(
                width: width,
                height: min(Constants.maxHeight, size.height) / ratio
            )
        } else {
            let height = min(Constants.maxHeight, size.height)
            return CGSize(
                width: min(Constants.maxWidth, size.width) * ratio,
                height: height
            )
        }
    }
}
