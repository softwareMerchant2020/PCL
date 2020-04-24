//
//  CustomersController.swift
//  PCL Admin
//
//  Created by Rutul Desai on 4/23/20.
//  Copyright © 2020 Abihshek. All rights reserved.
//

import UIKit

class CustomersController: UIViewController, UITableViewDelegate, UITableViewDataSource {
   
    

    @IBOutlet weak var customersTable: UITableView!
    var getCustomers : [Location]?
    var isEditMode:Bool?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.rightBarButtonItem = UIBarButtonItem.init(barButtonSystemItem: .add, target: self, action: #selector(addCustomer))
        RestManager.APIData(url: baseURL + getCustomer, httpMethod: RestManager.HttpMethod.get.self.rawValue, body: nil){Data,Error in
            if Error == nil{
                do {
                    self.getCustomers = try JSONDecoder().decode([Location].self, from: Data as! Data )
                    DispatchQueue.main.async {
                        self.customersTable?.reloadData()
                    }
                } catch let JSONErr{
                    print(JSONErr)
                }
            }
        }
        
    }
    
    
    
    @objc func addCustomer() {
        let presentingController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "CustomerController") as! CustomerController
        presentingController.isEditMode = false
        presentingController.modalPresentationStyle = UIModalPresentationStyle.pageSheet
        present(presentingController, animated: true, completion: nil)
    }
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.getCustomers?.count ?? 0
       }
       
       func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        cell.textLabel?.text = self.getCustomers?[indexPath.row].CustomerName
        return cell
       }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 40
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let presentingController: CustomerController
        presentingController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "CustomerController") as! CustomerController
        presentingController.isEditMode = true
        presentingController.Customer = self.getCustomers?[indexPath.row]
        presentingController.modalPresentationStyle = UIModalPresentationStyle.pageSheet
        self.present(presentingController, animated: true, completion: nil)
    }

}
