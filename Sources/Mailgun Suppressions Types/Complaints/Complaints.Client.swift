// Complaints.Client.swift
import Mailgun_Types_Shared

extension Mailgun.Suppressions.Complaints {
    @Witness
    public struct Client: Sendable {
        public var importList:
            @Sendable (_ request: Mailgun.Suppressions.Complaints.Import.Request) async throws ->
                Mailgun.Suppressions.Complaints.Import.Response
        public var get:
            @Sendable (_ address: EmailAddress) async throws ->
                Mailgun.Suppressions.Complaints.Get.Response
        public var delete:
            @Sendable (_ address: EmailAddress) async throws ->
                Mailgun.Suppressions.Complaints.Delete.Response
        public var list:
            @Sendable (_ request: Mailgun.Suppressions.Complaints.List.Request?) async throws ->
                Mailgun.Suppressions.Complaints.List.Response
        public var create:
            @Sendable (_ request: Mailgun.Suppressions.Complaints.Create.Request) async throws ->
                Mailgun.Suppressions.Complaints.Create.Response
        public var deleteAll:
            @Sendable () async throws -> Mailgun.Suppressions.Complaints.Delete.All.Response
    }
}
