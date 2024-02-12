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
        
        // step 5
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
                        print(self.names)
                    self.tableviewOutlet.reloadData()
                    })
    }


    @IBAction func buttonAction(_ sender: Any) {
        let name = textfieldOutlet.text!
        ref.child("Students").childByAutoId().setValue(name)
    }
    
    @IBAction func saveStudentAction(_ sender: Any) {
        let tempName = textfieldOutlet.text!
        let tempAge = Int(agefieldOutlet.text ?? "0")!
        let s1 = Student(name: tempName, age: tempAge)
        studentArray.append(s1)
        s1.saveToFirebase()
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return names.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "myCell")!
        cell.textLabel?.text = "\(names[indexPath.row])"
        return cell
    }
    
}

