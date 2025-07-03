import Foundation
import UIKit


final class PersistenceServiceImpl: PersistenceService {
    
    private let babyFileName = "baby.json"
    private let imageFileName = "baby_image.jpg"
    
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
        // Save image
        guard let imageData = baby.image.jpegData(compressionQuality: 0.9) else {
            throw NSError(domain: "ImageEncoding", code: 0, userInfo: [NSLocalizedDescriptionKey: "Could not encode image"])
        }
        try imageData.write(to: imageURL)
        
        // Save JSON
        let codableBaby = Baby(name: baby.name, birthday: baby.birthday, imageFileName: imageFileName)
        let data = try JSONEncoder().encode(codableBaby)
        try data.write(to: babyJSONURL)
    }
    
    func getBaby() throws -> BabyData {
        let data = try Data(contentsOf: babyJSONURL)
        let baby = try JSONDecoder().decode(Baby.self, from: data)
        
        let imageData = try Data(contentsOf: documentsURL.appendingPathComponent(baby.imageFileName))
        guard let image = UIImage(data: imageData) else {
            throw NSError(domain: "ImageDecoding", code: 0, userInfo: [NSLocalizedDescriptionKey: "Could not decode image"])
        }
        
        return BabyData(name: baby.name, birthday: baby.birthday, image: image)
    }
    
    func deleteBaby() throws {
        try? FileManager.default.removeItem(at: babyJSONURL)
        try? FileManager.default.removeItem(at: imageURL)
    }
}
