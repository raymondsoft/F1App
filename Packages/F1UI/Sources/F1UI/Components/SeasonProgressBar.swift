import SwiftUI

public extension F1UI {
    struct SeasonProgressBar: View {
        @State private var displayedProgress: Double = 0

        public struct ViewData: Hashable, Sendable {
            public let completed: Int
            public let total: Int
            public let label: String?

            public init(completed: Int, total: Int, label: String? = nil) {
                self.completed = completed
                self.total = total
                self.label = label
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
                            .fill(F1Theme.Colors.separator.opacity(0.28))
                        Capsule()
                            .fill(F1Theme.Colors.fastestLapCyan)
                            .frame(width: proxy.size.width * displayedProgress)
                    }
                }
                .frame(height: 6)
                .onAppear {
                    withAnimation(F1Theme.Motion.easeInOutStandard) {
                        displayedProgress = progress
                    }
                }
                .onChange(of: viewData) { _, _ in
                    withAnimation(F1Theme.Motion.easeInOutStandard) {
                        displayedProgress = progress
                    }
                }

                Text(
                    viewData.label
                        ?? "\(max(viewData.completed, 0)) / \(max(viewData.total, 0))"
                )
                    .font(F1Theme.Typography.meta.monospacedDigit())
                    .foregroundStyle(F1Theme.Colors.textSecondary)
            }
        }

        private var progress: Double {
            Self.clampedProgress(completed: viewData.completed, total: viewData.total)
        }

        static func clampedProgress(completed: Int, total: Int) -> Double {
            guard total > 0 else { return 0 }
            return min(max(Double(completed) / Double(total), 0), 1)
        }
    }
}

#Preview("Season Progress Light") {
    VStack(alignment: .leading, spacing: F1Theme.Spacing.s) {
        F1UI.SeasonProgressBar(.init(completed: 0, total: 24))
        F1UI.SeasonProgressBar(.init(completed: 10, total: 24))
        F1UI.SeasonProgressBar(.init(completed: 24, total: 24, label: "Season Complete"))
    }
    .padding()
    .preferredColorScheme(.light)
}

#Preview("Season Progress Dark") {
    VStack(alignment: .leading, spacing: F1Theme.Spacing.s) {
        F1UI.SeasonProgressBar(.init(completed: 0, total: 24))
        F1UI.SeasonProgressBar(.init(completed: 10, total: 24))
        F1UI.SeasonProgressBar(.init(completed: 24, total: 24, label: "Season Complete"))
    }
    .padding()
    .background(F1Theme.Colors.background)
    .preferredColorScheme(.dark)
}
