//
//  AnimatedSegmentSwitch.swift
//  AnimatedSegmentSwitch
//
//  Created by Tobias Schmid on 09/18/2015.
//  Copyright (c) 2015 Tobias Schmid. All rights reserved.
//

import UIKit

// MARK: - AnimatedSegmentSwitch

@IBDesignable public class AnimatedSegmentSwitch: UIControl {
    
    // MARK: - Public Properties
    
    public var items: [UIImage] = [] { didSet { setupImages() } }
    public var selectedIndex: Int = 0 { didSet { displayNewSelectedIndex() } }
    public var animationDuration: NSTimeInterval = 0.5
    public var animationSpringDamping: CGFloat = 0.6
    public var animationInitialSpringVelocity: CGFloat = 0.8
    
    // MARK: - IBInspectable Properties
    
    @IBInspectable public var selectedColor: UIColor = .blackColor() {
        didSet {
            setSelectedColors()
        }
    }
    
    @IBInspectable public var normalColor: UIColor = .whiteColor() {
        didSet {
            setSelectedColors()
        }
    }
    
    @IBInspectable public var borderColor: UIColor = .whiteColor() {
        didSet {
            layer.borderColor = borderColor.CGColor
        }
    }
    
    @IBInspectable public var cornerRadius: CGFloat! {
        didSet {
            layer.cornerRadius = cornerRadius
        }
    }
    
    @IBInspectable public var thumbColor: UIColor = .whiteColor() {
        didSet {
            setSelectedColors()
        }
    }
    
    @IBInspectable public var thumbCornerRadius: CGFloat! {
        didSet {
            thumbView.layer.cornerRadius = thumbCornerRadius
        }
    }
    
    @IBInspectable public var thumbInset: CGFloat = 2.0 {
        didSet {
            setNeedsLayout()
        }
    }
    
    // MARK: - Private Properties
    
    private var imageViews: [UIImageView] = []
    private var thumbView = UIView()
    private var selectedThumbViewFrame: CGRect?
    private var panGesture: UIPanGestureRecognizer!
    
    // MARK: - Lifecycle
    
    override public init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required public init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }
    
    private func setupView(){
        backgroundColor = .clearColor()
        
        setupImages()
        
        insertSubview(thumbView, atIndex: 0)
        
        panGesture = UIPanGestureRecognizer(target: self, action: #selector(AnimatedSegmentSwitch.pan(_:)))
        panGesture.delegate = self
        addGestureRecognizer(panGesture)
    }
    
    private func setupImages() {
        
        imageViews.forEach { $0.removeFromSuperview() }
        imageViews = []
        
        for index in 0..<items.count {
            
            let imageView = UIImageView(frame: CGRectMake(0, 0, 200, 50))
            imageView.image = items[index]
            imageView.contentMode = .Center
            imageView.translatesAutoresizingMaskIntoConstraints = false
            
            addSubview(imageView)
            imageViews.append(imageView)
            
        }
        
        addIndividualItemConstraints(imageViews, mainView: self, padding: thumbInset)
    }
    
    // MARK: - Touch Events
    
    override public func beginTrackingWithTouch(touch: UITouch, withEvent event: UIEvent?) -> Bool {
        let location = touch.locationInView(self)
        if let index = indexAtLocation(location) {
            selectedIndex = index
            sendActionsForControlEvents(.ValueChanged)
        }
        return false
    }
    
    func pan(gesture: UIPanGestureRecognizer!) {
        if gesture.state == .Began {
            selectedThumbViewFrame = thumbView.frame
        } else if gesture.state == .Changed {
            var frame = selectedThumbViewFrame!
            frame.origin.x += gesture.translationInView(self).x
            frame.origin.x = min(frame.origin.x, bounds.width - frame.width)
            thumbView.frame = frame
        } else if gesture.state == .Ended || gesture.state == .Failed || gesture.state == .Cancelled {
            let location = gesture.locationInView(self)
            if let index = indexAtLocation(location) {
                selectedIndex = index
                sendActionsForControlEvents(.ValueChanged)
            }
        }
    }
    
    // MARK: - Layout
    
    override public func layoutSubviews() {
        super.layoutSubviews()
        
        layer.cornerRadius = cornerRadius ?? frame.height / 2
        layer.borderColor = UIColor(white: 1.0, alpha: 0.0).CGColor
        layer.borderWidth = 1
        layer.masksToBounds = true
        
        var selectFrame = self.bounds
        let newWidth = CGRectGetWidth(selectFrame) / CGFloat(items.count)
        selectFrame.size.width = newWidth
        
        thumbView.frame = selectFrame
        thumbView.backgroundColor = thumbColor
        thumbView.layer.cornerRadius = (thumbCornerRadius ?? thumbView.frame.height / 2) - thumbInset
        
        displayNewSelectedIndex()
    }
    
    // MARK: - Private - Helpers
    
    private func displayNewSelectedIndex() {
        
        imageViews.forEach { $0.tintColor = normalColor }
        
        let selectedImageView = imageViews[selectedIndex]
        selectedImageView.tintColor = selectedColor
        
        UIView.animateWithDuration(animationDuration,
                                   delay: 0.0,
                                   usingSpringWithDamping: animationSpringDamping,
                                   initialSpringVelocity: animationInitialSpringVelocity,
                                   options: [],
                                   animations: { self.thumbView.frame = selectedImageView.frame },
                                   completion: nil)
        
    }
    
    private func setSelectedColors() {
        
        imageViews.forEach { $0.tintColor = normalColor }
        
        if imageViews.count > 0 {
            imageViews[selectedIndex].tintColor = selectedColor
        }
        
        thumbView.backgroundColor = thumbColor
    }
    
    private func indexAtLocation(location: CGPoint) -> Int? {
        var calculatedIndex: Int?
        for (index, item) in imageViews.enumerate() {
            if item.frame.contains(location) {
                calculatedIndex = index
                break
            }
        }
        return calculatedIndex
    }
    
    private func addIndividualItemConstraints(items: [UIView], mainView: UIView, padding: CGFloat) {
        for (index, button) in items.enumerate() {
            let topConstraint = NSLayoutConstraint(item: button,
                                                   attribute: NSLayoutAttribute.Top,
                                                   relatedBy: NSLayoutRelation.Equal,
                                                   toItem: mainView,
                                                   attribute: NSLayoutAttribute.Top,
                                                   multiplier: 1.0,
                                                   constant: padding)
            
            let bottomConstraint = NSLayoutConstraint(item: button,
                                                      attribute: NSLayoutAttribute.Bottom,
                                                      relatedBy: NSLayoutRelation.Equal,
                                                      toItem: mainView,
                                                      attribute: NSLayoutAttribute.Bottom,
                                                      multiplier: 1.0,
                                                      constant: -padding)
            
            var rightConstraint : NSLayoutConstraint!
            if index == items.count - 1 {
                rightConstraint = NSLayoutConstraint(item: button,
                                                     attribute: NSLayoutAttribute.Right,
                                                     relatedBy: NSLayoutRelation.Equal,
                                                     toItem: mainView,
                                                     attribute: NSLayoutAttribute.Right,
                                                     multiplier: 1.0,
                                                     constant: -padding)
            } else {
                let nextButton = items[index+1]
                rightConstraint = NSLayoutConstraint(item: button,
                                                     attribute: NSLayoutAttribute.Right,
                                                     relatedBy: NSLayoutRelation.Equal,
                                                     toItem: nextButton,
                                                     attribute: NSLayoutAttribute.Left,
                                                     multiplier: 1.0,
                                                     constant: -padding)
            }
            
            var leftConstraint : NSLayoutConstraint!
            if index == 0 {
                leftConstraint = NSLayoutConstraint(item: button,
                                                    attribute: NSLayoutAttribute.Left,
                                                    relatedBy: NSLayoutRelation.Equal,
                                                    toItem: mainView,
                                                    attribute: NSLayoutAttribute.Left,
                                                    multiplier: 1.0,
                                                    constant: padding)
            } else {
                let prevButton = items[index-1]
                leftConstraint = NSLayoutConstraint(item: button,
                                                    attribute: NSLayoutAttribute.Left,
                                                    relatedBy: NSLayoutRelation.Equal,
                                                    toItem: prevButton,
                                                    attribute: NSLayoutAttribute.Right,
                                                    multiplier: 1.0,
                                                    constant: padding)
                
                let firstItem = items[0]
                let widthConstraint = NSLayoutConstraint(item: button,
                                                         attribute: .Width,
                                                         relatedBy: NSLayoutRelation.Equal,
                                                         toItem: firstItem,
                                                         attribute: .Width,
                                                         multiplier: 1.0,
                                                         constant: 0)
                
                mainView.addConstraint(widthConstraint)
            }
            
            mainView.addConstraints([topConstraint, bottomConstraint, rightConstraint, leftConstraint])
        }
    }
}

// MARK: - UIGestureRecognizer Delegate
extension AnimatedSegmentSwitch: UIGestureRecognizerDelegate {
    
    override public func gestureRecognizerShouldBegin(gestureRecognizer: UIGestureRecognizer) -> Bool {
        if gestureRecognizer == panGesture {
            return thumbView.frame.contains(gestureRecognizer.locationInView(self))
        }
        return super.gestureRecognizerShouldBegin(gestureRecognizer)
    }
}
