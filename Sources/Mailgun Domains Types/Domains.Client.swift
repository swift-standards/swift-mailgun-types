//
//  File.swift
//  swift-mailgun
//
//  Created by Coen ten Thije Boonkkamp on 24/12/2024.
//

import Dependencies
import Mailgun_Types_Shared

extension Mailgun.Domains {
    @dynamicMemberLookup
    public struct Client: Sendable {
        public var domains: Mailgun.Domains.Domains.Client
        public var dkim: DKIM
        public var domain: Domain

        public struct DKIM: Sendable {
            public var security: Mailgun.Domains.DKIM_Security.Client
        }

        public struct Domain: Sendable {
            public var keys: Mailgun.Domains.DomainKeys.Client
            public var tracking: Mailgun.Domains.Domains.Tracking.Client
        }

        public init(
            domains: Mailgun.Domains.Domains.Client,
            dkimSecurity: Mailgun.Domains.DKIM_Security.Client,
            domainKeys: Mailgun.Domains.DomainKeys.Client,
            domainTracking: Mailgun.Domains.Domains.Tracking.Client
        ) {
            self.domains = domains
            self.dkim = .init(security: dkimSecurity)
            self.domain = .init(keys: domainKeys, tracking: domainTracking)
        }

        public subscript<Subject>(
            dynamicMember keyPath: KeyPath<Mailgun.Domains.Domains.Client, Subject>
        ) -> Subject {
            self.domains[keyPath: keyPath]
        }
    }
}
