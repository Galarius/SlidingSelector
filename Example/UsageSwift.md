# Swift Usage Guide

1. Add folder `SlidingSelectorSwift` to your project.

2. `SlidingSelectorViewController` behaves like UITableViewController providing the folowing data source and delegate method definitions:
    
    ```swift
    func numberOfItemsInSlideSelector(_ selector: SlidingSelectorViewController!) -> Int
    ```

    ```swift
    func slideSelector(_ selector: SlidingSelectorViewController!, titleForItemAtIndex index: Int) -> String
    ```

    ```swift
    func slideSelector(_ selector: SlidingSelectorViewController!, didSelectItemAtIndex index: Int)
    ```

3. Extend your class like this:

    ```swift
    class SomeViewController: SlidingSelectorDataSource,SlidingSelectorDelegate {

        var selector: SlidingSelectorViewController!
        
        var items: NSArray = ["Mercury","Venus","Earth","Mars","Jupiter","Saturn","Uranus","Neptune","Pluto"];
    }
    ```

4. Create an instance of `SlidingSelectorViewController`:

    ```swift
    self.selector = SlidingSelectorViewController()
    self.selector.delegate = self
    self.selector.dataSource = self
    self.addChild(self.selector)
    self.view.addSubview(self.selector.view)
    self.selector.didMove(toParent: self)
    ```

5. Fill `SlidingSelectorViewController` by calling the method `reloadData`:

    ```swift
    //...
    self.selector.reloadData()
    //...
    ```

6. Configure constraints, e.g. programmatically with visual format:

    ```swift
    self.selector.view.translatesAutoresizingMaskIntoConstraints   = false;
    let views: [String:UIView] = ["selectorView": self.selector.view]
    
    var constraintsH = NSLayoutConstraint.constraints(withVisualFormat: "|[selectorView]|", options: [], metrics: nil, views: views)

    var constraintsV = NSLayoutConstraint.constraints(withVisualFormat: "V:|[selectorView(==50)]", options: [], metrics: nil, views: views)    

    self.view.addConstraints(constraintsH)
    self.view.addConstraints(constraintsV)
    ```

7. Implement `SlidingSelectorDataSource` and `SlidingSelectorDelegate` methods:

    ```swift
    //NOTE: SlidingSelectorDataSource
    
    func numberOfItemsInSlideSelector(_ selector: SlidingSelectorViewController!) -> Int {
        return self.items.count
    }
    
    func slideSelector(_ selector: SlidingSelectorViewController!, titleForItemAtIndex index: Int) -> String {
        return self.items[index] as! String
    }
    
    //NOTE: SlidingSelectorDelegate
    
    func slideSelector(_ selector: SlidingSelectorViewController!, didSelectItemAtIndex index: Int) {
        
        print("[SlidingSelectorViewController] Selected item at index: \(index) (\(self.items[Int(index)]))")
        // Do something depending on the selected element ...
    }
    ```
