import SwiftUI

public extension F1Theme {
    enum Motion {
        public static let snappy = Animation.spring(response: 0.28, dampingFraction: 0.82)
        public static let easeInOutFast = Animation.easeInOut(duration: 0.18)
        public static let easeInOutStandard = Animation.easeInOut(duration: 0.30)
    }
}
