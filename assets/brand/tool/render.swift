// Rasterises an SVG with macOS CoreSVG (NSImage) into an sRGB PNG.
// usage: render <in.svg> <out.png> <width> <height> [opaque]
// `opaque` writes an RGB PNG without an alpha channel (iOS app icon rule).
import AppKit
import ImageIO
import UniformTypeIdentifiers

let a = CommandLine.arguments
guard a.count >= 5, let img = NSImage(contentsOfFile: a[1]),
      let w = Int(a[3]), let h = Int(a[4]) else {
  FileHandle.standardError.write("usage: render in.svg out.png w h [opaque]\n".data(using: .utf8)!)
  exit(2)
}
let opaque = a.count > 5 && a[5] == "opaque"
let space = CGColorSpace(name: CGColorSpace.sRGB)!
let info = opaque ? CGImageAlphaInfo.noneSkipLast.rawValue : CGImageAlphaInfo.premultipliedLast.rawValue
guard let ctx = CGContext(data: nil, width: w, height: h, bitsPerComponent: 8, bytesPerRow: 0,
                          space: space, bitmapInfo: info) else { exit(3) }
ctx.interpolationQuality = .high
if opaque {
  ctx.setFillColor(CGColor(srgbRed: 1, green: 1, blue: 1, alpha: 1))
  ctx.fill(CGRect(x: 0, y: 0, width: w, height: h))
}
NSGraphicsContext.saveGraphicsState()
NSGraphicsContext.current = NSGraphicsContext(cgContext: ctx, flipped: false)
img.draw(in: NSRect(x: 0, y: 0, width: w, height: h))
NSGraphicsContext.restoreGraphicsState()
guard let cg = ctx.makeImage(),
      let dest = CGImageDestinationCreateWithURL(URL(fileURLWithPath: a[2]) as CFURL,
                                                 UTType.png.identifier as CFString, 1, nil) else { exit(4) }
CGImageDestinationAddImage(dest, cg, nil)
exit(CGImageDestinationFinalize(dest) ? 0 : 5)
