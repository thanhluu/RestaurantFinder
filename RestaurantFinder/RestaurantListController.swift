//
//  RestaurantListController.swift
//  RestaurantFinder
//
//  Created by Luu Tien Thanh on 7/5/16.
//  Copyright © 2016 Thanh Luu. All rights reserved.
//

import UIKit

class RestaurantListController: UITableViewController {
    
    let coordinate = Coordinate(latitude: 40.759106, longitude: -73.985185) // Time Square
    
    //let coordinate = Coordinate(latitude: 21.042849, longitude: -105.8161224) // Thuy Khue
    
    let foursquareClient = FoursquareClient(clientID: "KNSAADANCCDJMJP1AVRT3YHIKLFX5XLUWMRL1VM4G03EIOEX", clientSecret: "A5HSY22YULU215ZZAEOBRDJDRQWXIU2GYC2COU2PQUDXAYP5")
    
    var venues: [Venue] = [] {
        didSet {
            tableView.reloadData()
        }
    }

    var detailViewController: DetailViewController? = nil
    var objects = [AnyObject]()


    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        foursquareClient.fetchRestaurantsFor(coordinate, category: .Food(nil)) { result in
            switch result {
            case .Success(let venues):
                self.venues = venues
            case .Failure(let error):
                print(error)
            }
        }
    }

    override func viewWillAppear(animated: Bool) {
        self.clearsSelectionOnViewWillAppear = self.splitViewController!.collapsed
        super.viewWillAppear(animated)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Segues

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "showDetail" {
            if let indexPath = self.tableView.indexPathForSelectedRow {
                let controller = (segue.destinationViewController as! UINavigationController).topViewController as! DetailViewController
                
                let venue = venues[indexPath.row]
                controller.venue = venue
                
                controller.navigationItem.leftBarButtonItem = self.splitViewController?.displayModeButtonItem()
                controller.navigationItem.leftItemsSupplementBackButton = true
            }
        }
    }

    // MARK: - Table View

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return venues.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("RestaurantCell", forIndexPath: indexPath) as! RestaurantCell
        
        let venue = venues[indexPath.row]
        cell.restaurantTitleLabel.text = venue.name
        cell.restaurantCheckinLabel.text = venue.checkins.description
        cell.restaurantCategoryLabel.text = venue.categoryName
        
        return cell
    }

    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    @IBAction func refreshRestaurantData(sender: AnyObject) {
        foursquareClient.fetchRestaurantsFor(coordinate, category: .Food(nil)) { result in
            switch result {
            case .Success(let venues):
                self.venues = venues
            case .Failure(let error):
                print(error)
            }
        }
        
        refreshControl?.endRefreshing()
    }
}

