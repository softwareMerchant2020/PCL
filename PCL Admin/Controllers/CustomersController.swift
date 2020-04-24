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
    var getCustomers = [Location]()
    var isEditMode:Bool?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.rightBarButtonItem = UIBarButtonItem.init(barButtonSystemItem: .add, target: self, action: #selector(addCustomer))
        loadData()
        
    }
    
    func loadData(){
        RestManager.APIData(url: baseURL + getCustomerURL, httpMethod: RestManager.HttpMethod.get.self.rawValue, body: nil){Data,Error in
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
    
    func deleteCustomer(customer:Location){
        RestManager.APIData(url: baseURL + deleteCustomerAPI + String(customer.CustomerId), httpMethod: RestManager.HttpMethod.post.self.rawValue, body: nil) { (result, error) in
            if (error == nil) {
                do {
                    let resultdata = try JSONDecoder().decode(RequestResult.self, from: result as! Data)
                    DispatchQueue.main.async {
                        let alert = UIAlertController(title:resultdata.Result, message: nil, preferredStyle: .alert)
                        self.present(alert, animated: true, completion: {
                            Timer.scheduledTimer(withTimeInterval: 0.5, repeats: false) { (_ ) in
                                self.dismiss(animated: true, completion: {
                                    self.customersTable?.reloadData()
                                }) }
                        })
                    }
                } catch {
                    print("Decode error:\(error.localizedDescription)")
                }
            }
        }
    }
    
    
    func refreshTable() {
        self.loadData()
        self.customersTable.layoutSubviews()
    }

    
    @objc func addCustomer() {
        let presentingController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "CustomerController") as! CustomerController
        presentingController.isEditMode = false
        presentingController.modalPresentationStyle = UIModalPresentationStyle.pageSheet
        present(presentingController, animated: true, completion: nil)
    }
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.getCustomers.count
       }
       
       func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        cell.textLabel?.text = self.getCustomers[indexPath.row].CustomerName
        return cell
       }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 40
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let presentingController: CustomerController
        presentingController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "CustomerController") as! CustomerController
        presentingController.isEditMode = true
        presentingController.Customer = self.getCustomers[indexPath.row]
        presentingController.modalPresentationStyle = UIModalPresentationStyle.pageSheet
        self.present(presentingController, animated: true, completion: nil)
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            deleteCustomer(customer: self.getCustomers[indexPath.row])
            self.getCustomers.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }

}
