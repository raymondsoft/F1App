import SwiftUI

#Preview("Design System Gallery Light") {
    ScrollView {
        VStack(alignment: .leading, spacing: F1Theme.Spacing.l) {
            F1UI.SectionHeader(.init(title: "Design System", subtitle: "Apple data-first + subtle Formula accents"))

            F1UI.RowContainer {
                F1UI.PositionBadge(.init(position: 1, text: "P1"))
            } content: {
                VStack(alignment: .leading, spacing: F1Theme.Spacing.xs) {
                    Text("Max Verstappen")
                        .font(F1Theme.Typography.rowTitle)
                    Text("Red Bull Racing")
                        .font(F1Theme.Typography.rowSubtitle)
                        .foregroundStyle(F1Theme.Colors.textSecondary)
                }
            } trailing: {
                VStack(alignment: .trailing, spacing: F1Theme.Spacing.xs) {
                    Text("575 pts")
                        .font(F1Theme.Typography.number)
                    F1UI.PointsBar(.init(value: 575, maxValue: 700))
                        .frame(width: 88)
                }
            }

            HStack(spacing: F1Theme.Spacing.s) {
                F1UI.PositionBadge(.init(position: 1, text: "P1"))
                F1UI.PositionBadge(.init(position: 2, text: "P2"))
                F1UI.PositionBadge(.init(position: 3, text: "P3"))
                F1UI.PositionBadge(.init(position: 9, text: "P9"))
            }

            HStack(spacing: F1Theme.Spacing.s) {
                F1UI.Chip(.init(text: "1:31:44.742", style: .time))
                F1UI.Chip(.init(text: "DNF", style: .status))
                F1UI.Chip(.init(text: "Round 18", style: .neutral))
            }

            VStack(alignment: .leading, spacing: F1Theme.Spacing.s) {
                F1UI.PointsBar(.init(value: 575, maxValue: 700))
                F1UI.PointsBar(.init(value: 420, maxValue: 700))
                F1UI.SeasonProgressBar(.init(completedRounds: 18, totalRounds: 24))
                F1UI.WinsPips(.init(wins: 1, maxVisible: 8))
                F1UI.WinsPips(.init(wins: 5, maxVisible: 8))
            }

            HStack(spacing: F1Theme.Spacing.s) {
                F1UI.TeamStripe(.init(token: .ferrari))
                    .frame(height: 28)
                F1UI.TeamStripe(.init(token: .mercedes))
                    .frame(height: 28)
                F1UI.TeamStripe(.init(token: .redBull))
                    .frame(height: 28)
                F1UI.TeamStripe(.init(token: .mclaren))
                    .frame(height: 28)
            }
        }
        .padding(F1Theme.Spacing.l)
    }
    .background(F1Theme.Colors.background)
    .preferredColorScheme(.light)
}

#Preview("Design System Gallery Dark") {
    ScrollView {
        VStack(alignment: .leading, spacing: F1Theme.Spacing.l) {
            F1UI.SectionHeader(.init(title: "Design System", subtitle: "Apple data-first + subtle Formula accents"))

            F1UI.RowContainer {
                F1UI.PositionBadge(.init(position: 1, text: "P1"))
            } content: {
                VStack(alignment: .leading, spacing: F1Theme.Spacing.xs) {
                    Text("Max Verstappen")
                        .font(F1Theme.Typography.rowTitle)
                    Text("Red Bull Racing")
                        .font(F1Theme.Typography.rowSubtitle)
                        .foregroundStyle(F1Theme.Colors.textSecondary)
                }
            } trailing: {
                VStack(alignment: .trailing, spacing: F1Theme.Spacing.xs) {
                    Text("575 pts")
                        .font(F1Theme.Typography.number)
                    F1UI.PointsBar(.init(value: 575, maxValue: 700))
                        .frame(width: 88)
                }
            }

            HStack(spacing: F1Theme.Spacing.s) {
                F1UI.PositionBadge(.init(position: 1, text: "P1"))
                F1UI.PositionBadge(.init(position: 2, text: "P2"))
                F1UI.PositionBadge(.init(position: 3, text: "P3"))
                F1UI.PositionBadge(.init(position: 9, text: "P9"))
            }

            HStack(spacing: F1Theme.Spacing.s) {
                F1UI.Chip(.init(text: "1:31:44.742", style: .time))
                F1UI.Chip(.init(text: "DNF", style: .status))
                F1UI.Chip(.init(text: "Round 18", style: .neutral))
            }

            VStack(alignment: .leading, spacing: F1Theme.Spacing.s) {
                F1UI.PointsBar(.init(value: 575, maxValue: 700))
                F1UI.PointsBar(.init(value: 420, maxValue: 700))
                F1UI.SeasonProgressBar(.init(completedRounds: 18, totalRounds: 24))
                F1UI.WinsPips(.init(wins: 1, maxVisible: 8))
                F1UI.WinsPips(.init(wins: 5, maxVisible: 8))
            }

            HStack(spacing: F1Theme.Spacing.s) {
                F1UI.TeamStripe(.init(token: .ferrari))
                    .frame(height: 28)
                F1UI.TeamStripe(.init(token: .mercedes))
                    .frame(height: 28)
                F1UI.TeamStripe(.init(token: .redBull))
                    .frame(height: 28)
                F1UI.TeamStripe(.init(token: .mclaren))
                    .frame(height: 28)
            }
        }
        .padding(F1Theme.Spacing.l)
    }
    .background(F1Theme.Colors.background)
    .preferredColorScheme(.dark)
}
