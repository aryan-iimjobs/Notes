//
//  ViewController.swift
//  Notes
//
//  Created by iim jobs on 27/02/20.
//  Copyright © 2020 iim jobs. All rights reserved.
//

import UIKit
import CoreData

class ViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var buttonAdd: FloatingButton!
   
    @IBAction func buttonAddClick(_ sender: Any) {
        
    }
    
    var managedObjectContext: NSManagedObjectContext?
    
    var arrayAddedNotes: [NSManagedObject] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        title = "Notes"
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        
        managedObjectContext = appDelegate.persistentContainer.viewContext
        
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Notes")
        
        do {
            arrayAddedNotes = try managedObjectContext!.fetch(fetchRequest)
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
        
        tableView.reloadData()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "segueShowNote" {
            if let indexPath = self.tableView.indexPathForSelectedRow {
                let controller = segue.destination as! InputViewController
                let text = arrayAddedNotes[indexPath.row].value(forKeyPath: "note") as? String
                controller.segueDataTextBoxNote = text
            }
        }
    }
}

extension ViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrayAddedNotes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "mainTableCell", for: indexPath)
        
        let note = arrayAddedNotes[indexPath.row]
        
        cell.textLabel?.text = note.value(forKeyPath: "note") as? String
        cell.detailTextLabel?.text = note.value(forKeyPath: "date") as? String
        return cell
    }
}
