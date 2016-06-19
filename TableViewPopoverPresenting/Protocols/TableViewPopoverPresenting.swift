//
//  TableViewPopoverPresenting.swift
//  Pods
//
//  Created by Daniel Loewenherz on 6/19/16.
//
//

import UIKit

public protocol TableViewPopoverPresentingHelper: class {
    func viewControllerForPopoverAtIndexPath(indexPath: NSIndexPath) -> UIViewController?
}

public protocol TableViewPopoverPresenting: class, TableViewPopoverPresentingHelper {
    var tableView: UITableView! { get }
    var popoverPresentingTapGestureRecognizer: UITapGestureRecognizer! { get set }
    func popoverPresentingGestureDetected(gesture: UIGestureRecognizer?)
}

public extension TableViewPopoverPresenting where Self: UIViewController {
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

    func gestureRecognizer(gestureRecognizer: UIGestureRecognizer, shouldReceiveTouch touch: UITouch) -> Bool {
        if gestureRecognizer is UITapGestureRecognizer {
            let location = touch.locationInView(tableView)
            return viewControllerForPopoverAtPoint(location) != nil
        }
        
        return false
    }
}