import SwiftUI

enum ScreenType: CaseIterable {
    case fox
    case elephant
    case pelican
    
    var backgroundColor: Color {
        switch self {
        case .fox: .foxGreen
        case .elephant: .elephantYellow
        case .pelican: .pelicanBlue
        }
    }
    
    var backgroundImage: Image {
        switch self {
        case .fox: Image(.iconFox)
        case .elephant: Image(.iconElephant)
        case .pelican: Image(.iconPelican)
        }
    }
    
    var babyIcon: Image {
        switch self {
        case .fox: Image(.iconBabyGreen)
        case .elephant: Image(.iconBabyYellow)
        case .pelican: Image(.iconBabyBlue)
        }
    }
    
    var cameraIcon: Image {
        switch self {
        case .fox: Image(.iconCameraGreen)
        case .elephant: Image(.iconCameraYellow)
        case .pelican: Image(.iconCameraBlue)
        }
    }
}
