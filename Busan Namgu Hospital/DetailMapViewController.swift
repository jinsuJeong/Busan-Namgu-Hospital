//
//  DetailMapView.swift
//  Busan Namgu Hospital
//
//  Created by D7703_18 on 2018. 12. 14..
//  Copyright © 2018년 A. All rights reserved.
//

import UIKit
import MapKit

class DetailMapViewController: UIViewController {
    
    var dName: String?
    var dAddr: String?
    
    @IBOutlet weak var detailMapView: MKMapView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        print("dTitle = \(String(describing: dName))")
        print("dAddress = \(String(describing: dAddr))")
        
        // navigation title 설정
        self.title = dName
        
        
        // geoCoding
        let geoCoder = CLGeocoder()
        geoCoder.geocodeAddressString(dAddr!, completionHandler: { plackmarks, error in
            
            if error != nil {
                print(error!)
            }
            
            if plackmarks != nil {
                let myPlacemark  = plackmarks?[0]
                
                if (myPlacemark?.location) != nil {
                    let myLat = myPlacemark?.location?.coordinate.latitude
                    let myLong = myPlacemark?.location?.coordinate.longitude
                    let center = CLLocationCoordinate2DMake(myLat!, myLong!)
                    let span = MKCoordinateSpanMake(0.05, 0.05)
                    let region = MKCoordinateRegionMake(center, span)
                    self.detailMapView.setRegion(region, animated: true)
                    
                    // Pin 꼽기, title, suttitle
                    let anno = MKPointAnnotation()
                    anno.title = self.dName
                    anno.subtitle = self.dAddr
                    anno.coordinate = (myPlacemark?.location?.coordinate)!
                    self.detailMapView.addAnnotation(anno)
                    self.detailMapView.selectAnnotation(anno, animated: true)
                }
            }
            
        } )
        
    }
}
