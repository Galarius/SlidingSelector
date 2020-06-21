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
            return UserDefaults.standard.bool(forKey: "SlidingSelector_HideHelp")
        }
        set(value) {
            UserDefaults.standard.set(value, forKey: "SlidingSelector_HideHelp")
        }
    }
}

// MARK: SlidingSelectorDelegate

@objc public protocol SlidingSelectorDelegate: NSObjectProtocol {
    func slideSelector(_ selector: SlidingSelectorViewController!, didSelectItemAtIndex index: Int)
}

// MARK: SlidingSelectorViewController

final public class SlidingSelectorViewController: UIViewController {

    @IBOutlet public weak var delegate: SlidingSelectorDelegate?
    @IBOutlet var selectorView: SlidingSelectorView?

    private(set) public var selectedIndex = 0 {
        didSet {
            selectorView?.selectedIndex = selectedIndex
        }
    }

    /**
     Set items that need to be displayed in the selector
     
     It is recommended to store a small amount of elements (<= 15)
     */
    public var items = [String]() {
        didSet {
            selectorView?.clearLabels()
            items.forEach { self.selectorView?.addLabel($0) }
            selectorView?.restoreTextField(atIndex: selectedIndex, animated: true)
            view.setNeedsLayout()
        }
    }

    /**
     Helper Images will be shown only once at first launch until another item is selected
     */
    public var shouldHideHelp: Bool {
        get {
            return UserDefaults.hideHelp
        }
        set(value) {
            UserDefaults.hideHelp = value
            selectorView?.isHelpHidden = value
        }
    }

    public override func viewDidLoad() {
        super.viewDidLoad()

        let grecognizer = UILongPressGestureRecognizer(target: self, action: #selector(SlidingSelectorViewController.holdGesture(_:)))
        grecognizer.minimumPressDuration = 0.0
        grecognizer.delegate = self
        selectorView?.scrollView.delegate = self
        selectorView?.scrollView.addGestureRecognizer(grecognizer)
        selectorView?.isHelpHidden = shouldHideHelp
    }

    public func setSelectedIndex(_ selectedIndex: Int, animated: Bool = false) {
        guard selectedIndex != selectedIndex && selectedIndex < items.count else { return }
        selectorView?.transformTextField(atIndex: selectedIndex, animated: animated)
        self.selectedIndex = selectedIndex
        selectorView?.restoreTextField(atIndex: selectedIndex, animated: animated)
        selectorView?.scrollToIndex(selectedIndex, animated: animated)
    }
}

// MARK: UIScrollViewDelegate

extension SlidingSelectorViewController: UIScrollViewDelegate {
    public func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        selectorView?.toggleState(false)
    }

    public func scrollViewWillEndDragging(_ scrollView: UIScrollView,
                                   withVelocity velocity: CGPoint,
                                   targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        let offset = scrollView.contentOffset.x + velocity.x * 60.0
        let pageWidth = 0.5 * scrollView.frame.width
        var idx = Int(max(0, round(offset / pageWidth)))
        idx = min(idx, Int(items.count - 1))
        targetContentOffset.pointee.x = CGFloat(idx) * pageWidth

        if !shouldHideHelp { shouldHideHelp = true }

        // Notify observer
        delegate?.slideSelector(self, didSelectItemAtIndex: idx)

        guard idx != selectedIndex else { return }
        selectorView?.transformTextField(atIndex: selectedIndex, animated: true)
        selectorView?.restoreTextField(atIndex: idx, animated: true)
        selectedIndex = idx
    }
}

// MARK: UIGestureRecognizerDelegate

extension SlidingSelectorViewController: UIGestureRecognizerDelegate {

    public func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }

    @objc func holdGesture(_ gesture: UIGestureRecognizer) {
        switch gesture.state {
        case .began:
            selectorView?.toggleState(true)
        case .ended, .failed, .cancelled:
            if let selector = selectorView,
                !selector.scrollView.isDecelerating,
                !selector.scrollView.isDragging {
                selectorView?.toggleState(false)
            }
        default:
            break
        }
    }
}
