import Foundation
import SwiftUI

public extension F1UI.Race {
    struct DetailHeader: View {
        public struct ViewData: Hashable, Sendable {
            public let id: String
            public let title: String
            public let dateText: String
            public let timeText: String?
            public let circuitName: String
            public let locality: String
            public let country: String
            public let wikipediaURL: URL?

            public init(
                id: String,
                title: String,
                dateText: String,
                timeText: String?,
                circuitName: String,
                locality: String,
                country: String,
                wikipediaURL: URL?
            ) {
                self.id = id
                self.title = title
                self.dateText = dateText
                self.timeText = timeText
                self.circuitName = circuitName
                self.locality = locality
                self.country = country
                self.wikipediaURL = wikipediaURL
            }
        }

        private let viewData: ViewData

        public init(_ viewData: ViewData) {
            self.viewData = viewData
        }

        public var body: some View {
            F1UI.RowContainer {
                Image(systemName: "flag.checkered")
                    .font(F1Theme.Typography.section)
                    .foregroundStyle(F1Theme.Colors.f1Red)
            } content: {
                VStack(alignment: .leading, spacing: F1Theme.Spacing.xs) {
                    Text(viewData.title)
                        .font(F1Theme.Typography.title)
                        .foregroundStyle(F1Theme.Colors.textPrimary)

                    Text(viewData.circuitName)
                        .font(F1Theme.Typography.rowTitle)
                        .foregroundStyle(F1Theme.Colors.textPrimary)

                    Text("\(viewData.locality), \(viewData.country)")
                        .font(F1Theme.Typography.rowSubtitle)
                        .foregroundStyle(F1Theme.Colors.textSecondary)
                }
            } trailing: {
                VStack(alignment: .trailing, spacing: F1Theme.Spacing.xs) {
                    Text(viewData.dateText)
                        .font(F1Theme.Typography.meta.monospacedDigit())
                        .foregroundStyle(F1Theme.Colors.textSecondary)

                    if let timeText = viewData.timeText {
                        Text(timeText)
                            .font(F1Theme.Typography.timing.monospacedDigit())
                            .foregroundStyle(F1Theme.Colors.textSecondary)
                    }

                    if let wikipediaURL = viewData.wikipediaURL {
                        Link(destination: wikipediaURL) {
                            Label("Wiki", systemImage: "safari")
                                .font(F1Theme.Typography.meta)
                                .foregroundStyle(F1Theme.Colors.f1Red)
                        }
                    }
                }
            }
        }
    }
}

#Preview("Race Detail Header Light") {
    F1UI.Race.DetailHeader(
        .init(
            id: "2024-1",
            title: "Bahrain Grand Prix",
            dateText: "2024-03-02",
            timeText: "15:00:00",
            circuitName: "Bahrain International Circuit",
            locality: "Sakhir",
            country: "Bahrain",
            wikipediaURL: URL(string: "https://en.wikipedia.org/wiki/Bahrain_International_Circuit")
        )
    )
    .padding()
    .background(F1Theme.Colors.background)
    .preferredColorScheme(.light)
}

#Preview("Race Detail Header Dark") {
    F1UI.Race.DetailHeader(
        .init(
            id: "2024-1",
            title: "Bahrain Grand Prix",
            dateText: "2024-03-02",
            timeText: "15:00:00",
            circuitName: "Bahrain International Circuit",
            locality: "Sakhir",
            country: "Bahrain",
            wikipediaURL: URL(string: "https://en.wikipedia.org/wiki/Bahrain_International_Circuit")
        )
    )
    .padding()
    .background(F1Theme.Colors.background)
    .preferredColorScheme(.dark)
}
