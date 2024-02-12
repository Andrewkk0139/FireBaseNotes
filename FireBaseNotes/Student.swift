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
    
    func saveToFirebase() {
        // in func makes a dictionary
        let dict = ["name:":name,"age:":age] as [String:Any]
        // saves the dictionary to the child, Students2
        ref.child("Students2").childByAutoId().setValue(dict)
    }
}
