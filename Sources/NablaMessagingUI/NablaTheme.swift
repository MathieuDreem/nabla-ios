import Foundation
import NablaMessagingCore
import UIKit

/// This struct is used to configure the theme of the app. You can use the default values if needed or
/// override one or many.
///
/// This is divided in two sections:
/// - First are the top level values, those are the primary configurations, used in all of the screens,
/// updating one inpact all of the app
/// - Then you have the sub structs. Those rely on the top level values but offer a fine tune configuration for each element of
/// the SDK.
public enum NablaTheme {
    // MARK: - Colors
    
    public static var primaryColor = CoreAssets.Colors.primary.color
    public static var backgroundColor = CoreAssets.Colors.background.color
    public static var primaryTextColor = CoreAssets.Colors.primaryText.color
    public static var secondaryTextColor = CoreAssets.Colors.secondaryText.color
    public static var alternateTextColor = CoreAssets.Colors.alternateText.color
    public static var secondaryBackgroundColor = CoreAssets.Colors.secondaryBackground.color
    public static var accessoryColor = CoreAssets.Colors.accessory.color
    
    // MARK: - Fonts
    
    public static var largeTitle = UIFont.regular(33)
    public static var title1 = UIFont.regular(27)
    public static var title2 = UIFont.regular(21)
    public static var title3 = UIFont.regular(19)
    public static var headline = UIFont.semiBold(18)
    public static var body = UIFont.regular(16)
    public static var bodyItalic = UIFont.italic(16)
    public static var callout = UIFont.regular(15)
    public static var subhead = UIFont.regular(14)
    public static var footnote = UIFont.regular(12)
    public static var caption1 = UIFont.regular(11)
    public static var caption2 = UIFont.regular(10)
    
    // MARK: - Components
    
    public enum ConversationListItemCell {
        /// Background color of a conversation in the conversations list. Default set to NablaTheme.backgroundColor
        public static var backgroundColor = NablaTheme.backgroundColor
        /// Color of the title of a conversation in the conversations list. Default set to NablaTheme.primaryTextColor
        public static var titleColor = NablaTheme.primaryTextColor
        /// Color of the subtitle or message preview of a conversation in the conversations list. Default set to NablaTheme.secondaryTextColor
        public static var subtitleColor = NablaTheme.secondaryTextColor
        /// Color of the time of the last message of a conversation in the conversations list. Default set to NablaTheme.secondaryTextColor
        public static var timeLabelColor = NablaTheme.secondaryTextColor
        /// Color of the dot indicator for an unread message for a conversation in the conversations list. Default set to NablaTheme.primaryColor
        public static var unreadIndicatorColor = NablaTheme.primaryColor

        /// Font used for the title of a conversation in the conversations list. Default set to NablaTheme.body
        public static var titleFont = NablaTheme.body
        /// Font used for the subtitle or message preview of a conversation in the conversations list. Default set to NablaTheme.subhead
        public static var subtitleFont = NablaTheme.subhead
        /// Font used for the time of the last message of a conversation in the conversations list. Default set to NablaTheme.footnote
        public static var timeLabelFont = NablaTheme.footnote
    }
    
    public enum ComposerView {
        /// Background color of the message composer in the conversation screen. Default set to NablaTheme.backgroundColor
        public static var backgroundColor = NablaTheme.backgroundColor
        /// Color used to tint buttons in the composer in the conversation screen. Default set to NablaTheme.accessoryColor
        public static var accessoryColor = NablaTheme.accessoryColor
        /// Color used to display the text entered by the user in the composer in the conversation screen. Default set to NablaTheme.primaryTextColor
        public static var textColor = NablaTheme.primaryTextColor

        /// Font used for the text entered by the user in the composer in the conversation screen. Default set to NablaTheme.body
        public static var font = NablaTheme.body

        /// UIImage used for the send button in the composer in the conversation screen. Default set to UIImage(systemName: "arrow.up.circle.fill")
        public static var sendIcon = UIImage(systemName: "arrow.up.circle.fill")
        /// UIImage used for the add media button in the composer in the conversation screen. Default set to UIImage(systemName: "camera.on.rectangle")
        public static var addMediaIcon = UIImage(systemName: "camera.on.rectangle")
        /// UIImage used for the record audio button in the composer in the conversation screen. Default set to UIImage(systemName: "camera.on.rectangle")
        public static var recordAudioIcon = UIImage(systemName: "waveform.circle.fill")
        /// UIImage used for the cancel button to delete a recording in progress. Default set to UIImage(systemName: "trash")
        public static var deleteAudioRecordingIcon = UIImage(systemName: "trash")
    }
    
    public enum TextMessageContentView {
        /// Color used for text messages send by the patient. Default set to NablaTheme.alternateTextColor
        public static var meTextColor = NablaTheme.alternateTextColor
        /// Color used for text messages send by a provider. Default set to NablaTheme.primaryTextColor
        public static var themTextColor = NablaTheme.primaryTextColor

        /// Font used for text messages. Default set to NablaTheme.body
        public static var font = NablaTheme.body
    }
    
    public enum DeletedMessageContentView {
        /// Color used for the borders of a deleted message. Default set to NablaTheme.secondaryTextColor
        public static var borderColor = NablaTheme.secondaryTextColor
        /// Background color of a deleted message. Default set to NablaTheme.backgroundColor
        public static var backgroundColor = NablaTheme.backgroundColor
        /// Color used to display the "Deleted message" text. Default set to NablaTheme.secondaryTextColor
        public static var textColor = NablaTheme.secondaryTextColor

        /// Font used to display the "Deleted message" text. Default set to NablaTheme.bodyItalic
        public static var font = NablaTheme.bodyItalic
    }
    
    public enum ConversationMessageCell {
        /// Corner radius used for all messages in the conversation screen. Default set to CGFloat = 16
        public static var cornerRadius: CGFloat = 16
        /// Background color used for all patient messages in the conversation screen. Default set to NablaTheme.primaryColor
        public static var meBackgroundColor = NablaTheme.primaryColor
        /// Background color used for all provider messages in the conversation screen. Default set to NablaTheme.secondaryBackgroundColor
        public static var themBackgroundColor = NablaTheme.secondaryBackgroundColor
        /// Color used to display the author for all provider messages in the conversation screen. Default set to NablaTheme.secondaryTextColor
        public static var authorLabelColor = NablaTheme.secondaryTextColor

        /// Font used to display the author for all provider messages in the conversation screen. Default set to NablaTheme.footnote
        public static var authorLabelFont = NablaTheme.footnote
        /// Font used to display additional info for a message in the conversation screen (like sending status of a message). Default set to NablaTheme.footnote
        public static var footerLabelFont = NablaTheme.footnote
    }
    
    public enum ConversationViewController {
        /// Background color for the conversation screen. Default set to NablaTheme.backgroundColor
        public static var backgroundColor = NablaTheme.backgroundColor
    }
    
    public enum ConversationListView {
        /// Background color for the conversations list view. Default set to NablaTheme.backgroundColor
        public static var backgroundColor = NablaTheme.backgroundColor
    }
    
    public enum LoadingView {
        /// Tint color used for the loading indicator. Default set to NablaTheme.primaryColor
        public static var tintColor = NablaTheme.primaryColor
    }
    
    public enum AvatarView {
        /// Background color used to display the avatar of someone who doesn't have a profile picture. Default set to NablaTheme.primaryColor
        public static var backgroundColor = NablaTheme.primaryColor
    }
    
    public enum TypingIndicatorView {
        /// Color used to display the dots of the typing indicator when a provider is typing a message in the conversation screen. Default set to NablaTheme.primaryColor
        public static var dotColor = NablaTheme.primaryColor
    }
    
    public enum ImageDetailViewController {
        /// Color used for the background of the full screen viewer for an image. Default set to NablaTheme.backgroundColor
        public static var backgroundColor = NablaTheme.backgroundColor
    }
    
    public enum DocumentMessageContentView {
        /// UIImage used as the document symbol for a document message in the conversation screen. Default set to UIImage(systemName: "doc.text")
        public static var icon = UIImage(systemName: "doc.text")
        /// Font used to display the name of the document for a document message in the conversation screen. Default set to NablaTheme.body
        public static var labelFont = NablaTheme.body
        /// Color used to display the name of the document for a document message sent by the patient in the conversation screen. Default set to NablaTheme.alternateTextColor
        public static var meTitleColor = NablaTheme.alternateTextColor
        /// Color used to display the name of the document for a document message sent by a provider in the conversation screen. Default set to NablaTheme.primaryTextColor
        public static var themTitleColor = NablaTheme.primaryTextColor
    }

    public enum AudioMessageContentView {
        public static var durationLabelFont = NablaTheme.body
        public static var meTitleColor = NablaTheme.alternateTextColor
        public static var themTitleColor = NablaTheme.primaryTextColor
    }
    
    public enum MediaComposerCollectionViewCell {
        /// UIImage used to represent a document to send in the composer in the conversation screen. Default set to UIImage(systemName: "doc.text")
        public static var documentIcon = UIImage(systemName: "doc.text")
        /// UIImage used for the delete button for a document to send in the composer in the conversation screen. Default set to UIImage(systemName: "x.circle.fill")
        public static var deleteButtonIcon = UIImage(systemName: "x.circle.fill")
        /// Color used to tint the document icon for a document to send in the composer in the conversation screen. Default set to NablaTheme.alternateTextColor
        public static var documentTintColor = NablaTheme.alternateTextColor
        /// Color of the background of the media composer in the conversation screen. Default set to NablaTheme.secondaryBackgroundColor
        public static var backgroundColor = NablaTheme.secondaryBackgroundColor
        /// Color used to tint the delete button for a media to send in the composer in the conversation screen. Default set to NablaTheme.primaryTextColor
        public static var deleteButtonTintColor = NablaTheme.primaryTextColor
        /// Background color of the delete button for a media to send in the composer in the conversation screen. Default set to NablaTheme.backgroundColor
        public static var deleteButtonBackgroundColor = NablaTheme.backgroundColor
    }

    public enum ErrorView {
        /// Font used to display the text explaining the error in the conversations list view or in the conversation list. Default set to NablaTheme.bodyItalic
        public static var labelFont = NablaTheme.bodyItalic
        /// Color of the text explaining the error in the conversations list view or in the conversation list. Default set to NablaTheme.secondaryTextColor
        public static var labelColor = NablaTheme.secondaryTextColor
        /// Font used for the retry button on error in the conversations list view or in the conversation list. Default set to NablaTheme.body
        public static var retryButtonTitleFont = NablaTheme.body
        /// Color of the retry button on error in the conversations list view or in the conversation list. Default set to NablaTheme.primaryColor
        public static var retryButtonTitleColor = NablaTheme.primaryColor
    }

    public enum ConversationTextSeparatorCell {
        public static var font = NablaTheme.footnote
        public static var color = NablaTheme.secondaryTextColor
    }

    public enum AudioRecorderComposerView {
        /// Background color used to display the current recording time on the composer. Default set to NablaTheme.primaryColor
        public static var backgroundColor = NablaTheme.primaryColor
        /// Color of the text used to display the current recording time on the composer. Default set to NablaTheme.alternateTextColor
        public static var durationTextColor = NablaTheme.alternateTextColor
        /// Color of the recording indicator on the composer. Default set to NablaTheme.alternateTextColor
        public static var recordIndicatorColor = UIColor.red
    }
}
