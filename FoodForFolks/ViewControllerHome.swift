//
//  ViewControllerHome.swift
//  FoodForFolks
//
//  Created by Cory L. Rooker on 3/5/19.
//  Copyright © 2019 Cory L. Rooker. All rights reserved.
//

import UIKit

class ViewControllerHome: UIViewController {

    let testFood = TestFoodData.data
    
    var foodNumber:Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        //print(testFood[0].itemDescription)
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "foodDetails") {
            let foodDetails = segue.destination as! ViewControllerFoodDetails
            foodDetails.food = testFood[foodNumber!]
        }
    }

}

extension ViewControllerHome: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let cellNib = UINib(nibName: "TableViewCellHome", bundle: nil)
        tableView.register(cellNib, forCellReuseIdentifier: "HomeCell")
        return testFood.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "HomeCell", for: indexPath) as! TableViewCellHome
        let food = testFood[indexPath.row]
        cell.itemDescription.text = food.itemDescription
        cell.itemQuanty.text = food.itemQuanty
        cell.postTime.text = food.itemPostDate
        cell.pictureOfFood.image = UIImage(named: "apples")!
        
        return cell
    }
}

extension ViewControllerHome: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
    func tableView(_ tableView: UITableView, accessoryButtonTappedForRowWith indexPath: IndexPath) {
        foodNumber = indexPath.row
        performSegue(withIdentifier: "foodDetails", sender: nil)
    }

}