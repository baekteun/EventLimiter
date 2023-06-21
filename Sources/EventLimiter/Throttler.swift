import Foundation

public final class Throttler {
    private let dueTime: UInt64
    private let latest: Bool
    private var task: Task<Void, Error>?
    private var action: (() async throws -> Void)?

    public init(for dueTime: TimeInterval, latest: Bool = true) {
        self.dueTime = UInt64(dueTime * 1_000_000_000)
        self.latest = latest
    }

    deinit {
        self.cancel()
    }

    public func callAsFunction(
        action: @escaping () async throws -> Void
    ) {
        self.execute(action: action)
    }

    public func cancel() {
        self.task?.cancel()
        self.task = nil
        self.action = nil
    }
}

private extension Throttler {
    func execute(
        action: @escaping () async throws -> Void
    ) {
        if self.latest {
            self.action = action
        }
        guard self.task?.isCancelled ?? true else { return }

        Task {
            try await action()
        }
        self.action = nil

        self.task = Task { [weak self] in
            guard let self else { return }
            try await Task.sleep(nanoseconds: self.dueTime)

            if self.latest, let action = self.action {
                try await action()
                self.action = nil
            }
            self.task?.cancel()
        }
    }
}
