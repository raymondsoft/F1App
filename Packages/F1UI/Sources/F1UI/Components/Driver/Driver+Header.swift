import Foundation
import SwiftUI

public extension F1UI.Driver {
    struct Header: View {
        public struct ViewData: Hashable, Sendable {
            public let displayName: String
            public let nationality: String
            public let dateOfBirthText: String?
            public let wikipediaURL: URL?
            public let flagEmoji: String?

            public init(
                displayName: String,
                nationality: String,
                dateOfBirthText: String?,
                wikipediaURL: URL?,
                flagEmoji: String? = nil
            ) {
                self.displayName = displayName
                self.nationality = nationality
                self.dateOfBirthText = dateOfBirthText
                self.wikipediaURL = wikipediaURL
                self.flagEmoji = flagEmoji
            }
        }

        private let viewData: ViewData

        public init(_ viewData: ViewData) {
            self.viewData = viewData
        }

        public var body: some View {
            F1UI.RowContainer {
                Group {
                    if let flagEmoji = viewData.flagEmoji {
                        Text(flagEmoji)
                    } else {
                        Image(systemName: "person.crop.circle.fill")
                            .foregroundStyle(F1Theme.Colors.f1Red)
                    }
                }
                .font(.title2)
            } content: {
                VStack(alignment: .leading, spacing: F1Theme.Spacing.xs) {
                    Text(viewData.displayName)
                        .font(F1Theme.Typography.title)
                        .foregroundStyle(F1Theme.Colors.textPrimary)

                    Text(identityLine)
                        .font(F1Theme.Typography.rowSubtitle)
                        .foregroundStyle(F1Theme.Colors.textSecondary)
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

        private var identityLine: String {
            if let dateOfBirthText = viewData.dateOfBirthText, !dateOfBirthText.isEmpty {
                return "\(viewData.nationality) • \(dateOfBirthText)"
            }
            return viewData.nationality
        }
    }
}

#Preview("Driver Header Light") {
    F1UI.Driver.Header(
        .init(
            displayName: "Max Verstappen",
            nationality: "Dutch",
            dateOfBirthText: "1997-09-30",
            wikipediaURL: URL(string: "https://en.wikipedia.org/wiki/Max_Verstappen"),
            flagEmoji: nil
        )
    )
    .padding()
    .background(F1Theme.Colors.background)
    .preferredColorScheme(.light)
}

#Preview("Driver Header Dark") {
    F1UI.Driver.Header(
        .init(
            displayName: "Max Verstappen",
            nationality: "Dutch",
            dateOfBirthText: "1997-09-30",
            wikipediaURL: URL(string: "https://en.wikipedia.org/wiki/Max_Verstappen"),
            flagEmoji: nil
        )
    )
    .padding()
    .background(F1Theme.Colors.background)
    .preferredColorScheme(.dark)
}
