//
//  AllListsViewController.swift
//  TimmiesRun
//
//  Created by Nicole Groeger on 2024-06-20.
//

import UIKit

class AllListsViewController: UITableViewController, ListDetailViewControllerDelegate {
    let cellIdentifier = "ChecklistCell"
    var lists = [Checklist]()  // array to storenew Checklist objects

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.prefersLargeTitles = true
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellIdentifier)
        navigationController?.navigationBar.prefersLargeTitles = true // large title shown in navigation bar
    
        // placeholder data
        var list = Checklist(name: "Order 1")
        lists.append(list)
        
        list = Checklist(name: "Order 2")
        lists.append(list)
        
        list = Checklist(name: "Order 3")
        lists.append(list)
        
        list = Checklist(name: "Order 66")
        lists.append(list)
    }

    // MARK: - Table view data source

    override func tableView(
        _ tableView: UITableView,
        numberOfRowsInSection section: Int
    ) -> Int {
        return lists.count
    }
    
    override func tableView(
        _ tableView: UITableView,
        cellForRowAt indexPath: IndexPath
    ) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(
            withIdentifier: cellIdentifier, for: indexPath)
        // update cell information
        let checklist = lists[indexPath.row]
        cell.textLabel!.text = checklist.name
        cell.accessoryType = .detailDisclosureButton
        
        return cell
    }
    
    override func tableView(
      _ tableView: UITableView,
      didSelectRowAt indexPath: IndexPath
    ) {
        let checklist = lists[indexPath.row]
      performSegue(withIdentifier: "ShowChecklist", sender: checklist)
    }
   
    // lets user delete checklists
    
    override func tableView(
        _ tableView: UITableView,
        commit editingStyle: UITableViewCell.EditingStyle,
        forRowAt indexPath: IndexPath
    ){
        lists.remove(at: indexPath.row)
        
        let indexPaths = [indexPath]
        tableView.deleteRows(at: indexPaths, with: .automatic)
    }
    
    override func tableView(
      _ tableView: UITableView,
      accessoryButtonTappedForRowWith indexPath: IndexPath
    ) {
      let controller = storyboard!.instantiateViewController(
        withIdentifier: "ListDetailViewController") as! ListDetailViewController
      controller.delegate = self

      let checklist = lists[indexPath.row]
      controller.checklistToEdit = checklist

      navigationController?.pushViewController(
        controller,
        animated: true)
    }
    
    // MARK: - Navigation
    override func prepare(
        for segue: UIStoryboardSegue,
        sender: Any?
    ) {
        if segue.identifier == "ShowChecklist" {
            let controller = segue.destination as! TimmiesViewController
            controller.checklist = sender as? Checklist
        } else if segue.identifier == "AddChecklist" {
            let controller = segue.destination as! ListDetailViewController
            controller.delegate = self
        }
    }

    // MARK: - List Detail View Controller Delegates
    func listDetailViewControllerDidCancel(
      _ controller: ListDetailViewController
    ) {
      navigationController?.popViewController(animated: true)
    }

    @objc(listDetailViewController:didFinishEditing:) func listDetailViewController(
        _ controller: ListDetailViewController,
        didFinishEditing checklist: Checklist
    ) {
      let newRowIndex = lists.count
      lists.append(checklist)

      let indexPath = IndexPath(row: newRowIndex, section: 0)
      let indexPaths = [indexPath]
      tableView.insertRows(at: indexPaths, with: .automatic)

      navigationController?.popViewController(animated: true)
    }

    @objc(listDetailViewController:didFinishAdding:) func listDetailViewController(
        _ controller: ListDetailViewController,
        didFinishAdding checklist: Checklist
    ) {
      if let index = lists.firstIndex(of: checklist) {
        let indexPath = IndexPath(row: index, section: 0)
        if let cell = tableView.cellForRow(at: indexPath) {
          cell.textLabel!.text = checklist.name
        }
      }
      navigationController?.popViewController(animated: true)
    }

}
