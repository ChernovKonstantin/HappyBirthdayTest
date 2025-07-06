import SwiftUI
import PhotosUI

struct ImagePicker: View {
    @Binding var image: UIImage?
    @State private var showCamera = false
    @State private var showGallery = false
    @State private var showPickerDialog = false
    
    var screenType: ScreenType = .pelican

    var body: some View {
        VStack(spacing: 20) {
            Button(
                action: {
                    showPickerDialog = true
                }, label: {
                    screenType.cameraIcon
                }
            )
        }
        .confirmationDialog("Choose how you want to add a photo", isPresented: $showPickerDialog, titleVisibility: .visible) {
            if UIImagePickerController.isSourceTypeAvailable(.camera) {
                Button("Camera") {
                    showCamera = true
                }
            }
            Button("Gallery") {
                showGallery = true
            }
            Button("Cancel", role: .cancel) { }
        }
        .sheet(isPresented: $showCamera) {
            CameraImagePicker(image: $image)
                .ignoresSafeArea(.all, edges: .bottom)
        }
        .sheet(isPresented: $showGallery) {
            PhotoPicker(image: $image)
                .ignoresSafeArea(.all, edges: .bottom)
        }
    }
}
