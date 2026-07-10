//
//  File.swift
//  swift-mailgun
//
//  Created by Coen ten Thije Boonkkamp on 24/12/2024.
//

import Mailgun_Types_Shared

extension Mailgun.Webhooks {
    @CasePathable
    @dynamicMemberLookup
    public enum API: Equatable, Sendable {
        case list(domain: Domain)
        case get(domain: Domain, webhookName: WebhookType)
        case create(domain: Domain, request: Create.Request)
        case update(domain: Domain, webhookName: WebhookType, request: Update.Request)
        case delete(domain: Domain, webhookName: WebhookType)
    }
}

extension Mailgun.Webhooks.API {
    public struct Router: ParserPrinter, Sendable {
        public init() {}

        public var body: some URLRouting.Router<Mailgun.Webhooks.API> {
            OneOf {
                // PUT /v3/domains/{domain}/webhooks/{webhook_name}
                URLRouting.Route(.case(Mailgun.Webhooks.API.update)) {
                    Method.put
                    Path { "v3" }
                    Path.domains
                    Path { Parse(.string.representing(Domain.self)) }
                    Path.webhooks
                    Path { Parse(.string.representing(Mailgun.Webhooks.WebhookType.self)) }
                    Body(
                        .form(
                            Mailgun.Webhooks.Update.Request.self,
                            decoder: .mailgun,
                            encoder: .mailgun
                        )
                    )
                }

                // DELETE /v3/domains/{domain}/webhooks/{webhook_name}
                URLRouting.Route(.case(Mailgun.Webhooks.API.delete)) {
                    Method.delete
                    Path { "v3" }
                    Path.domains
                    Path { Parse(.string.representing(Domain.self)) }
                    Path.webhooks
                    Path { Parse(.string.representing(Mailgun.Webhooks.WebhookType.self)) }
                }

                // GET /v3/domains/{domain}/webhooks/{webhook_name}
                URLRouting.Route(.case(Mailgun.Webhooks.API.get)) {
                    Method.get
                    Path { "v3" }
                    Path.domains
                    Path { Parse(.string.representing(Domain.self)) }
                    Path.webhooks
                    Path { Parse(.string.representing(Mailgun.Webhooks.WebhookType.self)) }
                }

                // POST /v3/domains/{domain}/webhooks
                URLRouting.Route(.case(Mailgun.Webhooks.API.create)) {
                    Method.post
                    Path { "v3" }
                    Path.domains
                    Path { Parse(.string.representing(Domain.self)) }
                    Path.webhooks
                    Body(
                        .form(
                            Mailgun.Webhooks.Create.Request.self,
                            decoder: .mailgun,
                            encoder: .mailgun
                        )
                    )
                }

                // GET /v3/domains/{domain}/webhooks
                URLRouting.Route(.case(Mailgun.Webhooks.API.list)) {
                    Method.get
                    Path { "v3" }
                    Path.domains
                    Path { Parse(.string.representing(Domain.self)) }
                    Path.webhooks
                }
            }
        }
    }
}

extension Path<PathBuilder.Component<String>> {
    public static var webhooks: Path<PathBuilder.Component<String>> { Path {
        "webhooks"
    } }

    public static var domains: Path<PathBuilder.Component<String>> { Path {
        "domains"
    } }
}
