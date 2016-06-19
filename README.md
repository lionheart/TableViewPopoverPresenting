# TableViewPopoverPresenting

[![CI Status](http://img.shields.io/travis/Dan Loewenherz/TableViewPopoverPresenting.svg?style=flat)](https://travis-ci.org/Dan Loewenherz/TableViewPopoverPresenting)
[![Version](https://img.shields.io/cocoapods/v/TableViewPopoverPresenting.svg?style=flat)](http://cocoapods.org/pods/TableViewPopoverPresenting)
[![License](https://img.shields.io/cocoapods/l/TableViewPopoverPresenting.svg?style=flat)](http://cocoapods.org/pods/TableViewPopoverPresenting)
[![Platform](https://img.shields.io/cocoapods/p/TableViewPopoverPresenting.svg?style=flat)](http://cocoapods.org/pods/TableViewPopoverPresenting)

TableViewPopoverPresenting is a simple, drop-in protocol that gives your table views the power to display presented view controllers in popovers in reaction to a cell tap. It overrides the standard table view tap handler only for the cells which you define it for, and everything else falls back to your existing `didSelectRowAtIndexPath` implementation.

## Example

In the good ole' days, in order to present popovers over your table view cells, you had to do a few things:

1. Instantiate a `UITapGestureRecognizer`.
2. ...add it to your `UITableView`.
3. ...make your `UIViewController` conform to `UIGestureRecognizerDelegate`.
4. ...create a method to handle the tap.
5. ...make sure the tap gesture recognizer doesn't override the standard `UITableView` touch handlers for `didSelectRowAtIndexPath`.
6. ...present the view controller exactly where the user tapped.
7. Etc.

And each of these things requires going through StackOverflow posts with a fine-toothed comb to make sure you're doing everything the "right" way. Obviously, that's lame. You shouldn't need to do all of this work for something which should be simple. And that's where TableViewPopoverPresenting comes in.

## Installation

TableViewPopoverPresenting is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod "TableViewPopoverPresenting"
```

## Usage

1. Install TableViewPopoverPresenting through Cocoapods by adding the following line to your Podfile.

        ```ruby
        pod "TableViewPopoverPresenting"
        ```

2. Import `TableViewPopoverPresenting` in the file with your table view controller.

        import TableViewPopoverPresenting

Now, in each view controller you want to handle taps:

1. Define `popoverPresentingTapGestureRecognizer`.

        var popoverPresentingTapGestureRecognizer: UITapGestureRecognizer!

2. Call `initializeTableViewPopover` in your `viewDidLoad` method:

        initializeTableViewPopover(#selector(popoverPresentingGestureDetected(_:)))

3. Add this method:

        func popoverPresentingGestureDetected(gesture: UIGestureRecognizer?) {
            handlePopoverGesture(gesture)
        }

4. And, lastly, implement `viewControllerForPopoverAtIndexPath` to define which view controllers to show at which index paths. E.g.:

            func viewControllerForPopoverAtIndexPath(indexPath: NSIndexPath) -> UIViewController? {
                if indexPath.row == 0 {
                    let actionSheet = UIAlertController(title: "Important Question", message: "What's your favorite color?", preferredStyle: .ActionSheet)
                    actionSheet.addAction(UIAlertAction(title: "Red", style: .Default)) {}
                    actionSheet.addAction(UIAlertAction(title: "Green", style: .Default)) {}
                    actionSheet.addAction(UIAlertAction(title: "Blue", style: .Default)) {}
                    return actionSheet
                }
            }

You're done! A nice action sheet will appear when a tap is detected on the first row of any section. Easy, right?

## Requirements

None.

## Author

Dan Loewenherz, dan@lionheartsw.com

## License

TableViewPopoverPresenting is available under the Apache 2.0 license. See the [LICENSE](LICENSE) file for more info.
