//
//  Support.swift
//  swift-mailgun-types
//
//  Batch-0 parity corpus support: fixture location and compare-or-record
//  assertion shared by every area parity suite.
//

import Foundation
import Testing
import URL_Routing_Test_Support

enum Support {
    /// URL of the committed corpus fixture for an area, derived from #filePath.
    static func corpusURL(area: String, filePath: String = #filePath) -> URL {
        URL(fileURLWithPath: filePath)
            .deletingLastPathComponent()
            .appendingPathComponent("__Corpus__")
            .appendingPathComponent("\(area).txt")
    }

    /// Compare-or-record the corpus against the committed fixture; fails the
    /// test (with the mismatch payload) only on `.mismatched`.
    static func assertFixture(
        _ corpus: String,
        area: String,
        filePath: String = #filePath
    ) throws {
        let normalized = normalizeJSONBodies(normalizeFormBoundary(corpus))
        let outcome = try Parity.fixture(normalized, at: corpusURL(area: area, filePath: filePath))
        if case .mismatched(let diff) = outcome {
            Issue.record("Corpus mismatch for \(area):\n\(diff)")
        }
    }

    /// Normalizes randomized `----FormBoundary<UUID>` tokens ANYWHERE in the
    /// corpus — including Content-Type HEADER values, where FileUpload-style
    /// multipart routes (Suppressions Bounces/Unsubscribe/Allowlist importList)
    /// leak the random boundary. Parity.canonical only normalizes bodies.
    /// Batch-2 `Boundary.random()` work item.
    static func normalizeFormBoundary(_ text: String) -> String {
        text.replacingOccurrences(
            of: #"----FormBoundary[0-9A-Fa-f\-]{36}"#,
            with: "----FormBoundary<NORMALIZED>",
            options: .regularExpression
        )
    }

    /// Re-serializes `body(utf8): {…}` JSON lines with sorted keys so
    /// Dictionary-order nondeterminism in `.json` bodies (Reporting Metrics and
    /// Logs) cannot flap the fixture. Batch-4 Content-Type/encoder work item.
    static func normalizeJSONBodies(_ corpus: String) -> String {
        corpus
            .split(separator: "\n", omittingEmptySubsequences: false)
            .map { line -> String in
                guard line.hasPrefix("body(utf8): "),
                      line.dropFirst("body(utf8): ".count).first == "{",
                      let data = String(line.dropFirst("body(utf8): ".count)).data(using: .utf8),
                      let object = try? JSONSerialization.jsonObject(with: data),
                      let sorted = try? JSONSerialization.data(
                          withJSONObject: object,
                          options: [.sortedKeys, .withoutEscapingSlashes]
                      ),
                      let text = String(data: sorted, encoding: .utf8)
                else { return String(line) }
                return "body(utf8/sorted-keys): " + text
            }
            .joined(separator: "\n")
    }

    /// Round-trip assertion that isolates each route: a thrown parse error is
    /// recorded as that route's failure instead of aborting the loop.
    static func assertRoundTrips<Router: Parser.Bidirectional>(
        _ routes: [(name: String, route: Router.Output)],
        via router: Router,
        excluding: Set<String> = []
    ) where Router.Input == RFC_3986.URI.Request.Data, Router.Output: Equatable {
        for (name, route) in routes where !excluding.contains(name) {
            do {
                #expect(try Parity.roundTrips(route, via: router), "\(name)")
            } catch {
                Issue.record("round-trip threw for \(name): \(error)")
            }
        }
    }

    /// Normalizes Mailgun Messages' randomized `Part-<UUID>` multipart boundary
    /// tokens (body AND Content-Type header) so snapshots are deterministic.
    /// Batch-2 `Boundary.random()` work item: Messages Send/Mime conversions.
    static func normalizePartBoundary(_ text: String) -> String {
        text.replacingOccurrences(
            of: #"Part-[0-9A-Fa-f]{8}-[0-9A-Fa-f]{4}-[0-9A-Fa-f]{4}-[0-9A-Fa-f]{4}-[0-9A-Fa-f]{12}"#,
            with: "Part-<NORMALIZED>",
            options: .regularExpression
        )
    }
}
