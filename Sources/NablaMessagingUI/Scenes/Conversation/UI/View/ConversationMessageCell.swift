import NablaMessagingCore
import UIKit

private enum Constants {
    static let avatarSize: CGFloat = 28
    static let bodyMaxWidth: CGFloat = 300
    static let spacing: CGFloat = 8
    static let messagePadding: UIEdgeInsets = .all(4)
    static let systemPadding = UIEdgeInsets(horizontal: 0, vertical: 6)
    static let padding = UIEdgeInsets(horizontal: 10, vertical: 1)
    static let authorFontSize: CGFloat = 14
    static let footerFontSize: CGFloat = 12
}

protocol ConversationMessagePresenter: Presenter {
    func userDidTapFooter()
    func userDidTapContent()
}

final class ConversationMessageCell<ContentView: MessageContentView>: UICollectionViewCell, ConversationMessageCellContract, Reusable {
    // MARK: Lifecycle
    
    override func didMoveToSuperview() {
        super.didMoveToSuperview()
        setUp()
    }
    
    // MARK: - Public
    
    lazy var content: ContentView = .init()
    
    func configure(with viewModel: ConversationMessageViewModel<ContentView.ContentViewModel>) {
        configure(with: viewModel.sender)
        configure(with: viewModel.footer)
        content.configure(with: viewModel.content, sender: viewModel.sender)
        menuElements = viewModel.menuElements
    }
    
    func configure(presenter: ConversationMessagePresenter) {
        self.presenter = presenter
        presenter.start()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        content.prepareForReuse()
        menuElements = []
    }
    
    // MARK: - Private
    
    private var presenter: ConversationMessagePresenter?
    private var menuElements: [UIMenuElement] = []
    
    private let leftSpacer = UISpacerView(axis: .horizontal)
    private let rightSpacer = UISpacerView(axis: .horizontal)
    private let topSpacer = UISpacerView(axis: .vertical, size: .fixed(value: 8), color: .clear)
    
    private lazy var authorLabel: UILabel = makeAuthorLabel()
    private lazy var header: UIView = makeHeader()
    private lazy var avatarContainerView: UIView = makeAvatarContainerView()
    private lazy var avatarView: AvatarView = makeAvatarView()
    private lazy var container: UIView = makeContainer()
    
    private lazy var footerLabel: UILabel = makeFooterLabel()
    
    private var footerTapAction: (() -> Void)?
    
    private lazy var contentTapGestureRecognizer: UITapGestureRecognizer = makeContentTapGestureRecognizer()
    
    private func setUp() {
        guard contentView.subviews.isEmpty else { return }
        let contentStack = UIStackView(arrangedSubviews: [container, footerLabel])
        contentStack.prepareForAutoLayout()
        contentStack.axis = .vertical
        contentStack.alignment = .trailing
        contentStack.distribution = .fill
        contentStack.spacing = 4
        
        let hstack = UIStackView(arrangedSubviews: [leftSpacer, avatarContainerView, contentStack, rightSpacer])
        hstack.prepareForAutoLayout()
        hstack.axis = .horizontal
        hstack.alignment = .top
        hstack.distribution = .fill
        hstack.spacing = Constants.spacing
        
        let vstack = UIStackView(arrangedSubviews: [
            topSpacer,
            header,
            hstack,
            UISpacerView(
                axis: .vertical,
                size: .fixed(value: Constants.spacing),
                color: .clear
            ),
        ])
        vstack.prepareForAutoLayout()
        vstack.axis = .vertical
        vstack.alignment = .fill
        vstack.distribution = .fill
        
        contentView.addSubview(vstack)
        vstack.pinToSuperView(insets: .horizontal(8), priority: .defaultHigh)
    }
    
    private func configure(with sender: ConversationMessageSender) {
        switch sender {
        case let .me(isContiguous):
            footerLabel.textAlignment = .right
            container.backgroundColor = NablaTheme.Conversation.messagePatientBackgroundColor
            if isContiguous {
                setVisibleViews([leftSpacer])
            } else {
                setVisibleViews([topSpacer, leftSpacer])
            }
        case let .them(themViewModel):
            footerLabel.textAlignment = .left
            avatarView.configure(with: themViewModel.avatar)
            authorLabel.text = themViewModel.author
            container.backgroundColor = NablaTheme.Conversation.messageProviderBackgroundColor

            if themViewModel.isContiguous {
                setVisibleViews([rightSpacer])
            } else {
                setVisibleViews([topSpacer, authorLabel, avatarView, rightSpacer])
            }
        }
    }
    
    private func configure(with footer: ConversationMessageFooterViewModel?) {
        guard let footer = footer else {
            footerLabel.isHidden = true
            return
        }
        
        guard footerLabel.text != footer.text || footerLabel.textColor != footer.color else { return }
        
        footerLabel.isHidden = false
        
        footerLabel.text = footer.text
        footerLabel.textColor = footer.color
        footerTapAction = { [weak self] in
            self?.presenter?.userDidTapFooter()
        }
    }
    
    private func makeContainer() -> UIView {
        let view = UIView()
        view.prepareForAutoLayout()
        view.layer.cornerRadius = NablaTheme.Conversation.messageCornerRadius
        view.clipsToBounds = true
        view.addSubview(content)
        content.pinToSuperView()
        content.addGestureRecognizer(contentTapGestureRecognizer)
        NSLayoutConstraint.activate([
            view.widthAnchor.constraint(lessThanOrEqualToConstant: Constants.bodyMaxWidth),
        ])
        return view
    }
    
    private func makeAuthorLabel() -> UILabel {
        let label = UILabel()
        label.prepareForAutoLayout()
        label.font = NablaTheme.Conversation.messageAuthorLabelFont
        label.numberOfLines = 1
        label.textColor = NablaTheme.Conversation.messageAuthorLabelColor
        return label
    }
    
    private func makeHeader() -> UIView {
        let view = UIStackView(arrangedSubviews: [
            UISpacerView(axis: .horizontal, size: .fixed(value: Constants.avatarSize + Constants.spacing)),
            authorLabel,
            UISpacerView(axis: .horizontal),
        ])
        view.prepareForAutoLayout()
        view.axis = .horizontal
        view.alignment = .bottom
        view.distribution = .fill
        return view
    }
    
    private func makeFooterLabel() -> UILabel {
        let label = UILabel()
        label.prepareForAutoLayout()
        label.font = NablaTheme.Conversation.messageFooterLabelFont
        label.numberOfLines = 0
        label.isHidden = true
        let gesture = UITapGestureRecognizer(target: self, action: #selector(footerTapHandler))
        label.addGestureRecognizer(gesture)
        label.isUserInteractionEnabled = true
        return label
    }
    
    private func makeAvatarView() -> AvatarView {
        let avatarView = AvatarView()
        avatarView.prepareForAutoLayout()
        return avatarView
    }
    
    private func makeAvatarContainerView() -> UIView {
        let view = UIView()
        view.prepareForAutoLayout()
        view.constraintToSize(CGSize(width: Constants.avatarSize, height: Constants.avatarSize))
        view.addSubview(avatarView)
        avatarView.pinToSuperView()
        return view
    }
    
    private func makeContentTapGestureRecognizer() -> UITapGestureRecognizer {
        let gesture = UITapGestureRecognizer(target: self, action: #selector(contentTapHandler))
        return gesture
    }
    
    private func setVisibleViews(_ visibleViews: Set<UIView>) {
        // Only add views whose visibility might change.
        [
            topSpacer,
            authorLabel,
            avatarView,
            leftSpacer,
            rightSpacer,
        ]
        .forEach { $0.isHidden = !visibleViews.contains($0) }
    }
    
    // MARK: Handlers
    
    @objc private func footerTapHandler() {
        footerTapAction?()
    }
    
    @objc private func contentTapHandler() {
        presenter?.userDidTapContent()
    }
}

extension ConversationMessageCell: ConversationContextCell {
    func makeContextMenuConfiguration(for indexPath: IndexPath) -> ContextMenuConfiguration? {
        guard !menuElements.isEmpty else {
            return nil
        }
        return .init(indexPath: indexPath, title: nil, items: menuElements)
    }
    
    func previewForHighlightingContextMenu() -> UITargetedPreview? {
        let parameters = UIPreviewParameters()
        parameters.backgroundColor = .clear
        parameters.visiblePath = UIBezierPath(
            roundedRect: container.bounds,
            cornerRadius: container.layer.cornerRadius
        )
        return .init(view: container, parameters: parameters)
    }
}
