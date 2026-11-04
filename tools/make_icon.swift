// Draws the app icon: a hue ring on white, like the original 2016 icon. Run
// from the repo root:
//   swift tools/make_icon.swift ColorBlend/Assets.xcassets/AppIcon.appiconset/AppIcon.png
import AppKit

let size = 1024
let out = CommandLine.arguments[1]
let ctx = CGContext(data: nil, width: size, height: size, bitsPerComponent: 8, bytesPerRow: 0,
                    space: CGColorSpace(name: CGColorSpace.sRGB)!,
                    bitmapInfo: CGImageAlphaInfo.noneSkipLast.rawValue)!

// Background: white.
ctx.setFillColor(CGColor(srgbRed: 1, green: 1, blue: 1, alpha: 1))
ctx.fill(CGRect(x: 0, y: 0, width: size, height: size))

// Ring: hue runs counterclockwise, with red just right of the top and yellow
// at the top.
let center = CGPoint(x: 512, y: 512)
let outer: CGFloat = 470
let inner: CGFloat = 175
let steps = 1440
let redAngle = CGFloat.pi / 2 - CGFloat.pi / 3

// Wedges without antialiasing, so their shared edges don't show as seams...
ctx.setShouldAntialias(false)
for i in 0..<steps {
    let hue = CGFloat(i) / CGFloat(steps)
    let start = redAngle + 2 * .pi * hue
    let end = start + 2 * .pi / CGFloat(steps) * 1.5
    let wedge = CGMutablePath()
    wedge.move(to: center)
    wedge.addArc(center: center, radius: outer + 20, startAngle: start, endAngle: end, clockwise: false)
    wedge.closeSubpath()
    ctx.setFillColor(NSColor(hue: hue, saturation: 1, brightness: 1, alpha: 1).cgColor)
    ctx.addPath(wedge)
    ctx.fillPath()
}

// ...then smooth white masks for the hole and the outside of the ring.
ctx.setShouldAntialias(true)
ctx.setFillColor(CGColor(srgbRed: 1, green: 1, blue: 1, alpha: 1))
ctx.fillEllipse(in: CGRect(x: center.x - inner, y: center.y - inner, width: inner * 2, height: inner * 2))
ctx.addRect(CGRect(x: 0, y: 0, width: size, height: size))
ctx.addEllipse(in: CGRect(x: center.x - outer, y: center.y - outer, width: outer * 2, height: outer * 2))
ctx.fillPath(using: .evenOdd)

let image = ctx.makeImage()!
let rep = NSBitmapImageRep(cgImage: image)
try! rep.representation(using: .png, properties: [:])!.write(to: URL(fileURLWithPath: out))
