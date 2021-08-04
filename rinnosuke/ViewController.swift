//
//  ViewController.swift
//  rinnosuke
//
//  Created by Tommy on 2021/08/03.
//

import MapKit
import UIKit

class ViewController: UIViewController, MKMapViewDelegate {
    @IBOutlet var mapView: MKMapView!
    let location = CLLocationCoordinate2D(latitude: 34.697218, longitude: 135.492481)
    let destination = CLLocationCoordinate2D(latitude: 34.703075, longitude: 135.495271)

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // MARK: このコードは、MapViewの設定！（地図の中心をLife is Tech! に）
        mapView.setCenter(location, animated: true)
        let locationAnnotation = MKPointAnnotation()
        locationAnnotation.coordinate = location
        mapView.addAnnotation(locationAnnotation)
        let destinationAnnotation = MKPointAnnotation()
        destinationAnnotation.coordinate = destination
        mapView.addAnnotation(destinationAnnotation)
        mapView.delegate = self
        
        // MARK: ここからルート検索
        // ルート検索のリクエストを作成
        let request = MKDirections.Request()
        // ルート検索の始点を設定 (MKMapItem(placemark: MKPlacemark(coordinate: 始点の位置情報)))
        request.source = MKMapItem(placemark: MKPlacemark(coordinate: location))
        // ルート検索の目的地を設定 (MKMapItem(placemark: MKPlacemark(coordinate: 目的地の位置情報)))
        request.destination = MKMapItem(placemark: MKPlacemark(coordinate: destination))
        // ルートが見つからなかった場合に代替案を表示
        request.requestsAlternateRoutes = true
        // 移動手段の設定
        request.transportType = .walking

        // ルート検索を実行
        let directions = MKDirections(request: request)

        // ルート検索結果を表示するコード
        directions.calculate { [unowned self] response, error in
            // ルートがない場合は処理を止める
            guard let route = response?.routes.first else { return }

            // MapViewにルートを表示
            self.mapView.addOverlay(route.polyline)
            // ルートの線が見えるように設定
            self.mapView.setVisibleMapRect(route.polyline.boundingMapRect, animated: true)
        }
    }

    // MARK: ルートの線の色など見た目の設定
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        let renderer = MKPolylineRenderer(polyline: overlay as! MKPolyline)
        renderer.strokeColor = UIColor.blue
        return renderer
    }
}
