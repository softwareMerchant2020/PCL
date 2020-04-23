//
//  SettingsViewController.swift
//  PCL Admin
//
//  Created by Abihshek on 12/20/18.
//  Copyright © 2018 Abihshek. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var settingsTableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIdentifier  = String(indexPath.row)
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier)
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let presentingController: UIViewController
        switch indexPath.row {
        case 0:
//            presentingController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "DriverController") as! DriverController
//            presentingController.modalPresentationStyle = UIModalPresentationStyle.pageSheet
           let driversVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "DriversController") as! DriversController
           driversVC.isEditMode = true
            self.navigationController?.pushViewController(driversVC, animated: true)
        case 1:
            presentingController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "CustomerController") as! CustomerController
            presentingController.modalPresentationStyle = .pageSheet
//        case 2:
//            presentingController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "RoutesEditor") as! RoutesEditor
//            presentingController.modalPresentationStyle = UIModalPresentationStyle.pageSheet
        case 2:
            presentingController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "AddVehicleController") as! AddVehiclesViewController
                       presentingController.modalPresentationStyle = UIModalPresentationStyle.pageSheet
        case 3:
           presentingController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "CustomerController") as! CustomerController
            self.performSegue(withIdentifier: "EditRoute", sender: self)
            return
        default:
            return
        }
//        present(presentingController, animated: true, completion: nil)
    }
}
