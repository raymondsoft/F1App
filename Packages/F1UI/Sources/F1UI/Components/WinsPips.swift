import SwiftUI

public extension F1UI {
    struct WinsPips: View {
        @State private var isVisible = false

        public struct ViewData: Hashable, Sendable {
            public let wins: Int
            public let maxVisible: Int

            public init(wins: Int, maxVisible: Int = 10) {
                self.wins = wins
                self.maxVisible = maxVisible
            }
        }

        private let viewData: ViewData

        public init(_ viewData: ViewData) {
            self.viewData = viewData
        }

        public var body: some View {
            HStack(spacing: F1Theme.Spacing.xs) {
                ForEach(0..<visibleCount, id: \.self) { index in
                    Circle()
                        .fill(index < filledCount ? F1Theme.Colors.victoryGold : F1Theme.Colors.separator.opacity(0.7))
                        .frame(width: 6, height: 6)
                        .scaleEffect(isVisible ? 1 : 0.85)
                }
            }
            .accessibilityLabel("\(viewData.wins) wins")
            .onAppear {
                withAnimation(F1Theme.Motion.easeInOutStandard) {
                    isVisible = true
                }
            }
            .onChange(of: viewData.wins) { _, _ in
                withAnimation(F1Theme.Motion.easeInOutStandard) {
                    isVisible = true
                }
            }
        }

        private var visibleCount: Int {
            max(1, viewData.maxVisible)
        }

        private var filledCount: Int {
            min(max(viewData.wins, 0), visibleCount)
        }
    }
}

#Preview("Wins Pips Light") {
    VStack(alignment: .leading, spacing: F1Theme.Spacing.s) {
        F1UI.WinsPips(.init(wins: 1, maxVisible: 8))
        F1UI.WinsPips(.init(wins: 4, maxVisible: 8))
        F1UI.WinsPips(.init(wins: 8, maxVisible: 8))
    }
    .padding()
    .preferredColorScheme(.light)
}

#Preview("Wins Pips Dark") {
    VStack(alignment: .leading, spacing: F1Theme.Spacing.s) {
        F1UI.WinsPips(.init(wins: 1, maxVisible: 8))
        F1UI.WinsPips(.init(wins: 4, maxVisible: 8))
        F1UI.WinsPips(.init(wins: 8, maxVisible: 8))
    }
    .padding()
    .background(F1Theme.Colors.background)
    .preferredColorScheme(.dark)
}
