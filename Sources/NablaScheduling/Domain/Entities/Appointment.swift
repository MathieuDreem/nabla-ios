import Foundation

public struct Appointment {
    public let id: UUID
    public let state: State
    public let start: Date
    public let provider: Provider
    public let videoCallRoom: VideoCallRoom?
    
    public enum State {
        case upcoming
        case finalized
    }
    
    public struct VideoCallRoom {
        public let url: String
        public let token: String
    }
}
