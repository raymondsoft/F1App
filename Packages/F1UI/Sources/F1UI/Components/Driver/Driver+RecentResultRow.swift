import SwiftUI

public extension F1UI.Driver {
    enum RecentResult {}
}

public extension F1UI.Driver.RecentResult {
    struct Row: View {
        public struct ViewData: Hashable, Sendable {
            public let id: String
            public let roundText: String
            public let raceName: String
            public let dateText: String?
            public let positionText: String
            public let position: Int?
            public let pointsText: String
            public let resultChip: F1UI.Chip.ViewData

            public init(
                id: String,
                roundText: String,
                raceName: String,
                dateText: String?,
                positionText: String,
                position: Int?,
                pointsText: String,
                resultChip: F1UI.Chip.ViewData
            ) {
                self.id = id
                self.roundText = roundText
                self.raceName = raceName
                self.dateText = dateText
                self.positionText = positionText
                self.position = position
                self.pointsText = pointsText
                self.resultChip = resultChip
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
                VStack(alignment: .leading, spacing: F1Theme.Spacing.xs) {
                    Text(viewData.raceName)
                        .font(F1Theme.Typography.rowTitle)
                        .foregroundStyle(F1Theme.Colors.textPrimary)

                    Text(viewData.roundText)
                        .font(F1Theme.Typography.rowSubtitle)
                        .foregroundStyle(F1Theme.Colors.textSecondary)

                    if let dateText = viewData.dateText {
                        Text(dateText)
                            .font(F1Theme.Typography.meta.monospacedDigit())
                            .foregroundStyle(F1Theme.Colors.textSecondary)
                    }
                }
            } trailing: {
                VStack(alignment: .trailing, spacing: F1Theme.Spacing.xs) {
                    Text(viewData.pointsText)
                        .font(F1Theme.Typography.number)
                        .foregroundStyle(F1Theme.Colors.textPrimary)

                    F1UI.Chip(viewData.resultChip)
                }
            }
        }
    }
}

#Preview("Driver Recent Result Row Light") {
    F1UI.Driver.RecentResult.Row(
        .init(
            id: "2024-1-max_verstappen",
            roundText: "Round 1",
            raceName: "Bahrain Grand Prix",
            dateText: "2024-03-02",
            positionText: "P1",
            position: 1,
            pointsText: "25 pts",
            resultChip: .init(text: "1:31:44.742", style: .time)
        )
    )
    .padding()
    .background(F1Theme.Colors.background)
    .preferredColorScheme(.light)
}

#Preview("Driver Recent Result Row Dark") {
    F1UI.Driver.RecentResult.Row(
        .init(
            id: "2024-1-max_verstappen",
            roundText: "Round 1",
            raceName: "Bahrain Grand Prix",
            dateText: "2024-03-02",
            positionText: "P1",
            position: 1,
            pointsText: "25 pts",
            resultChip: .init(text: "1:31:44.742", style: .time)
        )
    )
    .padding()
    .background(F1Theme.Colors.background)
    .preferredColorScheme(.dark)
}
