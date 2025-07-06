import Foundation
import UIKit


final class PersistenceServiceImpl: PersistenceService {
    
    private let babyFileName = "baby2.json"
    private let imageFileName = "baby_image2.jpg"
    
    private var documentsURL: URL {
        FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
    }
    
    private var babyJSONURL: URL {
        documentsURL.appendingPathComponent(babyFileName)
    }
    
    private var imageURL: URL {
        documentsURL.appendingPathComponent(imageFileName)
    }
    
    func saveBaby(_ baby: BabyData) throws {
        let imageData = baby.image?.jpegData(compressionQuality: 0.9)
        if let imageData {
            try imageData.write(to: imageURL)
        }
        
        let codableBaby = Baby(name: baby.name, birthday: baby.birthday, imageFileName: imageData == nil ? "" : imageFileName)
        let data = try JSONEncoder().encode(codableBaby)
        try data.write(to: babyJSONURL)
    }
    
    func getBaby() throws -> BabyData {
        let data = try Data(contentsOf: babyJSONURL)
        let baby = try JSONDecoder().decode(Baby.self, from: data)
        var image: UIImage? = nil
        if !baby.imageFileName.isEmpty {
            let imageData = try Data(contentsOf: documentsURL.appendingPathComponent(baby.imageFileName))
            image = UIImage(data: imageData)
        }
        return BabyData(name: baby.name, birthday: baby.birthday, image: image)
    }
    
    func deleteBaby() throws {
        try? FileManager.default.removeItem(at: babyJSONURL)
        try? FileManager.default.removeItem(at: imageURL)
    }
}
