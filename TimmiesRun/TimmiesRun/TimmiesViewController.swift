//
//  ViewController.swift
//  TimmiesRun
//
//  Created by Nicole Groeger on 2024-06-06.
//

import UIKit

class TimmiesViewController: UITableViewController, itemDetailViewControllerDelegate {
    var checklist: Checklist!
    
    // MARK: - Add Item View Controller Delegates
    
    func itemDetailViewControllerDidCancel(_ controller: ItemDetailViewController) {
        navigationController?.popViewController(animated: true)
    }
    
    func itemDetailViewController(_ controller: ItemDetailViewController, didFinishAdding item: ChecklistItem) {
        let newRowIndex = items.count
        items.append(item)
        
        let indexPath = IndexPath(row: newRowIndex, section: 0)
        let indexPaths = [indexPath]
        tableView.insertRows(at: indexPaths, with: .automatic)
        navigationController?.popViewController(animated: true)
        saveChecklistItems()
    }
    
    func itemDetailViewController(
      _ controller: ItemDetailViewController,
      didFinishEditing item: ChecklistItem
    ) {
      if let index = items.firstIndex(of: item) {
        let indexPath = IndexPath(row: index, section: 0)
        if let cell = tableView.cellForRow(at: indexPath) {
          configureText(for: cell, with: item)
        }
      }
      navigationController?.popViewController(animated: true)
      saveChecklistItems()
    }

    
    var items = [ChecklistItem]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Disable large titles for this view controller
        navigationItem.largeTitleDisplayMode = .never
        
        title = checklist.name
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
        saveChecklistItems()
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
        saveChecklistItems()
    }
    
    // file saving
    
    func documentsDirectory() -> URL {
        let paths = FileManager.default.urls(
            for: .documentDirectory,
            in: .userDomainMask)
        return paths [0]
    }
    
    func saveChecklistItems() {
      // 1
      let encoder = PropertyListEncoder()
      // 2
      do {
        // 3
        let data = try encoder.encode(items)
        // 4
        try data.write(
          to: dataFilePath(),
          options: Data.WritingOptions.atomic)
        // 5
      } catch {
        // 6
        print("Error encoding item array: \(error.localizedDescription)")
      }
    }
    
    func dataFilePath() -> URL {
        return documentsDirectory().appendingPathComponent("Timmiesrun.plist")
    }
    
    // loading items
    
    func loadChecklistItems() {
      // 1
      let path = dataFilePath()
      // 2
      if let data = try? Data(contentsOf: path) {
        // 3
        let decoder = PropertyListDecoder()
        do {
          // 4
          items = try decoder.decode(
            [ChecklistItem].self,
            from: data)
        } catch {
          print("Error decoding item array: \(error.localizedDescription)")
        }
      }
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
            let controller = segue.destination as! ItemDetailViewController
            controller.delegate = self
        }
        else if segue.identifier == "EditItem" {
            let controller = segue.destination as! ItemDetailViewController
            controller.delegate = self
            
            if let indexPath = tableView.indexPath(for: sender as! UITableViewCell) {
                controller.itemToEdit = items[indexPath.row]
            }
        }
    }
    
}

