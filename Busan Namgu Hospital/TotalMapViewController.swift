//
//  TotalMapView.swift
//  Busan Namgu Hospital
//
//  Created by D7703_18 on 2018. 12. 14..
//  Copyright © 2018년 A. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation //현재위치

class TotalMapViewController: UIViewController , MKMapViewDelegate, CLLocationManagerDelegate  {
    
    @IBOutlet weak var totalMapView: MKMapView!
    var dContents: NSArray?
    var locationManager:CLLocationManager!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // 현재위치를 표기하기 위한 코드
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization() //GPS사용 권한 요청
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.startUpdatingLocation()
        totalMapView.showsUserLocation = true //현재위치 표기를 true로 설정
        
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
        
        totalMapView.delegate = self
    }
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        //위치가 업데이트될때마다 갱신해줌.
        if let coor = manager.location?.coordinate{
            print("latitude" + String(coor.latitude) + "/ longitude" + String(coor.longitude))
        }
    }
    
    // MKMapViewDelegate 메소드 호출
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        let identifier = "myPin"
        
        // as?는 다운 캐스팅(형변환) 하려는 타입의 옵셔널 값을 리턴, 다운 캐스트가 가능하지 않으면 nil 반환, 형변환이 성공하리란 보장이 없으면 as? 사용
        // as!는 강제 형변환(force unwrap), 다운 캐스트가 가능하지 않으면 runtime error 발생, 형변환이 확실히 성공 가능하면 as! 사용
        var annotationView = totalMapView.dequeueReusableAnnotationView(withIdentifier: "identifier") as? MKPinAnnotationView
        
        if annotation is MKUserLocation {
            return nil
        }
        
        if annotationView == nil {
            annotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: identifier)
            annotationView?.canShowCallout = true
            let btn = UIButton(type: .detailDisclosure)
            annotationView?.rightCalloutAccessoryView = btn
            annotationView?.animatesDrop = true
        } else {
            annotationView?.annotation = annotation
        }
        return annotationView
    }
    
    // callout accessary를 눌렀을때 alertView 보여줌
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        let viewAnno = view.annotation
        let stationName = viewAnno?.title
        let stationInfo = viewAnno?.subtitle
        
        
        let ac = UIAlertController(title: stationName!, message: "", preferredStyle: .alert)
        
        //Alert를 통해 상세정보 확인가능.
        ac.addAction(UIAlertAction(title: "주소 : " + stationInfo!!, style: .default, handler: nil))
        ac.addAction(UIAlertAction(title: "닫기", style: .cancel, handler: nil))
        present(ac, animated: true, completion: nil)
        
    }
}

