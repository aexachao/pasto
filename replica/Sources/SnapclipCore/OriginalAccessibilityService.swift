import ApplicationServices
import Combine
import CoreGraphics
import Foundation

/// Permission observation is separate from the original explicit modal request actions.
public final class OriginalAccessibilityService {
    public init() {}

    public func f_100ae5e74() -> Bool {
        AXIsProcessTrusted()
    }

    /// Direct paste posts CGEvents; check that capability rather than inferring it
    /// from AX trust. Both checks are read-only and never request permission.
    public func canPostEvents() -> Bool {
        CGPreflightPostEventAccess()
    }

    public func postEventAccessChanges() -> AnyPublisher<Bool, Never> {
        Just(canPostEvents()).merge(with:
            Timer.publish(every: 1, on: .main, in: .common).autoconnect()
                .map { [weak self] _ in self?.canPostEvents() ?? false })
            .removeDuplicates().eraseToAnyPublisher()
    }

    public func f_100ae5e90() -> AnyPublisher<Bool, Never> {
        let initial = Just(f_100ae5e74())
        let changes = Timer.publish(every: 1, on: .main, in: .common)
            .autoconnect()
            .map { [weak self] _ in
                guard self != nil else { return false }
                return AXIsProcessTrusted()
            }
        return initial.merge(with: changes)
            .removeDuplicates()
            .eraseToAnyPublisher()
    }
}
