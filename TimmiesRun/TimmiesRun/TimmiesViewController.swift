//
//  ViewController.swift
//  TimmiesRun
//
//  Created by Nicole Groeger on 2024-06-06.
//

import UIKit

class TimmiesViewController: UITableViewController, AddItemViewControllerDelegate {
    
    // MARK: - Add Item View Controller Delegates
    
    func addItemViewControllerDidCancel(_ controller: AddItemViewController) {
        navigationController?.popViewController(animated: true)
    }
    
    func addItemViewController(_ controller: AddItemViewController, didFinishAdding item: ChecklistItem) {
        let newRowIndex = items.count
        items.append(item)
        
        let indexPath = IndexPath(row: newRowIndex, section: 0)
        let indexPaths = [indexPath]
        tableView.insertRows(at: indexPaths, with: .automatic)
        navigationController?.popViewController(animated: true)
    }
    
    func addItemViewController(
      _ controller: AddItemViewController,
      didFinishEditing item: ChecklistItem
    ) {
      if let index = items.firstIndex(of: item) {
        let indexPath = IndexPath(row: index, section: 0)
        if let cell = tableView.cellForRow(at: indexPath) {
          configureText(for: cell, with: item)
        }
      }
      navigationController?.popViewController(animated: true)
    }

    
    var items = [ChecklistItem]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.prefersLargeTitles = true // large title shown in navigation bar
        
        
        let item1 = ChecklistItem()
        item1.text = "Medium Double Double"
        items.append(item1)
        
        let item2 = ChecklistItem()
        item2.text = "Large English Breakfast Tea"
        items.append(item2)
        
        let item3 = ChecklistItem()
        item3.text = "Small Iced Capp"
        items.append(item3)
        
        let item4 = ChecklistItem()
        item4.text = "Box of 20 TimBits"
        items.append(item4)
        
        let item5 = ChecklistItem()
        item5.text = "Boston Cream Donut"
        items.append(item5)
    }
    
    var row0item = ChecklistItem()
    var row1item = ChecklistItem()
    var row2item = ChecklistItem()
    var row3item = ChecklistItem()
    var row4item = ChecklistItem()
    
    // MARK: - Table View Data Source
    override func tableView(
        _ tableView: UITableView,
        numberOfRowsInSection section: Int
    ) -> Int {
        return items.count
    }
    
    override func tableView(
        _ tableView: UITableView,
        cellForRowAt indexPath: IndexPath
    ) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(
            withIdentifier: "ChecklistItem",
            for: indexPath)
        
        let item = items[indexPath.row]
        
        configureText(for: cell, with: item)
        configureCheckmark(for: cell, with: item)
        return cell
    }
    
    
    // MARK: - Table View Delegate
    override func tableView(
        _ tableView: UITableView,
        didSelectRowAt indexPath: IndexPath
    ) {
        if let cell = tableView.cellForRow(at: indexPath) {
            let item = items[indexPath.row]
            item.checked.toggle()
            configureCheckmark(for: cell, with: item)
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    // swipe to delete
    
    override func tableView(
        _ tableView:UITableView,
        commit editingStyle: UITableViewCell.EditingStyle,
        forRowAt indexPath: IndexPath
    ) {
        // 1
        items.remove(at: indexPath.row)
        
        // 2
        let indexPaths = [indexPath]
        tableView.deleteRows(at: indexPaths, with: .automatic)
    }
    
    // configure checkmarks
    
    func configureCheckmark(
        for cell: UITableViewCell,
        with item: ChecklistItem
    ) {
        let label = cell.viewWithTag(1001) as! UILabel
        
        if item.checked{
            label.text = "✔️"
        }
        else {
            label.text = ""
        }
    }
    
    func configureText(
        for cell: UITableViewCell,
        with item: ChecklistItem
    ) {
        let label = cell.viewWithTag(1000) as! UILabel
        label.text = item.text
    }
    
    // default checkmark states
    var row0checked = false
    var row1checked = false
    var row2checked = false
    var row3checked = false
    var row4checked = false
    
// MARK: - Actions
    
    // MARK: - Navigation
    override func prepare(
        for segue: UIStoryboardSegue,
        sender: Any?
    ) {
        if segue.identifier == "AddItem" {
            let controller = segue.destination as! AddItemViewController
            controller.delegate = self
        }
        else if segue.identifier == "EditItem" {
            let controller = segue.destination as! AddItemViewController
            controller.delegate = self
            
            if let indexPath = tableView.indexPath(for: sender as! UITableViewCell) {
                controller.itemToEdit = items[indexPath.row]
            }
        }
    }
    
}

