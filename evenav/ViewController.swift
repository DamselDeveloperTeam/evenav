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
        currentSystemIndex = -1
        currentSystemIndex = locateSystemIndex(systemNameToSearch: sender.text!)
        if (currentSystemIndex >= 0) {
            print("system:", sender.text!, "system index:", currentSystemIndex)
            focusOnSystem = currentSystemIndex
            nc.post(name: Notification.Name("focusToSystem"), object: nil)
        } else {
            print("system '\(String(describing: sender.text))' not found")
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("VIEWCONTROLLER")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

