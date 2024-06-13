//
//  AddItemViewController.swift
//  TimmiesRun
//
//  Created by Nicole Groeger on 2024-06-13.
//

import UIKit

class AddItemViewController: UITableViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.largeTitleDisplayMode = .never
    }
    
    // MARK: - Actions
    
    // cancel button
    @IBAction func cancel() {
        navigationController?.popViewController(animated: true)
    }
    
    // done button
    @IBAction func done() {
        navigationController?.popViewController(animated: true)
    }
}
