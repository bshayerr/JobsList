//
//  JobsVC.swift
//  Madad
//
//  Created by bshayer  on 1/26/18.
//  Copyright © 2018 GeekLoop. All rights reserved.
//

import UIKit

class JobsVC: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate {

    // View Controller Labels
    @IBOutlet weak var JobsTable: UITableView!
    @IBOutlet weak var SearchBar: UISearchBar!

    
    var jobsArray = [Jobs]() // to store the data
    var currentJobsArray = [Jobs]() //to update data after a user do search
    
    
    // Loading the Functions to View Controller to be executed
    override func viewDidLoad() {
        super.viewDidLoad()
        JobsTable.delegate = self
        JobsTable.dataSource = self
        setUpJobs()
        setUpSearchBar()
        alterLayout()
    }
    
    
    @IBAction func AddJobsBtnPressed(_ sender: Any) {
        UIApplication.shared.open(URL(string: "http://www.madad-official.com/add-job")! as URL, options: [:], completionHandler: nil)
    }
    
    
  
    
    
   ///----------------- <<< TABEL VIEW SECTION >>> -----------------///
 
    private func setUpJobs() {
     jobsArray = DataService.instance.getJobs()
       jobsArray = currentJobsArray
    }
    
    
    // 1: UITabelViewFunction: To specify the number of rows "cells" in the table view
    func tableView(_ tableView: UITableView,numberOfRowsInSection section: Int) -> Int
    {
        return DataService.instance.getJobs().count
        // return currentJobsArray.count
       //Cause our data is inside DataService we call it that way
          }
    
    
    // 2: UITabelViewFunction: To add the data to each row "cell" in the tabel
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       
        if let cell = tableView.dequeueReusableCell(withIdentifier: "customCell") as? JobsCell {
           let jobs = DataService.instance.getJobs()[indexPath.row]
           
            // To make the cell corner looks convexyyy
            cell.cellView.layer.cornerRadius = cell.cellView.frame.height / 2
            
            // To update the cell view when new data is been added
            cell.updateViews(jobs: jobs)
            return cell
              }  else   {
                 return JobsCell()
        }
    }
    
    
    // 3: UITabelViewFunction: To Fix the size of cells, so its cannot be bigger or smaller
    func tableView(_ tableView: UITableView,heightForRowAt indexPath: IndexPath) -> CGFloat
    { return 90 }
    
    
    // 4: UITabelViewFunction: To show the Details View Controller when the user press on a Cell
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let jobs = DataService.instance.getJobs()[indexPath.row]
        performSegue(withIdentifier: "toJobDetails", sender: jobs )
    }
    
    
    // 5: UITabelViewFunction: To animate the Jobs Table in a faded way
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        //1. Set initial state of cell
        cell.alpha = 0
        let Transform = CATransform3DTranslate(CATransform3DIdentity, -250, 20 , 0)
        cell.layer.transform = Transform
        
        //2. Use UIView animation method to change the final state of cell
        UIView.animate(withDuration: 1.0) {
            cell.alpha = 1.0
            cell.layer.transform = CATransform3DIdentity
        }
    }
    
    // To pass the data to JobsDetails View Controller
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let DestinationVC = segue.destination as? JobDetailsVC {
            assert(sender as? Jobs != nil) //make sure the cell isnt empty 
            DestinationVC.initJobsDetails(jobs: sender as! Jobs)
        }
        
    }
    
    
  
    
    ///----------------- <<< SEARCH BAR SECTION >>> -----------------///
    
    
    //function to set search results
   func setUpSearchBar(){
        SearchBar.delegate = self
    }
    
    
    func alterLayout() {
        JobsTable.tableHeaderView = UIView()    // search bar in section header
        JobsTable.estimatedSectionHeaderHeight = 50  // search bar in navigation bar
        navigationItem.titleView = SearchBar
        SearchBar.placeholder = "Search for a job by name"
    }
    
    
    //Sreachbar Delegate function
  func searchBar(_searchBar: UISearchBar, textDidChange searchText: String ){
    guard !searchText.isEmpty
            else { currentJobsArray = jobsArray
                JobsTable.reloadData()
                return }
        currentJobsArray = jobsArray.filter({ Jobs -> Bool in
            Jobs.JobName.lowercased().contains(searchText.lowercased() ) })
        JobsTable.reloadData() }
    
    
    func searchBar(_ searchBar: UISearchBar, selectedScopeButtonIndexDidChange selectedScope: Int) {
        switch selectedScope {
        case 0:
            currentJobsArray = jobsArray
        default:
            break
        }
        JobsTable.reloadData()
    }

}

