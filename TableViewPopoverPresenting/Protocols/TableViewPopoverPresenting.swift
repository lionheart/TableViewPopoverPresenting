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
    func viewControllerForPopoverAtPoint(point: CGPoint) -> UIViewController?
    func viewControllerForPopoverAtIndexPath(indexPath: NSIndexPath) -> UIViewController?
}

public protocol TableViewPopoverPresenting: class, TableViewPopoverPresentingHelper {
    var tableView: UITableView! { get }

    var popoverPresentingTapGestureRecognizer: UITapGestureRecognizer! { get set }
}

public extension TableViewPopoverPresenting where Self: UIViewController {
    /**
     This method instantiates `popoverPresentingTapGestureRecognizer` and adds it to the view controller's table view.

     - parameter selector: An Objective-C selector representing `popoverPresentingGestureDetected`.
     - author: Daniel Loewenherz
     - copyright: ©2016 Lionheart Software LLC
     - date: June 19, 2016
     */
    func initializeTableViewPopover() {
        popoverPresentingTapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(handlePopoverGesture(_:)))
        popoverPresentingTapGestureRecognizer.numberOfTapsRequired = 1
        popoverPresentingTapGestureRecognizer.delegate = self

        tableView.addGestureRecognizer(popoverPresentingTapGestureRecognizer)
    }

    func viewControllerForPopoverAtPoint(point: CGPoint) -> UIViewController? {
        guard let indexPath = tableView.indexPathForRowAtPoint(point) else {
            return nil
        }

        return viewControllerForPopoverAtIndexPath(indexPath)
    }
}

extension UIViewController: UIGestureRecognizerDelegate {
    public func gestureRecognizer(gestureRecognizer: UIGestureRecognizer, shouldReceiveTouch touch: UITouch) -> Bool {
        guard let controller = self as? TableViewPopoverPresenting else {
            return true
        }

        if gestureRecognizer is UITapGestureRecognizer {
            let location = touch.locationInView(controller.tableView)
            return controller.viewControllerForPopoverAtPoint(location) != nil
        }

        return false
    }

    func handlePopoverGesture(gesture: UIGestureRecognizer?) {
        guard let popoverPresenter = self as? TableViewPopoverPresenting else {
            return
        }

        let location = gesture!.locationInView(popoverPresenter.tableView)
        if let controller = popoverPresenter.viewControllerForPopoverAtPoint(location) {
            if let popover = controller.popoverPresentationController {
                popover.sourceView = popoverPresenter.tableView
                popover.sourceRect = CGRectMake(location.x, location.y, 1, 1)
            }

            presentViewController(controller, animated: true, completion: nil)
        }
    }
}