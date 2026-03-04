import SwiftUI

public extension F1UI {
    struct SeasonProgressBar: View {
        public struct ViewData: Hashable, Sendable {
            public let completedRounds: Int
            public let totalRounds: Int

            public init(completedRounds: Int, totalRounds: Int) {
                self.completedRounds = completedRounds
                self.totalRounds = totalRounds
            }
        }

        private let viewData: ViewData

        public init(_ viewData: ViewData) {
            self.viewData = viewData
        }

        public var body: some View {
            VStack(alignment: .leading, spacing: F1Theme.Spacing.xs) {
                F1UI.PointsBar(
                    .init(
                        value: Double(viewData.completedRounds),
                        maxValue: Double(max(viewData.totalRounds, 1))
                    )
                )

                Text("\(viewData.completedRounds)/\(viewData.totalRounds) rounds")
                    .font(F1Theme.Typography.meta.monospacedDigit())
                    .foregroundStyle(F1Theme.Colors.textSecondary)
            }
        }
    }
}

#Preview("Season Progress Light") {
    F1UI.SeasonProgressBar(.init(completedRounds: 18, totalRounds: 24))
        .padding()
        .preferredColorScheme(.light)
}

#Preview("Season Progress Dark") {
    F1UI.SeasonProgressBar(.init(completedRounds: 18, totalRounds: 24))
        .padding()
        .background(F1Theme.Colors.background)
        .preferredColorScheme(.dark)
}
