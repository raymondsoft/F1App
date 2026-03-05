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
                        .fill(F1Theme.Colors.victoryGold)
                        .frame(width: 6, height: 6)
                        .scaleEffect(isVisible ? 1 : 0.85)
                        .opacity(isVisible ? 1 : 0.5)
                        .animation(
                            F1Theme.Motion.easeInOutStandard.delay(Double(index) * 0.01),
                            value: isVisible
                        )
                }

                if overflowCount > 0 {
                    Text("+\(overflowCount)")
                        .font(F1Theme.Typography.meta.monospacedDigit())
                        .foregroundStyle(F1Theme.Colors.textSecondary)
                }
            }
            .accessibilityLabel("\(viewData.wins) wins")
            .onAppear {
                withAnimation(F1Theme.Motion.easeInOutStandard) {
                    isVisible = true
                }
            }
            .onChange(of: viewData) { _, _ in
                isVisible = false
                withAnimation(F1Theme.Motion.easeInOutStandard) {
                    isVisible = true
                }
            }
        }

        private var visibleCount: Int {
            Self.visiblePipCount(wins: viewData.wins, maxVisible: viewData.maxVisible)
        }

        private var overflowCount: Int {
            Self.overflowCount(wins: viewData.wins, maxVisible: viewData.maxVisible)
        }

        static func visiblePipCount(wins: Int, maxVisible: Int) -> Int {
            min(max(wins, 0), max(maxVisible, 0))
        }

        static func overflowCount(wins: Int, maxVisible: Int) -> Int {
            max(max(wins, 0) - max(maxVisible, 0), 0)
        }
    }
}

#Preview("Wins Pips Light") {
    VStack(alignment: .leading, spacing: F1Theme.Spacing.s) {
        F1UI.WinsPips(.init(wins: 0))
        F1UI.WinsPips(.init(wins: 3))
        F1UI.WinsPips(.init(wins: 8))
        F1UI.WinsPips(.init(wins: 15))
    }
    .padding()
    .preferredColorScheme(.light)
}

#Preview("Wins Pips Dark") {
    VStack(alignment: .leading, spacing: F1Theme.Spacing.s) {
        F1UI.WinsPips(.init(wins: 0))
        F1UI.WinsPips(.init(wins: 3))
        F1UI.WinsPips(.init(wins: 8))
        F1UI.WinsPips(.init(wins: 15))
    }
    .padding()
    .background(F1Theme.Colors.background)
    .preferredColorScheme(.dark)
}
