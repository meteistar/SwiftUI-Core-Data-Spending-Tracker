//
//  UIImage+Resize.swift
//  SwiftUICoreDataSpendingTracker
//
//  Created by Mete İstar on 17.12.2025.
//

import UIKit

extension UIImage {
    func resized(to newSize: CGSize) -> UIImage {
        return UIGraphicsImageRenderer(size: newSize).image { _ in
            let hScale = newSize.height / size.height
            let vScale = newSize.width / size.width
            let scale = min(hScale, vScale)
            let resizeSize = CGSize(
                width: size.width * scale,
                height: size.height * scale
            )

            var middle = CGPoint.zero
            if resizeSize.width > newSize.width {
                middle.x -= (resizeSize.width - newSize.width) / 2.0
            }
            if resizeSize.height > newSize.height {
                middle.y -= (resizeSize.height - newSize.height) / 2.0
            }

            draw(in: CGRect(origin: middle, size: resizeSize))
        }
    }
}

