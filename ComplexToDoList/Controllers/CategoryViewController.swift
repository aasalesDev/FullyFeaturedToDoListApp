//
//  CategoryViewController.swift
//  ComplexToDoList
//
//  Created by Anderson Sales on 22/01/23.
//

import UIKit
import CoreData

class CategoryViewController: UITableViewController {
    
    var categories = [Category]()
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadCategories()
        hideKeyboardWhenTappedAround()
        
    }
    
    private func loadCategories() {
        let request: NSFetchRequest<Category> = Category.fetchRequest()
        do {
            categories = try context.fetch(request)
        } catch {
            print("Could not fetch data...")
        }
        tableView.reloadData()
    }
    
    func hideKeyboardWhenTappedAround() {
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
        
    }
    
    @objc private func dismissKeyboard() {
        view.endEditing(true)
    }
    
    // MARK: UITableView Data Manipulation Methods
    
    private func saveCategories() {
        do {
            try context.save()
        } catch {
            print("Could not save context...")
        }
        tableView.reloadData()
    }
    
    
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "New Category", message: "Enter a new category to your list", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add Category", style: .default) { action in
            
            // This is to create the variable of type NSContext that will be used to save data in the database...
            let newCategory = Category(context: self.context)
            
            // This is to unwrap the optional text from the textField
            if let name = textField.text {
                newCategory.name = name
                self.categories.append(newCategory)
                self.saveCategories()
            }
        }
        
        alert.addTextField { alertTextField in
            alertTextField.placeholder = "Create new item"
            textField = alertTextField
        }
        alert.addAction(action)
        present(alert, animated: true)
    }

}

// MARK: TableView DataSource

extension CategoryViewController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath)
        cell.textLabel?.text = categories[indexPath.row].name
        return cell
    }
}

// MARK: TableView Delegate

extension CategoryViewController {
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        // Using Segue
        performSegue(withIdentifier: "GoToItems", sender: self)
        
        // Instantiating a viewController
        /*guard let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: String(describing: ToDoListViewController.self)) as? ToDoListViewController else { return }
        navigationController?.pushViewController(vc, animated: true)*/
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        let destinationVC = segue.destination as! ToDoListViewController
       
        if let indexPath = tableView.indexPathForSelectedRow {
            destinationVC.selectedCategory = categories[indexPath.row]
        }
    }
}
