import SwiftUI

public extension F1UI {
    struct TeamStripe: View {
        public struct ViewData: Hashable, Sendable {
            public let token: TeamStyleToken

            public init(token: TeamStyleToken) {
                self.token = token
            }
        }

        private let viewData: ViewData

        public init(_ viewData: ViewData) {
            self.viewData = viewData
        }

        public var body: some View {
            RoundedRectangle(cornerRadius: F1Theme.Shapes.teamStripeCornerRadius, style: .continuous)
                .fill(F1Theme.Colors.teamColor(for: viewData.token))
                .frame(width: F1Theme.Shapes.teamStripeWidth)
                .padding(.vertical, F1Theme.Shapes.teamStripeVerticalInset)
                .accessibilityHidden(true)
        }
    }
}

#Preview("Team Stripe Light") {
    HStack(spacing: F1Theme.Spacing.s) {
        F1UI.TeamStripe(.init(token: .ferrari))
            .frame(height: 32)
        F1UI.TeamStripe(.init(token: .mercedes))
            .frame(height: 32)
        F1UI.TeamStripe(.init(token: .redBull))
            .frame(height: 32)
    }
    .padding()
    .preferredColorScheme(.light)
}

#Preview("Team Stripe Dark") {
    HStack(spacing: F1Theme.Spacing.s) {
        F1UI.TeamStripe(.init(token: .ferrari))
            .frame(height: 32)
        F1UI.TeamStripe(.init(token: .mercedes))
            .frame(height: 32)
        F1UI.TeamStripe(.init(token: .redBull))
            .frame(height: 32)
    }
    .padding()
    .background(F1Theme.Colors.background)
    .preferredColorScheme(.dark)
}
