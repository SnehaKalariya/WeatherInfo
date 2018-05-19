//
//  WeatherInfoViewController.swift
//  WeatherInfo
//
//  Created by Jigar Jarsania on 5/19/18.
//  Copyright © 2018 Sneha Jarsania. All rights reserved.
//

import UIKit
import CoreData

class WeatherInfoViewController: UIViewController,NSFetchedResultsControllerDelegate {
    
    let coreDataModel = CoreDataHandler()
    var fetchWeatherInfo = [WeatherData]()
    var managedObjectContext: NSManagedObjectContext!
    var fetchedResultsController: NSFetchedResultsController<NSFetchRequestResult>!
    
    @IBOutlet var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "Weather Information"
        
        //Notification Register 
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self,
                                       selector:#selector(getDataChanged(notification:)),
                                       name: .getDataNotification,
                                       object: nil)
        serviceCall()
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        managedObjectContext = appDelegate.persistentContainer.viewContext
        
        setFetchResultController()
        
        fetchResultData()
        
    }
    //MARK : - Get Data Changed
    @objc func getDataChanged(notification: NSNotification){
        //do stuff
        fetchResultData()
    }
    
    //MARK : - Service call
    func serviceCall() {
        let serviceObject = Service()
        serviceObject.fetchData()
        
    }
    
    // MARK : - Create Fetch Result Controller
    func setFetchResultController() {
        // Initialize Fetch Request
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "WeatherData")
        
        // Add Sort Descriptors
        let sortDescriptor = NSSortDescriptor(key: "temp", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]
        //
        // Initialize Fetched Results Controller
        fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: self.managedObjectContext, sectionNameKeyPath: nil, cacheName: nil)
        
        // Configure Fetched Results Controller
        fetchedResultsController.delegate = self
        
    }
    func fetchResultData(){
        do {
            try self.fetchedResultsController.performFetch()
        } catch {
            let fetchError = error as NSError
            print("\(fetchError), \(fetchError.userInfo)")
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func dataSavedSucessfully(){
        self.coreDataModel.fetchResult { (fetchData) in
            self.fetchWeatherInfo = fetchData
            // self.tableView.reloadData()
        }
    }
    // MARK: Fetched Results Controller Delegate Methods
    func controllerWillChangeContent( _ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.beginUpdates()
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.endUpdates()
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        switch (type) {
        case .insert:
            if let indexPath = newIndexPath {
                tableView.insertRows(at: [indexPath], with: .fade)
            }
            break;
        case .delete:
            if let indexPath = indexPath {
                tableView.deleteRows(at: [indexPath], with: .fade)
            }
            break;
        case .update:
            if let indexPath = indexPath {
                let cell = tableView.cellForRow(at: indexPath) as! WeatherInfoTableCell
                configureCell(cell, at: indexPath)
            }
            break;
        case .move:
            if let indexPath = indexPath {
                tableView.deleteRows(at: [indexPath], with: .fade)
            }
            
            if let newIndexPath = newIndexPath {
                tableView.insertRows(at: [newIndexPath], with: .fade)
            }
            break;
        }
    }
   
    
}
extension WeatherInfoViewController : UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let sections = fetchedResultsController.sections {
            let sectionInfo = sections[section]
            return sectionInfo.numberOfObjects
        }
        
        return 0
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! WeatherInfoTableCell
        //        cell.cityName.text = fetchWeatherInfo[indexPath.row].city!
        //        cell.temp.text = String(describing: fetchWeatherInfo[indexPath.row].temp!)
        configureCell(cell, at: indexPath)
        return cell
    }
    func configureCell(_ cell: WeatherInfoTableCell, at indexPath: IndexPath) {
        let fetchObject = fetchedResultsController.object(at: indexPath) as! WeatherData
        // Configure Cell
        if let cityName = fetchObject.city{
            cell.cityName.text = cityName
        }
        cell.temp.text = "\(String(describing: fetchObject.temp!)) °"
        
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let fetchObject = fetchedResultsController.object(at: indexPath) as! WeatherData
        let weatherDetailScreenObject = self.storyboard?.instantiateViewController(withIdentifier: "WeatherDetailsVC") as! WeatherInfoDetailsViewController
        weatherDetailScreenObject.weatherDetails = fetchObject
        self.navigationController?.pushViewController(weatherDetailScreenObject, animated: true)    //Alternatively, we can use prepare for segue method
    }
}
extension Notification.Name {
    static let getDataNotification = Notification.Name(
        rawValue: "getDataNotification")
}

