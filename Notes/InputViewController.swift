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
    
    var segueDataTextBoxNote: String?
    
    var managedObjectContext: NSManagedObjectContext?
   
    @IBOutlet var textFieldTitle: UIView!
    
    @IBOutlet weak var textBoxNote: UITextView!
    
    @IBAction func btnSaveNote(_ sender: UIStoryboardSegue) {
        let entity = NSEntityDescription.entity(forEntityName: "Notes", in: managedObjectContext!)!

        let person = NSManagedObject(entity: entity, insertInto: managedObjectContext!)

        person.setValue(textBoxNote.text, forKeyPath: "note")
        person.setValue(Date().toString(dateFormat: "dd-MM-YYYY HH:mm:ss"), forKeyPath: "date")

        do {
            try managedObjectContext?.save()
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
        self.navigationController?.popViewController(animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let text = segueDataTextBoxNote {
            textBoxNote.text = text
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        
        managedObjectContext = appDelegate.persistentContainer.viewContext
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
