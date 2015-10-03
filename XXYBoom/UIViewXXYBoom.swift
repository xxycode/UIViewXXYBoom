//
//  UIView+XXYBang.swift
//  XXYBang~
//
//  Created by Xiaoxueyuan on 15/10/1.
//  Copyright (c) 2015年 Xiaoxueyuan. All rights reserved.
//

import UIKit
extension UIView{
    
    private struct AssociatedKeys {
        static var BoomCellsName = "XXYBoomCells"
        static var ScaleSnapshotName = "XXYBoomScaleSnapshot"
    }
    private var boomCells:[CALayer]?{
        get{
            return objc_getAssociatedObject(self, &AssociatedKeys.BoomCellsName) as? [CALayer]
        }
        set{
            if let newValue = newValue{
                willChangeValueForKey(AssociatedKeys.BoomCellsName)
                objc_setAssociatedObject(self, &AssociatedKeys.BoomCellsName, newValue as [CALayer], UInt(OBJC_ASSOCIATION_RETAIN_NONATOMIC))
                didChangeValueForKey(AssociatedKeys.BoomCellsName)
            }
        }
    }
    private var scaleSnapshot:UIImage?{
        get{
            return objc_getAssociatedObject(self, &AssociatedKeys.ScaleSnapshotName) as? UIImage
        }
        set{
            if let newValue = newValue{
                willChangeValueForKey(AssociatedKeys.ScaleSnapshotName)
                objc_setAssociatedObject(self, &AssociatedKeys.ScaleSnapshotName, newValue as UIImage, UInt(OBJC_ASSOCIATION_RETAIN_NONATOMIC))
                didChangeValueForKey(AssociatedKeys.ScaleSnapshotName)
            }
        }
    }
    
    //从layer获取View的截图
    func snapshot() -> UIImage{
        UIGraphicsBeginImageContext(layer.frame.size)
        layer.renderInContext(UIGraphicsGetCurrentContext())
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }
    
    func colorWithPoint(x:Int,y:Int,image:UIImage) -> UIColor{
        var pixelData = CGDataProviderCopyData(CGImageGetDataProvider(image.CGImage))
        var data: UnsafePointer<UInt8> = CFDataGetBytePtr(pixelData)
        
        var pixelInfo: Int = ((Int(image.size.width) * y) + x) * 4
        
        var a = CGFloat(data[pixelInfo]) / CGFloat(255.0)
        var r = CGFloat(data[pixelInfo+1]) / CGFloat(255.0)
        var g = CGFloat(data[pixelInfo+2]) / CGFloat(255.0)
        var b = CGFloat(data[pixelInfo+3]) / CGFloat(255.0)
        
        return UIColor(red: r, green: g, blue: b, alpha: a)
    }
    
    func boom(){
        //摇摆~ 摇摆~ 震动~ 震动~
        let shakeXAnimation = CAKeyframeAnimation(keyPath: "position.x")
        shakeXAnimation.duration = 0.2
        shakeXAnimation.values = [makeShakeValue(layer.position.x),makeShakeValue(layer.position.x),makeShakeValue(layer.position.x),makeShakeValue(layer.position.x),makeShakeValue(layer.position.x)]
        let shakeYAnimation = CAKeyframeAnimation(keyPath: "position.y")
        shakeYAnimation.duration = shakeXAnimation.duration
        shakeYAnimation.values = [makeShakeValue(layer.position.y),makeShakeValue(layer.position.y),makeShakeValue(layer.position.y),makeShakeValue(layer.position.y),makeShakeValue(layer.position.y)]
        
        
        //缩放
        let scaleAnimation = CABasicAnimation(keyPath: "transform.scale")
        scaleAnimation.toValue = 0.01
        scaleAnimation.duration = 0.15
        scaleAnimation.removedOnCompletion = false
        scaleAnimation.beginTime = shakeXAnimation.duration
        scaleAnimation.fillMode = kCAFillModeForwards
        
        //透明度
        let opacityAnimation = CABasicAnimation(keyPath: "opacity")
        opacityAnimation.fromValue = 1
        opacityAnimation.toValue = 0
        opacityAnimation.duration = 0.15
        opacityAnimation.removedOnCompletion = false
        opacityAnimation.beginTime = shakeXAnimation.duration
        opacityAnimation.fillMode = kCAFillModeForwards
        
        //组合
        let groupAnimation = CAAnimationGroup()
        groupAnimation.animations = [shakeXAnimation,shakeYAnimation,scaleAnimation,opacityAnimation]
        groupAnimation.duration  = 0.35
        groupAnimation.removedOnCompletion = false
        groupAnimation.fillMode = kCAFillModeForwards
        groupAnimation.delegate = self
        layer.addAnimation(groupAnimation, forKey: "groupAnimation")
        
        
        if boomCells == nil{
            boomCells = [CALayer]()
            for i in 0...16{
                for j in 0...16{
                    if scaleSnapshot == nil{
                        scaleSnapshot = snapshot().scaleImageToSize(CGSizeMake(34, 34))
                    }
                    let pWidth = min(frame.size.width,frame.size.height)/17
                    let color = UIImage.getPixelColorAtLocation(CGPointMake(CGFloat(i * 2), CGFloat(j * 2)), image: scaleSnapshot!)
                    let shape = CALayer()
                    shape.backgroundColor = color.CGColor
                    shape.opacity = 0
                    shape.cornerRadius = pWidth/2
                    shape.frame = CGRectMake(CGFloat(i) * pWidth, CGFloat(j) * pWidth, pWidth, pWidth)
                    layer.superlayer.addSublayer(shape)
                    boomCells?.append(shape)
                }
            }
        }
        
        let delayTimer = NSTimer.scheduledTimerWithTimeInterval(0.35, target: self, selector: "cellAnimations", userInfo: nil, repeats: false)
    }
    
    func cellAnimations(){
        for shape in boomCells!{
            shape.position = center
            shape.opacity = 1
            //路径
            let moveAnimation = CAKeyframeAnimation(keyPath: "position")
            moveAnimation.path = makeRandomPath(shape).CGPath
            moveAnimation.removedOnCompletion = false
            moveAnimation.fillMode = kCAFillModeForwards
            moveAnimation.timingFunction = CAMediaTimingFunction(controlPoints: 0.240000, 0.590000, 0.506667, 0.026667)
            moveAnimation.duration = NSTimeInterval(random()%10) * 0.05 + 0.3
            
            let scaleAnimation = CABasicAnimation(keyPath: "transform.scale")
            scaleAnimation.toValue = makeScaleValue()
            scaleAnimation.duration = moveAnimation.duration
            scaleAnimation.removedOnCompletion = false
            scaleAnimation.fillMode = kCAFillModeForwards
            
            let opacityAnimation = CABasicAnimation(keyPath: "opacity")
            opacityAnimation.fromValue = 1
            opacityAnimation.toValue = 0
            opacityAnimation.duration = moveAnimation.duration
            opacityAnimation.delegate = false
            opacityAnimation.removedOnCompletion = true
            opacityAnimation.fillMode = kCAFillModeForwards
            opacityAnimation.timingFunction = CAMediaTimingFunction(controlPoints: 0.380000, 0.033333, 0.963333, 0.260000)
            
            shape.opacity = 0
            shape.addAnimation(scaleAnimation, forKey: "scaleAnimation")
            shape.addAnimation(moveAnimation, forKey: "moveAnimation")
            shape.addAnimation(opacityAnimation, forKey: "opacityAnimation")
        }
    }
    
    func makeShakeValue(p:CGFloat) -> CGFloat{
        let basicOrigin = -CGFloat(10)
        let maxOffset = -2 * basicOrigin
        return basicOrigin + maxOffset * (CGFloat(random()%101)/CGFloat(100)) + p
    }
    
    func makeScaleValue() -> CGFloat{
        let randomNumber = random()%101
        var scale = CGFloat(1)
        
        if randomNumber >= 0 && randomNumber <= 50{
            scale = 1 + 0.7 * (CGFloat(randomNumber)/CGFloat(50))
        }else{
            scale = 1 - 0.7 * (CGFloat(randomNumber - 50)/CGFloat(50))
        }
        
        return scale
    }
    
    func makeRandomPath(aLayer:CALayer) -> UIBezierPath{
        let particlePath = UIBezierPath()
        particlePath.moveToPoint(layer.position)
        let basicLeft = -CGFloat(150)
        let maxOffset = 2 * abs(basicLeft)
        let randomNumber = random()%101
        let endPointX = basicLeft + maxOffset * (CGFloat(randomNumber)/CGFloat(100)) + aLayer.position.x
        let controlPointOffSetX = (endPointX - aLayer.position.x)/2  + aLayer.position.x
        let controlPointOffSetY = layer.position.y - 20 - CGFloat(random()%140)
        let endPointY = layer.position.y + 100 + CGFloat(random()%36)
        particlePath.addQuadCurveToPoint(CGPointMake(endPointX, endPointY), controlPoint: CGPointMake(controlPointOffSetX, controlPointOffSetY))
        
        return particlePath

    }
    
    
    public override func animationDidStop(anim: CAAnimation!, finished flag: Bool) {
        cellAnimations()
    }
    
}
extension UIImage{
    //缩放图片
    func scaleImageToSize(size:CGSize) -> UIImage{
        UIGraphicsBeginImageContext(size)
        drawInRect(CGRectMake(0, 0, size.width, size.height))
        let res = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return res
    }
    
    class func createARGBBitmapContextFromImage(inImage:CGImageRef) -> CGContextRef{
        let pixelsWidth = CGImageGetWidth(inImage)
        let pixelsHeitht = CGImageGetHeight(inImage)
        let bitmapBytesPerRow = pixelsWidth * 4
        let bitmapByteCount = bitmapBytesPerRow * pixelsHeitht
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        let bitmapData = UnsafeMutablePointer<Void>.alloc(bitmapByteCount)
        let context = CGBitmapContextCreate(bitmapData,pixelsWidth,pixelsHeitht,8,bitmapBytesPerRow,colorSpace!, CGBitmapInfo(rawValue: CGBitmapInfo.ByteOrderDefault.rawValue | CGImageAlphaInfo.PremultipliedFirst.rawValue))
        return context
    }
    
    class func getPixelColorAtLocation(point:CGPoint, image:UIImage) -> UIColor{
        let inImage = image.CGImage
        let cgctx = UIImage.createARGBBitmapContextFromImage(inImage)
        let w = CGFloat(CGImageGetWidth(inImage))
        let h = CGFloat(CGImageGetHeight(inImage))
        let rect = CGRectMake(0, 0, w, h)
        CGContextDrawImage(cgctx, rect, inImage)
        let offset = 4*((w*round(point.y))+round(point.x))
        var resData = UnsafePointer<UInt8>(CGBitmapContextGetData(cgctx))
        var pixelInfo: Int = 4*((Int(w*round(point.y)))+Int(round(point.x)))
        
        var a = CGFloat(resData[pixelInfo]) / CGFloat(255.0)
        var r = CGFloat(resData[pixelInfo+1]) / CGFloat(255.0)
        var g = CGFloat(resData[pixelInfo+2]) / CGFloat(255.0)
        var b = CGFloat(resData[pixelInfo+3]) / CGFloat(255.0)
        
        return UIColor(red: r, green: g, blue: b, alpha: a)
    }
    
}
