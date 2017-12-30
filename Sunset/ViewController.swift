//
//  ViewController.swift
//  Sunset
//
//  Created by Kevin Lima on 26-02-17.
//  Copyright © 2017 Kevin Lima. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDataSource {
	@IBOutlet weak var locationLabel: UILabel!
	@IBOutlet weak var sunriseLabel: UILabel!
	@IBOutlet weak var sunsetLabel: UILabel!
	@IBOutlet weak var daylengthLabel: UILabel!
    @IBOutlet weak var settingsButtonOutlet: UIButton!
    
    @IBOutlet weak var tableView: UITableView!
    
    
    let settingsView = SettingsView.instanceFromNib()
    var settingsActive = false
    let sun = Sun()
    var dataKeys = [String]()
    var dataValues = [String]()
	

	override func viewDidLoad() {
		super.viewDidLoad()
		tableView.dataSource = self
		//reloadData()
		NotificationCenter.default.addObserver(self, selector: #selector(ViewController.reloadData(notification:)), name: Notification.Name("reloadData"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(ViewController.receiveLocation(notification:)), name: Notification.Name("receiveLocation"), object: nil)
	}
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //return self.sun.getDataCount()
        return 10
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let reusableCell = tableView.dequeueReusableCell(withIdentifier: "reusableCell", for: indexPath)
        if self.dataValues.isEmpty{
            reusableCell.textLabel?.text = "Row \(indexPath.row)"
        }else{
            reusableCell.textLabel?.text = self.dataKeys[indexPath.row]
            reusableCell.detailTextLabel?.text = self.dataValues[indexPath.row]
        }
        return reusableCell
    }
    
    override func updateViewConstraints() {
        super.updateViewConstraints()
        
        settingsView.translatesAutoresizingMaskIntoConstraints = false
        let topConstraint = NSLayoutConstraint(item: settingsView, attribute: .top, relatedBy: .equal, toItem: view, attribute: NSLayoutAttribute.top, multiplier: 1, constant: 0)
        let leadingConstraint = NSLayoutConstraint(item: settingsView, attribute: .leading, relatedBy: .equal, toItem: view, attribute: .leading, multiplier: 1, constant: 0)
        let trailingConstraint = NSLayoutConstraint(item: settingsView, attribute: .trailing, relatedBy: .equal, toItem: view, attribute: .trailing, multiplier: 1, constant: 0)
        let bottomConstraint = NSLayoutConstraint(item: settingsView, attribute: .bottom, relatedBy: .equal, toItem:settingsButtonOutlet , attribute: .top, multiplier: 1, constant: 0)
        
        self.view.addSubview(settingsView)
        self.view.addConstraints([topConstraint, leadingConstraint, trailingConstraint, bottomConstraint])
    }
	
    @IBAction func settingsButtonAction(_ sender: Any) {
        if settingsActive{
            settingsView.isHidden = true
            settingsActive = false
            settingsButtonOutlet.setTitle("Settings", for: .normal)
        }else{
            settingsView.isHidden = false
            settingsActive = true
            settingsButtonOutlet.setTitle("Back", for: .normal)
        }
    }
    
    /**
        Receives the notification that theres a new sun profile to be used
     */
    @objc func reloadData(notification:Notification){
		print("Reload notification recieved")
		reloadData()
	}
    
    /**
        Receives the notification that theres a new location to be used
     */
    @objc func receiveLocation(notification:Notification){
        print("Present Location notification received")
        presentLocation()
    }
	
    /**
        Presents the new sun profile data in the view
     */
	func reloadData(){
		DispatchQueue.main.async {
            self.dataKeys = self.sun.getKeys()
            self.dataValues = self.sun.getValues()
            self.tableView.reloadData()
		}
	}
    
    /**
        Presents the location in the view
     */
    func presentLocation(){
        DispatchQueue.main.async {
            self.locationLabel.text = self.sun.getLocation()
        }
    }

	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}
}

