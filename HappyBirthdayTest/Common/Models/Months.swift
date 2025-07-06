import SwiftUI


enum TimeQuantity {
    case zero, one, two, three, four, five, six, seven, eight, nine, ten, eleven, twelve
    case custom(Int)
    
    init(int: Int) {
        if (0...12).contains(int) {
            self = [
                .zero, .one, .two, .three, .four, .five,
                .six, .seven, .eight, .nine, .ten, .eleven, .twelve
            ][int]
        } else if int >= 0 {
            self = .custom(int)
        } else {
            self = .zero
        }
    }
    
    func getIcon() -> some View {
        switch self {
        case .custom(let number):
            let digits = String(number).compactMap { Int(String($0)) }
            return HStack(spacing: 0) {
                ForEach(digits, id: \.self) { digit in
                    TimeQuantity(int: digit).getIcon()
                }
            }
        default:
            return Image("icon_\(rawValue)")
        }
    }
    
    private var rawValue: Int {
        switch self {
        case .zero: return 0
        case .one: return 1
        case .two: return 2
        case .three: return 3
        case .four: return 4
        case .five: return 5
        case .six: return 6
        case .seven: return 7
        case .eight: return 8
        case .nine: return 9
        case .ten: return 10
        case .eleven: return 11
        case .twelve: return 12
        case .custom(let int): return int
        }
    }
}
