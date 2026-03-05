import SwiftUI

public extension F1UI {
    struct RowContainer<Leading: View, Content: View, Trailing: View>: View {
        private let leading: Leading
        private let content: Content
        private let trailing: Trailing

        public init(
            @ViewBuilder leading: () -> Leading,
            @ViewBuilder content: () -> Content,
            @ViewBuilder trailing: () -> Trailing
        ) {
            self.leading = leading()
            self.content = content()
            self.trailing = trailing()
        }

        public var body: some View {
            HStack(alignment: .top, spacing: F1Theme.Spacing.m) {
                leading
                content
                Spacer(minLength: 0)
                trailing
            }
            .padding(.horizontal, F1Theme.Shapes.rowHorizontalPadding)
            .padding(.vertical, F1Theme.Shapes.rowVerticalPadding)
            .background(F1Theme.Colors.groupedBackground)
            .clipShape(RoundedRectangle(cornerRadius: F1Theme.Shapes.rowCornerRadius, style: .continuous))
            .overlay(
                RoundedRectangle(cornerRadius: F1Theme.Shapes.rowCornerRadius, style: .continuous)
                    .stroke(F1Theme.Colors.separator, lineWidth: 1)
            )
        }
    }
}

#Preview("Row Container Light") {
    F1UI.RowContainer {
        Image(systemName: "flag.checkered")
            .foregroundStyle(F1Theme.Colors.f1Red)
    } content: {
        VStack(alignment: .leading) {
            Text("Bahrain Grand Prix")
                .font(F1Theme.Typography.rowTitle)
            Text("Round 1 • 2024-03-02")
                .font(F1Theme.Typography.meta)
                .foregroundStyle(F1Theme.Colors.textSecondary)
        }
    } trailing: {
        Text("25 pts")
            .font(F1Theme.Typography.number)
    }
    .padding()
    .background(F1Theme.Colors.background)
    .preferredColorScheme(.light)
}

#Preview("Row Container Dark") {
    F1UI.RowContainer {
        Image(systemName: "flag.checkered")
            .foregroundStyle(F1Theme.Colors.f1Red)
    } content: {
        VStack(alignment: .leading) {
            Text("Bahrain Grand Prix")
                .font(F1Theme.Typography.rowTitle)
            Text("Round 1 • 2024-03-02")
                .font(F1Theme.Typography.meta)
                .foregroundStyle(F1Theme.Colors.textSecondary)
        }
    } trailing: {
        Text("25 pts")
            .font(F1Theme.Typography.number)
    }
    .padding()
    .background(F1Theme.Colors.background)
    .preferredColorScheme(.dark)
}
