import SwiftUI

@main
struct HappyBirthdayTestApp: App {
    
    private var rootViewModel: RootView.RootViewModel
    
    init() {
        let persistenceService = PersistenceServiceImpl()
        rootViewModel = .init(persistanceService: persistenceService)
    }

    var body: some Scene {
        WindowGroup {
            RootView(viewModel: rootViewModel)
        }
    }
}
