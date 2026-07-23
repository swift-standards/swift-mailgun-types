import Foundation

extension Mailgun.Suppressions.Unsubscribe.Import {
    public struct Request: Sendable, Codable, Equatable {
        public let file: Data

        public init(file: Data) {
            self.file = file
        }
    }
}
