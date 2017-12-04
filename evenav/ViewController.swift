//
//  ViewController.swift
//  evenav
//
//  Created by Koulutus on 26/11/2017.
//  Copyright © 2017 Koulutus. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    @IBAction func sourceSystem(_ sender: UITextField) {
        initiateSearch(systemName: sender.text!)
    }
    
    @IBAction func targetSystem(_ sender: UITextField) {
        initiateSearch(systemName: sender.text!)
    }
    
    @IBOutlet weak var viewPinch: UIView!
    var pinchGesture = UIPinchGestureRecognizer()

    
    //  Search system name from Systems array and trigger notification to focus map onto it.
    func initiateSearch(systemName: String) {
        currentSystemIndex = -1
        currentSystemIndex = locateSystemIndex(systemNameToSearch: systemName)
        focusOnSystem = -1
        if (currentSystemIndex >= 0) {
            NSLog("system:", systemName, "system index:", currentSystemIndex)
            focusOnSystem = currentSystemIndex
            nc.post(name: Notification.Name("focusToSystem"), object: nil)
        } else {
            NSLog("system '\(String(describing: systemName))' not found")
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("VIEWCONTROLLER")
        
        // PINCH Gesture
        pinchGesture = UIPinchGestureRecognizer(target: self, action: #selector(ViewController.pinchedView))
        viewPinch.isUserInteractionEnabled = true
        viewPinch.addGestureRecognizer(pinchGesture)
    }
    
    @objc func pinchedView(sender:UIPinchGestureRecognizer){
        self.view.bringSubview(toFront: viewPinch)
        sender.view?.transform = (sender.view?.transform)!.scaledBy(x: sender.scale, y: sender.scale)
        sender.scale = 1.0
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

