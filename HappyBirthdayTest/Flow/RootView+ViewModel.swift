import Foundation
import SwiftUI
import UIKit
import Combine

extension RootView {
    final class ViewModel: ObservableObject {
        
        private var persistanceService: PersistenceService
        private var cancelBag = Set<AnyCancellable>()
        
        @Published var name: String = ""
        @Published var birthday: Date? = nil
        @Published var birthdaySelector: Date = Date()
        @Published var photo: UIImage? = nil
        @Published var canShowBirthdayScreen = false
        @Published var showBirthdayScreen = false
        
        var birthdayBinding: Binding<Date> {
            Binding<Date>(
                get: { [weak self] in self?.birthday ?? Date() },
                set: { [weak self] in self?.birthday = $0 }
            )
        }
        
        init(persistanceService: PersistenceService) {
            self.persistanceService = persistanceService
            loadBaby()
            setupBindings()
        }
        
        private func setupBindings() {
            Publishers.CombineLatest($name, $birthday)
                .drop(while: { $0.isEmpty || $1 == nil })
                .map { !$0.isEmpty && $1 != nil }
                .sink { [weak self] in self?.canShowBirthdayScreen = $0 }
                .store(in: &cancelBag)
            
            $showBirthdayScreen
                .dropFirst()
                .filter { $0 }
                .sink { [weak self] _ in self?.saveBaby() }
                .store(in: &cancelBag)
        }
        
        func saveBaby() {
            guard !name.isEmpty, let birthday else { return }
            let baby = BabyData(name: name, birthday: birthday, image: photo)
            do {
                try persistanceService.saveBaby(baby)
            } catch {
                print("Error saving baby: \(error)")
            }
        }
        
        func presentBirthdayScreen() -> some View {
            guard !name.isEmpty, let birthday else {
                return EmptyView()
            }
            let screenType = ScreenType.allCases.randomElement() ?? .fox
            let viewModel = BirthdayView.ViewModel(
                persistanceService: self.persistanceService,
                screenType: screenType,
                name: self.name,
                birthday: birthday,
                photo: self.photo
            )
            return BirthdayView(viewModel: viewModel)
        }
        
        func loadBaby() {
            do {
                let baby = try persistanceService.getBaby()
                self.name = baby.name
                self.birthday = baby.birthday
                self.photo = baby.image
            } catch {
                print("No saved data: \(error)")
            }
        }
    }
}
