import SwiftUI

public extension F1Theme {
    enum Typography {
        public static let title = Font.title3.weight(.semibold)
        public static let section = Font.headline.weight(.semibold)
        public static let rowTitle = Font.body.weight(.semibold)
        public static let rowSubtitle = Font.subheadline
        public static let meta = Font.caption
        public static let number = Font.subheadline.monospacedDigit().weight(.semibold)
        public static let timing = Font.caption.monospacedDigit()
    }
}
