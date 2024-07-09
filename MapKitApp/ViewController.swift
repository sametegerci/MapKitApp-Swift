//
//  ViewController.swift
//  MapKitApp
//
//  Created by Mehmet Samet Eğerci on 26.06.2024.
//

import UIKit
import MapKit
import CoreLocation
import CoreData
// 1. kullanıcı konumunu almak
// 2. haritaya pin eklemek (gestureRecognizer,UILongPressGestureRecognize - map kite eklemek)







class ViewController: UIViewController,MKMapViewDelegate,CLLocationManagerDelegate {
    @IBOutlet weak var mapKit: MKMapView!
    @IBOutlet weak var nameText: UITextField!
    @IBOutlet weak var commentText: UITextField!
    
    
    
    var locationManager = CLLocationManager()
    var choosenLongitude = Double()
    var choosenLatitude = Double()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mapKit.delegate = self
        locationManager.delegate = self
        
        locationManager.desiredAccuracy = kCLLocationAccuracyBest //kullanıcının konumunu tam olarak alma
        locationManager.requestWhenInUseAuthorization() // kullanıcıdan izin aldık (benim app imi ne zaman kullanırsa)
        locationManager.startUpdatingLocation() // kullanıcıonın lokasyonunu almaya başlıyoruz...
        
        let gestureRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(choosenLocation(gestureRecognizer: )))
        gestureRecognizer.minimumPressDuration = 2
        mapKit.addGestureRecognizer(gestureRecognizer)
        
        
        
        
        
    }
    
    @objc func choosenLocation (gestureRecognizer: UILongPressGestureRecognizer){
        if gestureRecognizer.state == .began { // konum alınmaya başlandıysa
            let touchPoint = gestureRecognizer.location(in: self.mapKit)
            let touchedCoordinate = self.mapKit.convert(touchPoint, toCoordinateFrom: self.mapKit)
            choosenLatitude = touchedCoordinate.latitude
            choosenLongitude = touchedCoordinate.longitude
            
            
            
            let annotation = MKPointAnnotation()
            annotation.coordinate = touchedCoordinate
            annotation.title = "samet"
            annotation.subtitle = "travel book"
            self.mapKit.addAnnotation(annotation)
            
            
            
        }
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = CLLocationCoordinate2D(latitude: locations[0].coordinate.latitude, longitude: locations[0].coordinate.longitude)//metodda verilem locations dan ilk gelen konumu aldık
        let span = MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1) // span anlık konuma yaklaştırma yaptık
        let region = MKCoordinateRegion(center: location, span: span) //merkezi nere alayım spani nasıl yapıcam
        mapKit.setRegion(region, animated: true) // mapkit bunu yap
    }
   
    
    
    
    
    
    @IBAction func saveButtonClicked(_ sender: Any) {
    
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        
        let newPlace = NSEntityDescription.insertNewObject(forEntityName: "Places", into: context)
        newPlace.setValue(nameText.text, forKey: "name")
        newPlace.setValue(commentText.text, forKey: "comment")
        newPlace.setValue(choosenLatitude, forKey: "latitude")
        newPlace.setValue(choosenLongitude, forKey: "longitude")
        newPlace.setValue(UUID(), forKey: "id")
        
        
        do {
            try context.save()
            print("succes")
        }catch{
            print("error")
        }
        
        
        
        
        
        NotificationCenter.default.post(name: NSNotification.Name("Places"), object: nil)
        navigationController?.popViewController(animated: true)
        
    }
    
    
    
    

}

