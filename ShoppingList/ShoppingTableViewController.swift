//
//  ShoppingTableViewController.swift
//  ShoppingList
//
//  Created by sindija.dzintare on 09/09/2020.
//  Copyright © 2020 sindija.dzintare. All rights reserved.
//

import UIKit
import CoreData

class ShoppingTableViewController: UITableViewController {
    
    var groceries = [Grocery]()
    
    //var gros = [String]()
    
    var managedObjectContext: NSManagedObjectContext?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        managedObjectContext = appDelegate.persistentContainer.viewContext
        loadData()
    }
    
    
//    @IBAction func addNewItemTapped(_ sender: Any) {
//        pickNewGrocery()
//    }
    
    @IBAction func addActionTapped2(_ sender: Any) {
        pickNewGrocery()
    }
    func pickNewGrocery(){
        let alertController = UIAlertController(title: "Grocery item", message: "What do you want to buy?", preferredStyle: .alert)
        alertController.addTextField { (textField: UITextField) in
        }
        
        let addAction = UIAlertAction(title: "Add", style: .cancel) { (action: UIAlertAction) in
            let textField = alertController.textFields?.first
            
            //     self.gros.append(textField!.text!)
            // self.tableView.reloadData()
            
            let entity = NSEntityDescription.entity(forEntityName: "Grocery", in: self.managedObjectContext!)
            
            let grocery = NSManagedObject(entity: entity!, insertInto: self.managedObjectContext)
            
            grocery.setValue(textField?.text, forKey: "item")
            
            do{
                try self.managedObjectContext?.save()
            }catch{
                fatalError("Error to store grocery item")
            }
            self.loadData()
        }// add Action
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .default, handler: nil)
        alertController.addAction(addAction)
        alertController.addAction(cancelAction)
        present(alertController, animated: true)
    }
    
    func loadData(){
        let request: NSFetchRequest<Grocery> = Grocery.fetchRequest()
        do{
            let result = try managedObjectContext?.fetch(request)
            groceries = result!
            tableView.reloadData()
        } catch{
            fatalError("Error in retrieving Grocery item")
        }
    }
    
    // MARK: - Table view data source
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return groceries.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "shoppingCell", for: indexPath)
        
        //     cell.textLabel?.text = gros[indexPath.row]
        let grocery = groceries[indexPath.row]
        cell.textLabel?.text = grocery.value(forKey: "item") as? String
        cell.selectionStyle = .none
        cell.accessoryType = grocery.completed ? .checkmark : .none
        
        return cell
    }
    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
           
            managedObjectContext?.delete(groceries[indexPath.row])
            tableView.reloadRows(at: [indexPath], with: .automatic)
        }
        do{
            try self.managedObjectContext?.save()
        }catch{
            fatalError("Error in deleting item")
        }
        loadData()
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        groceries[indexPath.row].completed = !groceries[indexPath.row].completed
        
        do{
                   try self.managedObjectContext?.save()
               }catch{
                   fatalError("Error in deleting item")
               }
               loadData()
    }
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
        UIView.animate(withDuration: 0.8){
            cell.transform = CGAffineTransform.identity
        }
    }
    
} //end of class
