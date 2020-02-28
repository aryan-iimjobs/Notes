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
   
    @IBOutlet weak var buttonCancel: FloatingButton!
    
    @IBAction func buttonCancelClick(_ sender: Any) {
        self.tableView.isEditing = false
        self.tableView.allowsMultipleSelectionDuringEditing = false
        
        let smallConfiguration = UIImage.SymbolConfiguration(scale: .medium)
        let smallTrashImage = UIImage(systemName: "plus", withConfiguration: smallConfiguration)
        buttonAdd.setImage(smallTrashImage, for: .normal)
        
        UIView.animate(withDuration: 0.5, animations: {
            self.buttonCancel.isEnabled = false
            self.buttonCancel.alpha = 0
        })
    }
    
    @IBAction func buttonAddClick(_ sender: Any) {}
    
    var managedObjectContext: NSManagedObjectContext?
    
    var arrayAddedNotes: [NSManagedObject] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        title = "Notes"
        
        // Handle long Press on tableView cell
        let longPressGesture = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPress))
        self.tableView.addGestureRecognizer(longPressGesture)
    }
    
    @objc func handleLongPress(longPressGesture: UILongPressGestureRecognizer) {
        let p = longPressGesture.location(in: self.tableView)
        let indexPath = self.tableView.indexPathForRow(at: p)
        if indexPath == nil {
            print("Long press on table view, not row.")
        } else if longPressGesture.state == UIGestureRecognizer.State.began {
            print("Long press on row, at \(indexPath!.row)")
            self.tableView.isEditing = true
            self.tableView.allowsMultipleSelectionDuringEditing = true
            tableView.reloadData()
            
            let smallConfiguration = UIImage.SymbolConfiguration(scale: .medium)
            let smallTrashImage = UIImage(systemName: "trash", withConfiguration: smallConfiguration)
            buttonAdd.setImage(smallTrashImage, for: .normal)
            
            UIView.animate(withDuration: 0.5, animations: {
                self.buttonCancel.isEnabled = true
                self.buttonCancel.alpha = 1
            })
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        
        managedObjectContext = appDelegate.persistentContainer.viewContext
        
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Notes")
        let sort = NSSortDescriptor(key: "date", ascending: false)
        fetchRequest.sortDescriptors = [sort]
        
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
                
                let note = arrayAddedNotes[indexPath.row]
                controller.segueDataNSObject = note
            }
        }
    }
    
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        if self.tableView.isEditing {
            if identifier == "segueInputNote" {
                if let arrayNote = self.tableView.indexPathsForSelectedRows {
                    
                    for note in arrayNote {
                        self.managedObjectContext?.delete(arrayAddedNotes[note.row])
                        self.arrayAddedNotes.remove(at: note.row)
                        self.tableView.deleteRows(at: [note], with: .fade)
                    }
            
                    do {
                        try self.managedObjectContext?.save()
                    } catch let error as NSError {
                        print("Could not save. \(error), \(error.userInfo)")
                    }
                }
            }
            return false
        }
        return true
    }
}


extension ViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrayAddedNotes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "mainTableCell", for: indexPath)
        
        let note = arrayAddedNotes[indexPath.row]
        
        if note.value(forKeyPath: "title") as? String == nil || note.value(forKeyPath: "title") as? String == "" {
            cell.textLabel?.text = note.value(forKeyPath: "comment") as? String
        }
        else{
            cell.textLabel?.text = note.value(forKeyPath: "title") as? String
        }
        cell.detailTextLabel?.text = note.value(forKeyPath: "date") as? String
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let note = arrayAddedNotes[indexPath.row]
            managedObjectContext?.delete(note)
            arrayAddedNotes.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)

            do {
                try managedObjectContext?.save()
            } catch let error as NSError {
                print("Could not save. \(error), \(error.userInfo)")
            }
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("select row \(indexPath.row)")
    }
    
}
