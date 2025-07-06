import SwiftUI

enum TimeQuantity: Int {
    case zero
    case one
    case two
    case three
    case four
    case five
    case six
    case seven
    case eight
    case nine
    case ten
    case eleven
    case twelve
    
    func getIcon() -> Image {
        return Image("icon_" + "\(self.rawValue)")
    }
}
