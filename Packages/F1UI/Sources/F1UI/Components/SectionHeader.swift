import SwiftUI

public extension F1UI {
    struct SectionHeader: View {
        public struct ViewData: Hashable, Sendable {
            public let title: String
            public let subtitle: String?
            public let trailingText: String?

            public init(title: String, subtitle: String? = nil, trailingText: String? = nil) {
                self.title = title
                self.subtitle = subtitle
                self.trailingText = trailingText
            }
        }

        private let viewData: ViewData

        public init(_ viewData: ViewData) {
            self.viewData = viewData
        }

        public var body: some View {
            HStack(alignment: .firstTextBaseline, spacing: F1Theme.Spacing.s) {
                VStack(alignment: .leading, spacing: F1Theme.Spacing.xs) {
                    Text(viewData.title)
                        .font(F1Theme.Typography.section)
                        .foregroundStyle(F1Theme.Colors.textPrimary)

                    if let subtitle = viewData.subtitle {
                        Text(subtitle)
                            .font(F1Theme.Typography.meta)
                            .foregroundStyle(F1Theme.Colors.textSecondary)
                    }
                }

                Spacer(minLength: 0)

                if let trailingText = viewData.trailingText {
                    Text(trailingText)
                        .font(F1Theme.Typography.meta.monospacedDigit())
                        .foregroundStyle(F1Theme.Colors.textSecondary)
                }
            }
            .padding(.horizontal, F1Theme.Spacing.m)
        }
    }
}

#Preview("Section Header") {
    F1UI.SectionHeader(
        .init(
            title: "Driver Standings",
            subtitle: "After Round 18",
            trailingText: "575 pts"
        )
    )
}
