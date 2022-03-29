//
//  PresentationController.swift
//  ChaRo-iOS
//
//  Created by 황지은 on 2021/12/28.
//

import UIKit
import Then

class PresentationController: UIPresentationController {
    let backdropView = UIView().then {
        $0.backgroundColor = .black
    }
    
    override init(presentedViewController: UIViewController, presenting presentingViewController: UIViewController?) {
        super.init(presentedViewController: presentedViewController, presenting: presentingViewController)
    }
    
    override var frameOfPresentedViewInContainerView: CGRect {
        CGRect(origin: CGPoint(x: 0, y: self.containerView!.frame.height * 0.4),
               size: CGSize(width: self.containerView!.frame.width, height: self.containerView!.frame.height *
                0.6))
    }

    override func presentationTransitionWillBegin() {
        backdropView.alpha = 0
        containerView?.addSubview(backdropView)
        presentedViewController.transitionCoordinator?.animate(alongsideTransition: { [self] (UIViewControllerTransitionCoordinatorContext) in
            backdropView.alpha = 0.5
        }, completion: {
            (UIViewControllerTransitionCoordinatorContext) in
            
        })
    }
    
    override func dismissalTransitionWillBegin() {
        presentedViewController.transitionCoordinator?.animate(alongsideTransition: { [self] (UIViewControllerTransitionCoordinatorContext) in
            backdropView.alpha = 0
        }, completion: {
            (UIViewControllerTransitionCoordinatorContext) in
            self.backdropView.removeFromSuperview()
        })
    }
    
    override func containerViewWillLayoutSubviews() {
        super.containerViewWillLayoutSubviews()
    }

    override func containerViewDidLayoutSubviews() {
        super.containerViewDidLayoutSubviews()
        
        presentedView?.frame = frameOfPresentedViewInContainerView
        backdropView.frame = containerView!.bounds
    }

    @objc func dismissController() {
        self.presentedViewController.dismiss(animated: true, completion: nil)
    }
  }

