//
//  ViewController.swift
//  evenav
//
//  Created by Koulutus on 26/11/2017.
//  Copyright © 2017 Koulutus. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var systemView: SystemsView!
    @IBOutlet weak var sourceSystem: UISearchBar!
    
    @IBAction func targetSystem(_ sender: UITextField) {
        sender.text = sender.text?.trimmingCharacters(in: .whitespaces)
        if sender.text != "" {
            initiateSearch(systemName: sender.text!)
        }
    }
    
    @IBOutlet var resetButton: UIButton!
    @IBAction func resetButton(_ sender: Any) {
        viewPinch.transform = CGAffineTransform.identity
        resetButton.isHidden = true
        self.viewPinch.center = CGPoint(x: viewPinch.frame.size.width  / 2, y: viewPinch.frame.size.height / 2);
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
            highlightRoute(originID: Systems[focusOnSystem].id, destinationID: 30002772);
        } else {
            NSLog("system '\(String(describing: systemName))' not found")
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NSLog("VIEWCONTROLLER")
        
        resetButton.isHidden = true
        // PINCH Gesture
        pinchGesture = UIPinchGestureRecognizer(target: self, action: #selector(ViewController.handlePinchGesture))
        viewPinch.isUserInteractionEnabled = true
        viewPinch.addGestureRecognizer(pinchGesture)
        
             self.viewPinch.center = CGPoint(x: viewPinch.frame.size.width  / 2, y: viewPinch.frame.size.height / 2);
        
        DataBase.sharedInstance.displayDBPath();
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        //RouteFinder Testing....
        /*
        let rFinder: RouteFinder = RouteFinder();
        DispatchQueue.global(qos: .userInitiated).async {
            if (rFinder.findRouteFor(origin: 30002771, destination: 30002772)) {
                DispatchQueue.main.async {
                    self.systemView.setNeedsDisplay();                }
            }
        }
         */
        
        //_ = rFinder.findRouteFor(origin: 30002771, destination: 30002772);
        //systemView.setNeedsDisplay();
        
        //highlightRoute(originID: 30002771, destinationID: 30002772);
    }
    
    @objc func handlePinchGesture(recognizer: UIPinchGestureRecognizer) {
        
        if let view = recognizer.view {
            resetButton.isHidden = false
            //scrollView.isScrollEnabled = true
    
            view.transform = (recognizer.view?.transform)!.scaledBy(x: recognizer.scale, y: recognizer.scale)
            if CGFloat(view.transform.a) > 3.0 {
                view.transform.a = 3.0 // this is x coordinate
                view.transform.d = 3.0 // this is x coordinate
            }
            if CGFloat(view.transform.d) < 0.05 {
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
    
    func highlightRoute(originID: Int, destinationID: Int) {
        let rFinder: RouteFinder = RouteFinder();
        DispatchQueue.global(qos: .userInitiated).async {
            if (rFinder.findRouteFor(origin: originID, destination: destinationID)) {
                DispatchQueue.main.async {
                    self.systemView.setNeedsDisplay();                }
            }
        }
    }
}

