//
//  CategoryTableViewController.swift
//  Grocery App Firebase
//
//  Created by Hayden Goldman on 3/8/17.
//  Copyright © 2017 Hayden Goldman. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase

class CategoryTableViewController: UITableViewController, AddNewCategoryDelegate {
    
    var categories = [Category]()
    var items = [Item]()
    var itemTitles :String?

    override func viewDidLoad() {
        super.viewDidLoad()

        self.populateData()
    }

    private func populateData() {
        
        let ref = FIRDatabase.database().reference(withPath: "categories")
        ref.observe(.value) { (snapshot :FIRDataSnapshot) in
            
            self.categories.removeAll()

            for snap in snapshot.children {
                
                let snapshotDictionary = (snap as! FIRDataSnapshot).value as! [String:Any]
                let categoryTitle = snapshotDictionary["title"] as! String
    
                let category = Category()
                category.title = categoryTitle

                self.categories.append(category)
            }
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    
    private func addData(title :String) {
        
        let ref = FIRDatabase.database().reference(withPath: "categories")
        let categoryRef = ref.child(title)
        
        let category = Category()
        category.title = title
        
        categoryRef.setValue(category.toDictionary())
            
    }
    
    //add stuff manually
//    @IBAction func AddStuffManually(_ sender: Any) {
//        
//        let ref = FIRDatabase.database().reference(withPath: "categories")
//        
//        let hebRef = ref.child("HEB")
//        
//        let heb = Category()
//        heb.title = "HEB"
//        
//        let beer = Item()
//        beer.title = "beer"
//        
//        let coffee = Item()
//        coffee.title = "coffee"
//        
//        let banana = Item()
//        banana.title = "banana"
//        
//        heb.items.append(beer)
//        heb.items.append(coffee)
//        heb.items.append(banana)
//        
//        hebRef.setValue(heb.toDictionary())
//        
//        let cvsRef = ref.child("CVS")
//        
//        let cvs = Category()
//        cvs.title = "CVS"
//        
//        let soap = Item()
//        soap.title = "soap"
//        
//        let toothPaste = Item()
//        toothPaste.title = "toothpaste"
//        
//        cvs.items.append(soap)
//        cvs.items.append(toothPaste)
//        
//        cvsRef.setValue(cvs.toDictionary())
//        
//    }
    
    //add category
    func addCategoryDidSave(title :String) {
        self.addData(title: title)
        self.populateData()
    }
    
    //segue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "AddCategory" {
            let addCategoryVC: AddCategoryViewController = segue.destination as! AddCategoryViewController
            addCategoryVC.delegate = self
        } else if segue.identifier == "ShowCategory" {
            
            guard  let indexPath :IndexPath = self.tableView.indexPathForSelectedRow else {
                fatalError("No Path Selected")
            }
            
            let category = self.categories[indexPath.row] 
            let itemTVC: ItemTableViewController = segue.destination as! ItemTableViewController
            
            itemTVC.categories = category
            
        }
        
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return self.categories.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath)
        let category = self.categories[indexPath.row]
        cell.textLabel?.text = category.title
        return cell
    }
    
}
