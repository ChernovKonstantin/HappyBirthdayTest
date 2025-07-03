import Foundation
import UIKit

extension RootView {
    final class RootViewModel: ObservableObject {
        
        private var persistanceService: PersistenceService
        
        @Published var name: String = ""
        @Published var birthday: Date = Date()
        @Published var photo: UIImage?
        
        init(persistanceService: PersistenceService) {
            self.persistanceService = persistanceService
        }
        
    }
}
