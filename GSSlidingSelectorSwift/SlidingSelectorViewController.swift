//
//  SlidingSelectorViewController.swift
//  GSSlidingSelector
//
//  Created by galarius on 23.02.2019.
//  Copyright © 2019 galarius. All rights reserved.
//

import UIKit

fileprivate extension Selector {
    static let holdGesture =
        #selector(SlidingSelectorViewController.holdGesture(_:))
}

final class SlidingSelectorViewController: UIViewController, UIScrollViewDelegate, UIGestureRecognizerDelegate {

    weak var delegate: SlidingSelectorDelegate?
    weak var dataSource: SlidingSelectorDataSource?

    var selectedIndex: Int {
        willSet {
            transformTextField(atIndex: selectedIndex, animated: false)
        }
        didSet {
            restoreTextField(atIndex: selectedIndex, animated: false)
            scrollToIndex(selectedIndex, animated: false)

        }
    }
    /// ScrollView to slide items horizontally
    private lazy var scrollView = UIScrollView()
    /// Array of text fields in scroll view
    private var textFields: NSMutableArray
    /// Selected & displayed item
    private var selectedItem: NSString

    private let transformTextFieldAnimationTime: TimeInterval = 0.15
    private let highlightBackColorAnimationTime: TimeInterval = 0.05
    private let restoreBackColorAnimationTime: TimeInterval = 0.55
    private let maximumNumberOfElements: Int = 25

    init() {

        selectedIndex = 0
        selectedItem = ""
        textFields = []

        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {

        selectedIndex = 0
        selectedItem = ""
        textFields = []

        super.init(coder: aDecoder)
    }

    override func viewDidLoad() {

        super.viewDidLoad()

        setupView()
    }

    override func viewWillLayoutSubviews() {

        super.viewWillLayoutSubviews()

        let w = view.frame.width
        let h = view.frame.height
        scrollView.frame = CGRect(x: 0, y: 0, width: w, height: h)
        scrollView.contentSize = CGSize(width: w, height: h)

        if textFields.count > 0 {
            /*
             *   |       ][    active    ][      |       ][              ]
             *         <------------>
             *            1/2 * w
             */
            let w2 = w * 0.5
            let w4 = w2 * 0.5
            var x  = w4
            for i in 0..<(textFields.count) {
                if let tfield = textFields.object(at: i) as? UITextField {
                    tfield.frame = CGRect(x: x, y: 0.0, width: w2, height: h)
                    tfield.alpha = (i == selectedIndex ? 1.0 : 0.0)
                    x += w2
                }
            }
            let target = CGPoint( x: CGFloat(selectedIndex) * w2, y: 0)
            scrollView.contentSize = CGSize(width: x + w4, height: h)
            scrollView.setContentOffset(target, animated: false)
        }
    }

    func setSelectedIndex(_ selectedIndex: Int, animated: Bool) {
        guard selectedIndex != selectedIndex && selectedIndex < textFields.count else { return }
        transformTextField(atIndex: selectedIndex, animated: animated)
        self.selectedIndex = selectedIndex
        restoreTextField(atIndex: selectedIndex, animated: animated)
        scrollToIndex(selectedIndex, animated: animated)
    }

    func setupView() {

        view.backgroundColor = SlidingSelectorStyle.shared.mainColor

        scrollView.delegate = self
        scrollView.isPagingEnabled = false
        scrollView.showsVerticalScrollIndicator = false
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.backgroundColor = UIColor.clear
        view.addSubview(scrollView)

        // Configure the press and hold gesture recognizer
        let grecognizer = UILongPressGestureRecognizer(target: self, action: Selector.holdGesture)
        grecognizer.minimumPressDuration = 0.0
        grecognizer.delegate = self
        scrollView.addGestureRecognizer(grecognizer)
    }

    func reloadData() {
        if textFields.count > 0 {
            // Remove all previously added text fields
            scrollView.subviews.forEach {$0.removeFromSuperview()}
            textFields.removeAllObjects()
        }
        // Recreate scroll view content
        var count = dataSource?.numberOfItemsInSlideSelector(self) ?? 0
        if count > maximumNumberOfElements {
            print("""
[GSSlidingSelectorViewController] Error: Maximum number of elements is \(maximumNumberOfElements),
                requested: \(count). Only \(maximumNumberOfElements) elements will be loaded.
""")
            count = maximumNumberOfElements
        }

        textFields = NSMutableArray(capacity: count)
        for i in 0..<(count) {
            let title = dataSource?.slideSelector(self, titleForItemAtIndex: i)
            let textField = SlidingSelectorStyle.shared.createTextField(withText: title)
            textField.transform = CGAffineTransform(scaleX: 0.5, y: 0.5)
            textFields.add(textField)
            scrollView.addSubview(textField)
        }

        if textFields.count > 0 {
            restoreTextField(atIndex: selectedIndex, animated: true)
        }

        view.setNeedsLayout()
    }

    // MARK: - State

    func hideNeighbors(_ hidden: Bool) {
        let textViews = scrollView.subviews.filter {$0 is UITextField}
        for i in 0..<(textViews.count) where i != selectedIndex {
            textViews[i].alpha = hidden ? 0.0 : 1.0
        }
    }

    func toggleState(_ updating: Bool) {
        if updating {
            UIView.animate(withDuration: highlightBackColorAnimationTime, delay: 0, options: [.allowUserInteraction, .beginFromCurrentState], animations: {
                self.scrollView.backgroundColor = SlidingSelectorStyle.shared.holdTouchColor
                self.hideNeighbors(false)
            }, completion: nil)

        } else {
            UIView.animate(withDuration: restoreBackColorAnimationTime, delay: 0, options: [.allowUserInteraction, .beginFromCurrentState], animations: {
                self.scrollView.backgroundColor = UIColor.clear
                self.hideNeighbors(true)
            }, completion: nil)
        }
    }

    func restoreTextField(atIndex index: Int, animated: Bool) {
        guard let tfield = textFields[index] as? UITextField else { return }
        if animated {
            UIView.animate(withDuration: transformTextFieldAnimationTime, animations: {
                tfield.transform = .identity
            })
        } else {
            tfield.transform = .identity
        }
    }

    func transformTextField(atIndex index: Int, animated: Bool) {
        guard let tfield = textFields[index] as? UITextField else { return }
        if animated {
            UIView.animate(withDuration: transformTextFieldAnimationTime, animations: {
                tfield.transform = CGAffineTransform(scaleX: 0.5, y: 0.5)
            })
        } else {
            tfield.transform = CGAffineTransform(scaleX: 0.5, y: 0.5)
        }
    }

    func scrollToIndex(_ index: Int, animated: Bool) {
        let w2 = view.frame.width * 0.5
        let target = CGPoint(x: CGFloat(index) * w2, y: 0.0)
        scrollView.setContentOffset(target, animated: animated)
    }

    // MARK: UIScrollViewDelegate

    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        toggleState(false)
    }

    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {

        let offset = scrollView.contentOffset.x + velocity.x * 60.0
        let w = scrollView.frame.width
        let pageWidth = w * 0.5
        var idx: Int = Int(max(0, round(offset / pageWidth)))
        idx = min(idx, Int(textFields.count - 1))
        targetContentOffset.pointee.x = CGFloat(idx) * pageWidth
        // Notify observer
        delegate?.slideSelector(self, didSelectItemAtIndex: idx)

        if idx != selectedIndex {
            transformTextField(atIndex: selectedIndex, animated: true)
            restoreTextField(atIndex: idx, animated: true)
            selectedIndex = idx
        }
    }

    // MARK: GestureRecognizer Delegate

    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }

    // MARK: GestureRecognizer Delegate

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
