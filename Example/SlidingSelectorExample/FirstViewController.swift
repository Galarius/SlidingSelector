//
//  FirstViewController.swift
//  GSSlidingSelector
//
//  Created by galarius on 23.02.2019.
//  Copyright © 2019 galarius. All rights reserved.
//

import UIKit
import SlidingSelector

final class FirstViewController: UIViewController, SlidingSelectorDelegate {

    @IBOutlet private var selector: SlidingSelectorViewController!
    @IBOutlet private var imgViewLeft: UIImageView!
    @IBOutlet private var imgViewSelected: UIImageView!
    @IBOutlet private var imgViewRight: UIImageView!

    private var prevSelectedIndex = 3
    private let defaultSelectedIndex = 3
    private let animationTime: TimeInterval = 0.4
    private let items  = ["Mercury", "Venus", "Earth", "Mars", "Jupiter", "Saturn", "Uranus", "Neptune", "Pluto"]

    override func viewDidLoad() {
        super.viewDidLoad()

        selector.items = items
        selector.delegate = self
        selector.setSelectedIndex(defaultSelectedIndex, animated: false)

        // Set default images
        imgViewLeft.image = imageFromIndex(defaultSelectedIndex - 1)
        imgViewSelected.image = imageFromIndex(defaultSelectedIndex)
        imgViewRight.image = imageFromIndex(defaultSelectedIndex + 1)

        view.backgroundColor = UIColor(red: 240/255.0, green: 235/255.0, blue: 180/255.0, alpha: 1.0)
        edgesForExtendedLayout = []
        tabBarController?.tabBar.backgroundColor = view.backgroundColor
    }

    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
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

    private func imageFromIndex(_ index: Int) -> UIImage? {
        let name = items[index]
        return UIImage(named: "\(name).jpg")
    }

    // NOTE: - SlidingSelectorDelegate

    func slideSelector(_ selector: SlidingSelectorViewController!, didSelectItemAtIndex index: Int) {
        if index == prevSelectedIndex {
            return
        }

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

        UIView.transition(with: imgViewLeft, duration: animationTime, options: .transitionFlipFromLeft, animations: {
            self.imgViewLeft.image = prevImage
        }, completion: nil)

        UIView.transition(with: imgViewSelected, duration: animationTime, options: .transitionFlipFromLeft, animations: {
            self.imgViewSelected.image = selectedImage
        }, completion: nil)

        UIView.transition(with: imgViewRight, duration: animationTime, options: .transitionFlipFromLeft, animations: {
            self.imgViewRight.image = nextImage
        }, completion: nil)

        prevSelectedIndex = index
    }
}
