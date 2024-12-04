//
//  Photo.swift
//  Snap2Spoon
//
//  Created by Cory DeWitt on 11/3/24.
//

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
