//
//  ShowSplashScreen.swift
//  evenav
//
//  Created by Koulutus on 12/12/2017.
//  Copyright © 2017 Koulutus. All rights reserved.
//

import UIKit

class ShowSplashScreen: UIViewController {

    @IBOutlet var splashScreenUIView: UIView!
    
    @IBOutlet var activityIndicator: UIActivityIndicatorView!
    
    @IBOutlet var lblStatusMessage: UILabel!
    // Local notification observer for focusToSystem.
    
    var timer: DispatchSourceTimer!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let messageStrings = ["Welcome to EveOnline", "Connecting to database...", "Populating region array...", "Populating constellation array...", "Populating system array...", "Populating connection array...", "Drawing 67 region labels...", "Drawing 1120 constellation labels...", "Drawing 6913 connections...", "Drawing 5433 systems...", "Loading.....", "...all drawing done"]
        var index = messageStrings.startIndex
        timer = DispatchSource.makeTimerSource(queue: .main)
        timer.schedule(deadline: .now(), repeating: .seconds(3))
        timer.setEventHandler { [weak self] in
            self?.lblStatusMessage.text = messageStrings[index]
            index = index.advanced(by: 1)
            if index == messageStrings.endIndex {
               
                
                self?.timer.cancel() //Stops timmer and does not repeat lopping through string array.
                self?.perform(#selector(self?.showViewController), with: nil)
            }
        }
        timer.resume()

       
        nc.addObserver(self, selector: #selector(loadingMessage), name: Notification.Name("loadingMessage"), object: nil)
        
        activityIndicator.isHidden = false
        lblStatusMessage.isHidden = false
        activityIndicator.startAnimating()
   
        
    }
    
    @objc func showViewController()
    {
        performSegue(withIdentifier: "showSplashScreen", sender: self)
      
        //UIApplication.shared.endIgnoringInteractionEvents()
    }
    
    @objc func loadingMessage() {
        lblStatusMessage.text = messageString
        lblStatusMessage.setNeedsDisplay()
        lblStatusMessage.setNeedsLayout()
        NSLog("\(lblStatusMessage.text ?? "Loading...")")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        activityIndicator.stopAnimating()
        activityIndicator.isHidden = true
        lblStatusMessage.isHidden = true
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

}
