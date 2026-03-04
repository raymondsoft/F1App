import SwiftUI

public extension F1UI {
    struct PositionBadge: View {
        public struct ViewData: Hashable, Sendable {
            public let position: Int?
            public let text: String

            public init(position: Int?, text: String) {
                self.position = position
                self.text = text
            }
        }

        private let viewData: ViewData

        public init(_ viewData: ViewData) {
            self.viewData = viewData
        }

        public var body: some View {
            Text(viewData.text)
                .font(F1Theme.Typography.number)
                .foregroundStyle(F1Theme.Colors.textOnAccent)
                .frame(minWidth: 28)
                .padding(.horizontal, F1Theme.Spacing.s)
                .padding(.vertical, F1Theme.Spacing.xs)
                .background(backgroundColor)
                .clipShape(RoundedRectangle(cornerRadius: F1Theme.Shapes.badgeCornerRadius, style: .continuous))
        }

        private var backgroundColor: Color {
            switch viewData.position {
            case 1:
                return F1Theme.Colors.victoryGold
            case 2:
                return F1Theme.Colors.textSecondary.opacity(0.85)
            case 3:
                return F1Theme.Colors.polePurple
            default:
                return F1Theme.Colors.f1Red
            }
        }
    }
}

#Preview("Position Badges Light") {
    HStack(spacing: F1Theme.Spacing.s) {
        F1UI.PositionBadge(.init(position: 1, text: "P1"))
        F1UI.PositionBadge(.init(position: 2, text: "P2"))
        F1UI.PositionBadge(.init(position: 3, text: "P3"))
        F1UI.PositionBadge(.init(position: 9, text: "P9"))
    }
    .padding()
    .preferredColorScheme(.light)
}

#Preview("Position Badges Dark") {
    HStack(spacing: F1Theme.Spacing.s) {
        F1UI.PositionBadge(.init(position: 1, text: "P1"))
        F1UI.PositionBadge(.init(position: 2, text: "P2"))
        F1UI.PositionBadge(.init(position: 3, text: "P3"))
        F1UI.PositionBadge(.init(position: 9, text: "P9"))
    }
    .padding()
    .background(F1Theme.Colors.background)
    .preferredColorScheme(.dark)
}
