//
//  ViewController.swift
//  TMFlingUpCards
//
//  Created by Travis Ma on 8/1/16.
//  Copyright © 2016 Travis Ma. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var constraintView1Height: NSLayoutConstraint!
    @IBOutlet weak var constraintView1Width: NSLayoutConstraint!
    @IBOutlet weak var constraintView2Height: NSLayoutConstraint!
    @IBOutlet weak var constraintView2Width: NSLayoutConstraint!
    @IBOutlet weak var constraintView3Height: NSLayoutConstraint!
    @IBOutlet weak var constraintView3Width: NSLayoutConstraint!
    @IBOutlet weak var constraintView2Bottom: NSLayoutConstraint!
    @IBOutlet weak var constraintView3Bottom: NSLayoutConstraint!
    @IBOutlet weak var constraintView1Bottom: NSLayoutConstraint!
    @IBOutlet weak var view3: UIView!
    @IBOutlet weak var view2: UIView!
    @IBOutlet weak var view1: UIView!
    var originBottomConstantView1: CGFloat = 0
    var originBottomConstantView2: CGFloat = 0
    var originBottomConstantView3: CGFloat = 0
    var sizeView1: CGFloat = 0
    var sizeView2: CGFloat = 0
    var sizeView3: CGFloat = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        if originBottomConstantView1 == 0 {
            originBottomConstantView1 = constraintView1Bottom.constant
            originBottomConstantView2 = constraintView2Bottom.constant
            originBottomConstantView3 = constraintView3Bottom.constant
            sizeView1 = constraintView1Width.constant
            sizeView2 = constraintView2Width.constant
            sizeView3 = constraintView3Width.constant
        }
    }
    
    func moveViewsForward() {
        self.view.isUserInteractionEnabled = false
        view1.isHidden = true
        constraintView1Height.constant = sizeView1
        constraintView1Width.constant = sizeView1
        constraintView1Bottom.constant = originBottomConstantView1
        constraintView2Height.constant = sizeView1
        constraintView2Width.constant = sizeView1
        constraintView2Bottom.constant = originBottomConstantView1
        constraintView3Height.constant = sizeView2
        constraintView3Width.constant = sizeView2
        constraintView3Bottom.constant = originBottomConstantView2
        UIView.animate(withDuration: 0.6, animations: {
            self.view.layoutIfNeeded()
            }, completion: { completed in
                let view1Color = self.view1.backgroundColor
                self.view1.backgroundColor = self.view2.backgroundColor
                self.view2.backgroundColor = self.view3.backgroundColor
                self.view3.backgroundColor = view1Color
                self.view1.isHidden = false
                self.constraintView2Height.constant = self.sizeView2
                self.constraintView2Width.constant = self.sizeView2
                self.constraintView2Bottom.constant = self.originBottomConstantView2
                self.view.layoutIfNeeded()
                self.constraintView3Height.constant = self.sizeView3
                self.constraintView3Width.constant = self.sizeView3
                self.constraintView3Bottom.constant = self.originBottomConstantView3
                UIView.animate(withDuration: 0.2, animations: {
                    self.view.layoutIfNeeded()
                    }, completion: { completed in
                        self.view.isUserInteractionEnabled = true
                })
        })
    }
    
    @IBAction func handlePan(_ sender: UIPanGestureRecognizer) {
        let translation = sender.translation(in: sender.view)
        let velocity = sender.velocity(in: sender.view)
        switch sender.state {
        case .began:
            break
        case .changed:
            constraintView1Bottom.constant = constraintView1Bottom.constant - translation.y
            break
        case .ended:
            if velocity.y < -1000 {
                self.view.isUserInteractionEnabled = false
                constraintView1Bottom.constant = self.view.frame.height
                let remainingY = self.view.frame.height - view1.frame.origin.y
                let duration = TimeInterval(remainingY / velocity.y)
                UIView.animate(withDuration: duration, animations: {
                    self.view.layoutIfNeeded()
                    }, completion: { completed in
                        self.moveViewsForward()
                })
            } else {
                self.view.isUserInteractionEnabled = false
                self.constraintView1Bottom.constant = self.originBottomConstantView1
                UIView.animate(withDuration: 0.6, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0.8, options: [], animations: {
                    self.view.layoutIfNeeded()
                    }, completion: { completed in
                        self.view.isUserInteractionEnabled = true
                })
            }
            break
        default:
            break
        }
        sender.setTranslation(CGPoint.zero, in: sender.view)
    }
    
}

