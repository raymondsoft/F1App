import Foundation
import SwiftUI

public extension F1UI.Circuit {
    struct Summary: View {
        public struct ViewData: Hashable, Sendable {
            public let id: String
            public let name: String
            public let locality: String
            public let country: String
            public let coordinatesText: String?
            public let wikipediaURL: URL?

            public init(
                id: String,
                name: String,
                locality: String,
                country: String,
                coordinatesText: String?,
                wikipediaURL: URL?
            ) {
                self.id = id
                self.name = name
                self.locality = locality
                self.country = country
                self.coordinatesText = coordinatesText
                self.wikipediaURL = wikipediaURL
            }
        }

        private let viewData: ViewData

        public init(_ viewData: ViewData) {
            self.viewData = viewData
        }

        public var body: some View {
            F1UI.RowContainer {
                Image(systemName: "mappin.and.ellipse")
                    .font(F1Theme.Typography.section)
                    .foregroundStyle(F1Theme.Colors.fastestLapCyan)
            } content: {
                VStack(alignment: .leading, spacing: F1Theme.Spacing.xs) {
                    Text(viewData.name)
                        .font(F1Theme.Typography.rowTitle)
                        .foregroundStyle(F1Theme.Colors.textPrimary)

                    Text("\(viewData.locality), \(viewData.country)")
                        .font(F1Theme.Typography.rowSubtitle)
                        .foregroundStyle(F1Theme.Colors.textSecondary)

                    if let coordinatesText = viewData.coordinatesText {
                        Text(coordinatesText)
                            .font(F1Theme.Typography.meta.monospacedDigit())
                            .foregroundStyle(F1Theme.Colors.textSecondary)
                    }
                }
            } trailing: {
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

#Preview("Circuit Summary Light") {
    F1UI.Circuit.Summary(
        .init(
            id: "bahrain",
            name: "Bahrain International Circuit",
            locality: "Sakhir",
            country: "Bahrain",
            coordinatesText: "26.0325, 50.5106",
            wikipediaURL: URL(string: "https://en.wikipedia.org/wiki/Bahrain_International_Circuit")
        )
    )
    .padding()
    .background(F1Theme.Colors.background)
    .preferredColorScheme(.light)
}

#Preview("Circuit Summary Dark") {
    F1UI.Circuit.Summary(
        .init(
            id: "bahrain",
            name: "Bahrain International Circuit",
            locality: "Sakhir",
            country: "Bahrain",
            coordinatesText: "26.0325, 50.5106",
            wikipediaURL: URL(string: "https://en.wikipedia.org/wiki/Bahrain_International_Circuit")
        )
    )
    .padding()
    .background(F1Theme.Colors.background)
    .preferredColorScheme(.dark)
}
