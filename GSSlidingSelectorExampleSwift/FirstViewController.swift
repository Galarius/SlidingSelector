/*!
 * \file FirstViewController.swift
 * \author Galarius
 * \date 24.02.2019
 * \copyright (c) 2019 galarius. All rights reserved.
 */

import UIKit

let GSDefaultSelectedIndex : Int = 3;   // [1 - 7]
let GSTransformImageAnimationTime : TimeInterval = 0.4;

class FirstViewController: UIViewController,GSSlidingSelectorDataSource,GSSlidingSelectorDelegate {
    
    var selector: GSSlidingSelectorViewController!
    var imgViewLeft: UIImageView!
    var imgViewSelected: UIImageView!
    var imgViewRight: UIImageView!
    
    var constraintsPortraitArray: NSArray = []
    var constraintsLandscapeArray: NSArray = []
    var prevSelectedIndex: Int = 0
    
    var items: NSArray = ["Mercury","Venus","Earth","Mars",
                          "Jupiter","Saturn","Uranus","Neptune","Pluto"];
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        self.view.backgroundColor = GSSlidingSelectorStyle.shared.mainColor
        self.edgesForExtendedLayout = []
        self.tabBarController?.tabBar.backgroundColor = UIColor.yellow
        
        // Create GSSlidingSelectorViewController
        self.selector = GSSlidingSelectorViewController()
        self.selector.delegate = self
        self.selector.dataSource = self
        self.addChild(self.selector)
        self.view.addSubview(self.selector.view)
        self.selector.didMove(toParent: self)
        
        // Create Image Views
        
        self.imgViewLeft = UIImageView()
        self.imgViewLeft.contentMode = .scaleAspectFit
        self.imgViewLeft.clipsToBounds = true
        self.view.addSubview(self.imgViewLeft)
        
        self.imgViewSelected = UIImageView()
        self.imgViewSelected.contentMode = .scaleAspectFit
        self.imgViewSelected.clipsToBounds = true
        self.view.addSubview(self.imgViewSelected)
        
        self.imgViewRight = UIImageView()
        self.imgViewRight.contentMode = .scaleAspectFit
        self.imgViewRight.clipsToBounds = true
        self.view.addSubview(self.imgViewRight)
        
        self.selector.reloadData()
        self.selector.selectedIndex = GSDefaultSelectedIndex
        self.prevSelectedIndex = GSDefaultSelectedIndex
        
        // Set default images
        self.imgViewLeft.image = self.imageFromIndex(GSDefaultSelectedIndex-1)
        self.imgViewSelected.image = self.imageFromIndex(GSDefaultSelectedIndex)
        self.imgViewRight.image = self.imageFromIndex(GSDefaultSelectedIndex+1)
        
        // Setup Constraints Programmatically
        self.setupConstraints()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let orientation = UIApplication.shared.statusBarOrientation
        self.installConstraint(forOrientation: orientation)
    }
    
    override func  viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        
        coordinator.animate(alongsideTransition: {
            _ in
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
    
    func isiPhoneXType() -> Bool
    {
        let h = UIScreen.main.nativeBounds.size.height
        if(h == 2436 /*iPhone X, Xs*/  ||
           h == 2688 /*iPhone Xs Max*/ ||
           h == 1792 /*iPhone Xr*/) {
            return true;
        }
        return false;
    }
    
    func setupConstraints() {
        self.selector.view.translatesAutoresizingMaskIntoConstraints   = false;
        self.imgViewLeft.translatesAutoresizingMaskIntoConstraints     = false;
        self.imgViewSelected.translatesAutoresizingMaskIntoConstraints = false;
        self.imgViewRight.translatesAutoresizingMaskIntoConstraints    = false;
        
        let views: [String:UIView] = [
            "selectorView"    : self.selector.view,
            "imgViewLeft"     : self.imgViewLeft,
            "imgViewSelected" : self.imgViewSelected,
            "imgViewRight"    : self.imgViewRight,
        ]
        
        // Install fixed constraints
        var constraints = NSLayoutConstraint.constraints(withVisualFormat: "|[selectorView]|", options: [], metrics: nil, views: views)
        self.view.addConstraints(constraints)
        constraints = NSLayoutConstraint.constraints(withVisualFormat: "|-[imgViewLeft]-[imgViewSelected(==imgViewLeft)]-[imgViewRight(==imgViewLeft)]-|", options: [], metrics: nil, views: views)
        self.view.addConstraints(constraints)

        // Save portrait constraints
        var top = self.isiPhoneXType() ? 40.0 : 20.0
        let metrics = ["top": top]
        self.constraintsPortraitArray = [
            NSLayoutConstraint.constraints(withVisualFormat: "V:|-(top)-[selectorView(==50)]-10-[imgViewLeft]-10-|", options: [], metrics: metrics, views: views),
            NSLayoutConstraint.constraints(withVisualFormat: "V:|-(top)-[selectorView(==50)]-10-[imgViewSelected]-10-|", options: [], metrics: metrics, views: views),
            NSLayoutConstraint.constraints(withVisualFormat: "V:|-(top)-[selectorView(==50)]-10-[imgViewRight]-10-|", options: [], metrics: metrics, views: views),
        ]
        
        // Save landscape constraints
        top = self.isiPhoneXType() ? 0.0 : 20.0
        self.constraintsLandscapeArray = [
            NSLayoutConstraint.constraints(withVisualFormat: "V:|-(top)-[selectorView(==50)]-10-[imgViewLeft]-10-|", options: [], metrics: metrics, views: views),
            NSLayoutConstraint.constraints(withVisualFormat: "V:|-(top)-[selectorView(==50)]-10-[imgViewSelected]-10-|", options: [], metrics: metrics, views: views),
            NSLayoutConstraint.constraints(withVisualFormat: "V:|-(top)-[selectorView(==50)]-10-[imgViewRight]-10-|", options: [], metrics: metrics, views: views),
        ]
    }
    
    func installConstraint(forOrientation orientation: UIInterfaceOrientation)
    {
        if orientation.isLandscape {
            for constraints in self.constraintsPortraitArray {
                self.view.removeConstraints(constraints as! [NSLayoutConstraint])
            }
            for constraints in self.constraintsLandscapeArray {
                self.view.addConstraints(constraints as! [NSLayoutConstraint])
            }
        } else {
            for constraints in self.constraintsLandscapeArray {
                self.view.removeConstraints(constraints as! [NSLayoutConstraint])
            }
            for constraints in self.constraintsPortraitArray {
                self.view.addConstraints(constraints as! [NSLayoutConstraint])
            }
        }
    }
    
    func imageFromIndex(_ index: Int) -> UIImage?
    {
        let name = self.items[index]
        
        return UIImage(named: "\(name).jpg");
    }
    
    //NOTE: GSSlidingSelectorDataSource
    
    func numberOfItemsInSlideSelector(_ selector: GSSlidingSelectorViewController!) -> Int {
        return self.items.count
    }
    
    func slideSelector(_ selector: GSSlidingSelectorViewController!, titleForItemAtIndex index: Int) -> String {
        return self.items[index] as! String
    }
    
    //NOTE: GSSlidingSelectorDelegate
    
    func slideSelector(_ selector: GSSlidingSelectorViewController!, didSelectItemAtIndex index: Int) {
        if index == self.prevSelectedIndex {
            return
        }
        
        print("[GSSlidingSelectorViewController] Selected item at index: \(index) (\(self.items[index]))")
        
        var prevImage: UIImage?
        var selectedImage: UIImage?
        var nextImage: UIImage?
        
        if index > 0 {
            prevImage = self.imageFromIndex(index-1)
        }
        selectedImage = self.imageFromIndex(index)
        if(index < self.items.count-1) {
            nextImage = self.imageFromIndex(index+1)
        }
        
        UIView.transition(with: self.imgViewLeft, duration: GSTransformImageAnimationTime, options: .transitionFlipFromLeft, animations: {
            self.imgViewLeft.image = prevImage
        }, completion: nil)
        
        UIView.transition(with: self.imgViewSelected, duration: GSTransformImageAnimationTime, options: .transitionFlipFromLeft, animations: {
            self.imgViewSelected.image = selectedImage
        }, completion: nil)
        
        UIView.transition(with: self.imgViewRight, duration: GSTransformImageAnimationTime, options: .transitionFlipFromLeft, animations: {
            self.imgViewRight.image = nextImage
        }, completion: nil)
        
        self.prevSelectedIndex = index;
    }

}

