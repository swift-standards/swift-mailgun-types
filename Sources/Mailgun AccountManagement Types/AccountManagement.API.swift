//
//  File.swift
//  swift-mailgun
//
//  Created by Coen ten Thije Boonkkamp on 24/12/2024.
//

import Mailgun_Types_Shared

extension Mailgun.AccountManagement {
    @Cases
    public enum API: Equatable, Sendable {
        case updateAccount(request: Mailgun.AccountManagement.Update.Request)
        case getHttpSigningKey
        case regenerateHttpSigningKey
        case getSandboxAuthRecipients
        case addSandboxAuthRecipient(
            request: Mailgun.AccountManagement.Sandbox.Auth.Recipients.Add.Request
        )
        case deleteSandboxAuthRecipient(email: EmailAddress)
        case resendActivationEmail
        case getSAMLOrganization
        case addSAMLOrganization(request: Mailgun.AccountManagement.SAML.Organization.Add.Request)
    }
}

extension Mailgun.AccountManagement.API {
    public struct Router: ParserPrinter, Sendable {
        public init() {}

        public var body: some URLRouting.Router<Mailgun.AccountManagement.API> {
            OneOf {
                URLRouting.Route(.case(Mailgun.AccountManagement.API.cases.updateAccount)) {
                    Method.put
                    Path { "v5" }
                    Path.accounts
                    Parse(
                        .convert(
                            apply: { ($0.0.0.0, $0.0.0.1, $0.0.1, $0.1) },
                            unapply: { ((($0.0, $0.1), $0.2), $0.3) }
                        )
                        .map(
                            .memberwise(
                                Mailgun.AccountManagement.Update.Request.init,
                                {
                                    (
                                        $0.name, $0.inactiveSessionTimeout, $0.absoluteSessionTimeout,
                                        $0.logoutRedirectUrl
                                    )
                                }
                            )
                        )
                    ) {
                        URLRouting.Query {
                            Optionally { Field("name") { Parse(.string) } }
                            Optionally { Field("inactive_session_timeout") { Int.parser() } }
                            Optionally { Field("absolute_session_timeout") { Int.parser() } }
                            Optionally { Field("logout_redirect_url") { Parse(.string) } }
                        }
                    }
                }

                URLRouting.Route(.case(Mailgun.AccountManagement.API.cases.getHttpSigningKey)) {
                    Method.get
                    Path { "v5" }
                    Path.accounts
                    Path.httpSigningKey
                }

                URLRouting.Route(.case(Mailgun.AccountManagement.API.cases.regenerateHttpSigningKey)) {
                    Method.post
                    Path { "v5" }
                    Path.accounts
                    Path.httpSigningKey
                }

                URLRouting.Route(.case(Mailgun.AccountManagement.API.cases.getSandboxAuthRecipients)) {
                    Method.get
                    Path { "v5" }
                    Path.sandbox
                    Path.authRecipients
                }

                URLRouting.Route(.case(Mailgun.AccountManagement.API.cases.addSandboxAuthRecipient)) {
                    Method.post
                    Path { "v5" }
                    Path.sandbox
                    Path.authRecipients
                    Parse(
                        .memberwise(
                            Mailgun.AccountManagement.Sandbox.Auth.Recipients.Add.Request.init,
                            { $0.email }
                        )
                    ) {
                        URLRouting.Query {
                            Field("email") { Parse(.string.representing(EmailAddress.self)) }
                        }
                    }
                }

                URLRouting.Route(.case(Mailgun.AccountManagement.API.cases.deleteSandboxAuthRecipient)) {
                    Method.delete
                    Path { "v5" }
                    Path.sandbox
                    Path.authRecipients
                    Path { Parse(.string.representing(EmailAddress.self)) }
                }

                URLRouting.Route(.case(Mailgun.AccountManagement.API.cases.resendActivationEmail)) {
                    Method.post
                    Path { "v5" }
                    Path.accounts
                    Path.resendActivationEmail
                }

                URLRouting.Route(.case(Mailgun.AccountManagement.API.cases.getSAMLOrganization)) {
                    Method.get
                    Path { "v5" }
                    Path.accounts
                    Path.samlOrg
                }

                URLRouting.Route(.case(Mailgun.AccountManagement.API.cases.addSAMLOrganization)) {
                    Method.post
                    Path { "v5" }
                    Path.accounts
                    Path.samlOrg
                    Parse(
                        .memberwise(
                            Mailgun.AccountManagement.SAML.Organization.Add.Request.init,
                            { ($0.userId, $0.domain) }
                        )
                    ) {
                        URLRouting.Query {
                            Field("user_id") { Parse(.string) }
                            Optionally { Field("domain") { Parse(.string) } }
                        }
                    }
                }
            }
        }
    }
}

extension Path<PathBuilder.Component<String>> {
    public static var accounts: Path<PathBuilder.Component<String>> { Path {
        "accounts"
    } }

    public static var httpSigningKey: Path<PathBuilder.Component<String>> { Path {
        "http_signing_key"
    } }

    public static var sandbox: Path<PathBuilder.Component<String>> { Path {
        "sandbox"
    } }

    public static var authRecipients: Path<PathBuilder.Component<String>> { Path {
        "auth_recipients"
    } }

    public static var resendActivationEmail: Path<PathBuilder.Component<String>> { Path {
        "resend_activation_email"
    } }

    public static var samlOrg: Path<PathBuilder.Component<String>> { Path {
        "saml_org"
    } }
}
