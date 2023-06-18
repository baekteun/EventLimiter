import XCTest
@testable import EventLimiter

final class ThrottlerTests: XCTestCase {
    func testThrottlerLatestTrue() async throws {
        let throttler = Throttler(for: 1, latest: true)

        var targetNumber = 0

        throttler {
            targetNumber = 1
        }

        throttler {
            targetNumber = 2
        }
        try await Task.sleep(nanoseconds: 100_000_000)
        XCTAssertEqual(targetNumber, 1)
        XCTAssertNotEqual(targetNumber, 2)

        try await Task.sleep(nanoseconds: 700_000_000)

        throttler {
            targetNumber = 3
        }

        throttler {
            targetNumber = 4
        }
        try await Task.sleep(nanoseconds: 400_000_000)
        XCTAssertEqual(targetNumber, 4)
    }

    func testThrottlerLatestFalse() async throws {
        let throttler = Throttler(for: 1, latest: false)

        var targetNumber = 0

        throttler {
            targetNumber = 1
        }

        throttler {
            targetNumber = 2
        }
        try await Task.sleep(nanoseconds: 100_000_000)
        XCTAssertEqual(targetNumber, 1)
        XCTAssertNotEqual(targetNumber, 2)

        try await Task.sleep(nanoseconds: 700_000_000)

        throttler {
            targetNumber = 3
        }

        throttler {
            targetNumber = 4
        }
        try await Task.sleep(nanoseconds: 400_000_000)
        XCTAssertNotEqual(targetNumber, 3)
        XCTAssertNotEqual(targetNumber, 4)

        throttler {
            targetNumber = 5
        }
        try await Task.sleep(nanoseconds: 100_000_000)
        XCTAssertEqual(targetNumber, 5)
    }

    func testThrottlerTime() async throws {
        let throttler = Throttler(for: 3, latest: true)

        var targetNumber = 0

        throttler {
            targetNumber = 1
        }

        throttler {
            targetNumber = 2
        }
        try await Task.sleep(nanoseconds: 100_000_000)
        XCTAssertEqual(targetNumber, 1)

        throttler {
            targetNumber = 3
        }
        try await Task.sleep(nanoseconds: 3_500_000_000)
        XCTAssertEqual(targetNumber, 3)
    }

    func testThrottlerFirtActionShouldNotExecuteWhenLatestTrue() async throws {
        let throttler = Throttler(for: 1, latest: true)

        var targetNumber = 0

        throttler {
            targetNumber += 1
        }
        try await Task.sleep(nanoseconds: 100_000_000)
        XCTAssertEqual(targetNumber, 1)

        try await Task.sleep(nanoseconds: 1_100_000_000)
        XCTAssertNotEqual(targetNumber, 2)
    }
}
