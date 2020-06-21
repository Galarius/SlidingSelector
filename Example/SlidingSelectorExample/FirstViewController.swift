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

final class FirstViewController: UIViewController, SlidingSelectorDelegate {

    @IBOutlet var selector: SlidingSelectorViewController!

    @IBOutlet var imgViewLeft: UIImageView!
    @IBOutlet var imgViewSelected: UIImageView!
    @IBOutlet var imgViewRight: UIImageView!

    var prevSelectedIndex: Int = 0

    var items  = ["Mercury", "Venus", "Earth", "Mars", "Jupiter", "Saturn", "Uranus", "Neptune", "Pluto"]

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        selector.items = items
        selector.delegate = self
        selector.setSelectedIndex(GSDefaultSelectedIndex, animated: false)
        prevSelectedIndex = GSDefaultSelectedIndex

        // Set default images
        imgViewLeft.image = imageFromIndex(GSDefaultSelectedIndex-1)
        imgViewSelected.image = imageFromIndex(GSDefaultSelectedIndex)
        imgViewRight.image = imageFromIndex(GSDefaultSelectedIndex+1)

        view.backgroundColor = UIColor(red: 240/255.0, green: 235/255.0, blue: 180/255.0, alpha: 1.0)
        edgesForExtendedLayout = []
        tabBarController?.tabBar.backgroundColor = view.backgroundColor
    }

    override func  viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        coordinator.animate(alongsideTransition: { _ in
                let orientation = UIApplication.shared.statusBarOrientation
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

    func imageFromIndex(_ index: Int) -> UIImage? {
        let name = items[index]
        return UIImage(named: "\(name).jpg")
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
