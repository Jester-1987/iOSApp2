//
//  AddItemViewController.swift
//  TimmiesRun
//
//  Created by Nicole Groeger on 2024-06-13.
//

import UIKit

class AddItemViewController: UITableViewController, UITextFieldDelegate {
    
    // Text field outlet
    
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var doneBarButton: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.largeTitleDisplayMode = .never
    }
    
    // bring up keyboard automatically
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        textField.becomeFirstResponder()
    }
    
    // MARK: - Actions
    
    // cancel button
    @IBAction func cancel() {
        navigationController?.popViewController(animated: true)
    }
    
    // done button
    @IBAction func done() {
        // test print to terminal
        print("Contents of the text field: \(textField.text!)")
        
        navigationController?.popViewController(animated: true)
    }
    
    // MARK: - Table View Delegates
    
    // stops text field from being grayed out when user taps on screen elsewhere
    override func tableView(
        _ tableView: UITableView,
        willSelectRowAt indexPath: IndexPath
    ) -> IndexPath? {
        return nil
    }
    
    // MARK: Text Field Delegates
    
    // disabling done button until something is entered into the text field
    func textField(
        _ textField: UITextField,
        shouldChangeCharactersIn range: NSRange,
        replacementString string: String
    ) -> Bool {
        let oldText = textField.text!
        let stringRange = Range(range, in:oldText)!
        let newText = oldText.replacingCharacters(in: stringRange, with: string)
        if newText.isEmpty {
            doneBarButton.isEnabled = false
        } else {
            doneBarButton.isEnabled = true
        }
        return true
    }
    
    // clear button correctly disables the Done button after clearing text field
    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        doneBarButton.isEnabled = false
        return true
    }
   
    

}
