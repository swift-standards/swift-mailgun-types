//
//  File.swift
//  swift-mailgun
//
//  Created by Coen ten Thije Boonkkamp on 24/12/2024.
//

import Dependencies
import Mailgun_Types_Shared

extension Mailgun.IPs {
    @Witness
    public struct Client: Sendable {
        public var list: @Sendable () async throws -> Mailgun.IPs.List.Response
        public var get: @Sendable (_ ip: String) async throws -> Mailgun.IPs.IP
        public var listDomains:
            @Sendable (_ ip: String) async throws -> Mailgun.IPs.DomainList.Response
        public var assignDomain:
            @Sendable (_ ip: String, _ request: Mailgun.IPs.AssignDomain.Request) async throws ->
                Mailgun.IPs.AssignDomain.Response
        public var unassignDomain:
            @Sendable (_ ip: String, _ domain: String) async throws -> Mailgun.IPs.Delete.Response
        public var assignIPBand:
            @Sendable (_ ip: String, _ request: Mailgun.IPs.IPBand.Request) async throws ->
                Mailgun.IPs.IPBand.Response
        public var requestNew:
            @Sendable (_ request: Mailgun.IPs.RequestNew.Request) async throws ->
                Mailgun.IPs.RequestNew.Response
        public var getRequestedIPs: @Sendable () async throws -> Mailgun.IPs.RequestNew.Response
        public var deleteDomainIP:
            @Sendable (_ domain: String, _ ip: String) async throws -> Mailgun.IPs.Delete.Response
        public var deleteDomainPool:
            @Sendable (_ domain: String, _ ip: String) async throws -> Mailgun.IPs.Delete.Response
    }
}
