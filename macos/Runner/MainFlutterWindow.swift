import Cocoa
import FlutterMacOS

class MainFlutterWindow: NSWindow {
  override func awakeFromNib() {
    let flutterViewController = FlutterViewController()
    var windowFrame = self.frame
    
    // Set initial comfortable desktop size
    windowFrame.size = NSSize(width: 1100, height: 750)
    
    self.contentViewController = flutterViewController
    self.setFrame(windowFrame, display: true)
    
    // Set a minimum window size proportional to a phone screen 
    // to prevent UI overflow artifacts when scaled down
    self.minSize = NSSize(width: 375, height: 400)

    self.styleMask.insert(.fullSizeContentView)
    self.titlebarAppearsTransparent = true
    self.titleVisibility = .hidden
    self.isMovableByWindowBackground = true

    let toolbar = NSToolbar(identifier: "TransparentToolbar")
    toolbar.showsBaselineSeparator = false
    self.toolbar = toolbar

    RegisterGeneratedPlugins(registry: flutterViewController)

    super.awakeFromNib()
  }
}
