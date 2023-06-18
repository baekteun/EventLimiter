import XCTest
@testable import EventLimiter

final class DebouncerTests: XCTestCase {
    func testDebouncer() async throws {
        let debouncer = Debouncer(for: 1)

        var targetNumber = 0

        debouncer {
            targetNumber = 1
        }
        try await Task.sleep(nanoseconds: 100_000_000)
        XCTAssertNotEqual(targetNumber, 1)

        try await Task.sleep(nanoseconds: 700_000_000)
        XCTAssertNotEqual(targetNumber, 1)

        debouncer {
            targetNumber = 2
        }
        try await Task.sleep(nanoseconds: 1_100_000_000)
        XCTAssertEqual(targetNumber, 2)

        debouncer {
            targetNumber = 3
        }
        try await Task.sleep(nanoseconds: 500_000_000)

        debouncer {
            targetNumber = 4
        }
        try await Task.sleep(nanoseconds: 600_000_000)
        XCTAssertNotEqual(targetNumber, 3)

        try await Task.sleep(nanoseconds: 500_000_000)
        XCTAssertEqual(targetNumber, 4)

        debouncer {
            targetNumber = 5
        }
        debouncer.cancel()
        try await Task.sleep(nanoseconds: 1_100_000_000)
        XCTAssertNotEqual(targetNumber, 5)
    }

    func testDebouncerTime() async throws {
        let debouncer = Debouncer(for: 3)

        var targetNumber = 0

        debouncer {
            targetNumber = 1
        }
        try await Task.sleep(nanoseconds: 1_100_000_000)
        XCTAssertNotEqual(targetNumber, 1)

        try await Task.sleep(nanoseconds: 2_000_000_000)
        XCTAssertEqual(targetNumber, 1)
    }
}
