import SwiftUI

public extension F1UI.Driver {
    struct SeasonSummary: View {
        public struct ViewData: Hashable, Sendable {
            public let positionText: String
            public let position: Int?
            public let pointsText: String
            public let winsText: String
            public let pointsBar: F1UI.PointsBar.ViewData
            public let winsPips: F1UI.WinsPips.ViewData

            public init(
                positionText: String,
                position: Int?,
                pointsText: String,
                winsText: String,
                pointsBar: F1UI.PointsBar.ViewData,
                winsPips: F1UI.WinsPips.ViewData
            ) {
                self.positionText = positionText
                self.position = position
                self.pointsText = pointsText
                self.winsText = winsText
                self.pointsBar = pointsBar
                self.winsPips = winsPips
            }
        }

        private let viewData: ViewData

        public init(_ viewData: ViewData) {
            self.viewData = viewData
        }

        public var body: some View {
            F1UI.RowContainer {
                F1UI.PositionBadge(
                    .init(position: viewData.position, text: viewData.positionText)
                )
            } content: {
                VStack(alignment: .leading, spacing: F1Theme.Spacing.s) {
                    Text("Season Summary")
                        .font(F1Theme.Typography.rowTitle)
                        .foregroundStyle(F1Theme.Colors.textPrimary)

                    F1UI.PointsBar(viewData.pointsBar)
                        .frame(width: 120)

                    F1UI.WinsPips(viewData.winsPips)
                }
            } trailing: {
                VStack(alignment: .trailing, spacing: F1Theme.Spacing.xs) {
                    Text(viewData.pointsText)
                        .font(F1Theme.Typography.number)
                        .foregroundStyle(F1Theme.Colors.textPrimary)

                    Text(viewData.winsText)
                        .font(F1Theme.Typography.meta.monospacedDigit())
                        .foregroundStyle(F1Theme.Colors.textSecondary)
                }
            }
        }
    }
}

#Preview("Driver Season Summary Light") {
    F1UI.Driver.SeasonSummary(
        .init(
            positionText: "P1",
            position: 1,
            pointsText: "575 pts",
            winsText: "9 wins",
            pointsBar: .init(value: 575, maxValue: 700, style: .subtle),
            winsPips: .init(wins: 9)
        )
    )
    .padding()
    .background(F1Theme.Colors.background)
    .preferredColorScheme(.light)
}

#Preview("Driver Season Summary Dark") {
    F1UI.Driver.SeasonSummary(
        .init(
            positionText: "P1",
            position: 1,
            pointsText: "575 pts",
            winsText: "9 wins",
            pointsBar: .init(value: 575, maxValue: 700, style: .subtle),
            winsPips: .init(wins: 9)
        )
    )
    .padding()
    .background(F1Theme.Colors.background)
    .preferredColorScheme(.dark)
}
