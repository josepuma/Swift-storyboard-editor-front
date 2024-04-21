//
//  Utilities.swift
//  storyboard-editor-front
//
//  Created by José Puma on 20-04-24.
//

import Foundation
import SpriteKit


class Utilities{
    
    func generateTextureFromSprite(from sprite: Sprite) -> SKTexture{
        if let nsImage = generateImage(from: sprite.content, sprite: sprite) {
            if let texture = imageToTexture(image: nsImage) {
                // Now you can use this texture in your SpriteKit scene
                return texture
                // Add sprite to your scene or perform any other desired actions
            } else {
                print("Failed to convert NSImage to SKTexture")
                return SKTexture()
            }
        } else {
            print("Failed to generate NSImage")
            return SKTexture()
        }
    }
    
    
    func generateTextureFromText(from text: String) -> SKTexture{
        if let nsImage = generateImage(from: text) {
            if let texture = imageToTexture(image: nsImage) {
                // Now you can use this texture in your SpriteKit scene
                return texture
                // Add sprite to your scene or perform any other desired actions
            } else {
                print("Failed to convert NSImage to SKTexture")
                return SKTexture()
            }
        } else {
            print("Failed to generate NSImage")
            return SKTexture()
        }
    }
    
    private func imageToTexture(image: NSImage) -> SKTexture? {
        // Convert NSImage to CGImage
        guard let cgImage = image.cgImage(forProposedRect: nil, context: nil, hints: nil) else {
            return nil
        }
        
        // Create SKTexture from CGImage
        return SKTexture(cgImage: cgImage)
    }

    
    func saveTextureFromString(from text: String){
        let filePath = "/Users/josepuma/Documents/Swtoard/Freda - Maybe/sb/lyrics/image.png" // Specify your file path
        if let nsImage = generateImage(from: text) {
            if saveImage(image: nsImage, filePath: filePath) {
                print("Image saved successfully at \(filePath)")
            } else {
                print("Failed to save image")
            }
        } else {
            print("Failed to generate NSImage")
        }
    }

    private func generateImage(from text: String, sprite: Sprite? = nil) -> NSImage? {
        // Define text attributes
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = .center
        
        // Define shadow attributes
        let shadow = NSShadow()
        shadow.shadowColor = sprite?.textTextureShadowColor
        shadow.shadowBlurRadius = sprite?.shadowBlurRadius ?? CGFloat(0)
        shadow.shadowOffset = CGSize(width: sprite?.shadowOffsetX ?? CGFloat(0), height: sprite?.shadowOffsetY ?? CGFloat(0))
        
        let font = NSFont(name: sprite!.fontName ?? "", size: 72)
        
        let attributes: [NSAttributedString.Key: Any] = [
            .font: font ?? NSFont.systemFont(ofSize: 72),
            .paragraphStyle: paragraphStyle,
            .foregroundColor: sprite?.textTextureColor ?? NSColor.white,
            .shadow: shadow
        ]

        // Calculate text bounding rect
        let textSize = text.size(withAttributes: attributes)
        let imageSize = CGSize(width: textSize.width + 10 + shadow.shadowBlurRadius,
                                   height: textSize.height + 10 + shadow.shadowBlurRadius)
        
        // Create image context
        let image = NSImage(size: imageSize)
        image.lockFocus()
        
        // Fill the background with white color
        NSColor.clear.setFill()
        NSBezierPath(rect: NSRect(origin: .zero, size: imageSize)).fill()
        
        // Draw text in the center of the image
        let textRect = NSRect(x: (imageSize.width - textSize.width) / 2,
                              y: (imageSize.height - textSize.height) / 2,
                              width: textSize.width,
                              height: textSize.height)
        text.draw(in: textRect, withAttributes: attributes)
        
        image.unlockFocus()
        
        return image
    }
    
    func saveImage(image: NSImage, filePath: String) -> Bool {
        guard let imageData = image.tiffRepresentation,
              let bitmap = NSBitmapImageRep(data: imageData),
              let pngData = bitmap.representation(using: .png, properties: [:]) else {
            return false
        }
        
        do {
            try pngData.write(to: URL(fileURLWithPath: filePath))
            return true
        } catch {
            print("Error saving image: \(error.localizedDescription)")
            return false
        }
    }

}
