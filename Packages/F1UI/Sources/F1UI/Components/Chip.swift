import SwiftUI

public extension F1UI {
    struct Chip: View {
        @State private var isVisible = false

        public enum Style: Hashable, Sendable {
            case neutral
            case time
            case status
        }

        public struct ViewData: Hashable, Sendable {
            public let text: String
            public let style: Style

            public init(text: String, style: Style = .neutral) {
                self.text = text
                self.style = style
            }
        }

        private let viewData: ViewData

        public init(_ viewData: ViewData) {
            self.viewData = viewData
        }

        public var body: some View {
            Text(viewData.text)
                .font(F1Theme.Typography.timing)
                .foregroundStyle(foregroundColor)
                .padding(.horizontal, F1Theme.Spacing.s)
                .padding(.vertical, F1Theme.Spacing.xs)
                .background(backgroundColor)
                .clipShape(RoundedRectangle(cornerRadius: F1Theme.Shapes.chipCornerRadius, style: .continuous))
                .opacity(isVisible ? 1 : 0.92)
                .scaleEffect(isVisible ? 1 : 0.98)
                .onAppear {
                    withAnimation(F1Theme.Motion.easeInOutStandard) {
                        isVisible = true
                    }
                }
                .animation(F1Theme.Motion.easeInOutStandard, value: viewData.style)
        }

        private var foregroundColor: Color {
            switch viewData.style {
            case .neutral:
                return F1Theme.Colors.textSecondary
            case .time:
                return F1Theme.Colors.fastestLapCyan
            case .status:
                return F1Theme.Colors.f1Red
            }
        }

        private var backgroundColor: Color {
            switch viewData.style {
            case .neutral:
                return F1Theme.Colors.separator.opacity(0.4)
            case .time:
                return F1Theme.Colors.fastestLapCyan.opacity(0.12)
            case .status:
                return F1Theme.Colors.f1Red.opacity(0.10)
            }
        }
    }
}

#Preview("Chip Styles Light") {
    HStack(spacing: F1Theme.Spacing.s) {
        F1UI.Chip(.init(text: "1:31:44.742", style: .time))
        F1UI.Chip(.init(text: "DNF", style: .status))
        F1UI.Chip(.init(text: "Round 18", style: .neutral))
    }
    .padding()
    .preferredColorScheme(.light)
}

#Preview("Chip Styles Dark") {
    HStack(spacing: F1Theme.Spacing.s) {
        F1UI.Chip(.init(text: "1:31:44.742", style: .time))
        F1UI.Chip(.init(text: "DNF", style: .status))
        F1UI.Chip(.init(text: "Round 18", style: .neutral))
    }
    .padding()
    .background(F1Theme.Colors.background)
    .preferredColorScheme(.dark)
}
