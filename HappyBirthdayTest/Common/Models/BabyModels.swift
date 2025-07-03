import Foundation
import UIKit

struct Baby: Codable {
    var name: String
    var birthday: Date
    var imageFileName: String
}

struct BabyData {
    let name: String
    let birthday: Date
    let image: UIImage
}
