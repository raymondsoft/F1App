import SwiftUI

public extension F1UI.Standing {
    struct Row: View {
        public struct ViewData: Hashable, Sendable {
            public let id: String
            public let positionText: String
            public let title: String
            public let subtitle: String?
            public let pointsText: String
            public let winsText: String
            public let position: Int?
            public let pointsValue: Double?
            public let maxPointsValue: Double?
            public let winsCount: Int?

            public init(
                id: String,
                positionText: String,
                title: String,
                subtitle: String?,
                pointsText: String,
                winsText: String,
                position: Int? = nil,
                pointsValue: Double? = nil,
                maxPointsValue: Double? = nil,
                winsCount: Int? = nil
            ) {
                self.id = id
                self.positionText = positionText
                self.title = title
                self.subtitle = subtitle
                self.pointsText = pointsText
                self.winsText = winsText
                self.position = position
                self.pointsValue = pointsValue
                self.maxPointsValue = maxPointsValue
                self.winsCount = winsCount
            }
        }

        private let viewData: ViewData

        public init(_ viewData: ViewData) {
            self.viewData = viewData
        }

        public var body: some View {
            F1UI.RowContainer {
                F1UI.PositionBadge(
                    .init(
                        position: viewData.position,
                        text: "P\(viewData.positionText)"
                    )
                )
            } content: {
                VStack(alignment: .leading, spacing: F1Theme.Spacing.xs) {
                    Text(viewData.title)
                        .font(F1Theme.Typography.rowTitle)
                        .foregroundStyle(F1Theme.Colors.textPrimary)

                    if let subtitle = viewData.subtitle, !subtitle.isEmpty {
                        Text(subtitle)
                            .font(F1Theme.Typography.rowSubtitle)
                            .foregroundStyle(F1Theme.Colors.textSecondary)
                    }
                }
            } trailing: {
                VStack(alignment: .trailing, spacing: F1Theme.Spacing.xs) {
                    Text(viewData.pointsText)
                        .font(F1Theme.Typography.number)
                        .foregroundStyle(F1Theme.Colors.textPrimary)

                    if
                        let pointsValue = viewData.pointsValue,
                        let maxPointsValue = viewData.maxPointsValue
                    {
                        F1UI.PointsBar(
                            .init(
                                value: pointsValue,
                                maxValue: max(maxPointsValue, pointsValue)
                            )
                        )
                        .frame(width: 80)
                    }

                    if let winsCount = viewData.winsCount {
                        F1UI.WinsPips(.init(wins: winsCount, maxVisible: 8))
                    } else {
                        Text(viewData.winsText)
                            .font(F1Theme.Typography.meta)
                            .foregroundStyle(F1Theme.Colors.textSecondary)
                    }
                }
            }
        }
    }
}

#Preview("Standing Row") {
    F1UI.Standing.Row(
        .init(
            id: "2024-max_verstappen",
            positionText: "1",
            title: "Max Verstappen",
            subtitle: "Red Bull Racing",
            pointsText: "575 pts",
            winsText: "9 wins",
            position: 1,
            pointsValue: 575,
            maxPointsValue: 700,
            winsCount: 9
        )
    )
    .padding()
    .background(F1Theme.Colors.background)
}
