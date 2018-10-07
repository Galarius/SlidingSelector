# GSSlidingSelector

[![GitHub license](https://img.shields.io/github/license/galarius/GSSlidingSelector.svg)](https://github.com/galarius/GSSlidingSelector/blob/master/LICENSE)
![platform](https://img.shields.io/badge/platform-ios-lightgrey.svg)
![language](https://img.shields.io/badge/language-objc-orange.svg)

Controller for selecting items with swipe gestures.

![](assets/example.gif)

*Inspired by [Figure](https://itunes.apple.com/us/app/figure-make-music-beats/id511269223) app*

## Usage

1. Add folder `GSSlidingSelector` to your project.

2. In your `UIViewController` import `GSSlidingSelectorViewController.h`:

    ```objc
    #import "GSSlidingSelectorViewController.h"
    ```

3. Extend your interface like this:

    ```objc
    @interface SomeViewController () <GSSlidingSelectorDelegate, GSSlidingSelectorDataSource>

    @property (strong, nonatomic) GSSlidingSelectorViewController *selector;
    @property (strong, nonatomic) NSArray *items;

    @end
    ```

4. In `-(void)viewDidLoad` add the following:

    ```objc
    _selector = [[GSSlidingSelectorViewController alloc] init];
    self.selector.delegate = self;
    self.selector.dataSource = self;

    [self addChildViewController:self.selector];
    [self.view addSubview:self.selector.view];
    [self.selector didMoveToParentViewController:self];

    _items = @[@"Item 1", @"Item 2", @"Item 3", @"Item 4"];

    [self.selector reloadData];
    ```

5. Configure constraints, e.g. programmatically with visual format:

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

    Or just set the frame like this:

    ```objc
    self.selector.view.frame = CGRectMake(0, 0, CGRectGetWidth(self.view.frame), 50);
    ```

6. Implement `GSSlidingSelectorDataSource` and `GSSlidingSelectorDelegate` protocol methods:

    ```objc
    #pragma mark - GSSlidingSelectorDelegate

    - (NSUInteger)numberOfItemsInSlideSelector:(GSSlidingSelectorViewController*)selector
    {
        return self.items.count;
    }

    - (NSString *)slideSelector:(GSSlidingSelectorViewController*)selector titleForItemAtIndex:(NSUInteger)index
    {
        return [self.items objectAtIndex:index];
    }

    - (void)slideSelector:(GSSlidingSelectorViewController*)selector didSelectItemAtIndex:(NSUInteger)index
    {
        NSLog(@"Selected item at index: %lu (%@)", (unsigned long)index, [self.items objectAtIndex:index]);
        // Do something depending on selected item ...
    }
    ```

## Example

The example project is located under `GSSlidingSelectorExample` folder.

## License

GSSlidingSelector is released under the MIT license. See [LICENSE](https://github.com/galarius/GSSlidingSelector/blob/master/LICENSE) for details.

