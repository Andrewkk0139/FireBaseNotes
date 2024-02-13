//
//  Student.swift
//  FireBaseNotes
//
//  Created by ANDREW KAISER on 2/12/24.
//

import Foundation
import FirebaseCore
import FirebaseDatabase

class Student{
    
    var name: String
    var age: Int
    
    //refrence to firebase
    var ref = Database.database().reference()
    //
    
    init(name: String, age: Int) {
        self.name = name
        self.age = age
    }
    
    // this method lets new data from firebase be converted into a student.
    init(dict: [String:Any]){
        // Safely unwrapping values from dictionary
        if let a = dict["age:"] as? Int{
            age = a
        }
        else{
            age = 0
        }
        if let n = dict["name:"] as? String{
            name = n
        } else {
            name = ""
        }
    }
    
    func saveToFirebase() {
        // in func makes a dictionary
        let dict = ["name:":name,"age:":age] as [String:Any]
        // saves the dictionary to the child, Students2
        ref.child("Students2").childByAutoId().setValue(dict)
    }
}
