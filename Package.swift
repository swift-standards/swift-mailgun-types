// swift-tools-version: 6.3.1

import PackageDescription

extension String {
    static let mailgun: Self = "Mailgun".types
    static let accountManagement: Self = "Mailgun AccountManagement".types
    static let credentials: Self = "Mailgun Credentials".types
    static let customMessageLimit: Self = "Mailgun CustomMessageLimit".types
    static let domains: Self = "Mailgun Domains".types
    static let ipAllowlist: Self = "Mailgun IPAllowlist".types
    static let ipPools: Self = "Mailgun IPPools".types
    static let ips: Self = "Mailgun IPs".types
    static let keys: Self = "Mailgun Keys".types
    static let lists: Self = "Mailgun Lists".types
    static let messages: Self = "Mailgun Messages".types
    static let reporting: Self = "Mailgun Reporting".types
    static let routes: Self = "Mailgun Routes".types
    static let subaccounts: Self = "Mailgun Subaccounts".types
    static let suppressions: Self = "Mailgun Suppressions".types
    static let templates: Self = "Mailgun Templates".types
    static let users: Self = "Mailgun Users".types
    static let webhooks: Self = "Mailgun Webhooks".types
    static let shared: Self = "Mailgun Types Shared"
}

extension Target.Dependency {
    static var mailgun: Self { .target(name: .mailgun) }
    static var accountManagement: Self { .target(name: .accountManagement) }
    static var credentials: Self { .target(name: .credentials) }
    static var customMessageLimit: Self { .target(name: .customMessageLimit) }
    static var domains: Self { .target(name: .domains) }
    static var ipAllowlist: Self { .target(name: .ipAllowlist) }
    static var ipPools: Self { .target(name: .ipPools) }
    static var ips: Self { .target(name: .ips) }
    static var keys: Self { .target(name: .keys) }
    static var lists: Self { .target(name: .lists) }
    static var messages: Self { .target(name: .messages) }
    static var reporting: Self { .target(name: .reporting) }
    static var routes: Self { .target(name: .routes) }
    static var subaccounts: Self { .target(name: .subaccounts) }
    static var suppressions: Self { .target(name: .suppressions) }
    static var templates: Self { .target(name: .templates) }
    static var users: Self { .target(name: .users) }
    static var webhooks: Self { .target(name: .webhooks) }
    static var shared: Self { .target(name: .shared) }
}

extension Target.Dependency {
    static var dependencies: Self { .product(name: "Dependencies", package: "swift-dependencies") }
    static var dependenciesTestSupport: Self { .product(name: "Dependencies Test Support", package: "swift-dependencies") }
    static var dateParsing: Self { .product(name: "UnixEpochParsing", package: "swift-date-parsing") }
    static var emailType: Self { .product(name: "Email Standard", package: "swift-email-standard") }
    static var domain: Self { .product(name: "Domain Standard", package: "swift-domain-standard") }
    static var emailAddress: Self { .product(name: "EmailAddress", package: "swift-emailaddress") }
    static var urlFormCoding: Self { .product(name: "URLFormCoding", package: "swift-url-form-coding") }
    static var rfc2822: Self { .product(name: "RFC 2822", package: "swift-rfc-2822") }
    static var urlRouting: Self {
        // TRANSITIONAL: pointfreeco/swift-url-routing — no institute equivalent adopted this wave;
        // kept temporarily per the manifest-swap directive (do not eliminate this wave).
        .product(name: "URLRouting", package: "swift-url-routing")
    }
    static var casePaths: Self {
        // TRANSITIONAL: pointfreeco/swift-case-paths — no institute equivalent adopted this wave;
        // kept temporarily per the manifest-swap directive (do not eliminate this wave).
        .product(name: "CasePaths", package: "swift-case-paths")
    }
}

let package = Package(
    name: "swift-mailgun-types",
    platforms: [
        .macOS(.v26),
        .iOS(.v26),
        .tvOS(.v26),
        .watchOS(.v26),
        .visionOS(.v26),
    ],
    products: [
        .library(name: .mailgun, targets: [.mailgun]),
        .library(name: .accountManagement, targets: [.accountManagement]),
        .library(name: .credentials, targets: [.credentials]),
        .library(name: .customMessageLimit, targets: [.customMessageLimit]),
        .library(name: .domains, targets: [.domains]),
        .library(name: .ipAllowlist, targets: [.ipAllowlist]),
        .library(name: .ipPools, targets: [.ipPools]),
        .library(name: .ips, targets: [.ips]),
        .library(name: .keys, targets: [.keys]),
        .library(name: .lists, targets: [.lists]),
        .library(name: .messages, targets: [.messages]),
        .library(name: .reporting, targets: [.reporting]),
        .library(name: .routes, targets: [.routes]),
        .library(name: .subaccounts, targets: [.subaccounts]),
        .library(name: .suppressions, targets: [.suppressions]),
        .library(name: .templates, targets: [.templates]),
        .library(name: .users, targets: [.users]),
        .library(name: .webhooks, targets: [.webhooks]),
        .library(name: .shared, targets: [.shared])
    ],
    dependencies: [
        .package(url: "https://github.com/swift-foundations/swift-date-parsing.git", branch: "main"),
        .package(url: "https://github.com/swift-foundations/swift-dependencies.git", branch: "main"),
        .package(url: "https://github.com/swift-standards/swift-email-standard.git", branch: "main"),
        .package(url: "https://github.com/swift-standards/swift-domain-standard.git", branch: "main"),
        .package(url: "https://github.com/swift-foundations/swift-emailaddress.git", branch: "main"),
        .package(url: "https://github.com/swift-foundations/swift-url-form-coding.git", branch: "main"),
        .package(url: "https://github.com/swift-ietf/swift-rfc-2822.git", branch: "main"),
        .package(url: "https://github.com/pointfreeco/swift-case-paths.git", from: "1.7.2"),
        .package(url: "https://github.com/swift-foundations/swift-url-routing.git", branch: "main"),
    ],
    targets: [
        .target(
            name: .shared,
            dependencies: [
                .domain,
                .emailAddress,
                .urlRouting,
                .urlFormCoding,
                .casePaths,
                .dateParsing,
                .dependencies
            ]
        ),
        .target(
            name: .mailgun,
            dependencies: [
                .shared,
                .accountManagement,
                .credentials,
                .customMessageLimit,
                .domains,
                .ipAllowlist,
                .ipPools,
                .ips,
                .keys,
                .lists,
                .messages,
                .reporting,
                .routes,
                .subaccounts,
                .suppressions,
                .templates,
                .users,
                .webhooks
            ]
        ),
        .testTarget(
            name: .mailgun.tests,
            dependencies: [
                .mailgun,
                .dependenciesTestSupport
            ]
        ),
        .target(
            name: .accountManagement,
            dependencies: [
                .shared
            ]
        ),
        .testTarget(
            name: .accountManagement.tests,
            dependencies: [.accountManagement, .shared, .dependenciesTestSupport]
        ),
        .target(
            name: .credentials,
            dependencies: [
                .shared
            ]
        ),
        .testTarget(
            name: .credentials.tests,
            dependencies: [.credentials, .shared, .dependenciesTestSupport]
        ),
        .target(
            name: .customMessageLimit,
            dependencies: [
                .shared
            ]
        ),
        .testTarget(
            name: .customMessageLimit.tests,
            dependencies: [.customMessageLimit, .shared, .dependenciesTestSupport]
        ),
        .target(
            name: .domains,
            dependencies: [
                .shared
            ]
        ),
        .testTarget(
            name: .domains.tests,
            dependencies: [.domains, .shared, .dependenciesTestSupport]
        ),
        .target(
            name: .ipAllowlist,
            dependencies: [
                .shared
            ]
        ),
        .testTarget(
            name: .ipAllowlist.tests,
            dependencies: [.ipAllowlist, .shared, .dependenciesTestSupport]
        ),
        .target(
            name: .ipPools,
            dependencies: [
                .shared
            ]
        ),
        .testTarget(
            name: .ipPools.tests,
            dependencies: [.ipPools, .shared, .dependenciesTestSupport]
        ),
        .target(
            name: .ips,
            dependencies: [
                .shared
            ]
        ),
        .testTarget(
            name: .ips.tests,
            dependencies: [.ips, .shared, .dependenciesTestSupport]
        ),
        .target(
            name: .keys,
            dependencies: [
                .shared
            ]
        ),
        .testTarget(
            name: .keys.tests,
            dependencies: [.keys, .shared, .dependenciesTestSupport]
        ),
        .target(
            name: .lists,
            dependencies: [
                .shared
            ]
        ),
        .testTarget(
            name: .lists.tests,
            dependencies: [.lists, .shared, .dependenciesTestSupport]
        ),
        .target(
            name: .messages,
            dependencies: [
                .shared,
                .emailType
            ]
        ),
        .testTarget(
            name: .messages.tests,
            dependencies: [.messages, .shared, .dependenciesTestSupport]
        ),
        .target(
            name: .reporting,
            dependencies: [
                .shared,
                .rfc2822
            ]
        ),
        .testTarget(
            name: .reporting.tests,
            dependencies: [.reporting, .shared, .dependenciesTestSupport]
        ),
        .target(
            name: .routes,
            dependencies: [
                .shared
            ]
        ),
        .testTarget(
            name: .routes.tests,
            dependencies: [.routes, .shared, .dependenciesTestSupport]
        ),
        .target(
            name: .subaccounts,
            dependencies: [
                .shared
            ]
        ),
        .testTarget(
            name: .subaccounts.tests,
            dependencies: [.subaccounts, .shared, .dependenciesTestSupport]
        ),
        .target(
            name: .suppressions,
            dependencies: [
                .shared,
                .urlFormCoding
            ]
        ),
        .testTarget(
            name: .suppressions.tests,
            dependencies: [.suppressions, .shared, .dependenciesTestSupport]
        ),
        .target(
            name: .templates,
            dependencies: [
                .shared
            ]
        ),
        .testTarget(
            name: .templates.tests,
            dependencies: [.templates, .shared, .dependenciesTestSupport]
        ),
        .target(
            name: .users,
            dependencies: [
                .shared
            ]
        ),
        .testTarget(
            name: .users.tests,
            dependencies: [.users, .shared, .dependenciesTestSupport]
        ),
        .target(
            name: .webhooks,
            dependencies: [
                .shared
            ]
        ),
        .testTarget(
            name: .webhooks.tests,
            dependencies: [.webhooks, .shared, .dependenciesTestSupport]
        )
    ]
)

extension String {
    var tests: Self { self + " Tests" }
    var types: Self { self + " Types" }
}
