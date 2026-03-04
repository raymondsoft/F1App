import SwiftUI

public extension F1UI {
    struct PointsBar: View {
        public struct ViewData: Hashable, Sendable {
            public let value: Double
            public let maxValue: Double

            public init(value: Double, maxValue: Double) {
                self.value = value
                self.maxValue = maxValue
            }
        }

        private let viewData: ViewData

        public init(_ viewData: ViewData) {
            self.viewData = viewData
        }

        public var body: some View {
            GeometryReader { proxy in
                ZStack(alignment: .leading) {
                    Capsule()
                        .fill(F1Theme.Colors.separator.opacity(0.45))
                    Capsule()
                        .fill(F1Theme.Colors.f1Red)
                        .frame(width: proxy.size.width * fillRatio)
                }
            }
            .frame(height: 6)
            .accessibilityLabel("Points progress")
        }

        private var fillRatio: CGFloat {
            guard viewData.maxValue > 0 else { return 0 }
            let normalized = viewData.value / viewData.maxValue
            return CGFloat(min(max(normalized, 0), 1))
        }
    }
}

#Preview("Points Bars") {
    VStack(spacing: F1Theme.Spacing.s) {
        F1UI.PointsBar(.init(value: 575, maxValue: 700))
        F1UI.PointsBar(.init(value: 420, maxValue: 700))
    }
    .padding()
}
