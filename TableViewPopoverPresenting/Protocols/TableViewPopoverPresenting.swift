//
//  TableViewPopoverPresenting.swift
//  Pods
//
//  Created by Daniel Loewenherz on 6/19/16.
//
//

import UIKit

protocol TableViewPopoverPresentingHelper: class {
    func viewControllerForPopoverAtPoint(point: CGPoint) -> UIViewController?
}

public protocol TableViewPopoverPresenting: class, UIGestureRecognizerDelegate {
    var tableView: UITableView! { get }

    /**
     - parameter indexPath: The indexPath to optionally provide a popover for.
     - returns: Optionally returns a UIViewController. If no view controller is returned, no popover will be displayed for this index path.
     - author: Daniel Loewenherz
     - copyright: ©2016 Lionheart Software LLC
     - date: June 19, 2016
     */
    func viewControllerForPopoverAtIndexPath(indexPath: NSIndexPath) -> UIViewController?
}

extension UIViewController: TableViewPopoverPresentingHelper {
    func viewControllerForPopoverAtPoint(point: CGPoint) -> UIViewController? {
        guard let controller = self as? TableViewPopoverPresenting,
            let indexPath = controller.tableView.indexPathForRowAtPoint(point) else {
            return nil
        }

        return controller.viewControllerForPopoverAtIndexPath(indexPath)
    }

    public func gestureRecognizer(gestureRecognizer: UIGestureRecognizer, shouldReceiveTouch touch: UITouch) -> Bool {
        guard let controller = self as? TableViewPopoverPresenting else {
            return true
        }

        if gestureRecognizer is UITapGestureRecognizer {
            let point = touch.locationInView(controller.tableView)
            return viewControllerForPopoverAtPoint(point) != nil
        }

        return false
    }

    @objc func handlePopoverGesture(gesture: UIGestureRecognizer?) {
        guard let popoverPresenter = self as? TableViewPopoverPresenting,
            let gesture = gesture else {
            return
        }

        let point = gesture.locationInView(popoverPresenter.tableView)
        guard let controller = viewControllerForPopoverAtPoint(point) else {
            return
        }

        controller.modalPresentationStyle = .Popover

        if let popover = controller.popoverPresentationController {
            popover.sourceView = popoverPresenter.tableView
            popover.sourceRect = CGRect(x: point.x, y: point.y, width: 1, height: 1)
        }

        presentViewController(controller, animated: true, completion: nil)
    }
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
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.handlePopoverGesture(_:)))
        tapGestureRecognizer.numberOfTapsRequired = 1
        tapGestureRecognizer.delegate = self as? UIGestureRecognizerDelegate

        tableView.addGestureRecognizer(tapGestureRecognizer)
    }
}