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
    func permittedArrowDirectionsForPopoverAtPoint(point: CGPoint) -> UIPopoverArrowDirection
}

public protocol TableViewPopoverPresenting: class {
    var tableView: UITableView! { get }

    /**
     - parameter indexPath: The indexPath to optionally provide a popover for.
     - returns: Optionally returns a UIViewController. If no view controller is returned, no popover will be displayed for this index path.
     - author: Daniel Loewenherz
     - copyright: ©2016 Lionheart Software LLC
     - date: June 19, 2016
     */
    func viewControllerForPopoverAtIndexPath(indexPath: NSIndexPath) -> UIViewController?
    func permittedArrowDirectionsForPopoverAtIndexPath(indexPath: NSIndexPath) -> UIPopoverArrowDirection?
}

extension UIViewController: TableViewPopoverPresentingHelper {
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

    func viewControllerForPopoverAtPoint(point: CGPoint) -> UIViewController? {
        guard let controller = self as? TableViewPopoverPresenting,
            let indexPath = controller.tableView.indexPathForRowAtPoint(point) else {
            return nil
        }

        return controller.viewControllerForPopoverAtIndexPath(indexPath)
    }

    func permittedArrowDirectionsForPopoverAtPoint(point: CGPoint) -> UIPopoverArrowDirection {
        guard let controller = self as? TableViewPopoverPresenting,
            let indexPath = controller.tableView.indexPathForRowAtPoint(point),
            let permittedArrowDirections = controller.permittedArrowDirectionsForPopoverAtIndexPath(indexPath) else {
                return .Any
        }

        return permittedArrowDirections
    }

    @objc private func handlePopoverGesture(gesture: UIGestureRecognizer?) {
        guard let popoverPresenter = self as? TableViewPopoverPresenting,
            let point = gesture?.locationInView(popoverPresenter.tableView),
            let controller = viewControllerForPopoverAtPoint(point) else {
                return
        }

        controller.modalPresentationStyle = .Popover

        if let popover = controller.popoverPresentationController {
            popover.sourceView = popoverPresenter.tableView
            popover.permittedArrowDirections = permittedArrowDirectionsForPopoverAtPoint(point)

            // MARK: TODO
//            let size = CGSize.zero
            popover.sourceRect = CGRect(origin: point, size: CGSize(width: 1, height: 1))
        }

        presentViewController(controller, animated: true, completion: nil)
    }
}

// MARK: -

public class TableViewPopoverPresentingGestureHandler: NSObject, UIGestureRecognizerDelegate {
    var controller: TableViewPopoverPresenting!

    init(_ theController: TableViewPopoverPresenting) {
        super.init()

        controller = theController
    }

    public func gestureRecognizer(gestureRecognizer: UIGestureRecognizer, shouldReceiveTouch touch: UITouch) -> Bool {
        if gestureRecognizer is UITapGestureRecognizer {
            let point = touch.locationInView(controller.tableView)

            if let helper = controller as? TableViewPopoverPresentingHelper {
                return helper.viewControllerForPopoverAtPoint(point) != nil
            }
        }

        return false
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
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(handlePopoverGesture(_:)))
        tapGestureRecognizer.numberOfTapsRequired = 1

        let handler = TableViewPopoverPresentingGestureHandler(self)
        tapGestureRecognizer.delegate = handler

        tableView.addGestureRecognizer(tapGestureRecognizer)
    }
}