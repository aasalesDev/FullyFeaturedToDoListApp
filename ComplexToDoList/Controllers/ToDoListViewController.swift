//
//  ViewController.swift
//  ComplexToDoList
//
//  Created by Anderson Sales on 19/01/23.
//

import UIKit
import CoreData

class ToDoListViewController: UITableViewController {
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    var itemArray: [Item]? = [Item]()
    //let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathExtension("Items.plist")
    let context = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext

    // MARK: Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchBar.delegate = self
        loadItems()
    }
    
    // MARK: Method to load the tableview items
    
    private func loadItems() {
        let request: NSFetchRequest<Item> = Item.fetchRequest()
            do {
                itemArray = try context?.fetch(request)
            } catch {
                print("Could not fetch data...")
            }
    }
    
    // MARK: IBAction
    
    @IBAction func addButtonTapped(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "New ToDo Item", message: "Enter a new item to your list", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add Item", style: .default) { action in
            
            // This is to create the variable of type NSContext that will be used to save data in the database...
            if let context = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext {
                let newItem = Item(context: context)
                
                // This is to unwrap the optional text from the textField
                if let title = textField.text {
                    newItem.title = title
                    newItem.done = false
                    self.itemArray?.append(newItem)
                    self.saveItems()
                }
            }
        }
        
        alert.addTextField { alertTextField in
            alertTextField.placeholder = "Create new item"
            textField = alertTextField
        }
        alert.addAction(action)
        present(alert, animated: true)
    }
    
    // MARK: Save data to Core Data
    
    // This is like a staging area, similar to commit in git
    private func saveItems() {
        do {
            if let context = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext {
                try context.save()
            }
        } catch {
            print("Could not save context...")
        }
        tableView.reloadData()
    }
}

extension ToDoListViewController {
    
    // MARK: TableView DataSource Methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray?.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
                
        let item = itemArray?[indexPath.row]
        cell.textLabel?.text = item?.title
        
        // This line of code replaces the if else block below
        cell.accessoryType = item?.done ?? false ? .checkmark : .none
        
        /*if itemArray[indexPath.row].done == true {
            cell.accessoryType = .checkmark
        } else {
            cell.accessoryType = .none
        }*/
        
        return cell
    }
    
    // MARK: TableView Delegate Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        // MARK: UPDATE ITEMS
        // This line of code replaces the if else block below
        itemArray?[indexPath.row].done = !(itemArray?[indexPath.row].done ?? false)
        
        /*if itemArray[indexPath.row].done == false {
            itemArray[indexPath.row].done = true
        } else {
            itemArray[indexPath.row].done = false
        }*/
        
        /// MARK: DELETE ITEMS
        /*context?.delete(itemArray?[indexPath.row] ?? Item())
        itemArray?.remove(at: indexPath.row)*/
        
        saveItems()
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

// MARK: Search Bar Methods

extension ToDoListViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        let request: NSFetchRequest<Item> = Item.fetchRequest()
        let predicate = NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text!)
        request.predicate = predicate
        
        let sortDescriptor = NSSortDescriptor(key: "title", ascending: true)
        request.sortDescriptors = [sortDescriptor]
        
        do {
            itemArray = try context?.fetch(request)
        } catch {
            print("Could not fetch data...")
        }
        
        tableView.reloadData()
    }
}
