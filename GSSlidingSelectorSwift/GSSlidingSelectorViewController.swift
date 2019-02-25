/**
 * @file GSSlideSelectorViewController.swift
 * @author Galarius
 * @date 23.02.2019
 * @copyright (c) 2018 galarius. All rights reserved.
 */

import UIKit

private let GSTransformTextFieldAnimationTime: TimeInterval = 0.15
private let GSHighlightBackColorAnimationTime: TimeInterval = 0.05
private let GSRestoreBackColorAnimationTime  : TimeInterval = 0.55
private let GSMaximumNumberOfElements        : Int = 25

fileprivate extension Selector {
    static let holdGesture =
        #selector(GSSlidingSelectorViewController.holdGesture(_:))
}

class GSSlidingSelectorViewController: UIViewController, UIScrollViewDelegate, UIGestureRecognizerDelegate {
    
    weak var delegate:   GSSlidingSelectorDelegate?
    weak var dataSource: GSSlidingSelectorDataSource?
    
    var selectedIndex: Int {
        willSet {
            self.transformTextField(atIndex: self.selectedIndex, animated:false);
        }
        didSet {
            self.restoreTextField(atIndex: self.selectedIndex, animated:false);
            self.scrollToIndex(self.selectedIndex, animated:false);
            
        }
    }
    var scrollView: UIScrollView!   ///< ScrollView to slide items horizontally
    var textFields: NSMutableArray ///< Array of text fields in scroll view
    var selectedItem: NSString     ///< Selected & displayed item
    var decelerating: Bool         ///< Flag to know if scroll view's decelerating is active
    
    init() {
        
        self.selectedIndex = 0
        self.selectedItem = ""
        self.decelerating = false
        self.textFields = []
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        
        self.selectedIndex = 0
        self.selectedItem = ""
        self.decelerating = false
        self.textFields = []
        
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        self.setupView()
    }
    
    override func viewWillLayoutSubviews() {
        
        super.viewWillLayoutSubviews()
        
        let w = view.frame.width
        let h = view.frame.height
        scrollView.frame = CGRect(x: 0, y: 0, width: w, height: h)
        scrollView.contentSize = CGSize(width: w, height: h)
        
        if self.textFields.count > 0 {
            /*
             *   |       ][    active    ][      |       ][              ]
             *         <------------>
             *            1/2 * w
             */
            let w2 = w * 0.5;
            let w4 = w2 * 0.5;
            var x  = w4;
            for i in 0..<(self.textFields.count) {
                let tf : UITextField = self.textFields.object(at: i) as! UITextField
                tf.frame = CGRect(x: x, y: 0.0, width: w2, height: h);
                tf.alpha = (i == self.selectedIndex ? 1.0 : 0.0);
                x += w2;
            }
            self.scrollView.contentSize = CGSize(width: x + w4, height: h);
            let target = CGPoint( x: CGFloat(self.selectedIndex) * w2, y: 0);
            self.scrollView.setContentOffset(target, animated: false)
        }
    }
    
    func setSelectedIndex(_ selectedIndex: Int, animated: Bool) {
        if selectedIndex != self.selectedIndex && selectedIndex < self.textFields.count {
            self.transformTextField(atIndex: self.selectedIndex, animated:animated);
            self.selectedIndex = selectedIndex;
            self.restoreTextField(atIndex: self.selectedIndex, animated:animated);
            self.scrollToIndex(selectedIndex, animated:animated);
        }
    }
    
    func setupView() {
        
        self.view.backgroundColor = GSSlidingSelectorStyle.shared.mainColor;
    
        self.scrollView = UIScrollView()
        self.scrollView.delegate = self
        self.scrollView.isPagingEnabled = false
        self.scrollView.showsVerticalScrollIndicator = false
        self.scrollView.showsHorizontalScrollIndicator = false
        self.scrollView.backgroundColor = UIColor.clear
        self.view.addSubview(self.scrollView)
        
        // Configure the press and hold gesture recognizer
        let gr = UILongPressGestureRecognizer(target: self, action: Selector.holdGesture)
        gr.minimumPressDuration = 0.0;
        gr.delegate = self;
        self.scrollView.addGestureRecognizer(gr)
    }
    
    
    /**
     * @brief Initiate data reloading
     * @see GSSlideSelectorDelegate methods
     * @see GSMaximumNumberOfElements
     */
    func reloadData()
    {
        if self.textFields.count > 0 {
            // Remove all previously added text fields
            self.scrollView.subviews.forEach {$0.removeFromSuperview()}
            self.textFields.removeAllObjects();
        }
        // Recreate scroll view content
        var count = self.dataSource?.numberOfItemsInSlideSelector(self) ?? 0
        
        if count > GSMaximumNumberOfElements {
            print("[GSSlidingSelectorViewController] Error: Maximum number of elements is \(GSMaximumNumberOfElements), requested: \(count). Only \(GSMaximumNumberOfElements) elements will be loaded.")
            count = GSMaximumNumberOfElements;
        }
        
        self.textFields = NSMutableArray(capacity: count)
        for i in 0..<(count) {
            let title = self.dataSource?.slideSelector(self, titleForItemAtIndex: i)
            let textField = GSSlidingSelectorStyle.shared.createTextField(withText: title)
            textField.transform = CGAffineTransform(scaleX: 0.5, y: 0.5)
            self.textFields.add(textField)
            self.scrollView.addSubview(textField)
        }
        
        if self.textFields.count > 0 {
            self.restoreTextField(atIndex: self.selectedIndex, animated:true)
        }
        
        self.view.setNeedsLayout()
    }
    
    // MARK: - State
    
    func hideNeighbors(_ hidden: Bool) {
        
        let textViews = self.scrollView.subviews.filter{$0 is UITextField}
        for i in 0..<(textViews.count) {
            let tv = textViews[i]
            if(i != self.selectedIndex) {
                tv.alpha = hidden ? 0.0 : 1.0;
            }
        }
        
    }
    
    func toggleState(_ updating: Bool) {
        if updating {
            
            UIView.animate(withDuration: GSHighlightBackColorAnimationTime, delay: 0, options: [.allowUserInteraction, .beginFromCurrentState], animations: {
                self.scrollView.backgroundColor = GSSlidingSelectorStyle.shared.holdTouchColor
                self.hideNeighbors(false)
            }, completion: nil);
        
        } else {
            
            UIView.animate(withDuration: GSRestoreBackColorAnimationTime, delay: 0, options: [.allowUserInteraction, .beginFromCurrentState], animations: {
                self.scrollView.backgroundColor = UIColor.clear
                self.hideNeighbors(true)
            }, completion: nil);
        }
    }
    
    func restoreTextField(atIndex index: Int, animated: Bool) {
        let tf : UITextField = self.textFields[index] as! UITextField
        if animated {
            UIView.animate(withDuration: GSTransformTextFieldAnimationTime, animations: {
                tf.transform = .identity
            })
        } else {
            tf.transform = .identity
        }
    }
    
    func transformTextField(atIndex index: Int, animated: Bool) {
        
        let tf : UITextField = self.textFields[index] as! UITextField
        if animated {
            UIView.animate(withDuration: GSTransformTextFieldAnimationTime, animations: {
                tf.transform = CGAffineTransform(scaleX: 0.5, y: 0.5)
            })
        } else {
            tf.transform = CGAffineTransform(scaleX: 0.5, y: 0.5)
        }
    }
    
    func scrollToIndex(_ index: Int, animated: Bool) {
        let w2 = self.view.frame.width * 0.5
        let target = CGPoint(x: CGFloat(index) * w2, y: 0.0)
        self.scrollView.setContentOffset(target, animated: animated)
    }
    
    //MARK: UIScrollViewDelegate
    
    func scrollViewWillBeginDecelerating(_ scrollView: UIScrollView) {
        self.decelerating = true
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        self.toggleState(false)
        self.decelerating = false
    }
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        
        let offset = scrollView.contentOffset.x + velocity.x * 60.0
        let w = self.scrollView.frame.width
        let pageWidth = w * 0.5
        var idx: Int = Int(max(0, round(offset / pageWidth)))
        idx = min(idx, Int(self.textFields.count - 1))
        targetContentOffset.pointee.x = CGFloat(idx) * pageWidth
        // Notify observer
        self.delegate?.slideSelector(self, didSelectItemAtIndex: idx)
        
        if idx != self.selectedIndex {
            self.transformTextField(atIndex: self.selectedIndex, animated: true)
            self.restoreTextField(atIndex: idx, animated: true)
            self.selectedIndex = idx
        }
    }
    
    //MARK: GestureRecognizer Delegate
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
    
    //MARK: GestureRecognizer Delegate
    
    @objc func holdGesture(_ gesture: UIGestureRecognizer) {
        
        switch gesture.state {
        case .began:
            self.toggleState(true)
            break
        case .ended,.failed,.cancelled:
            if !self.decelerating {
                self.toggleState(false)
            }
            break
        default:
            break
        }
    }
}
