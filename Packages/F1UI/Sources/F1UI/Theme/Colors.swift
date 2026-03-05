import SwiftUI
#if canImport(UIKit)
import UIKit
#elseif canImport(AppKit)
import AppKit
#endif

public extension F1Theme {
    enum Colors {
        public static let background: Color = {
            #if canImport(UIKit)
            Color(uiColor: .systemGroupedBackground)
            #elseif canImport(AppKit)
            Color(nsColor: .windowBackgroundColor)
            #else
            Color(red: 0.96, green: 0.97, blue: 0.98)
            #endif
        }()

        public static let groupedBackground: Color = {
            #if canImport(UIKit)
            Color(uiColor: .secondarySystemGroupedBackground)
            #elseif canImport(AppKit)
            Color(nsColor: .underPageBackgroundColor)
            #else
            Color.white
            #endif
        }()

        public static let separator: Color = {
            #if canImport(UIKit)
            Color(uiColor: .separator)
            #elseif canImport(AppKit)
            Color(nsColor: .separatorColor)
            #else
            Color.gray.opacity(0.2)
            #endif
        }()

        public static let textPrimary = Color.primary
        public static let textSecondary = Color.secondary
        public static let textOnAccent = Color.white

        public static let f1Red = Color(red: 0.88, green: 0.07, blue: 0.19)
        public static let polePurple = Color(red: 0.42, green: 0.25, blue: 0.73)
        public static let fastestLapCyan = Color(red: 0.00, green: 0.67, blue: 0.80)
        public static let victoryGold = Color(red: 0.80, green: 0.63, blue: 0.17)

        public static func teamColor(for token: TeamStyleToken) -> Color {
            switch token {
            case .ferrari:
                return Color(red: 0.86, green: 0.07, blue: 0.11)
            case .mercedes:
                return Color(red: 0.10, green: 0.74, blue: 0.64)
            case .redBull:
                return Color(red: 0.05, green: 0.18, blue: 0.58)
            case .mclaren:
                return Color(red: 0.93, green: 0.38, blue: 0.12)
            case .astonMartin:
                return Color(red: 0.00, green: 0.36, blue: 0.31)
            case .alpine:
                return Color(red: 0.16, green: 0.39, blue: 0.85)
            case .williams:
                return Color(red: 0.00, green: 0.38, blue: 0.83)
            case .haas:
                return Color(red: 0.54, green: 0.57, blue: 0.62)
            case .rb:
                return Color(red: 0.22, green: 0.28, blue: 0.74)
            case .sauber:
                return Color(red: 0.26, green: 0.68, blue: 0.21)
            }
        }
    }
}
