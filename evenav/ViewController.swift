//
//  ViewController.swift
//  evenav
//
//  Created by Koulutus on 26/11/2017.
//  Copyright © 2017 Koulutus. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchResultsUpdating, UISearchBarDelegate {
    @IBOutlet weak var systemView: SystemsView!
    @IBOutlet weak var sourceSystem: SourceSearchBar!
    @IBOutlet weak var destinationBar: DestinationSearchBar!
    
    @IBOutlet weak var splashView: UIView!
    @IBOutlet weak var splashActivityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var splashLoadingLabel: UILabel!
    
    
    @IBOutlet weak var detailView: UIView!
    @IBOutlet weak var detailTextView: UITextView!
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var topBarUIView: UIView!
    
    @IBAction func searchButton(_ sender: UIButton) {
        if (bothSystemsSelectedInSearchBar()) {
            initiateSearch(systemName: sourceSystem.text!);
            highlightRoute(originID: sourceSystem.selectedSystemID!, destinationID: destinationBar.selectedSystemID!);
        }
    
        //AlertDisplayer.customAlert(title: "Test Title", message: "Test message.")
    }
    
    private func bothSystemsSelectedInSearchBar() -> Bool {
        if (sourceSystem.selectedSystemID == nil || destinationBar.selectedSystemID == nil) {
            return false
        }
        return true
    }
    
    var systems : [SystemButton] = []
    var filteredSystems : [SystemButton]?
    let searchController = UISearchController(searchResultsController: nil)
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let filtered = filteredSystems else {
            return 0
        }
        
        if filtered.count == 0 || filtered.count == systems.count
        {
            tableView.isHidden = true
            tableView.layer.zPosition = 0
            NSLog("Tableview hidden")
        }
        else
        {
            let systemsCount = systems.count
            if filtered.count > 0 && filtered.count < systemsCount
            {
                tableView.isHidden = false
                tableView.layer.zPosition = 10
                NSLog("Tableview shown, number of filtered systems: " + filtered.count.description)
            }
        }
        return filtered.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "systemNameCellIdentifier") as! SystemTableViewCell
        
        if let filtered = filteredSystems {
            let systemID = filtered[indexPath.row].id
            let systemName = filtered[indexPath.row].name
            
            cell.systemIDLabel?.text = systemID.description;
            cell.systemNameLabel?.text = systemName;
            cell.textLabel?.text = systemName;
            cell.textLabel?.textColor = UIColor.white
        }
        
        return cell
    }
    
    func updateSearchResults(for searchController: UISearchController)
    {
        if let searchText = searchController.searchBar.text, !searchText.isEmpty {
            filteredSystems = systems.filter { system in
                let systemName = system.name
                return systemName.lowercased().contains(searchText.lowercased())
            }
        }
        else
        {
            filteredSystems = systems
        }
        
        tableView.reloadData()
        //tableView.setNeedsDisplay();
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedItem = indexPath.item
        let selectedSystem = filteredSystems![selectedItem]
        NSLog(selectedSystem.id.description)
        let selectedSystemName = selectedSystem.name
        //searchController.searchBar.text = selectedSystemName
        tableView.isHidden = true
        
        if(sourceSystem.isBeingEdited) {
            sourceSystem.selectedSystemID = selectedSystem.id;
            sourceSystem.text = selectedSystemName;
            //sourceSystem.barTintColor = UIColor.green;
            //
            NSLog("Set \(String(describing: sourceSystem.selectedSystemID)) for \(sourceSystem.identifier)");
            
            
            let dHandler: DetailHander = DetailHander();
            self.detailTextView.text = dHandler.getDetailsForSystem(systemID: selectedSystem.id);
            self.detailView.isHidden = false;
            
            initiateSearch(systemName: sourceSystem.text!)
            self.view.endEditing(true)  // remove keyboard from view
        }
        
        if(destinationBar.isBeingEdited) {
            destinationBar.selectedSystemID = selectedSystem.id;
            destinationBar.text = selectedSystemName;
            //destinationBar.barTintColor = UIColor.green;
            NSLog("Set \(String(describing: destinationBar.selectedSystemID)) for \(destinationBar.identifier)");
            
            let dHandler: DetailHander = DetailHander();
            self.detailTextView.text = dHandler.getDetailsForSystem(systemID: selectedSystem.id);
            self.detailView.isHidden = false;
            
            initiateSearch(systemName: destinationBar.text!)
            self.view.endEditing(true)  // remove keyboard from view
        }
        
        //tableView.layer.zPosition = 0
        //self.sourceSystem.text = "";
        
        //initiateSearch(systemName: selectedSystem.name)
    }
    
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
            //highlightRoute(originID: Systems[focusOnSystem].id, destinationID: 30002772);
        } else {
            NSLog("system '\(String(describing: systemName))' not found")
        }
    }
    
    /*
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        NSLog("Search bar test2!");
    }
    */
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        NSLog("Search bar test!: \(searchText)");
        
        self.detailView.isHidden = true;
        
        if (searchBar.accessibilityLabel == "Source") {
            sourceSystem.isBeingEdited = true;
            destinationBar.isBeingEdited = false;
            NSLog("\(sourceSystem.identifier) is being edited");
        }
        
        if (searchBar.accessibilityLabel == "Destination") {
            sourceSystem.isBeingEdited = false;
            destinationBar.isBeingEdited = true;
            NSLog("\(destinationBar.identifier) is being edited");
        }
        
        if (!searchText.isEmpty) {
            filteredSystems = systems.filter { system in
                let systemName = system.name
                return systemName.lowercased().contains(searchText.lowercased())
            }
        } else {
            filteredSystems = systems
        }
        
        tableView.reloadData()
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
        
        
        NSLog("Systems count: " + systems.count.description)
        tableView.dataSource = self
        tableView.delegate = self
        //tableView.isScrollEnabled = true;
        //tableView.isUserInteractionEnabled = true;
        //tableView.allowsSelection = true;
        
        filteredSystems = systems
        searchController.searchResultsUpdater = self
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.dimsBackgroundDuringPresentation = false
        
        searchController.searchBar.widthAnchor.constraint(equalToConstant: 150).isActive = true;
        //topBarUIView.addSubview(searchController.searchBar)
        tableView.tableFooterView = UIView(frame: .zero)
        
        self.sourceSystem.delegate = self;
        self.sourceSystem.accessibilityLabel = "Source";
        self.sourceSystem.isAccessibilityElement = true;
        
        self.destinationBar.delegate = self;
        self.destinationBar.accessibilityLabel = "Destination";
        self.destinationBar.isAccessibilityElement = true;
        
        AlertDisplayer.viewToDisplayAlert = self;
        
        self.detailView.isHidden = true;
        self.detailView.isUserInteractionEnabled = true;
        
        self.updateLoadingLabelText(text: "Loading started...");
        self.splashActivityIndicator.startAnimating();
        self.view.addSubview(self.splashView);
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.createArrays();
    }
    
    
    
    func updateLoadingLabelText(text: String) {
        DispatchQueue.main.async {
            self.splashLoadingLabel.text = text;
            //self.splashLoadingLabel.setNeedsDisplay();
        }
    }
    
    func returnToMapView() {
        if (self.splashView != nil) {
            self.splashView.removeFromSuperview();
        }
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
                    self.systemView.setNeedsDisplay();
                }
            }
        }
    }
    
    func createArrays() {
        DispatchQueue.global().async {
            //  Appending regions, constellations, systems and connectors to their respective arrays.
            NSLog("Populating region array...");
            self.updateLoadingLabelText(text: "Populating region array...");
            //messageString = "Populating region array..."
            //nc.post(name: Notification.Name("loadingMessage"), object: nil)
            DataBase.sharedInstance.CreateRegionArray()
            NSLog("Populating constellation array...");
            self.updateLoadingLabelText(text: "Populating constellation array...");
            //messageString = "Populating constellation array..."
            //nc.post(name: Notification.Name("loadingMessage"), object: nil)
            DataBase.sharedInstance.CreateConstellationsArray()
            NSLog("Populating system array...");
            self.updateLoadingLabelText(text: "Populating system array...");
            //messageString = "Populating system array..."
            //nc.post(name: Notification.Name("loadingMessage"), object: nil)
            DataBase.sharedInstance.CreateSystemsArray()
            NSLog("Populating connection array...");
            self.updateLoadingLabelText(text: "Populating connection array...");
            //messageString = "Populating connection array..."
            //nc.post(name: Notification.Name("loadingMessage"), object: nil)
            DataBase.sharedInstance.CreateConnectorArray();
            
            self.updateLoadingLabelText(text: "Drawing map...");
            NSLog("All arrays populated....");
            
            DispatchQueue.main.async {
                self.systems = Systems;
                self.systemView.setNeedsDisplay();
            }
        }
    }
}

