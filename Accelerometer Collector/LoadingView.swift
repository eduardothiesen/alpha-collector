//
//  LoadingView.swift
//  Pointr
//
//  Created by Eduardo Thiesen on 24/06/16.
//  Copyright © 2016 Synapps. All rights reserved.
//

import UIKit

class LoadingView: UIView {
    
    static let sharedInstance = LoadingView()

    func loadSpinner() -> LoadingView? {
        let loadingView = LoadingView.init(frame: UIScreen.mainScreen().bounds)
        loadingView.backgroundColor = UIColor(red: 39.0/255.0, green: 57.0/255.0, blue: 71.0/255.0, alpha: 1.0)

        let backgroundImage: UIImage = UIImage(named: "splash_screen-1")!
        let backgroundImageView: UIImageView = UIImageView(frame: loadingView.frame)
        backgroundImageView.contentMode = .ScaleAspectFit
        backgroundImageView.image = backgroundImage
        
        loadingView.addSubview(backgroundImageView)
        loadingView.sendSubviewToBack(backgroundImageView)
        
        let loadingImages = UIImageView(frame: CGRectMake(176, 36, 48, 50))
        loadingImages.center.x = loadingView.center.x
        loadingImages.animationImages = [UIImage(named: "2RO_Xjzr")!, UIImage(named: "2RO_Xjzr")!, UIImage(named: "2RO_Xjzr")!]
        loadingImages.animationDuration = 1.0
        loadingImages.startAnimating()
        
        loadingView.addSubview(loadingImages)
        
        loadingView.alpha = 0.0
        
        let loadingSpinner : UIActivityIndicatorView = UIActivityIndicatorView(frame: loadingView.frame)
        loadingSpinner.startAnimating()
        
        loadingView.addSubview(loadingSpinner)
        
        
        let loadingLabel: UILabel = UILabel(frame: CGRectMake(loadingView.center.x - (loadingView.frame.size.width/2), loadingView.center.y + 40, loadingView.frame.size.width, 200))
        loadingLabel.text = "Enviando dados para o servidor..."
        loadingLabel.font = UIFont(name: "HelveticaNeue", size: 15.0)
        loadingLabel.textAlignment = NSTextAlignment.Center
        loadingLabel.textColor = UIColor.whiteColor()
        
        loadingView.addSubview(loadingLabel)
        
        return loadingView
    }
    
    func startLoader(subview: UIView) {
        UIApplication.sharedApplication().keyWindow?.addSubview(subview)
        UIView.animateWithDuration(0.3) {
            subview.alpha = 1.0
        }
    }
    
    func stopLoader(subview: UIView) {
        UIView.animateWithDuration(0.3, animations: {
            subview.alpha = 0.0
            }) { (Bool) in
                subview.removeFromSuperview()
        }
    }
}
