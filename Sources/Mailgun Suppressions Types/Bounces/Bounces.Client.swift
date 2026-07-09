import Mailgun_Types_Shared

extension Mailgun.Suppressions.Bounces {
    @Witness
    public struct Client: Sendable {
        public var importList:
            @Sendable (_ request: Foundation.Data) async throws ->
                Mailgun.Suppressions.Bounces.Import.Response
        public var get:
            @Sendable (_ address: EmailAddress) async throws -> Mailgun.Suppressions.Bounces.Record
        public var delete:
            @Sendable (_ address: EmailAddress) async throws ->
                Mailgun.Suppressions.Bounces.Delete.Response
        public var list:
            @Sendable (_ request: Mailgun.Suppressions.Bounces.List.Request?) async throws ->
                Mailgun.Suppressions.Bounces.List.Response
        public var create:
            @Sendable (_ request: Mailgun.Suppressions.Bounces.Create.Request) async throws ->
                Mailgun.Suppressions.Bounces.Create.Response
        public var deleteAll:
            @Sendable () async throws -> Mailgun.Suppressions.Bounces.Delete.All.Response
    }
}
