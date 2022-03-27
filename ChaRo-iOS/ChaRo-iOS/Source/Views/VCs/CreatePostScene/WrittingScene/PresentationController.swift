//
//  PresentationController.swift
//  ChaRo-iOS
//
//  Created by 황지은 on 2021/12/28.
//

import UIKit

class PresentationController: UIPresentationController {
    let blurEffectView: UIVisualEffectView!
    
    override init(presentedViewController: UIViewController, presenting presentingViewController: UIViewController?) {
        
        let blurEffect = UIBlurEffect(style: .dark)
        blurEffectView = UIVisualEffectView(effect: blurEffect)
        
        super.init(presentedViewController: presentedViewController, presenting: presentingViewController)
    }
    
    override var frameOfPresentedViewInContainerView: CGRect {
        CGRect(origin: CGPoint(x: 0, y: self.containerView!.frame.height * 0.4),
               size: CGSize(width: self.containerView!.frame.width, height: self.containerView!.frame.height *
                0.6))
    }

    override func presentationTransitionWillBegin() {
        blurEffectView.alpha = 0
        containerView?.addSubview(blurEffectView)
        presentedViewController.transitionCoordinator?.animate(alongsideTransition: { [self] (UIViewControllerTransitionCoordinatorContext) in
            blurEffectView.alpha = 0.7
        }, completion: {
            (UIViewControllerTransitionCoordinatorContext) in
            
        })
    }
    
    override func dismissalTransitionWillBegin() {
        presentedViewController.transitionCoordinator?.animate(alongsideTransition: { [self] (UIViewControllerTransitionCoordinatorContext) in
            blurEffectView.alpha = 0
        }, completion: {
            (UIViewControllerTransitionCoordinatorContext) in
            self.blurEffectView.removeFromSuperview()
        })
    }
    
    override func containerViewWillLayoutSubviews() {
        super.containerViewWillLayoutSubviews()
    }

    override func containerViewDidLayoutSubviews() {
        super.containerViewDidLayoutSubviews()
        
        presentedView?.frame = frameOfPresentedViewInContainerView
        blurEffectView.frame = containerView!.bounds
    }

    @objc func dismissController() {
        self.presentedViewController.dismiss(animated: true, completion: nil)
    }
  }

