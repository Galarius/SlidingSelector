# GSSlidingSelector

[![GitHub license](https://img.shields.io/github/license/galarius/GSSlidingSelector.svg)](https://github.com/galarius/GSSlidingSelector/blob/master/LICENSE)
![platform](https://img.shields.io/badge/platform-ios-lightgrey.svg)
![language](https://img.shields.io/badge/language-objc-orange.svg)

`GSSlidingSelector` is a controller for selecting a small fixed amount of elements with swipe gestures.

![](assets/screen.png)

*Inspired by [Figure](https://itunes.apple.com/us/app/figure-make-music-beats/id511269223) app*

## Example

The example project is located under `GSSlidingSelectorExample` folder. Watch an [animated demo](assets/example.gif).

## Usage

1. Add folder `GSSlidingSelector` to your project.

2. `GSSlidingSelectorViewController` behaves like UITableViewController providing the folowing data source and delegate method definitions:

    ```objc
    - (NSUInteger)numberOfItemsInSlideSelector:(GSSlidingSelectorViewController*)selector;
    ```

    ```objc
    - (NSString *)slideSelector:(GSSlidingSelectorViewController*)selector titleForItemAtIndex:(NSUInteger)index;
    ```

    ```objc
    - (void)slideSelector:(GSSlidingSelectorViewController*)selector didSelectItemAtIndex:(NSUInteger)index;
    ```

3. Import `GSSlidingSelectorViewController.h`:

    ```objc
    #import "GSSlidingSelectorViewController.h"
    ```

4. Extend your interface like this:

    ```objc
    @interface SomeViewController () <GSSlidingSelectorDelegate, GSSlidingSelectorDataSource>

    @property (strong, nonatomic) GSSlidingSelectorViewController *selector;

    @property (strong, nonatomic) NSArray *items;

    @end
    ```

5. Allocate and initialize an instance of `GSSlidingSelectorViewController`:

    ```objc
    _selector = [[GSSlidingSelectorViewController alloc] init];
    self.selector.delegate = self;
    self.selector.dataSource = self;

    [self addChildViewController:self.selector];
    [self.view addSubview:self.selector.view];
    [self.selector didMoveToParentViewController:self];
    ```

6. Create an array of elements and fill `GSSlidingSelectorViewController` by calling the method `reloadData`:

    ```objc
    _items = @[@"Item 1", @"Item 2", @"Item 3", @"Item 4"];

    [self.selector reloadData];
    ```

7. Configure constraints, e.g. programmatically with visual format:

    ```objc
    self.selector.view.translatesAutoresizingMaskIntoConstraints = NO;
    NSDictionary *views = @{@"selectorView":self.selector.view};
    NSArray *constraintsH = [NSLayoutConstraint constraintsWithVisualFormat:@"|[selectorView]|"
                                                 options:0 metrics:nil views:views];
    NSArray *constraintsV = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|[selectorView(==50)]"
                                                 options:0 metrics:nil views:views];
    [self.view addConstraints:constraintsH];
    [self.view addConstraints:constraintsV];
    ```

8. Implement `GSSlidingSelectorDataSource` and `GSSlidingSelectorDelegate` methods:

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

## License

`GSSlidingSelector` is released under the MIT license. 

See [LICENSE](https://github.com/galarius/GSSlidingSelector/blob/master/LICENSE) for details.

Images are provided on the terms of personal, non commercial use by `bytecodeminer` from [alphacoders.com](https://wall.alphacoders.com/big.php?i=725422).