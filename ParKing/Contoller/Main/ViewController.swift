//
//  ViewController.swift
//  ParKing
//
//  Created by Mark Lai on 23/4/2022.
//

import UIKit

class ViewController: UIViewController {
    
    // Define Label in Launch page
    @IBOutlet var labelP: UILabel!
    @IBOutlet var labelK: UILabel!
    @IBOutlet var labela: UILabel!
    @IBOutlet var labelr: UILabel!
    @IBOutlet var labeli: UILabel!
    @IBOutlet var labeln: UILabel!
    @IBOutlet var labelg: UILabel!
    // Define Car Image in Launch Page
    var carImage: UIImageView!
    
    
    override func viewDidLoad(){
        super.viewDidLoad()
        
        // Hide part of the label
        labela.layer.opacity = 0
        labelr.layer.opacity = 0
        labeli.layer.opacity = 0
        labeln.layer.opacity = 0
        labelg.layer.opacity = 0
        
        print("Start to Launch")
        // Animation to move a car from left to center
        carParkingAction()
        // Wait for a second to animate the remaining part of label
        Timer.scheduledTimer(timeInterval: 1, target: self,
                             selector: #selector(self.opacityAction), userInfo: nil,
          repeats: false)

//        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 350, height: 350))
//        imageView.image = UIImage(named: "Launch")
//        imageView.layer.add(opacityStartAnimation, forKey: nil)
//        imageView.center = view.center
//        view.addSubview(imageView)
        
        // wait 2.5 seconds to transit to Main Page
        DispatchQueue.main.asyncAfter(deadline: .now()+2.5, execute: {
//            let home = IndexViewController()
//            home.modalTransitionStyle = .crossDissolve
//            home.modalPresentationStyle = .fullScreen
//            self.present(home, animated: true)
            print("Start to Launch")
            let storyboard = UIStoryboard(name: "Index", bundle: nil)
            let mainTabBarController = storyboard.instantiateViewController(identifier: "Welcome")
              
            // This is to get the SceneDelegate object from your view controller
            // then call the change root view controller function to change to main tab bar
            (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.changeRootViewController(mainTabBarController)
        })
    }
    
    // Move a car from left to center
    func carParkingAction() {
        let Height = self.view.frame.height
        let Width = self.view.frame.width
        self.carImage = UIImageView(frame: CGRect(x: 10, y: Height/2 + 70, width: 120, height: 50))
        self.carImage.image = UIImage(named: "car")
        // set up car start and end location
        let positionStartAnimation = CABasicAnimation(keyPath: "position")
        positionStartAnimation.fromValue = CGRect(x: 10, y: Height/2 + 70, width: 120, height: 50)
        positionStartAnimation.toValue = CGRect(x: (Width/2), y: Height/2 + 70, width: 120, height: 50)
        positionStartAnimation.duration = 1
        positionStartAnimation.isRemovedOnCompletion = false
        positionStartAnimation.fillMode = .both
        // Car Image layer add animation
        self.carImage.layer.add(positionStartAnimation, forKey: "positionStartAnimation")
        self.view.addSubview(carImage)
    }
    
    // set Label Animation, from Hide to enable
    @objc func opacityAction() {
        
        // Set up opacity of part of the labels
        let opacityStartAnimation = CABasicAnimation(keyPath: "opacity")
        opacityStartAnimation.isRemovedOnCompletion = false
        opacityStartAnimation.fromValue = 0
        opacityStartAnimation.toValue = 1
        opacityStartAnimation.duration = 1.5
        opacityStartAnimation.repeatCount = 0
        opacityStartAnimation.fillMode = .both
        
        // Add animation to label layer of part of the character
        labela.layer.add(opacityStartAnimation, forKey: "opacityStartAnimation")
        labelr.layer.add(opacityStartAnimation, forKey: "opacityStartAnimation")
        
        labeli.layer.add(opacityStartAnimation, forKey: "opacityStartAnimation")
        labeln.layer.add(opacityStartAnimation, forKey: "opacityStartAnimation")
        labelg.layer.add(opacityStartAnimation, forKey: "opacityStartAnimation")
    }
    
//    private let imageView: UIImageView = {
//        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 350, height: 350))
//        imageView.image = UIImage.init(named: "Launch")
//        imageView.alpha = 0
//        return imageView
//    }()
//
//    override func viewDidLoad(){
//        super.viewDidLoad()
//        view.addSubview(imageView)
//        view.backgroundColor = .white
//    }
//    override func viewDidLayoutSubviews() {
//        super.viewDidLayoutSubviews()
//        imageView.center = view.center
//
//
//        DispatchQueue.main.asyncAfter(deadline: .now()+0.5
//            , execute: {
//                self.animate()
//        })
//
//    }
//    private func animate(){
//        UIView.animate(withDuration: 1, animations: {
//            let size = self.view.frame.width * 3
//            let diffX  = size - self.view.frame.size.width
//            let diffY = self.view.frame.size.height - size
//
//         //   self.imageView.frame = CGRect(x: -(diffX/2), y: diffY/2, width: size, height: size)
//            self.imageView.alpha = 1
//        })
//
////        DispatchQueue.main.asyncAfter(deadline: .now()+0.6, execute: {
////            let home = WelcomeViewController()
////            home.modalTransitionStyle = .crossDissolve
////            home.modalPresentationStyle = .fullScreen
////            self.present(home, animated: true)
////        })
//
//
//    }


}

