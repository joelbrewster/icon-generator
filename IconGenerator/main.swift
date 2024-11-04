import AppKit

func generateAppIcon() {
    let sizes = [8, 16, 32, 64, 128, 256, 512, 1024]
    
    for size in sizes {
        let image = NSImage(size: NSSize(width: size, height: size))
        image.lockFocus()
        
        // Calculate scaled size and padding
        let scale: CGFloat = 0.8  // Further reduce the scale
        let iconSize = CGFloat(size) * scale
        let padding = (CGFloat(size) - iconSize) / 2
        
        // Fill white background with rounded corners
        NSColor.white.set()
        let backgroundPath = NSBezierPath(roundedRect: NSRect(x: padding, y: padding, width: iconSize, height: iconSize),
                                          xRadius: iconSize * 0.2,
                                          yRadius: iconSize * 0.2)
        backgroundPath.fill()
        
        // Draw black circle
        let innerPadding = iconSize * 0.2
        let circlePath = NSBezierPath(ovalIn: NSRect(x: padding + innerPadding,
                                                     y: padding + innerPadding,
                                                     width: iconSize - (innerPadding * 2),
                                                     height: iconSize - (innerPadding * 2)))
        NSColor.black.withAlphaComponent(0.3).setStroke()
        circlePath.lineWidth = iconSize * 0.06
        circlePath.lineCapStyle = .round
        circlePath.stroke()
        
        image.unlockFocus()
        
        // Save the image
        if let tiffData = image.tiffRepresentation,
           let bitmapImage = NSBitmapImageRep(data: tiffData),
           let pngData = bitmapImage.representation(using: .png, properties: [:]) {
            let desktopURL = FileManager.default.urls(for: .desktopDirectory, in: .userDomainMask).first!
            let fileURL = desktopURL.appendingPathComponent("appicon_\(size).png")
            try? pngData.write(to: fileURL)
        }
    }
}

generateAppIcon()
