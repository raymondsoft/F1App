import SwiftUI

public extension F1UI {
    struct PointsBar: View {
        @State private var displayedFillRatio: CGFloat = 0

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
                        .frame(width: proxy.size.width * displayedFillRatio)
                }
            }
            .frame(height: 6)
            .accessibilityLabel("Points progress")
            .onAppear {
                withAnimation(F1Theme.Motion.easeInOutStandard) {
                    displayedFillRatio = fillRatio
                }
            }
            .onChange(of: viewData.value) { _, _ in
                withAnimation(F1Theme.Motion.easeInOutStandard) {
                    displayedFillRatio = fillRatio
                }
            }
        }

        private var fillRatio: CGFloat {
            guard viewData.maxValue > 0 else { return 0 }
            let normalized = viewData.value / viewData.maxValue
            return CGFloat(min(max(normalized, 0), 1))
        }
    }
}

#Preview("Points Bars Light") {
    VStack(spacing: F1Theme.Spacing.s) {
        F1UI.PointsBar(.init(value: 575, maxValue: 700))
        F1UI.PointsBar(.init(value: 420, maxValue: 700))
    }
    .padding()
    .preferredColorScheme(.light)
}

#Preview("Points Bars Dark") {
    VStack(spacing: F1Theme.Spacing.s) {
        F1UI.PointsBar(.init(value: 575, maxValue: 700))
        F1UI.PointsBar(.init(value: 420, maxValue: 700))
    }
    .padding()
    .background(F1Theme.Colors.background)
    .preferredColorScheme(.dark)
}
