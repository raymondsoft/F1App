import SwiftUI

public extension F1UI.Result {
    struct Row: View {
        public struct ViewData: Hashable, Sendable {
            public let id: String
            public let positionText: String
            public let driverName: String
            public let constructorName: String
            public let pointsText: String
            public let resultText: String

            public init(
                id: String,
                positionText: String,
                driverName: String,
                constructorName: String,
                pointsText: String,
                resultText: String
            ) {
                self.id = id
                self.positionText = positionText
                self.driverName = driverName
                self.constructorName = constructorName
                self.pointsText = pointsText
                self.resultText = resultText
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

                VStack(alignment: .leading, spacing: 2) {
                    Text(viewData.driverName)
                        .font(.headline)

                    Text(viewData.constructorName)
                        .font(.subheadline)
                        .foregroundStyle(.secondary)

                    Text(viewData.resultText)
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }

                Spacer(minLength: 0)

                Text(viewData.pointsText)
                    .font(.subheadline.weight(.semibold))
            }
            .padding(.vertical, 4)
        }
    }
}

#Preview("Result Row") {
    F1UI.Result.Row(
        .init(
            id: "2024-1-1",
            positionText: "1",
            driverName: "Max Verstappen",
            constructorName: "Red Bull Racing",
            pointsText: "25 pts",
            resultText: "1:31:44.742"
        )
    )
    .padding()
}
