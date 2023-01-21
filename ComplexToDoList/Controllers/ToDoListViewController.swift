//
//  ViewController.swift
//  ComplexToDoList
//
//  Created by Anderson Sales on 19/01/23.
//

import UIKit

class ToDoListViewController: UITableViewController {
    
    var itemArray = [Item]()
    let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathExtension("Items.plist")
    
    override func viewDidLoad() {
        super.viewDidLoad()

        loadItems()
    }
    
    private func loadItems() {
        if let dataPath = dataFilePath {
            if let data = try? Data(contentsOf: dataPath) {
                let decoder = PropertyListDecoder()
                do {
                    itemArray = try decoder.decode([Item].self, from: data)
                } catch {
                    print("Somthing went wrong in the load items function")
                }
            }
        }
        
    }
    
    @IBAction func addButtonTapped(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "New ToDo Item", message: "Enter a new item to your list", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add Item", style: .default) { action in
            
            let newItem = Item()
            // This is to unwrap the optional text from the textField
            if let title = textField.text {
                newItem.title = title
                newItem.done = false
                self.itemArray.append(newItem)
                
                self.saveItems()
            }
        }
        
        alert.addTextField { alertTextField in
            alertTextField.placeholder = "Create new item"
            textField = alertTextField
            
        }
        
        alert.addAction(action)
        present(alert, animated: true)
    }
    
    private func saveItems() {
        
        let encoder = PropertyListEncoder()
        
        do {
            let data = try encoder.encode(itemArray)
            if let path = dataFilePath {
                try data.write(to: path)
            }
        } catch {
            print("Could not encode data...")
        }
        
        tableView.reloadData()
    }
    
}

extension ToDoListViewController {
    
    // MARK: TableView DataSource Methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count 
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
                
        let item = itemArray[indexPath.row]
        cell.textLabel?.text = item.title
        
        // This line of code replaces the if else block below
        cell.accessoryType = item.done ? .checkmark : .none
        
        /*if itemArray[indexPath.row].done == true {
            cell.accessoryType = .checkmark
        } else {
            cell.accessoryType = .none
        }*/
        
        return cell
    }
    
    // MARK: TableView Delegate Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        // This line of code replaces the if else block below
        itemArray[indexPath.row].done = !itemArray[indexPath.row].done
        
        /*if itemArray[indexPath.row].done == false {
            itemArray[indexPath.row].done = true
        } else {
            itemArray[indexPath.row].done = false
        }*/
        
        saveItems()
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

