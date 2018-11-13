//
//  BuildingControllerViewController.swift
//  FurnitureApp
//
//  Created by Carl Claesson on 2018-11-11.
//  Copyright © 2018 Mohammad Azam. All rights reserved.
//

import UIKit

class BuildingSelectorVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet weak var tableView: UITableView!
    var buildings = ["Medival_Building.DAE", "ship.scn", "Medival_Building.DAE", "ship.scn", "Medival_Building.DAE", "ship.scn", "Medival_Building.DAE", "ship.scn"]
    var buildingToPass: String!

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.contentInset = UIEdgeInsets(top: 10, left: 0, bottom: 0, right: 0)

    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return buildings.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "BuildingCell", for: indexPath) as? BuildingViewCell{
            cell.configureCell(building: buildings[indexPath.row])
            return cell
        }
        return UITableViewCell()
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 200.0
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        buildingToPass = buildings[indexPath.row]
        performSegue(withIdentifier: "toARView", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let ARVC = segue.destination as? ARViewController {
            ARVC.selectedBuilding = buildingToPass
        }
    }
}
