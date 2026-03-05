import SwiftUI

public extension F1UI {
    struct PointsBar: View {
        @State private var displayedProgress: Double = 0

        public enum Style: Hashable, Sendable {
            case `default`
            case subtle
        }

        public struct ViewData: Hashable, Sendable {
            public let value: Double
            public let maxValue: Double
            public let showsValueLabel: Bool
            public let style: Style

            public init(
                value: Double,
                maxValue: Double,
                showsValueLabel: Bool = false,
                style: Style = .default
            ) {
                self.value = value
                self.maxValue = maxValue
                self.showsValueLabel = showsValueLabel
                self.style = style
            }
        }

        private let viewData: ViewData

        public init(_ viewData: ViewData) {
            self.viewData = viewData
        }

        public var body: some View {
            VStack(alignment: .leading, spacing: F1Theme.Spacing.xs) {
                GeometryReader { proxy in
                    ZStack(alignment: .leading) {
                        Capsule()
                            .fill(trackColor)
                        Capsule()
                            .fill(fillColor)
                            .frame(width: proxy.size.width * displayedProgress)
                    }
                }
                .frame(height: 6)

                if viewData.showsValueLabel {
                    Text(valueLabel)
                        .font(F1Theme.Typography.meta.monospacedDigit())
                        .foregroundStyle(F1Theme.Colors.textSecondary)
                }
            }
            .accessibilityLabel("Points progress")
            .accessibilityValue("\(Int((clampedProgress * 100).rounded())) percent")
            .onAppear {
                withAnimation(F1Theme.Motion.easeInOutStandard) {
                    displayedProgress = clampedProgress
                }
            }
            .onChange(of: viewData) { _, _ in
                withAnimation(F1Theme.Motion.easeInOutStandard) {
                    displayedProgress = clampedProgress
                }
            }
        }

        private var trackColor: Color {
            switch viewData.style {
            case .default:
                return F1Theme.Colors.separator.opacity(0.35)
            case .subtle:
                return F1Theme.Colors.separator.opacity(0.22)
            }
        }

        private var fillColor: Color {
            switch viewData.style {
            case .default:
                return F1Theme.Colors.f1Red
            case .subtle:
                return F1Theme.Colors.f1Red.opacity(0.75)
            }
        }

        private var clampedProgress: Double {
            Self.clampedProgress(value: viewData.value, maxValue: viewData.maxValue)
        }

        private var valueLabel: String {
            "\(formatNumber(viewData.value)) / \(formatNumber(viewData.maxValue))"
        }

        private func formatNumber(_ value: Double) -> String {
            if value.rounded() == value {
                return String(Int(value))
            }
            return String(format: "%.1f", locale: Locale(identifier: "en_US_POSIX"), value)
        }

        static func clampedProgress(value: Double, maxValue: Double) -> Double {
            guard maxValue > 0 else { return 0 }
            return min(max(value / maxValue, 0), 1)
        }
    }
}

#Preview("Points Bars Light") {
    VStack(spacing: F1Theme.Spacing.s) {
        F1UI.PointsBar(.init(value: 0, maxValue: 100))
        F1UI.PointsBar(.init(value: 30, maxValue: 100, style: .subtle))
        F1UI.PointsBar(.init(value: 70, maxValue: 100, showsValueLabel: true))
        F1UI.PointsBar(.init(value: 100, maxValue: 100))
    }
    .padding()
    .preferredColorScheme(.light)
}

#Preview("Points Bars Dark") {
    VStack(spacing: F1Theme.Spacing.s) {
        F1UI.PointsBar(.init(value: 0, maxValue: 100))
        F1UI.PointsBar(.init(value: 30, maxValue: 100, style: .subtle))
        F1UI.PointsBar(.init(value: 70, maxValue: 100, showsValueLabel: true))
        F1UI.PointsBar(.init(value: 100, maxValue: 100))
    }
    .padding()
    .background(F1Theme.Colors.background)
    .preferredColorScheme(.dark)
}
