//
//  ViewController.swift
//  FireBaseNotes
//
//  Created by ANDREW KAISER on 2/7/24.
//

import UIKit
import FirebaseCore
import FirebaseDatabase


class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
   
    
    @IBOutlet weak var agefieldOutlet: UITextField!
    @IBOutlet weak var textfieldOutlet: UITextField!
    var name: String!
    var names: [String] = []
    @IBOutlet weak var tableviewOutlet: UITableView!
    var studentArray: [Student] = []
    
    
    //reference to the firebase
    var ref: DatabaseReference!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        tableviewOutlet.delegate = self
        tableviewOutlet.dataSource = self
        ref = Database.database().reference()
        
        // step 5, SINGLE OBJECTS
        //observe looks for data changes in a specified child location.
        ref.child("Students").observe(.childAdded, with: { (snapshot) in
                  // snapshot is a dictionary with a key and a value
                   
                   // this gets each name from each snapshot
                   let n = snapshot.value as! String
                   // adds the name to an array if the name is not already there
                   if !self.names.contains(n){
                       self.names.append(n)
                   }
               })
        //called after .childAdded is done
                ref.child("Students").observeSingleEvent(of: .value, with: { snapshot in
                        print("--inital load has completed and the last user was read--")
                      //  print(self.studentArray)
                    self.tableviewOutlet.reloadData()
                    })
        // Step 8, READING NEW DATA FROM STUDENTS
        
        // looks for data changes
        ref.child("Students2").observe(.childAdded, with: { (snapshot) in
            // keys are the "-NqY-fXQANmvGjwoY9Qw" numbers, then the values are dictionaries
                    let dict = snapshot.value as! [String:Any]
                    let s = Student(dict: dict)
                    //assigns each new read student's key variable to its firebase key.
                    s.firebaseKey = snapshot.key
                    self.studentArray.append(s)
                    self.names.append(s.name)
            
                    self.tableviewOutlet.reloadData()
               })
        
        // called after .childAdded
        ref.child("Students2").observeSingleEvent(of: .value, with: { snapshot in
                print("--inital load has completed and the last user was read--")
                print(self.studentArray.count)
            })
        ref.child("Students2").observe(.childRemoved) { (snapshot) in
            for i in 0..<self.studentArray.count {
                if snapshot.key == self.studentArray[i].firebaseKey {
                    self.studentArray.remove(at: i)
                    self.tableviewOutlet.reloadData()
                    break
                }
            }
            
        }
        
    }


    @IBAction func buttonAction(_ sender: Any) {
        let name = textfieldOutlet.text!
        ref.child("Students").childByAutoId().setValue(name)
    }
    
    @IBAction func saveStudentAction(_ sender: Any) {
        let tempName = textfieldOutlet.text!
        let tempAge = Int(agefieldOutlet.text ?? "0")!
        let s1 = Student(name: tempName, age: tempAge)
        s1.saveToFirebase()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return studentArray.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "myCell")!
        cell.textLabel?.text = "\(studentArray[indexPath.row].name)"
        return cell
    }
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .delete
    }
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
        //    print("This is studentArray WOOO: \(self.studentArray[indexPath.row].name)")
            studentArray[indexPath.row].deleteFromFirebase()
            studentArray.remove(at: indexPath.row)
            tableView.reloadData()
        }
    }
    
    
    
}

