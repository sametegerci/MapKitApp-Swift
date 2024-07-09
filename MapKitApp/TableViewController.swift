//
//  TableViewController.swift
//  MapKitApp
//
//  Created by Mehmet Samet Eğerci on 27.06.2024.
//

import UIKit
import CoreData

class TableViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    @IBOutlet weak var tableView: UITableView!
    var titleArray = [String]()
    var titleArrayId = [UUID]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.dataSource = self
        tableView.delegate = self
        
       
        
        
        
        
        
        navigationController?.navigationBar.topItem?.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.add, target: self, action: #selector(addButtonClicked))
        
        getData()
        
        
    }
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        NotificationCenter.default.addObserver(self, selector: #selector(getData), name: NSNotification.Name("Places"), object: nil)
    }
   @objc func getData() {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Places")
        request.returnsObjectsAsFaults = false
        do {
            // CORE DATA DAKİ VERİLERE ERİŞMEMİZİ SAĞLAR
            
                
             let results = try context.fetch(request)
            if results.count > 0 {
                self.titleArray.removeAll(keepingCapacity: false) // aşşağoda başlıyacak olan for loop başlamadan önce verileri silmemiz lazım(kapasiteyi tutma)
                self.titleArrayId.removeAll(keepingCapacity: false)
                
                
                for result in results as! [NSManagedObject] {
                  if let name =  result.value(forKey: "name") as? String {
                        self.titleArray.append(name)
                        
                    }
                    if let id = result.value(forKey: "id") as? UUID {
                        self.titleArrayId.append(id)
                        
                    }
                    
                    tableView.reloadData()
                }
            }
            
            
            
        }catch{
            print("error")
        }
        
        
        
    }
    
    @objc func addButtonClicked(){
        
        performSegue(withIdentifier: "toViewController", sender: nil)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return titleArray.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        var content = cell.defaultContentConfiguration()
        content.text = titleArray[indexPath.row]
        cell.contentConfiguration = content
        return cell
    }
    
    
    
    

}
