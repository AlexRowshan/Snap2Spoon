import UIKit

struct Photo: Identifiable {
    let id = UUID()
    let image: UIImage
    let timestamp: Date
    
    init(image: UIImage, timestamp: Date = Date()) {
        self.image = image
        self.timestamp = timestamp
    }
}
