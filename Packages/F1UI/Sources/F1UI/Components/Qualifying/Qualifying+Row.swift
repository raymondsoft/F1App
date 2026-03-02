import SwiftUI

public extension F1UI.Qualifying {
    struct Row: View {
        public struct ViewData: Hashable, Sendable {
            public let id: String
            public let positionText: String
            public let driverName: String
            public let constructorName: String
            public let q1Text: String?
            public let q2Text: String?
            public let q3Text: String?

            public init(
                id: String,
                positionText: String,
                driverName: String,
                constructorName: String,
                q1Text: String?,
                q2Text: String?,
                q3Text: String?
            ) {
                self.id = id
                self.positionText = positionText
                self.driverName = driverName
                self.constructorName = constructorName
                self.q1Text = q1Text
                self.q2Text = q2Text
                self.q3Text = q3Text
            }
        }

        private let viewData: ViewData

        public init(_ viewData: ViewData) {
            self.viewData = viewData
        }

        public var body: some View {
            HStack(alignment: .top, spacing: 12) {
                Text(viewData.positionText)
                    .font(.headline)
                    .frame(minWidth: 28, alignment: .leading)

                VStack(alignment: .leading, spacing: 4) {
                    Text(viewData.driverName)
                        .font(.headline)

                    Text(viewData.constructorName)
                        .font(.subheadline)
                        .foregroundStyle(.secondary)

                    HStack(spacing: 12) {
                        lapText(label: "Q1", value: viewData.q1Text)
                        lapText(label: "Q2", value: viewData.q2Text)
                        lapText(label: "Q3", value: viewData.q3Text)
                    }
                    .font(.caption)
                    .foregroundStyle(.secondary)
                }

                Spacer(minLength: 0)
            }
            .padding(.vertical, 4)
        }

        private func lapText(label: String, value: String?) -> some View {
            Text("\(label) \(value ?? "-")")
        }
    }
}

#Preview("Qualifying Row") {
    F1UI.Qualifying.Row(
        .init(
            id: "2024-1-1",
            positionText: "1",
            driverName: "Max Verstappen",
            constructorName: "Red Bull Racing",
            q1Text: "1:29.421",
            q2Text: "1:29.374",
            q3Text: "1:29.179"
        )
    )
    .padding()
}
