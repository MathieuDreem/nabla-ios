import Foundation
import NablaCore
import UIKit

final class VideoCallActionRequestContentView: UIView, MessageContentView {
    // MARK: - Internal
    
    // MARK: Init
    
    init() {
        super.init(frame: .zero)
        setUpSubviews()
    }
    
    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(presenter: VideoCallActionRequestPresenter) {
        self.presenter = presenter
    }
    
    // MARK: - MessageContentView
    
    func configure(with viewModel: VideoCallActionRequestContentViewModel) {
        switch viewModel.state {
        case .waiting:
            hstack?.alignment = .center
            button.setTitle(L10n.videoCallActionRequestButtonDefault, for: .normal)
            button.isEnabled = true
            button.isHidden = false
        case .opened:
            hstack?.alignment = .center
            button.setTitle(L10n.videoCallActionRequestButtonInProgress, for: .normal)
            button.isEnabled = true
            button.isHidden = false
        case .closed:
            hstack?.alignment = .top
            button.setTitle(L10n.videoCallActionRequestButtonClosed, for: .disabled)
            button.setTitleColor(NablaTheme.Conversation.messageProviderBackgroundColor, for: .disabled)
            button.isHidden = false
            button.isEnabled = false
        }
    }
    
    func configure(sender _: ConversationMessageSender) {}
    
    func prepareForReuse() {}

    // MARK: - Private
    
    private var presenter: VideoCallActionRequestPresenter?
    
    // MARK: Subviews
    
    private lazy var imageView: UIImageView = {
        let view = UIImageView()
        view.image = NablaTheme.Conversation.videoCallActionRequestIcon
        return view
    }()
    
    private lazy var titleLabel: UILabel = {
        let view = UILabel()
        view.text = L10n.videoCallActionRequestTitle
        view.textColor = NablaTheme.Conversation.textMessageProviderTextColor
        view.font = NablaTheme.Fonts.bodyMedium
        view.numberOfLines = 1
        view.nabla.constraintHeight(24)
        return view
    }()
    
    private lazy var button: NablaViews.PrimaryButton = {
        let view = NablaViews.PrimaryButton()
        view.theme = NablaTheme.Conversation.videoCallActionRequestButton
        view.nabla.constraintHeight(34)
        view.addTarget(self, action: #selector(buttonHandler), for: .touchDown)
        return view
    }()

    private var hstack: UIStackView?
    
    private func setUpSubviews() {

        let hstack = UIStackView(arrangedSubviews: [imageView, titleLabel])
        hstack.axis = .horizontal
        hstack.distribution = .fill
        hstack.alignment = .center
        hstack.spacing = 8
        self.hstack = hstack
        
        let vstack = UIStackView(arrangedSubviews: [hstack, button])
        vstack.axis = .vertical
        vstack.distribution = .fill
        vstack.alignment = .fill
        vstack.spacing = 14
        
        addSubview(vstack)
        vstack.nabla.pinToSuperView(insets: .nabla.all(10))
    }
    
    @objc private func buttonHandler() {
        presenter?.userDidTapJoinRoomButton()
    }
}
