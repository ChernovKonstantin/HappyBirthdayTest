import SwiftUI

struct RootView: View {
    
    @ObservedObject var viewModel: ViewModel
    
    var body: some View {
        NavigationView {
            containerView
        }
    }
    
    private var containerView: some View {
        VStack(alignment: .leading, spacing: 20) {
            
            header
            
            nameContainer
            
            birthdayContainer
            
            photoContainer
            
            presentationButton
            
            Spacer()
        }
        .padding(.top)
        .padding(.horizontal)
        .fullScreenCover(isPresented: $viewModel.showBirthdayScreen) {
            viewModel.presentBirthdayScreen()
                .onDisappear{
                    viewModel.loadBaby()
                }
        }
    }
    
    private var header: some View {
        Text("Details screen")
            .font(.largeTitle)
            .bold()
    }
    
    private var nameContainer: some View {
        TextField("Name", text: $viewModel.name)
            .textFieldStyle(.roundedBorder)
    }
    
    private var photoContainer: some View {
        HStack {
            Text(viewModel.photo == nil ? "No photo" : "Photo selected")
            Spacer()
            ImagePicker(image: $viewModel.photo)
        }
    }
    
    private var presentationButton: some View {
        Button("Show birthday screen") {
            viewModel.showBirthdayScreen = true
        }
        .disabled(!viewModel.canShowBirthdayScreen)
        .buttonStyle(.borderedProminent)
        .padding(.top)
    }
    
    @ViewBuilder private var birthdayContainer: some View {
        if let _ = viewModel.birthday {
            DatePicker("Birthday", selection: viewModel.birthdayBinding, displayedComponents: .date)
        } else {
            Button("Select birthday") {
                viewModel.birthday = Date()
            }
            .foregroundColor(.blue)
        }
    }
}

#Preview {
    RootView(viewModel: RootView.ViewModel(persistanceService: PersistenceServiceImpl()))
}
