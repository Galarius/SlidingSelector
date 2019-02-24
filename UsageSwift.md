# Swift Usage Guide

1. Add folder `GSSlidingSelectorSwift` to your project.

2. `GSSlidingSelectorViewController` behaves like UITableViewController providing the folowing data source and delegate method definitions:
    
    ```swift
    func numberOfItemsInSlideSelector(_ selector: GSSlidingSelectorViewController!) -> Int
    ```

    ```swift
    func slideSelector(_ selector: GSSlidingSelectorViewController!, titleForItemAtIndex index: Int) -> String
    ```

    ```swift
    func slideSelector(_ selector: GSSlidingSelectorViewController!, didSelectItemAtIndex index: Int)
    ```

3. Extend your class like this:

    ```swift
    class SomeViewController: GSSlidingSelectorDataSource,GSSlidingSelectorDelegate {

        var selector: GSSlidingSelectorViewController!
        
        var items: NSArray = ["Mercury","Venus","Earth","Mars","Jupiter","Saturn","Uranus","Neptune","Pluto"];
    }
    ```

4. Create an instance of `GSSlidingSelectorViewController`:

    ```swift
    self.selector = GSSlidingSelectorViewController()
    self.selector.delegate = self
    self.selector.dataSource = self
    self.addChild(self.selector)
    self.view.addSubview(self.selector.view)
    self.selector.didMove(toParent: self)
    ```

5. Fill `GSSlidingSelectorViewController` by calling the method `reloadData`:

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

7. Implement `GSSlidingSelectorDataSource` and `GSSlidingSelectorDelegate` methods:

    ```objc
    #pragma mark - GSSlidingSelectorDataSource

    - (NSUInteger)numberOfItemsInSlideSelector:(GSSlidingSelectorViewController*)selector
    {
        return self.items.count;
    }

    - (NSString *)slideSelector:(GSSlidingSelectorViewController*)selector titleForItemAtIndex:(NSUInteger)index
    {
        return [self.items objectAtIndex:index];
    }

    #pragma mark - GSSlidingSelectorDelegate

    - (void)slideSelector:(GSSlidingSelectorViewController*)selector didSelectItemAtIndex:(NSUInteger)index
    {
        NSLog(@"Selected element at index: %lu (%@)", (unsigned long)index, [self.items objectAtIndex:index]);
        // Do something depending on the selected element ...
    }
    ```

    ```swift
    //NOTE: GSSlidingSelectorDataSource
    
    func numberOfItemsInSlideSelector(_ selector: GSSlidingSelectorViewController!) -> Int {
        return self.items.count
    }
    
    func slideSelector(_ selector: GSSlidingSelectorViewController!, titleForItemAtIndex index: Int) -> String {
        return self.items[index] as! String
    }
    
    //NOTE: GSSlidingSelectorDelegate
    
    func slideSelector(_ selector: GSSlidingSelectorViewController!, didSelectItemAtIndex index: Int) {
        
        print("[GSSlidingSelectorViewController] Selected item at index: \(index) (\(self.items[Int(index)]))")
        // Do something depending on the selected element ...
    }
    ```
