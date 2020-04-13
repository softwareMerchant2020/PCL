//
//  DriversControllerViewController.swift
//  PCL Admin
//
//  Created by Anish Verma on 12/31/18.
//  Copyright © 2018 Abihshek. All rights reserved.
//

import UIKit

class DriversController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var driversTable: UITableView!
    var delegate: RoutesEditor?
    let drivers = ["Adam", "Charles", "John", "Mathew"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return drivers.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:UITableViewCell = tableView.dequeueReusableCell(withIdentifier: "cell")!
        cell.textLabel?.text = drivers[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        delegate?.selectedDriver = drivers[indexPath.row]
        delegate?.refreshDriver()
        self.dismiss(animated: true, completion: nil)
        
    }
}
