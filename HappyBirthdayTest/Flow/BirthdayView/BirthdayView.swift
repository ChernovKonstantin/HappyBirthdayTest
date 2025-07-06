import SwiftUI

struct BirthdayView: View {
    
    @Environment(\.dismiss) var dismiss
    
    @ObservedObject var viewModel: ViewModel
    
    @State private var shareImage: UIImage?
    @State private var showShareSheet = false
    
    var body: some View {
        containerView()
    }
    
    private func containerView(toShare: Bool = false) -> some View {
        ZStack {
            background
            
            photoContainer(toShare: toShare)
                .position(viewModel.photoContainerPosition)
            monthsContainer
                .position(viewModel.monthPosition)
            
            if !toShare {
                buttonsContainer
            }
        }
    }
    
    private var monthsContainer: some View {
let ttt = viewModel.getTimeQuantity()
        return VStack(spacing: 0) {
            Text("TODAY " + viewModel.name.uppercased() + " IS")
                .multilineTextAlignment(.center)
                .lineLimit(2)
            HStack(spacing: 22) {
                Image(.iconLeftSwirls)
                HStack(spacing: 0) {
                    viewModel.getTimeQuantity().0.getIcon()
                }
                Image(.iconRightSwirls)
            }
            .padding(.top, 13)
            
            Text(ttt.1)
                .padding(.top, 14)
        }
        .padding(.horizontal, 24)
        .overlay {
            if !showShareSheet {
                Color.clear
                    .onGeometryChange(for: CGRect.self, of: { $0.frame(in: .global) }) { rect in
                        
                        viewModel.updateMonthFrame(rect)
                    }
            }
        }
    }
    
    private var buttonsContainer: some View {
        VStack {
            HStack {
                closeButton
                Spacer()
                shareButton
            }
            .padding(.horizontal, 8)
            Spacer()
        }
    }
    
    private func photoContainer(toShare: Bool = false) -> some View {
        VStack(spacing: 0) {
            let circleSize = viewModel.photoContainerSize - 35
            ZStack(alignment: .center) {
                viewModel.screenType.babyIcon
                    .resizable()
                    .frame(width: max(0, circleSize), height: max(0, circleSize))
                    .aspectRatio(contentMode: .fit)
                
                if let photo = viewModel.photo, circleSize > 0 {
                    Image(uiImage: photo)
                        .resizable()
                        .scaledToFill()
                        .frame(width: circleSize-16, height: circleSize-16)
                        .clipShape(Circle())
                }
                if !toShare {
                    ImagePicker(image: $viewModel.photo, screenType: viewModel.screenType)
                        .frame(width: 36, height: 36)
                        .position(viewModel.imagePickerPosition)
                }
            }
            
            Image(.iconNanit)
                .resizable()
                .frame(width: 60, height: 20)
                .padding(.top, 15)
        }
        .frame(width: viewModel.photoContainerSize, height: viewModel.photoContainerSize)
    }
    
    private var shareButton: some View {
        Button {
            if let rendered = viewModel.renderShareableUIImage(content: containerView(toShare: true)) {
                shareImage = rendered
                showShareSheet = true
            }
        } label: {
            Image(systemName: "square.and.arrow.up")
                .foregroundStyle(Color.gray)
        }
        .sheet(isPresented: $showShareSheet) {
            if let shareImage {
                ActivityView(activityItems: [shareImage])
            }
        }
    }
    
    @ViewBuilder private var background: some View {
        Color(viewModel.screenType.backgroundColor)
            .ignoresSafeArea()
        
        VStack {
            Spacer()
            viewModel.screenType.backgroundImage
                .resizable()
                .scaledToFit()
        }
        .ignoresSafeArea()
    }
    
    @ViewBuilder private var closeButton: some View {
        Button {
            dismiss()
        } label: {
            Image(systemName: "xmark")
                .foregroundStyle(Color.gray)
        }
    }
}

#Preview {
    BirthdayView(viewModel: BirthdayView.ViewModel(persistanceService: PersistenceServiceImpl(), screenType: .elephant, name: "Tom something something something something ", birthday: Date(), photo: UIImage()))
}
