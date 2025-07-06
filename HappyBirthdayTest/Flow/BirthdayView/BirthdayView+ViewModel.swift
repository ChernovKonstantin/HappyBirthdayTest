import Foundation
import Combine
import SwiftUI
import UIKit

extension BirthdayView {
    final class ViewModel: ObservableObject {
        
        @Published var photo: UIImage?
        @Published var photoContainerPosition: CGPoint = .zero
        @Published var photoContainerSize: CGFloat = 0
        @Published var monthPosition: CGPoint = .zero
        @Published var imagePickerPosition: CGPoint = .zero
        
        private(set) var screenType: ScreenType
        private var monthsFrame: CGRect = .zero
        private var persistanceService: PersistenceService
        private var cancelBag = Set<AnyCancellable>()
        
        var name: String
        var birthday: Date
        
        init(persistanceService: PersistenceService, screenType: ScreenType, name: String, birthday: Date, photo: UIImage?) {
            self.persistanceService = persistanceService
            self.screenType = screenType
            self.name = name
            self.birthday = birthday
            self.photo = photo
                
            setupBinding()
        }
        
        func getTimeQuantity() -> (TimeQuantity, String) {
            let monthsQuantity = Calendar.current.dateComponents([.month], from: birthday, to: Date()).month ?? 0
            if monthsQuantity > 12 {
                let yearsQuantity = Calendar.current.dateComponents([.year], from: birthday, to: Date()).year ?? 0
                let string = yearsQuantity == 1 ? "YEAR OLD!" : "YEARS OLD!"
                return (TimeQuantity(int: yearsQuantity), string)
            }
            let string = monthsQuantity == 1 ? "MONTH OLD!" : "MONTHS OLD!"
            return (TimeQuantity(int: monthsQuantity), string)
        }
        
        func setupBinding() {
            $photo
                .dropFirst()
                .sink { [weak self] newPhoto in
                    self?.updatePhoto(newPhoto)
                }
                .store(in: &cancelBag)
        }
        
        func updateMonthFrame(_ frame: CGRect) {
            self.monthsFrame = frame
            recalculateViewsPosition()
        }
        
        @MainActor
        func renderShareableUIImage(content: some View) -> UIImage? {
            let renderer = ImageRenderer(
                content: content
                    .frame(width: UIScreen.currentSize?.width, height: UIScreen.currentSize?.height)
            )
            return renderer.uiImage
        }
        
        private func updatePhoto(_ photo: UIImage?) {
            let baby = BabyData(name: name, birthday: birthday, image: photo)
            do {
                try persistanceService.saveBaby(baby)
            } catch {
                print("Error saving baby: \(error)")
            }
        }
        
        private func recalculateViewsPosition() {
            guard let viewSize = UIScreen.currentSize else { return }
            let statusBarHeight = UIScreen.statusBarHeight ?? 0
            let visibleHeight = viewSize.height - statusBarHeight
            let visibleWidth = viewSize.width
            let screenWidthCenter = visibleWidth / 2
            let screenHeightCenter = visibleHeight / 2
            
            let minTopPaddings: CGFloat = 35
            let topLimit: CGFloat = 20
            let space = (visibleHeight / 2) - (photoContainerSize / 2) - monthsFrame.height

            let monthCenterY: CGFloat
            if space > minTopPaddings {
                monthCenterY = ((visibleHeight / 2) - (photoContainerSize / 2)) / 2
            } else {
                monthCenterY = topLimit + (monthsFrame.height / 2)
            }
            
            self.photoContainerPosition = CGPoint(x: screenWidthCenter, y: screenHeightCenter)
            var photoContainerSize = (((visibleHeight / 2) - minTopPaddings - (monthsFrame.height)) * 2)
            if photoContainerSize + 100 > visibleWidth {
                photoContainerSize = visibleWidth - 100
            }
            self.photoContainerSize = photoContainerSize
            self.monthPosition = CGPoint(
                x: screenWidthCenter,
                y: monthCenterY
            )
            
            recalculateImagePickerPosition(with: photoContainerSize/2)
        }
        
        private func recalculateImagePickerPosition(with radius: CGFloat) {
            let angle = Double.pi / 4
            self.imagePickerPosition = CGPoint(
                x: radius + radius * CGFloat(sin(angle)) - 3,
                y: radius - radius * CGFloat(cos(angle)) + 3
            )
        }
    }
}
