//
//  ViewController.swift
//  moodCalendar
//
//  Created by LisaBebe11 on 5/5/18.
//  Copyright © 2018 LisaBebe11. All rights reserved.
//
import EventKit
import UIKit

class ViewController: UIViewController {
    
    @IBOutlet var addNewCalendarEventView: UIView!
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var descriptionTextField: UITextField!
    @IBOutlet weak var locationTextField: UITextField!
    @IBOutlet weak var kindSegmentedControl: UISegmentedControl!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var addButton: UIButton!
    
    var tableData: [Model] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        checkForCalendarAccess()
        
        tableView.dataSource = self
        tableView.delegate = self
        
        updateTableView()
        setupUi()
        
    }
    
    func setupUi() {
        addButton.layer.cornerRadius = addButton.bounds.height / 2
        addNewCalendarEventView.layer.cornerRadius = 15
        addNewCalendarEventView.layer.shadowOpacity = 1
        addNewCalendarEventView.layer.shadowOffset = CGSize.zero
    }
    
    func updateTableView() {
        Data.getEvents(for: Date()) { (data) in
            self.tableData = data
            self.tableView.reloadData()
        }
    }
    
    func checkForCalendarAccess() {
        EKEventStore().requestAccess(to: .event) { (granted, error) in
            if granted == false {
                let alert = UIAlertController(title: "Need Calendar Access", message: "Go into Settings for this app to provide access to your Calendar.", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
                alert.addAction(UIAlertAction(title: "Settings", style: .default, handler: { (alertAction) in
                    UIApplication.shared.open(URL(string:UIApplicationOpenSettingsURLString)!)
                }))
                self.present(alert, animated: true)
            }
        }
    }
    
    @IBAction func addCalendarEvent(_ sender: UIButton) {
        Data.saveEvent(title: titleTextField.text!, description: descriptionTextField.text, location: locationTextField.text, startDate: Date())
        
        closeAddCalendarPopup()
        updateTableView()
    }
    
    @IBAction func newCalendarEvent(_ sender: UIButton) {
        addNewCalendarEventView.alpha = 0
        titleTextField.text = ""
        descriptionTextField.text = ""
        locationTextField.text = ""
        
        view.addSubview(addNewCalendarEventView)
        addNewCalendarEventView.center = view.center
        addNewCalendarEventView.frame.origin.y -= 50
        
        UIView.animate(withDuration: 0.3) {
            self.addNewCalendarEventView.alpha = 1
            self.titleTextField.becomeFirstResponder()
        }
    }
    
    @IBAction func cancelAddCalendarEvent(_ sender: UIButton) {
        closeAddCalendarPopup()
    }
    
    func closeAddCalendarPopup() {
        UIView.animate(withDuration: 0.3, animations: {
            self.addNewCalendarEventView.alpha = 0
        }) { (success) in
            self.addNewCalendarEventView.removeFromSuperview()
        }
    }
}

extension ViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "tableViewCell") as! TableViewCell
        cell.setup(model: tableData[indexPath.row])
        return cell
    }
}

extension ViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let identifier = tableData[indexPath.row].eventIdentifier
        
        let deleteAction = UIContextualAction(style: .destructive, title: "Delete") { (action, view, success) in
            // If this success function returns false, the row does not get removed.
            success(Data.deleteEvent(eventIdentifier: identifier))
        }
        deleteAction.image = #imageLiteral(resourceName: "delete")
        
        return UISwipeActionsConfiguration(actions: [deleteAction])
    }
    
    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let identifier = tableData[indexPath.row].eventIdentifier
        
        let doneAction = UIContextualAction(style: .normal, title: "Done") { (action, view, success) in
            // If this success function returns false, the row does not get removed.
            success(Data.deleteEvent(eventIdentifier: identifier))
            view.tintColor = UIColor.purple // Changes color of icon from white
        }
        
        doneAction.image = #imageLiteral(resourceName: "done")
        doneAction.backgroundColor = #colorLiteral(red: 0.2745098174, green: 0.4862745106, blue: 0.1411764771, alpha: 1)
        
        return UISwipeActionsConfiguration(actions: [doneAction])
    }
}
