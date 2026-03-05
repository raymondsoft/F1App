import SwiftUI

public extension F1UI.Driver {
    struct SeasonSelector: View {
        public struct ViewData: Hashable, Sendable {
            public struct SeasonOption: Hashable, Sendable {
                public let id: String
                public let title: String

                public init(id: String, title: String) {
                    self.id = id
                    self.title = title
                }
            }

            public let seasons: [SeasonOption]
            public let selectedSeasonId: String

            public init(seasons: [SeasonOption], selectedSeasonId: String) {
                self.seasons = seasons
                self.selectedSeasonId = selectedSeasonId
            }
        }

        private let viewData: ViewData
        private let selectedSeasonId: Binding<String>

        public init(_ viewData: ViewData, selectedSeasonId: Binding<String>) {
            self.viewData = viewData
            self.selectedSeasonId = selectedSeasonId
        }

        public var body: some View {
            VStack(alignment: .leading, spacing: F1Theme.Spacing.s) {
                F1UI.SectionHeader(.init(title: "Season", trailingText: selectedSeasonId.wrappedValue))

                Picker("Season", selection: selectedSeasonId) {
                    ForEach(viewData.seasons, id: \.id) { season in
                        Text(season.title).tag(season.id)
                    }
                }
                .pickerStyle(.menu)
            }
        }
    }
}
