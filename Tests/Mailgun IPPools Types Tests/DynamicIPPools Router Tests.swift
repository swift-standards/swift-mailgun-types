//
//  DynamicIPPools Router Tests.swift
//  swift-mailgun-types
//
//  Created by Assistant on 05/08/2025.
//

import Dependencies_Test_Support
import Testing

@testable import Mailgun_IPPools_Types

@Suite("Dynamic IP Pools Router Tests")
struct DynamicIPPoolsRouterTests {

    @Test("Creates correct URL for listing history")
    func testListHistoryURL() throws {
        let router: Mailgun.DynamicIPPools.API.Router = .init()

        let request = Mailgun.DynamicIPPools.HistoryList.Request(
            limit: 10,
            includeSubaccounts: true,
            domain: "test.com",
            before: "2025-01-01",
            after: "2024-01-01",
            movedTo: "pool-a",
            movedFrom: "pool-b"
        )
        let api: Mailgun.DynamicIPPools.API = .listHistory(request: request)

        let url = router.url(for: api)
        #expect(url.path == "/v1/dynamic_pools/history")
        #expect(url.query?.contains("Limit=10") == true)
        #expect(url.query?.contains("include_subaccounts=true") == true)
        #expect(url.query?.contains("domain=test.com") == true)
        #expect(url.query?.contains("before=2025-01-01") == true)
        #expect(url.query?.contains("after=2024-01-01") == true)
        #expect(url.query?.contains("moved_to=pool-a") == true)
        #expect(url.query?.contains("moved_from=pool-b") == true)

        let match: Mailgun.DynamicIPPools.API = try router.match(
            request: try router.request(for: api)
        )
        #expect(match.is(\.listHistory))
        #expect(match.listHistory?.domain == "test.com")
    }

    @Test("Client test implementation")
    func testDynamicIPPoolsClient() async throws {
        let testDate = Date(timeIntervalSince1970: 1_704_067_200)  // 2024-01-01

        let client = Mailgun.DynamicIPPools.Client(
            listHistory: { request in
                #expect(request.limit == 20)
                #expect(request.includeSubaccounts == true)
                return Mailgun.DynamicIPPools.HistoryList.Response(
                    items: [
                        Mailgun.DynamicIPPools.HistoryRecord(
                            domain: "test.com",
                            timestamp: testDate,
                            movedFrom: "pool-a",
                            movedTo: "pool-b",
                            reason: "Health check failed",
                            accountId: "acc-123"
                        ),
                        Mailgun.DynamicIPPools.HistoryRecord(
                            domain: "example.com",
                            timestamp: testDate.addingTimeInterval(3600),
                            movedFrom: nil,
                            movedTo: "pool-a",
                            reason: "Initial assignment"
                        ),
                    ],
                    paging: Mailgun.DynamicIPPools.HistoryList.Response.PagingInfo(
                        next: "/v1/dynamic_pools/history?page=2",
                        previous: nil,
                        first: "/v1/dynamic_pools/history?page=1",
                        last: "/v1/dynamic_pools/history?page=5"
                    )
                )
            },
            removeOverride: { domain in
                #expect(domain == "test.com")
                return Mailgun.DynamicIPPools.RemoveOverride.Response(
                    message: "Override removed successfully"
                )
            }
        )

        let historyResponse = try await client.listHistory(
            Mailgun.DynamicIPPools.HistoryList.Request(
                limit: 20,
                includeSubaccounts: true
            )
        )
        #expect(historyResponse.items.count == 2)
        #expect(historyResponse.items[0].domain == "test.com")
        #expect(historyResponse.items[0].movedFrom == "pool-a")
        #expect(historyResponse.items[0].movedTo == "pool-b")
        #expect(historyResponse.items[1].movedFrom == nil)
        #expect(historyResponse.paging?.next != nil)

        let removeResponse = try await client.removeOverride("test.com")
        #expect(removeResponse.message == "Override removed successfully")
    }

    @Test("Test history record coding")
    func testHistoryRecordCoding() throws {
        let record = Mailgun.DynamicIPPools.HistoryRecord(
            domain: "test.com",
            timestamp: Date(timeIntervalSince1970: 1_704_067_200),
            movedFrom: "pool-a",
            movedTo: "pool-b",
            reason: "Health check",
            accountId: "acc-123"
        )

        let encoder = JSONEncoder()
        encoder.dateEncodingStrategy = .iso8601
        let data = try encoder.encode(record)

        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        let decoded = try decoder.decode(Mailgun.DynamicIPPools.HistoryRecord.self, from: data)

        #expect(decoded.domain == record.domain)
        #expect(decoded.movedFrom == record.movedFrom)
        #expect(decoded.movedTo == record.movedTo)
        #expect(decoded.reason == record.reason)
        #expect(decoded.accountId == record.accountId)
    }

    @Test("Test history list request with all parameters")
    func testHistoryListRequestAllParameters() throws {
        let request = Mailgun.DynamicIPPools.HistoryList.Request(
            limit: 50,
            includeSubaccounts: false,
            domain: "specific.com",
            before: "2025-01-01T00:00:00Z",
            after: "2024-01-01T00:00:00Z",
            movedTo: "pool-high",
            movedFrom: "pool-low"
        )

        #expect(request.limit == 50)
        #expect(request.includeSubaccounts == false)
        #expect(request.domain == "specific.com")
        #expect(request.before == "2025-01-01T00:00:00Z")
        #expect(request.after == "2024-01-01T00:00:00Z")
        #expect(request.movedTo == "pool-high")
        #expect(request.movedFrom == "pool-low")
    }
}
