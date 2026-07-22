//
//  File.swift
//  swift-mailgun
//
//  Created by Coen ten Thije Boonkkamp on 24/12/2024.
//

import HTML_Form_Coder_Codable
import HTML_Standard
import Mailgun_Types_Shared
import RFC_2046

extension Mailgun.Templates {
    @Cases
    public enum API: Equatable, Sendable {
        case list(domainId: Domain, request: Mailgun.Templates.List.Request?)
        case create(domainId: Domain, request: Mailgun.Templates.Create.Request)
        case deleteAll(domainId: Domain)
        case versions(
            domainId: Domain,
            templateName: String,
            request: Mailgun.Templates.Versions.Request?
        )
        case createVersion(
            domainId: Domain,
            templateName: String,
            request: Mailgun.Templates.Version.Create.Request
        )
        case get(domainId: Domain, templateName: String, request: Mailgun.Templates.Get.Request?)
        case update(
            domainId: Domain,
            templateName: String,
            request: Mailgun.Templates.Update.Request
        )
        case delete(domainId: Domain, templateName: String)
        case getVersion(domainId: Domain, templateName: String, versionName: String)
        case updateVersion(
            domainId: Domain,
            templateName: String,
            versionName: String,
            request: Mailgun.Templates.Version.Update.Request
        )
        case deleteVersion(domainId: Domain, templateName: String, versionName: String)
        case copyVersion(
            domainId: Domain,
            templateName: String,
            versionName: String,
            newVersionName: String,
            request: Mailgun.Templates.Version.Copy.Request?
        )
    }
}

extension Mailgun.Templates.API {
    public struct Router: ParserPrinter, Sendable {
        public init() {}

        public var body: some URLRouting.Router<Mailgun.Templates.API> {
            OneOf {
                // PUT /v3/{domain_name}/templates/{template_name}/versions/{version_name}/copy/{new_version_name}
                Route(
                    .convert(
                        apply: {
                            (
                                domainId: $0.0.0.0.0,
                                templateName: $0.0.0.0.1,
                                versionName: $0.0.0.1,
                                newVersionName: $0.0.1,
                                request: $0.1
                            )
                        },
                        unapply: {
                            (((($0.domainId, $0.templateName), $0.versionName), $0.newVersionName), $0.request)
                        }
                    )
                    .map(.case(Mailgun.Templates.API.cases.copyVersion))
                ) {
                    Method.put
                    Path { "v3" }
                    Path { Parse(.string.representing(Domain.self)) }
                    Path.templates
                    Path { Parse(.string) }
                    Path.versions
                    Path { Parse(.string) }
                    Path { "copy" }
                    Path { Parse(.string) }
                    Optionally {
                        Parse(
                            .memberwise(
                                Mailgun.Templates.Version.Copy.Request.init,
                                { $0.comment }
                            )
                        ) {
                            Query {
                                Optionally {
                                    Field("comment") { Parse(.string) }
                                }
                            }
                        }
                    }
                }

                // PUT /v3/{domain_name}/templates/{template_name}/versions/{version_name}
                Route(
                    .convert(
                        apply: {
                            (
                                domainId: $0.0.0.0,
                                templateName: $0.0.0.1,
                                versionName: $0.0.1,
                                request: $0.1
                            )
                        },
                        unapply: {
                            ((($0.domainId, $0.templateName), $0.versionName), $0.request)
                        }
                    )
                    .map(.case(Mailgun.Templates.API.cases.updateVersion))
                ) {
                    Method.put
                    Path { "v3" }
                    Path { Parse(.string.representing(Domain.self)) }
                    Path.templates
                    Path { Parse(.string) }
                    Path.versions
                    Path { Parse(.string) }
                    URLRouting.Body(coding:
                        HTML.Form.Coder.Multipart.Value(
                            Mailgun.Templates.Version.Update.Request.self,
                            boundary: RFC_2046.Boundary(__unchecked: (), rawValue: "----MailgunFormBoundary"),
                            encoder: .init(array: .brackets)
                        )
                    )
                }

                // DELETE /v3/{domain_name}/templates/{template_name}/versions/{version_name}
                Route(
                    .convert(
                        apply: { (domainId: $0.0.0, templateName: $0.0.1, versionName: $0.1) },
                        unapply: { (($0.domainId, $0.templateName), $0.versionName) }
                    )
                    .map(.case(Mailgun.Templates.API.cases.deleteVersion))
                ) {
                    Method.delete
                    Path { "v3" }
                    Path { Parse(.string.representing(Domain.self)) }
                    Path.templates
                    Path { Parse(.string) }
                    Path.versions
                    Path { Parse(.string) }
                }

                // GET /v3/{domain_name}/templates/{template_name}/versions/{version_name}
                Route(
                    .convert(
                        apply: { (domainId: $0.0.0, templateName: $0.0.1, versionName: $0.1) },
                        unapply: { (($0.domainId, $0.templateName), $0.versionName) }
                    )
                    .map(.case(Mailgun.Templates.API.cases.getVersion))
                ) {
                    Method.get
                    Path { "v3" }
                    Path { Parse(.string.representing(Domain.self)) }
                    Path.templates
                    Path { Parse(.string) }
                    Path.versions
                    Path { Parse(.string) }
                }

                // POST /v3/{domain_name}/templates/{template_name}/versions
                Route(
                    .convert(
                        apply: { (domainId: $0.0.0, templateName: $0.0.1, request: $0.1) },
                        unapply: { (($0.domainId, $0.templateName), $0.request) }
                    )
                    .map(.case(Mailgun.Templates.API.cases.createVersion))
                ) {
                    Method.post
                    Path { "v3" }
                    Path { Parse(.string.representing(Domain.self)) }
                    Path.templates
                    Path { Parse(.string) }
                    Path.versions
                    URLRouting.Body(coding:
                        HTML.Form.Coder.Multipart.Value(
                            Mailgun.Templates.Version.Create.Request.self,
                            boundary: RFC_2046.Boundary(__unchecked: (), rawValue: "----MailgunFormBoundary"),
                            encoder: .init(array: .brackets)
                        )
                    )
                }

                // GET /v3/{domain_name}/templates/{template_name}/versions
                Route(
                    .convert(
                        apply: { (domainId: $0.0.0, templateName: $0.0.1, request: $0.1) },
                        unapply: { (($0.domainId, $0.templateName), $0.request) }
                    )
                    .map(.case(Mailgun.Templates.API.cases.versions))
                ) {
                    Method.get
                    Path { "v3" }
                    Path { Parse(.string.representing(Domain.self)) }
                    Path.templates
                    Path { Parse(.string) }
                    Path.versions
                    Optionally {
                        Parse(
                            .convert(
                                apply: { ($0.0.0, $0.0.1, $0.1) },
                                unapply: { (($0.0, $0.1), $0.2) }
                            )
                            .map(
                                .memberwise(
                                    Mailgun.Templates.Versions.Request.init,
                                    { ($0.page, $0.limit, $0.p) }
                                )
                            )
                        ) {
                            Query {
                                Optionally {
                                    Field("page") {
                                        Parse(.string.representing(Mailgun.Templates.Page.self))
                                    }
                                }
                                Optionally {
                                    Field("limit") { Int.parser() }
                                }
                                Optionally {
                                    Field("p") { Parse(.string) }
                                }
                            }
                        }
                    }
                }

                // PUT /v3/{domain_name}/templates/{template_name}
                Route(
                    .convert(
                        apply: { (domainId: $0.0.0, templateName: $0.0.1, request: $0.1) },
                        unapply: { (($0.domainId, $0.templateName), $0.request) }
                    )
                    .map(.case(Mailgun.Templates.API.cases.update))
                ) {
                    Method.put
                    Path { "v3" }
                    Path { Parse(.string.representing(Domain.self)) }
                    Path.templates
                    Path { Parse(.string) }
                    URLRouting.Body(coding:
                        HTML.Form.Coder.Multipart.Value(
                            Mailgun.Templates.Update.Request.self,
                            boundary: RFC_2046.Boundary(__unchecked: (), rawValue: "----MailgunFormBoundary"),
                            encoder: .init(array: .brackets)
                        )
                    )
                }

                // DELETE /v3/{domain_name}/templates/{template_name}
                Route(
                    .convert(
                        apply: { (domainId: $0.0, templateName: $0.1) },
                        unapply: { ($0.domainId, $0.templateName) }
                    )
                    .map(.case(Mailgun.Templates.API.cases.delete))
                ) {
                    Method.delete
                    Path { "v3" }
                    Path { Parse(.string.representing(Domain.self)) }
                    Path.templates
                    Path { Parse(.string) }
                }

                // GET /v3/{domain_name}/templates/{template_name}
                Route(
                    .convert(
                        apply: { (domainId: $0.0.0, templateName: $0.0.1, request: $0.1) },
                        unapply: { (($0.domainId, $0.templateName), $0.request) }
                    )
                    .map(.case(Mailgun.Templates.API.cases.get))
                ) {
                    Method.get
                    Path { "v3" }
                    Path { Parse(.string.representing(Domain.self)) }
                    Path.templates
                    Path { Parse(.string) }
                    Optionally {
                        Parse(
                            .memberwise(
                                Mailgun.Templates.Get.Request.init,
                                { $0.active }
                            )
                        ) {
                            Query {
                                Optionally {
                                    Field("active") { Parse(.string) }
                                }
                            }
                        }
                    }
                }

                // POST /v3/{domain_name}/templates
                Route(
                    .convert(
                        apply: { (domainId: $0.0, request: $0.1) },
                        unapply: { ($0.domainId, $0.request) }
                    )
                    .map(.case(Mailgun.Templates.API.cases.create))
                ) {
                    Method.post
                    Path { "v3" }
                    Path { Parse(.string.representing(Domain.self)) }
                    Path.templates
                    URLRouting.Body(coding:
                        HTML.Form.Coder.Multipart.Value(
                            Mailgun.Templates.Create.Request.self,
                            boundary: RFC_2046.Boundary(__unchecked: (), rawValue: "----MailgunFormBoundary"),
                            encoder: .init(array: .brackets)
                        )
                    )
                }

                // DELETE /v3/{domain_name}/templates
                Route(.case(Mailgun.Templates.API.cases.deleteAll)) {
                    Method.delete
                    Path { "v3" }
                    Path { Parse(.string.representing(Domain.self)) }
                    Path.templates
                }

                // GET /v3/{domain_name}/templates
                Route(
                    .convert(
                        apply: { (domainId: $0.0, request: $0.1) },
                        unapply: { ($0.domainId, $0.request) }
                    )
                    .map(.case(Mailgun.Templates.API.cases.list))
                ) {
                    Method.get
                    Path { "v3" }
                    Path { Parse(.string.representing(Domain.self)) }
                    Path.templates
                    Optionally {
                        Parse(
                            .convert(
                                apply: { ($0.0.0, $0.0.1, $0.1) },
                                unapply: { (($0.0, $0.1), $0.2) }
                            )
                            .map(
                                .memberwise(
                                    Mailgun.Templates.List.Request.init,
                                    { ($0.page, $0.limit, $0.p) }
                                )
                            )
                        ) {
                            Query {
                                Optionally {
                                    Field("page") {
                                        Parse(.string.representing(Mailgun.Templates.Page.self))
                                    }
                                }
                                Optionally {
                                    Field("limit") { Int.parser() }
                                }
                                Optionally {
                                    Field("p") { Parse(.string) }
                                }
                            }
                        }
                    }
                }
            }
        }
    }
}

extension Path<PathBuilder.Component<String>> {
    static var templates: Path<PathBuilder.Component<String>> { Path { "templates" } }
    static var versions: Path<PathBuilder.Component<String>> { Path { "versions" } }
}
