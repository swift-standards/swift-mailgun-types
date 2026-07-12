//
//  File.swift
//  swift-mailgun
//
//  Created by Coen ten Thije Boonkkamp on 24/12/2024.
//

import Mailgun_Types_Shared

extension Mailgun.Suppressions {
    @Cases
    public enum API: Equatable, Sendable {
        case bounces(Bounces.API)
        case complaints(Complaints.API)
        case unsubscribe(Unsubscribe.API)
        case Allowlist(Allowlist.API)
    }
}

extension Mailgun.Suppressions.API {
    public struct Router: ParserPrinter, Sendable {
        public init() {}

        public var body: some URLRouting.Router<Mailgun.Suppressions.API> {
            OneOf {
                URLRouting.Route(.case(Mailgun.Suppressions.API.cases.bounces)) {
                    Mailgun.Suppressions.Bounces.API.Router()
                }
                URLRouting.Route(.case(Mailgun.Suppressions.API.cases.complaints)) {
                    Mailgun.Suppressions.Complaints.API.Router()
                }
                URLRouting.Route(.case(Mailgun.Suppressions.API.cases.unsubscribe)) {
                    Mailgun.Suppressions.Unsubscribe.API.Router()
                }
                URLRouting.Route(.case(Mailgun.Suppressions.API.cases.Allowlist)) {
                    Mailgun.Suppressions.Allowlist.API.Router()
                }
            }
        }
    }
}
