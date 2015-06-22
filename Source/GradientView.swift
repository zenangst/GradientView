import UIKit

public class GradientView: UIView {

  lazy var gradientLayer: CAGradientLayer = {
    let layer = CAGradientLayer()
    layer.frame = self.frame
    return layer
    }()

  var colors: [UIColor]? {
    willSet(newColors) {
      if let colors = newColors as [UIColor]? {
        var colorsArray = [CGColorRef]()
        colors.map({ colorsArray.append($0.CGColor) })
        gradientLayer.colors = colors
      }
    }
  }

  var duration: CFTimeInterval = 0.3

  override init(frame: CGRect) {
    super.init(frame: frame)
    
    layer.addSublayer(gradientLayer)
  }

  required public init(coder aDecoder: NSCoder) {
      fatalError("init(coder:) has not been implemented")
  }
  
  public func changeGradient(colors: [UIColor], delay: Double, duration: CFTimeInterval) {
    self.duration = duration

    let delay = delay * Double(NSEC_PER_SEC)
    var time = dispatch_time(DISPATCH_TIME_NOW, Int64(delay))

    dispatch_after(time, dispatch_get_main_queue(), {
      NSThread.detachNewThreadSelector("animateGradient:",
        toTarget:self,
        withObject: self.colors)
    })
  }

  public func animateGradient(colors: [UIColor]) {
    UIView.animateWithDuration(duration, animations: {
      CATransaction.begin()
      CATransaction.setAnimationDuration(self.duration)
      self.colors = colors
      CATransaction.commit()
    })
  }
}
