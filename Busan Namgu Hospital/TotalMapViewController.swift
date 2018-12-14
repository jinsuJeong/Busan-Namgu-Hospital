//
//  TotalMapView.swift
//  Busan Namgu Hospital
//
//  Created by D7703_18 on 2018. 12. 14..
//  Copyright © 2018년 A. All rights reserved.
//

import UIKit
import MapKit

class TotalMapViewController: UIViewController {
    
    @IBOutlet weak var totalMapView: MKMapView!
    var dContents: NSArray?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        print("dContents = \(String(describing: dContents))")
        
        var annos = [MKPointAnnotation]()
        
        if let myItems = dContents {
            for item in myItems {
                let addr = (item as AnyObject).value(forKey: "addr")
                let name = (item as AnyObject).value(forKey: "name")
                let geoCoder = CLGeocoder()
                
                geoCoder.geocodeAddressString(addr as! String, completionHandler: { placemarks, error in
                    if error != nil {
                        print(error!)
                        return
                    }
                    
                    if let myPlacemarks = placemarks {
                        let myPlacemark = myPlacemarks[0]
                        
                        let anno = MKPointAnnotation()
                        anno.title = name as? String
                        anno.subtitle = addr as? String
                        
                        if let myLocation = myPlacemark.location {
                            anno.coordinate = myLocation.coordinate
                            annos.append(anno)
                        }
                        
                    }
                    
                    self.totalMapView.showAnnotations(annos, animated: true)
                    self.totalMapView.addAnnotations(annos)
                } )
            }
            
        } else {
            print("dContents의 값은 nil")
        }
        
    }
}
