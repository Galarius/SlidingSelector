//
//  FirstViewController.swift
//  GSSlidingSelector
//
//  Created by galarius on 23.02.2019.
//  Copyright © 2019 galarius. All rights reserved.
//

import UIKit

let GSDefaultSelectedIndex: Int = 3   // [1 - 7]
let GSTransformImageAnimationTime: TimeInterval = 0.4

final class FirstViewController: UIViewController, SlidingSelectorDataSource, SlidingSelectorDelegate {

    var selector: SlidingSelectorViewController!
    var imgViewLeft: UIImageView!
    var imgViewSelected: UIImageView!
    var imgViewRight: UIImageView!

    var constraintsPortraitArray: NSArray = []
    var constraintsLandscapeArray: NSArray = []
    var prevSelectedIndex: Int = 0

    var items: NSArray = ["Mercury", "Venus", "Earth", "Mars",
                          "Jupiter", "Saturn", "Uranus", "Neptune", "Pluto"]

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.

        // Create GSSlidingSelectorViewController
        selector = SlidingSelectorViewController()
        selector.delegate = self
        selector.dataSource = self
        addChild(selector)
        view.addSubview(selector.view)
        selector.didMove(toParent: self)

        // Create Image Views

        imgViewLeft = UIImageView()
        imgViewLeft.contentMode = .scaleAspectFit
        imgViewLeft.clipsToBounds = true
        view.addSubview(imgViewLeft)

        imgViewSelected = UIImageView()
        imgViewSelected.contentMode = .scaleAspectFit
        imgViewSelected.clipsToBounds = true
        view.addSubview(imgViewSelected)

        imgViewRight = UIImageView()
        imgViewRight.contentMode = .scaleAspectFit
        imgViewRight.clipsToBounds = true
        view.addSubview(imgViewRight)

        selector.reloadData()
        selector.selectedIndex = GSDefaultSelectedIndex
        prevSelectedIndex = GSDefaultSelectedIndex

        // Set default images
        imgViewLeft.image = imageFromIndex(GSDefaultSelectedIndex-1)
        imgViewSelected.image = imageFromIndex(GSDefaultSelectedIndex)
        imgViewRight.image = imageFromIndex(GSDefaultSelectedIndex+1)

        // Setup Constraints Programmatically
        setupConstraints()

        view.backgroundColor = selector.mainColor
        edgesForExtendedLayout = []
        tabBarController?.tabBar.backgroundColor = view.backgroundColor
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        let orientation = UIApplication.shared.statusBarOrientation
        installConstraint(forOrientation: orientation)
    }

    override func  viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {

        coordinator.animate(alongsideTransition: { _ in
                let orientation = UIApplication.shared.statusBarOrientation
                self.installConstraint(forOrientation: orientation)

                if orientation.isLandscape {
                    self.imgViewLeft.contentMode = .center
                    self.imgViewSelected.contentMode = .center
                    self.imgViewRight.contentMode = .center
                } else {
                    self.imgViewLeft.contentMode = .scaleAspectFit
                    self.imgViewSelected.contentMode = .scaleAspectFit
                    self.imgViewRight.contentMode = .scaleAspectFit
                }
        }, completion: nil)

        super.viewWillTransition(to: size, with: coordinator)
    }

    func isiPhoneXType() -> Bool {
        let h = UIScreen.main.nativeBounds.size.height
        if h == 2436 /*iPhone X, Xs*/  ||
           h == 2688 /*iPhone Xs Max*/ ||
           h == 1792 /*iPhone Xr*/ {
            return true
        }
        return false
    }

    func setupConstraints() {
        selector.view.translatesAutoresizingMaskIntoConstraints   = false
        imgViewLeft.translatesAutoresizingMaskIntoConstraints     = false
        imgViewSelected.translatesAutoresizingMaskIntoConstraints = false
        imgViewRight.translatesAutoresizingMaskIntoConstraints    = false

        let views: [String: UIView] = [
            "selectorView": selector.view,
            "imgViewLeft": imgViewLeft,
            "imgViewSelected": imgViewSelected,
            "imgViewRight": imgViewRight
        ]

        // Install fixed constraints
        var constraints = NSLayoutConstraint.constraints(withVisualFormat: "|[selectorView]|", options: [], metrics: nil, views: views)
        view.addConstraints(constraints)
        constraints = NSLayoutConstraint.constraints(withVisualFormat:
            "|-[imgViewLeft]-[imgViewSelected(==imgViewLeft)]-[imgViewRight(==imgViewLeft)]-|",
                                                     options: [],
                                                     metrics: nil,
                                                     views: views)
        view.addConstraints(constraints)

        // Save portrait constraints
        var top = isiPhoneXType() ? 40.0 : 20.0
        let metrics = ["top": top]
        constraintsPortraitArray = [
            NSLayoutConstraint.constraints(withVisualFormat: "V:|-(top)-[selectorView(==50)]-10-[imgViewLeft]-10-|", options: [], metrics: metrics, views: views),
            NSLayoutConstraint.constraints(withVisualFormat: "V:|-(top)-[selectorView(==50)]-10-[imgViewSelected]-10-|", options: [], metrics: metrics, views: views),
            NSLayoutConstraint.constraints(withVisualFormat: "V:|-(top)-[selectorView(==50)]-10-[imgViewRight]-10-|", options: [], metrics: metrics, views: views)
        ]

        // Save landscape constraints
        top = isiPhoneXType() ? 0.0 : 20.0
        constraintsLandscapeArray = [
            NSLayoutConstraint.constraints(withVisualFormat: "V:|-(top)-[selectorView(==50)]-10-[imgViewLeft]-10-|", options: [], metrics: metrics, views: views),
            NSLayoutConstraint.constraints(withVisualFormat: "V:|-(top)-[selectorView(==50)]-10-[imgViewSelected]-10-|", options: [], metrics: metrics, views: views),
            NSLayoutConstraint.constraints(withVisualFormat: "V:|-(top)-[selectorView(==50)]-10-[imgViewRight]-10-|", options: [], metrics: metrics, views: views)
        ]
    }

    func installConstraint(forOrientation orientation: UIInterfaceOrientation) {
        if orientation.isLandscape {
            for constraints in constraintsPortraitArray {
                if let constraints = constraints as? [NSLayoutConstraint] {
                    view.removeConstraints(constraints)
                }
            }
            for constraints in constraintsLandscapeArray {
                if let constraints = constraints as? [NSLayoutConstraint] {
                    view.addConstraints(constraints)
                }
            }
        } else {
            for constraints in constraintsLandscapeArray {
                if let constraints = constraints as? [NSLayoutConstraint] {
                    view.removeConstraints(constraints)
                }
            }
            for constraints in constraintsPortraitArray {
                if let constraints = constraints as? [NSLayoutConstraint] {
                    view.addConstraints(constraints)
                }
            }
        }
    }

    func imageFromIndex(_ index: Int) -> UIImage? {
        let name = items[index]

        return UIImage(named: "\(name).jpg")
    }

    //NOTE: GSSlidingSelectorDataSource

    func numberOfItemsInSlideSelector(_ selector: SlidingSelectorViewController!) -> Int {
        return items.count
    }

    func slideSelector(_ selector: SlidingSelectorViewController!, titleForItemAtIndex index: Int) -> String {
        return items[index] as? String ?? ""
    }

    //NOTE: GSSlidingSelectorDelegate

    func slideSelector(_ selector: SlidingSelectorViewController!, didSelectItemAtIndex index: Int) {
        if index == prevSelectedIndex {
            return
        }

        print("[GSSlidingSelectorViewController] Selected item at index: \(index) (\(items[index]))")

        var prevImage: UIImage?
        var selectedImage: UIImage?
        var nextImage: UIImage?

        if index > 0 {
            prevImage = imageFromIndex(index-1)
        }
        selectedImage = imageFromIndex(index)
        if index < items.count-1 {
            nextImage = imageFromIndex(index+1)
        }

        UIView.transition(with: imgViewLeft, duration: GSTransformImageAnimationTime, options: .transitionFlipFromLeft, animations: {
            self.imgViewLeft.image = prevImage
        }, completion: nil)

        UIView.transition(with: imgViewSelected, duration: GSTransformImageAnimationTime, options: .transitionFlipFromLeft, animations: {
            self.imgViewSelected.image = selectedImage
        }, completion: nil)

        UIView.transition(with: imgViewRight, duration: GSTransformImageAnimationTime, options: .transitionFlipFromLeft, animations: {
            self.imgViewRight.image = nextImage
        }, completion: nil)

        prevSelectedIndex = index
    }
}
