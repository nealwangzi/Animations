//
//  DetailViewController.swift
//  Animations
//
//  Created by neal on 2017/7/11.
//  Copyright © 2017年 Cloudoc. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {

    //MARK: - Variables
    
    var barTitle = ""
    var animateView: UIView!
    fileprivate let duration = 2.0
    fileprivate let delay = 0.2
    fileprivate let scale = 1.2
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupRect()
        setupNavigationBar()

    }

    fileprivate func setupNavigationBar() {
        navigationController?.navigationBar.topItem?.title = barTitle
    }
    
    func setupRect() -> Void {
        if barTitle == "BezierCurve Position" {
            animateView = drawCircleView()
        }else if barTitle == "View Fade In" {
            animateView = UIImageView(image: UIImage(named: "whatsapp"))
            animateView.frame = generalFrame
            animateView.center = generalCenter
        }else {
            animateView = drawRectView(UIColor.red, frame: generalFrame, center: generalCenter)
        }
        
        view.addSubview(animateView)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

    @IBAction func didTapAnimate(_ sender: UIButton) {
        switch barTitle {
        case "2-Color":
            changeColor(UIColor.blue)
        case "Simple 2D Rotation":
            rotateView(.pi)
        case "Multicolor":
            multiColor(UIColor.green, secondColor: UIColor.blue)
        case "Multi Point Position":
            multiPosition(CGPoint(x: animateView.frame.origin.x, y: 100), CGPoint(x:animateView.frame.origin.x, y:350))
        case "BezierCurve Position":
            var controlPoint1 = self.animateView.center
            controlPoint1.y -= 125.0
            var controlPoint2 = controlPoint1
            controlPoint2.x += 40
            controlPoint2.y -= 125.0
            var endPoint = self.animateView.center
            endPoint.x += 75.0
            curvePath(endPoint, controlPoint1: controlPoint1, controlPoint2: controlPoint2)
            
        case "Color and Frame Change":
            let currentFrame = self.animateView.frame
            let firstFrame = currentFrame.insetBy(dx: -30, dy: -50)
            let secondFrame = firstFrame.insetBy(dx: 10, dy: 15)
            let thirdFrame = secondFrame.insetBy(dx: -15, dy: -20)
            colorFrameChange(firstFrame, secondFrame, thirdFrame, UIColor.orange, UIColor.yellow, UIColor.green)
            
        case "View Fade In":
            viewFadeIn()
        case "Pop":
            Pop()
        default:
            let alert = makeAlert("Alert", message: "the animation not inplemented yet", actionTitle: "OK")
            self.present(alert, animated: true, completion: nil)
            
        }
    }
    

    // MARK: - Private Methods for Animations
    fileprivate func changeColor(_ color: UIColor) {
        UIView.animate(withDuration: self.duration, animations: { 
            self.animateView.backgroundColor = color
        }, completion: nil)
        
    }
    
    fileprivate func multiColor(_ firstColor: UIColor , secondColor: UIColor) -> Void {
        UIView.animate(withDuration: duration, animations: { 
            self.animateView.backgroundColor = firstColor
        }) { (finised) in
            self.changeColor(secondColor)
        }
    }

    fileprivate func simplePosition(_ pos: CGPoint) -> Void {
        UIView.animate(withDuration: self.duration, animations: { 
            self.animateView.frame.origin = pos
        }, completion: nil)
    }
    
    fileprivate func multiPosition(_ firstPos: CGPoint , _ secondPos: CGPoint) -> Void {
        UIView.animate(withDuration: self.duration, animations: { 
            self.animateView.frame.origin = firstPos
        }) { (finished) in
            self.simplePosition(secondPos)
        }
    }
    
    fileprivate func rotateView(_ angel:Double) -> Void {
        UIView.animate(withDuration: self.duration, delay: delay, options: [.repeat], animations: { 
            self.animateView.transform = CGAffineTransform(rotationAngle: CGFloat(angel))
        }, completion: nil)
    }
    
    fileprivate func colorFrameChange(_ firstFrame: CGRect , _ secondFrame: CGRect , _ thirdFrame: CGRect, _ firstColor: UIColor, _ secondColor:UIColor, _ thirdColor: UIColor) -> Void {
        UIView.animate(withDuration: self.duration, animations: { 
            self.animateView.backgroundColor = firstColor
            self.animateView.frame = firstFrame
        }) { (finished) in
            UIView.animate(withDuration: self.duration, animations: { 
                self.animateView.backgroundColor = secondColor
                self.animateView.frame = secondFrame
            }, completion: { (finished) in
                UIView.animate(withDuration: self.duration, animations: { 
                    self.animateView.backgroundColor = thirdColor
                    self.animateView.frame = thirdFrame
                }, completion: nil)
            })
        }
    }
    
    fileprivate func curvePath(_ endPoint: CGPoint , controlPoint1: CGPoint , controlPoint2: CGPoint) -> Void {
        let path = UIBezierPath()
        path.move(to: self.animateView.center)
        path.addCurve(to: endPoint, controlPoint1: controlPoint1, controlPoint2: controlPoint2)
        
        let anim = CAKeyframeAnimation(keyPath: "position")
        
        anim.path = path.cgPath
        
        anim.duration = self.duration
        
        self.animateView.layer.add(anim, forKey: "animate position along path")
        self.animateView.center = endPoint
    }
    
    fileprivate func viewFadeIn() -> Void {
        let secondView = UIImageView(image: UIImage(named: "facebook"))
        secondView.frame = self.animateView.frame
        secondView.alpha = 0.0
        
        view.insertSubview(secondView, aboveSubview: self.animateView)
        
        UIView.animate(withDuration: self.duration, delay: delay, options: .curveEaseOut, animations: { 
            secondView.alpha = 1.0
            self.animateView.alpha = 0.0
        }, completion: nil)
    }
    
    fileprivate func Pop() -> Void {
        UIView.animate(withDuration: self.duration / 4, animations: { 
            self.animateView.transform = CGAffineTransform(scaleX: CGFloat(self.scale), y: CGFloat(self.scale))
        }) { (finished) in
            UIView.animate(withDuration: self.duration / 4, animations: { 
                self.animateView.transform = CGAffineTransform.identity
            })
        }
    }
}
