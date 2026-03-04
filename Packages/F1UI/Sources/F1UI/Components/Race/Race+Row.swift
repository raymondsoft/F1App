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
            F1UI.RowContainer {
                Image(systemName: "flag.checkered")
                    .font(F1Theme.Typography.meta)
                    .foregroundStyle(F1Theme.Colors.f1Red)
            } content: {
                VStack(alignment: .leading, spacing: F1Theme.Spacing.xs) {
                    Text(viewData.title)
                        .font(F1Theme.Typography.rowTitle)
                        .foregroundStyle(F1Theme.Colors.textPrimary)

                    Text("\(viewData.circuit.locality), \(viewData.circuit.country)")
                        .font(F1Theme.Typography.rowSubtitle)
                        .foregroundStyle(F1Theme.Colors.textSecondary)
                }
            } trailing: {
                VStack(alignment: .trailing, spacing: F1Theme.Spacing.xs) {
                    F1UI.Chip(.init(text: viewData.roundText, style: .neutral))
                    F1UI.Chip(.init(text: timingText, style: viewData.timeText == nil ? .neutral : .time))
                }
            }
        }

        private var timingText: String {
            if let timeText = viewData.timeText { return "\(viewData.dateText) \(timeText)" }
            return viewData.dateText
        }
    }
}

#Preview("Race Row With Time Light") {
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
    .background(F1Theme.Colors.background)
    .preferredColorScheme(.light)
}

#Preview("Race Row With Time Dark") {
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
    .background(F1Theme.Colors.background)
    .preferredColorScheme(.dark)
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
