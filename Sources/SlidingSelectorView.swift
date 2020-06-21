//
//  SlidingSelectorView.swift
//  GSSlidingSelector
//
//  Created by galarius on 21.06.2020.
//  Copyright © 2020 galarius. All rights reserved.
//

import UIKit

final public class SlidingSelectorView: UIView {
    @IBInspectable var holdTouchColor: UIColor? = UIColor(red: 0.1, green: 0.1, blue: 0.1, alpha: 0.2)
    @IBInspectable var textColor: UIColor? = UIColor.black {
        didSet {
           labels.forEach { $0.textColor = textColor }
       }
    }
    public var font: UIFont? = UIFont(name: "Helvetica", size: UIFontDescriptor.preferredFontDescriptor(withTextStyle: .title2).pointSize)
    
    var isHelpHidden = false {
        didSet {
            imgViewLeft.isHidden = isHelpHidden
            imgViewRight.isHidden = isHelpHidden
        }
    }
    var selectedIndex = 0
    var scrollView = UIScrollView()

    private var labels = [UILabel]()
    private var imgViewLeft = UIImageView(image: UIImage(named: "swapRight"))
    private var imgViewRight = UIImageView(image: UIImage(named: "swapLeft"))

    private let transformTextFieldAnimationTime: TimeInterval = 0.15
    private let highlightBackColorAnimationTime: TimeInterval = 0.05
    private let restoreBackColorAnimationTime: TimeInterval = 0.55

    required init?(coder: NSCoder) {
        super.init(coder: coder)

        scrollView.isPagingEnabled = false
        scrollView.backgroundColor = UIColor.clear
        scrollView.showsVerticalScrollIndicator = false
        scrollView.showsHorizontalScrollIndicator = false

        addSubview(scrollView)
        addSubview(imgViewLeft)
        addSubview(imgViewRight)
    }

    public override func layoutSubviews() {
        super.layoutSubviews()

        let w = frame.width
        let h = frame.height
        scrollView.frame = CGRect(x: 0, y: 0, width: w, height: h)
        scrollView.contentSize = CGSize(width: w, height: h)

        if labels.count > 0 {
        /*
        *   |       ][    active    ][      |       ][              ]
        *         <------------>
        *            1/2 * w
        */
        let w2 = w * 0.5
        let w4 = w2 * 0.5
        var x  = w4
        for i in 0..<(labels.count) {
            let lbl = labels[i]
            lbl.frame = CGRect(x: x, y: 0.0, width: w2, height: h)
            lbl.alpha = (i == selectedIndex ? 1.0 : 0.0)
            x += w2
        }
        let target = CGPoint( x: CGFloat(selectedIndex) * w2, y: 0)
            scrollView.contentSize = CGSize(width: x + w4, height: h)
            scrollView.setContentOffset(target, animated: false)
        }

        let offsetX: CGFloat = 20.0
        let offsetY: CGFloat = 4.0
        let offsetY2 = offsetY * 2.0
        let size = h - offsetY2
        imgViewLeft.frame = CGRect(x: offsetX, y: offsetY, width: size, height: size)
        imgViewRight.frame = CGRect(x: w - h - offsetX, y: offsetY, width: size, height: size)
    }

    func restoreTextField(atIndex index: Int, animated: Bool) {
       UIView.animate(withDuration: animated ? transformTextFieldAnimationTime : 0, animations: {
           self.labels[index].transform = .identity
       })
    }
    func transformTextField(atIndex index: Int, animated: Bool) {
       UIView.animate(withDuration: animated ? transformTextFieldAnimationTime : 0, animations: {
           self.labels[index].transform = CGAffineTransform(scaleX: 0.5, y: 0.5)
       })
    }
    func scrollToIndex(_ index: Int, animated: Bool) {
        let target = CGPoint(x: CGFloat(index) * 0.5 * frame.width, y: 0.0)
        scrollView.setContentOffset(target, animated: animated)
    }
    func toggleState(_ updating: Bool) {
        let duration = updating ? highlightBackColorAnimationTime : restoreBackColorAnimationTime
        let color = updating ? holdTouchColor : UIColor.clear
        let shouldHideNeighbors = !updating
        UIView.animate(withDuration: duration, delay: 0, options: [.allowUserInteraction, .beginFromCurrentState], animations: {
            self.scrollView.backgroundColor = color
            self.hideNeighbors(shouldHideNeighbors)
        }, completion: nil)
    }
    func hideNeighbors(_ hidden: Bool) {
        imgViewLeft.alpha = hidden ? 1.0 : 0.0
        imgViewRight.alpha = hidden ? 1.0 : 0.0
        for i in 0..<(labels.count) where i != selectedIndex {
            labels[i].alpha = hidden ? 0.0 : 1.0
        }
    }
    func clearLabels() {
        scrollView.subviews.forEach { if $0 is UILabel { $0.removeFromSuperview() } }
        labels.removeAll()
    }
    func addLabel(_ text: String) {
        let lbl = UILabel()
        lbl.transform = CGAffineTransform(scaleX: 0.5, y: 0.5)
        lbl.lineBreakMode = .byWordWrapping
        lbl.textAlignment = .center
        lbl.textColor = textColor
        lbl.numberOfLines = 0
        lbl.font = font
        lbl.text = text
        scrollView.addSubview(lbl)
        labels.append(lbl)
    }
}
