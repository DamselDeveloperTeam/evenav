//
//  ViewController.swift
//  evenav
//
//  Created by Koulutus on 26/11/2017.
//  Copyright © 2017 Koulutus. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var sourceSystem: UISearchBar!
    
    @IBAction func targetSystem(_ sender: UITextField) {
        sender.text = sender.text?.trimmingCharacters(in: .whitespaces)
        if sender.text != "" {
            initiateSearch(systemName: sender.text!)
        }
    }
    
    @IBOutlet weak var viewPinch: UIView!
    var pinchGesture = UIPinchGestureRecognizer()

    
    //  Search system name from Systems array and trigger notification to focus map onto it.
    func initiateSearch(systemName: String) {
        currentSystemIndex = -1
        currentSystemIndex = locateSystemIndex(systemNameToSearch: systemName)
        focusOnSystem = -1
        if (currentSystemIndex >= 0) {
            //NSLog("system:", systemName, "system index:", currentSystemIndex)
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
        pinchGesture = UIPinchGestureRecognizer(target: self, action: #selector(ViewController.handlePinchGesture))
        viewPinch.isUserInteractionEnabled = true
        viewPinch.addGestureRecognizer(pinchGesture)
        
        DataBase.sharedInstance.displayDBPath();
    }

    /*
    @objc func pinchedView(sender:UIPinchGestureRecognizer){
        self.view.bringSubview(toFront: viewPinch)
        sender.view?.transform = (sender.view?.transform)!.scaledBy(x: sender.scale, y: sender.scale)
        sender.scale = 1.0
    }
    */
    
    @objc func handlePinchGesture(recognizer: UIPinchGestureRecognizer) {
        
        if let view = recognizer.view {
            //view.transform = CGAffineTransform(view.transform,recognizer.scale, recognizer.scale)
            view.transform = (recognizer.view?.transform)!.scaledBy(x: recognizer.scale, y: recognizer.scale)
            if CGFloat(view.transform.a) > 3.0 {
                view.transform.a = 3.0 // this is x coordinate
                view.transform.d = 3.0 // this is x coordinate
            }
            if CGFloat(view.transform.d) < 0.01 {
                view.transform.a = 0.05 // this is x coordinate
                view.transform.d = 0.05 // this is x coordinate
            }
            recognizer.scale = 1
        }
    }

    func printSystemContents(system: System) {
        NSLog(String(system.id) + " " +
            system.name + " " +
            String(system.pX) + " " +
            String(system.pY) + " " +
            String(system.pZ)
        );
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

