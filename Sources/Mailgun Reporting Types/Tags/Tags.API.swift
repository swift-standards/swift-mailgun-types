//
//  Tags.API.swift
//  swift-mailgun
//
//  Created by Claude on 31/12/2024.
//

import Mailgun_Types_Shared

extension Mailgun.Reporting.Tags {
    @CasePathable
    @dynamicMemberLookup
    public enum API: Equatable, Sendable {
        case list(domain: Domain, request: Mailgun.Reporting.Tags.List.Request?)
        case get(domain: Domain, tag: String)
        case update(domain: Domain, tag: String, request: Mailgun.Reporting.Tags.Update.Request)
        case delete(domain: Domain, tag: String)
        case stats(domain: Domain, tag: String, request: Mailgun.Reporting.Tags.Stats.Request)
        case aggregates(
            domain: Domain,
            tag: String,
            request: Mailgun.Reporting.Tags.Aggregates.Request
        )
        case limits(domain: Domain)
    }
}

extension Mailgun.Reporting.Tags.API {
    public struct Router: ParserPrinter, Sendable {
        public init() {}

        public var body: some URLRouting.Router<Mailgun.Reporting.Tags.API> {
            OneOf {
                // List tags
                Route(.case(Mailgun.Reporting.Tags.API.list)) {
                    Method.get
                    Path { "v3" }
                    Path { Parse(.string.representing(Domain.self)) }
                    Path.tags
                    Optionally {
                        Parse(.memberwise(Mailgun.Reporting.Tags.List.Request.init)) {
                            Query {
                                Optionally {
                                    Field("page") { Parse(.string) }
                                }
                                Optionally {
                                    Field("limit") { Digits() }
                                }
                            }
                        }
                    }
                }

                // Get a tag
                Route(.case(Mailgun.Reporting.Tags.API.get)) {
                    Method.get
                    Path { "v3" }
                    Path { Parse(.string.representing(Domain.self)) }
                    Path.tag
                    Query {
                        Field("tag") { Parse(.string) }
                    }
                }

                // Update tag description
                Route(.case(Mailgun.Reporting.Tags.API.update)) {
                    Method.put
                    Path { "v3" }
                    Path { Parse(.string.representing(Domain.self)) }
                    Path.tag
                    Query {
                        Field("tag") { Parse(.string) }
                    }
                    Parse(.memberwise(Mailgun.Reporting.Tags.Update.Request.init)) {
                        Query {
                            Field("description") { Parse(.string) }
                        }
                    }
                }

                // Delete tag
                Route(.case(Mailgun.Reporting.Tags.API.delete)) {
                    Method.delete
                    Path { "v3" }
                    Path { Parse(.string.representing(Domain.self)) }
                    Path.tag
                    Query {
                        Field("tag") { Parse(.string) }
                    }
                }

                // Get tag stats
                Route(.case(Mailgun.Reporting.Tags.API.stats)) {
                    Method.get
                    Path { "v3" }
                    Path { Parse(.string.representing(Domain.self)) }
                    Path.tag
                    Path.stats
                    Query {
                        Field("tag") { Parse(.string) }
                    }
                    Parse(.memberwise(Mailgun.Reporting.Tags.Stats.Request.init)) {
                        Query {
                            Field("event") {
                                Many {
                                    Parse(.string)
                                }
                            }
                            Optionally {
                                Field("start") { Parse(.string) }
                            }
                            Optionally {
                                Field("end") { Parse(.string) }
                            }
                            Optionally {
                                Field("resolution") { Parse(.string) }
                            }
                            Optionally {
                                Field("duration") { Parse(.string) }
                            }
                            Optionally {
                                Field("provider") { Parse(.string) }
                            }
                            Optionally {
                                Field("device") { Parse(.string) }
                            }
                            Optionally {
                                Field("country") { Parse(.string) }
                            }
                        }
                    }
                }

                // Get tag aggregates
                Route(.case(Mailgun.Reporting.Tags.API.aggregates)) {
                    Method.get
                    Path { "v3" }
                    Path { Parse(.string.representing(Domain.self)) }
                    Path.tag
                    Path.stats
                    Path.aggregates
                    Query {
                        Field("tag") { Parse(.string) }
                    }
                    Parse(.memberwise(Mailgun.Reporting.Tags.Aggregates.Request.init)) {
                        Query {
                            Field("type") { Parse(.string) }
                        }
                    }
                }

                // Get tag limits
                Route(.case(Mailgun.Reporting.Tags.API.limits)) {
                    Method.get
                    Path { "v3" }
                    Path.domains
                    Path { Parse(.string.representing(Domain.self)) }
                    Path.limits
                    Path.tag
                }
            }
        }
    }
}

extension Path<PathBuilder.Component<String>> {
    public static var tags: Path<PathBuilder.Component<String>> { Path {
        "tags"
    } }

    public static var tag: Path<PathBuilder.Component<String>> { Path {
        "tag"
    } }

    public static var domains: Path<PathBuilder.Component<String>> { Path {
        "domains"
    } }

    public static var limits: Path<PathBuilder.Component<String>> { Path {
        "limits"
    } }
}
