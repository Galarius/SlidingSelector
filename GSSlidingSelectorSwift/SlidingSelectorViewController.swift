//
//  SlidingSelectorViewController.swift
//  GSSlidingSelector
//
//  Created by galarius on 23.02.2019.
//  Copyright © 2019 galarius. All rights reserved.
//

import UIKit

// MARK: UserDefaults

private extension UserDefaults {
    static var hideHelp: Bool {
        get {
            return UserDefaults.standard.bool(forKey: "HideHelp")
        }
        set(value) {
            UserDefaults.standard.set(value, forKey: "HideHelp")
        }
    }
}

// MARK: SlidingSelectorDelegate

protocol SlidingSelectorDelegate: NSObjectProtocol {
    func slideSelector(_ selector: SlidingSelectorViewController!, didSelectItemAtIndex index: Int)
}

// MARK: SlidingSelectorDataSource

protocol SlidingSelectorDataSource: NSObjectProtocol {
    func numberOfItemsInSlideSelector(_ selector: SlidingSelectorViewController!) -> Int
    func slideSelector(_ selector: SlidingSelectorViewController!, titleForItemAtIndex index: Int) -> String
}

// MARK: SlidingSelectorViewController

final class SlidingSelectorViewController: UIViewController {

    public weak var delegate: SlidingSelectorDelegate?
    public weak var dataSource: SlidingSelectorDataSource?

    private var labels = [UILabel]()
    private lazy var scrollView = UIScrollView()
    private lazy var imgViewLeft = UIImageView(image: UIImage(named: "swapRight"))
    private lazy var imgViewRight = UIImageView(image: UIImage(named: "swapLeft"))

    private let transformTextFieldAnimationTime: TimeInterval = 0.15
    private let highlightBackColorAnimationTime: TimeInterval = 0.05
    private let restoreBackColorAnimationTime: TimeInterval = 0.55

    private(set) var selectedItem = ""
    public var selectedIndex = 0 {
        willSet {
            transformTextField(atIndex: selectedIndex, animated: false)
        }
        didSet {
            restoreTextField(atIndex: selectedIndex, animated: false)
            scrollToIndex(selectedIndex, animated: false)

        }
    }
    /// Help images will be shown only once at first launch until another item is selected
    public var shouldHideHelp: Bool {
        get {
            return UserDefaults.hideHelp
        }
        set(value) {
            UserDefaults.hideHelp = value
            imgViewLeft.isHidden = value
            imgViewRight.isHidden = value
        }
    }
    public var font: UIFont? = UIFont(name: "Helvetica", size: UIFontDescriptor.preferredFontDescriptor(withTextStyle: .title2).pointSize) {
        didSet {
            labels.forEach { $0.font = font }
        }
    }
    public var mainColor: UIColor? = UIColor(red: 240/255.0, green: 235/255.0, blue: 180/255.0, alpha: 1.0) {
        didSet {
            view.backgroundColor = mainColor
        }
    }
    public var holdTouchColor: UIColor? = UIColor(red: 0.1, green: 0.1, blue: 0.1, alpha: 0.2)
    public var tintColor: UIColor? = UIColor.black {
        didSet {
            imgViewLeft.tintColor = tintColor
            imgViewRight.tintColor = tintColor
        }
    }
    public var textColor: UIColor? = UIColor.black {
         didSet {
            labels.forEach { $0.textColor = textColor }
        }
    }

    override func viewDidLoad() {

        super.viewDidLoad()

        // Setup info images
        imgViewLeft.tintColor = tintColor
        imgViewRight.tintColor = tintColor
        imgViewLeft.isHidden = shouldHideHelp
        imgViewRight.isHidden = shouldHideHelp

        // Setup scroll view
        scrollView.delegate = self
        scrollView.isPagingEnabled = false
        scrollView.showsVerticalScrollIndicator = false
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.backgroundColor = UIColor.clear

        // Setup view
        view.addSubview(scrollView)
        view.addSubview(imgViewLeft)
        view.addSubview(imgViewRight)
        view.backgroundColor = mainColor

        // Configure the press and hold gesture recognizer
        let grecognizer = UILongPressGestureRecognizer(target: self, action: #selector(SlidingSelectorViewController.holdGesture(_:)))
        grecognizer.minimumPressDuration = 0.0
        grecognizer.delegate = self
        scrollView.addGestureRecognizer(grecognizer)
    }

    override func viewWillLayoutSubviews() {

        super.viewWillLayoutSubviews()

        let w = view.frame.width
        let h = view.frame.height
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

    func setSelectedIndex(_ selectedIndex: Int, animated: Bool) {
        guard selectedIndex != selectedIndex && selectedIndex < labels.count else { return }
        transformTextField(atIndex: selectedIndex, animated: animated)
        self.selectedIndex = selectedIndex
        restoreTextField(atIndex: selectedIndex, animated: animated)
        scrollToIndex(selectedIndex, animated: animated)
    }

    func reloadData() {
        // Recreate scroll view content
        if labels.count > 0 {
            scrollView.subviews.forEach {$0.removeFromSuperview()}
            labels.removeAll()
        }
        let count = dataSource?.numberOfItemsInSlideSelector(self) ?? 0
        for i in 0..<(count) {
            let lbl = createLabel(with: dataSource?.slideSelector(self, titleForItemAtIndex: i))
            labels.append(lbl)
            scrollView.addSubview(lbl)
        }
        if labels.count > 0 {
            restoreTextField(atIndex: selectedIndex, animated: true)
        }
        view.setNeedsLayout()
    }

    func createLabel(with text: String?) -> UILabel {
        let lbl = UILabel()
        lbl.transform = CGAffineTransform(scaleX: 0.5, y: 0.5)
        lbl.lineBreakMode = .byWordWrapping
        lbl.textAlignment = .center
        lbl.textColor = textColor
        lbl.numberOfLines = 0
        lbl.font = font
        lbl.text = text
        return lbl
    }

    // MARK: - State

    func hideNeighbors(_ hidden: Bool) {
        imgViewLeft.alpha = hidden ? 1.0 : 0.0
        imgViewRight.alpha = hidden ? 1.0 : 0.0
        for i in 0..<(labels.count) where i != selectedIndex {
            labels[i].alpha = hidden ? 0.0 : 1.0
        }
    }

    func toggleState(_ updating: Bool) {
        let duration = updating ? highlightBackColorAnimationTime : restoreBackColorAnimationTime
        let color = updating ? self.holdTouchColor : UIColor.clear
        let shouldHideNeighbors = !updating
        UIView.animate(withDuration: duration, delay: 0, options: [.allowUserInteraction, .beginFromCurrentState], animations: {
            self.scrollView.backgroundColor = color
            self.hideNeighbors(shouldHideNeighbors)
        }, completion: nil)
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
        let target = CGPoint(x: CGFloat(index) * 0.5 * view.frame.width, y: 0.0)
        scrollView.setContentOffset(target, animated: animated)
    }
}

// MARK: UIScrollViewDelegate

extension SlidingSelectorViewController: UIScrollViewDelegate {
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        toggleState(false)
    }

    func scrollViewWillEndDragging(_ scrollView: UIScrollView,
                                   withVelocity velocity: CGPoint,
                                   targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        let offset = scrollView.contentOffset.x + velocity.x * 60.0
        let pageWidth = 0.5 * scrollView.frame.width
        var idx = Int(max(0, round(offset / pageWidth)))
        idx = min(idx, Int(labels.count - 1))
        targetContentOffset.pointee.x = CGFloat(idx) * pageWidth

        if !shouldHideHelp { shouldHideHelp = true }

        // Notify observer
        delegate?.slideSelector(self, didSelectItemAtIndex: idx)

        guard idx != selectedIndex else { return }
        transformTextField(atIndex: selectedIndex, animated: true)
        restoreTextField(atIndex: idx, animated: true)
        selectedIndex = idx
    }
}

// MARK: UIGestureRecognizerDelegate

extension SlidingSelectorViewController: UIGestureRecognizerDelegate {

    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }

    @objc func holdGesture(_ gesture: UIGestureRecognizer) {
        switch gesture.state {
        case .began:
            toggleState(true)
        case .ended, .failed, .cancelled:
            if !scrollView.isDecelerating && !scrollView.isDragging {
                toggleState(false)
            }
        default:
            break
        }
    }
}
