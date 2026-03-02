import SwiftUI

public extension F1UI.Standing {
    struct Row: View {
        public struct ViewData: Hashable, Sendable {
            public let id: String
            public let positionText: String
            public let title: String
            public let subtitle: String?
            public let pointsText: String
            public let winsText: String

            public init(
                id: String,
                positionText: String,
                title: String,
                subtitle: String?,
                pointsText: String,
                winsText: String
            ) {
                self.id = id
                self.positionText = positionText
                self.title = title
                self.subtitle = subtitle
                self.pointsText = pointsText
                self.winsText = winsText
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
                    Text(viewData.title)
                        .font(.headline)

                    if let subtitle = viewData.subtitle {
                        Text(subtitle)
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                    }
                }

                Spacer(minLength: 0)

                VStack(alignment: .trailing, spacing: 2) {
                    Text(viewData.pointsText)
                        .font(.subheadline.weight(.semibold))

                    Text(viewData.winsText)
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
            }
            .padding(.vertical, 4)
        }
    }
}

#Preview("Standing Row") {
    F1UI.Standing.Row(
        .init(
            id: "2024-max_verstappen",
            positionText: "1",
            title: "Max Verstappen",
            subtitle: "Red Bull Racing",
            pointsText: "575 pts",
            winsText: "9 wins"
        )
    )
    .padding()
}
