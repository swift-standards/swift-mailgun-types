//
//  File.swift
//  swift-mailgun
//
//  Created by Coen ten Thije Boonkkamp on 24/12/2024.
//

import Mailgun_Types_Shared

extension Mailgun.Templates {
    @CasePathable
    @dynamicMemberLookup
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
                Route(.case(Mailgun.Templates.API.copyVersion)) {
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
                        Parse(.memberwise(Mailgun.Templates.Version.Copy.Request.init)) {
                            Query {
                                Optionally {
                                    Field("comment") { Parse(.string) }
                                }
                            }
                        }
                    }
                }

                // PUT /v3/{domain_name}/templates/{template_name}/versions/{version_name}
                Route(.case(Mailgun.Templates.API.updateVersion)) {
                    Method.put
                    Path { "v3" }
                    Path { Parse(.string.representing(Domain.self)) }
                    Path.templates
                    Path { Parse(.string) }
                    Path.versions
                    Path { Parse(.string) }
                    Multipart(
                        Mailgun.Templates.Version.Update.Request.self,
                        arrayEncodingStrategy: .brackets
                    )
                }

                // DELETE /v3/{domain_name}/templates/{template_name}/versions/{version_name}
                Route(.case(Mailgun.Templates.API.deleteVersion)) {
                    Method.delete
                    Path { "v3" }
                    Path { Parse(.string.representing(Domain.self)) }
                    Path.templates
                    Path { Parse(.string) }
                    Path.versions
                    Path { Parse(.string) }
                }

                // GET /v3/{domain_name}/templates/{template_name}/versions/{version_name}
                Route(.case(Mailgun.Templates.API.getVersion)) {
                    Method.get
                    Path { "v3" }
                    Path { Parse(.string.representing(Domain.self)) }
                    Path.templates
                    Path { Parse(.string) }
                    Path.versions
                    Path { Parse(.string) }
                }

                // POST /v3/{domain_name}/templates/{template_name}/versions
                Route(.case(Mailgun.Templates.API.createVersion)) {
                    Method.post
                    Path { "v3" }
                    Path { Parse(.string.representing(Domain.self)) }
                    Path.templates
                    Path { Parse(.string) }
                    Path.versions
                    Multipart(
                        Mailgun.Templates.Version.Create.Request.self,
                        arrayEncodingStrategy: .brackets
                    )
                }

                // GET /v3/{domain_name}/templates/{template_name}/versions
                Route(.case(Mailgun.Templates.API.versions)) {
                    Method.get
                    Path { "v3" }
                    Path { Parse(.string.representing(Domain.self)) }
                    Path.templates
                    Path { Parse(.string) }
                    Path.versions
                    Optionally {
                        Parse(.memberwise(Mailgun.Templates.Versions.Request.init)) {
                            Query {
                                Optionally {
                                    Field("page") {
                                        Parse(.string.representing(Mailgun.Templates.Page.self))
                                    }
                                }
                                Optionally {
                                    Field("limit") { Digits() }
                                }
                                Optionally {
                                    Field("p") { Parse(.string) }
                                }
                            }
                        }
                    }
                }

                // PUT /v3/{domain_name}/templates/{template_name}
                Route(.case(Mailgun.Templates.API.update)) {
                    Method.put
                    Path { "v3" }
                    Path { Parse(.string.representing(Domain.self)) }
                    Path.templates
                    Path { Parse(.string) }
                    Multipart(
                        Mailgun.Templates.Update.Request.self,
                        arrayEncodingStrategy: .brackets
                    )
                }

                // DELETE /v3/{domain_name}/templates/{template_name}
                Route(.case(Mailgun.Templates.API.delete)) {
                    Method.delete
                    Path { "v3" }
                    Path { Parse(.string.representing(Domain.self)) }
                    Path.templates
                    Path { Parse(.string) }
                }

                // GET /v3/{domain_name}/templates/{template_name}
                Route(.case(Mailgun.Templates.API.get)) {
                    Method.get
                    Path { "v3" }
                    Path { Parse(.string.representing(Domain.self)) }
                    Path.templates
                    Path { Parse(.string) }
                    Optionally {
                        Parse(.memberwise(Mailgun.Templates.Get.Request.init)) {
                            Query {
                                Optionally {
                                    Field("active") { Parse(.string) }
                                }
                            }
                        }
                    }
                }

                // POST /v3/{domain_name}/templates
                Route(.case(Mailgun.Templates.API.create)) {
                    Method.post
                    Path { "v3" }
                    Path { Parse(.string.representing(Domain.self)) }
                    Path.templates
                    Multipart(
                        Mailgun.Templates.Create.Request.self,
                        arrayEncodingStrategy: .brackets
                    )
                }

                // DELETE /v3/{domain_name}/templates
                Route(.case(Mailgun.Templates.API.deleteAll)) {
                    Method.delete
                    Path { "v3" }
                    Path { Parse(.string.representing(Domain.self)) }
                    Path.templates
                }

                // GET /v3/{domain_name}/templates
                Route(.case(Mailgun.Templates.API.list)) {
                    Method.get
                    Path { "v3" }
                    Path { Parse(.string.representing(Domain.self)) }
                    Path.templates
                    Optionally {
                        Parse(.memberwise(Mailgun.Templates.List.Request.init)) {
                            Query {
                                Optionally {
                                    Field("page") {
                                        Parse(.string.representing(Mailgun.Templates.Page.self))
                                    }
                                }
                                Optionally {
                                    Field("limit") { Digits() }
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
