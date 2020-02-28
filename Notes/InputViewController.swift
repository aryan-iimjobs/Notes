//
//  InputViewController.swift
//  Notes
//
//  Created by iim jobs on 27/02/20.
//  Copyright © 2020 iim jobs. All rights reserved.
//

import UIKit
import CoreData

class InputViewController: UIViewController {
    
    var segueDataNSObject: NSManagedObject?
    
    var managedObjectContext: NSManagedObjectContext?
   
    
    @IBOutlet weak var textFieldTitle: UITextField!
    
    @IBOutlet weak var textBoxNote: UITextView!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Get context reference from AppDelegate
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        
        managedObjectContext = appDelegate.persistentContainer.viewContext
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Put focus on textBox
        textBoxNote.becomeFirstResponder()
        
        // Set initial values if note selected from tableView
        if let note = segueDataNSObject {
            textBoxNote.text = note.value(forKeyPath: "comment") as? String
            textFieldTitle.text = note.value(forKeyPath: "title") as? String
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // if note selected from tableView check for data change
        if let note = segueDataNSObject {
            let title = note.value(forKeyPath: "title") as? String
            let note = note.value(forKeyPath: "comment") as? String
            
            if note != textBoxNote.text && title != textFieldTitle.text && (!textBoxNote.text!.isEmpty || !textFieldTitle.text!.isEmpty) {
                saveNote()
                print("Note Saved old")
            }else {
                print("Note not Saved")
            }
        } else {
            if !textBoxNote.text!.isEmpty || !textFieldTitle.text!.isEmpty {
                saveNote()
                print("Note Saved new")
            }
        }
    }
    
    func saveNote() {
        let entity = NSEntityDescription.entity(forEntityName: "Notes", in: managedObjectContext!)!

        let person = NSManagedObject(entity: entity, insertInto: managedObjectContext!)
        
        person.setValue(textFieldTitle.text, forKey: "title")
        person.setValue(textBoxNote.text, forKeyPath: "comment")
        person.setValue(Date().toString(dateFormat: "HH:mm:ss dd-MM-YYYY"), forKeyPath: "date")

        do {
            try managedObjectContext?.save()
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
        self.navigationController?.popViewController(animated: true)

    }
}

// MARK:- ToString for Date()
extension Date {
    func toString(dateFormat format  : String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        return dateFormatter.string(from: self)
    }
}
