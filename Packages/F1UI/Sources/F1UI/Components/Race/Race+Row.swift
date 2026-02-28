import SwiftUI

public extension F1UI.Race {
    struct Row: View {
        public struct ViewData: Hashable, Sendable {
            public let id: String
            public let roundText: String
            public let title: String
            public let dateText: String
            public let timeText: String?
            public let circuit: F1UI.Circuit.Row.ViewData

            public init(
                id: String,
                roundText: String,
                title: String,
                dateText: String,
                timeText: String?,
                circuit: F1UI.Circuit.Row.ViewData
            ) {
                self.id = id
                self.roundText = roundText
                self.title = title
                self.dateText = dateText
                self.timeText = timeText
                self.circuit = circuit
            }
        }

        private let viewData: ViewData

        public init(_ viewData: ViewData) {
            self.viewData = viewData
        }

        public var body: some View {
            VStack(alignment: .leading, spacing: 8) {
                Text(viewData.title)
                    .font(.headline)

                Text(metaText)
                    .font(.caption)
                    .foregroundStyle(.secondary)

                F1UI.Circuit.Row(viewData.circuit)
            }
            .padding(.vertical, 4)
        }

        private var metaText: String {
            if let timeText = viewData.timeText {
                "\(viewData.roundText) • \(viewData.dateText) • \(timeText)"
            } else {
                "\(viewData.roundText) • \(viewData.dateText)"
            }
        }
    }
}

#Preview("Race Row With Time") {
    F1UI.Race.Row(
        .init(
            id: "2024-1",
            roundText: "Round 1",
            title: "Bahrain Grand Prix",
            dateText: "2024-03-02",
            timeText: "15:00:00",
            circuit: .init(
                id: "bahrain",
                name: "Bahrain International Circuit",
                locality: "Sakhir",
                country: "Bahrain",
                showsWikipediaIndicator: true
            )
        )
    )
    .padding()
}

#Preview("Race Row Without Time") {
    F1UI.Race.Row(
        .init(
            id: "2024-2",
            roundText: "Round 2",
            title: "Saudi Arabian Grand Prix",
            dateText: "2024-03-09",
            timeText: nil,
            circuit: .init(
                id: "jeddah",
                name: "Jeddah Corniche Circuit",
                locality: "Jeddah",
                country: "Saudi Arabia",
                showsWikipediaIndicator: true
            )
        )
    )
    .padding()
}
