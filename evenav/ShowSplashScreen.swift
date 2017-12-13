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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        activityIndicator.isHidden = false
        lblStatusMessage.isHidden = false
        activityIndicator.startAnimating()

   
        perform(#selector(showViewController), with: nil, afterDelay: 4)

        
        // Do any additional setup after loading the view.
    }
    
    @objc func showViewController()
    {
        performSegue(withIdentifier: "showSplashScreen", sender: self)
      

        //UIApplication.shared.endIgnoringInteractionEvents()
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
