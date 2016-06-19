//
//  TableViewPopoverPresenting.swift
//  Pods
//
//  Created by Daniel Loewenherz on 6/19/16.
//
//

import UIKit

public protocol TableViewPopoverPresentingHelper: class {
    /**
     - parameter indexPath: The indexPath to optionally provide a popover for.
     - returns: Optionally returns a UIViewController. If no view controller is returned, no popover will be displayed for this index path.
     - author: Daniel Loewenherz
     - copyright: ©2016 Lionheart Software LLC
     - date: June 19, 2016
     */
    func viewControllerForPopoverAtIndexPath(indexPath: NSIndexPath) -> UIViewController?
}

public protocol TableViewPopoverPresenting: class, TableViewPopoverPresentingHelper {
    var tableView: UITableView! { get }

    var popoverPresentingTapGestureRecognizer: UITapGestureRecognizer! { get set }

    /**
     You shouldn't do anything with this function besides what's included in the README. It's essentially meant to be a placeholder for an Objective-C function that can be passed to #selector (Swift functions are not dynamic and can't be specified as dynamic as a part of a protocol definition, hence this workaround).

     - parameter gesture: The gesture passed to the handler. Should always be `popoverPresentingTapGestureRecognizer`.
     - author: Daniel Loewenherz
     - copyright: ©2016 Lionheart Software LLC
     - date: June 19, 2016
     */
    func popoverPresentingGestureDetected(gesture: UIGestureRecognizer?)
}

public extension TableViewPopoverPresenting where Self: UIViewController {
    /**
     This method instantiates `popoverPresentingTapGestureRecognizer` and adds it to the view controller's table view.

     - parameter selector: An Objective-C selector representing `popoverPresentingGestureDetected`.
     - author: Daniel Loewenherz
     - copyright: ©2016 Lionheart Software LLC
     - date: June 19, 2016
     */
    func initializeTableViewPopover(selector: Selector) {
        popoverPresentingTapGestureRecognizer = UITapGestureRecognizer(target: self, action: selector)
        popoverPresentingTapGestureRecognizer.numberOfTapsRequired = 1
        popoverPresentingTapGestureRecognizer.delegate = self as? UIGestureRecognizerDelegate

        tableView.addGestureRecognizer(popoverPresentingTapGestureRecognizer)
    }

    private func viewControllerForPopoverAtPoint(point: CGPoint) -> UIViewController? {
        guard let indexPath = tableView.indexPathForRowAtPoint(point) else {
            return nil
        }

        return viewControllerForPopoverAtIndexPath(indexPath)
    }

    func handlePopoverGesture(gesture: UIGestureRecognizer?) {
        let location = gesture!.locationInView(tableView)
        if let controller = viewControllerForPopoverAtPoint(location) {
            if let popover = controller.popoverPresentationController {
                popover.sourceView = tableView
                popover.sourceRect = CGRectMake(location.x, location.y, 1, 1)
            }

            presentViewController(controller, animated: true, completion: nil)
        }
    }

    private func gestureRecognizer(gestureRecognizer: UIGestureRecognizer, shouldReceiveTouch touch: UITouch) -> Bool {
        if gestureRecognizer is UITapGestureRecognizer {
            let location = touch.locationInView(tableView)
            return viewControllerForPopoverAtPoint(location) != nil
        }
        
        return false
    }
}