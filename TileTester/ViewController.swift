import UIKit
import MapKit

class ViewController: UIViewController, MKMapViewDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()

        let map = MKMapView(frame: view.bounds)
        view.addSubview(map)

        map.delegate = self

        let overlay = Overlay()
        overlay.canReplaceMapContent = true
        map.addOverlay(overlay)
    }

    func mapView(mapView: MKMapView!, rendererForOverlay overlay: MKOverlay!) -> MKOverlayRenderer! {
        return MKTileOverlayRenderer(overlay: overlay)
    }

}

class Overlay: MKTileOverlay {

    override func loadTileAtPath(path: MKTileOverlayPath, result: ((NSData!, NSError!) -> ())!) {
        if let URLString = "https://a.tiles.mapbox.com/v3/justin.tm2-basemap/\(path.z)/\(path.x)/\(path.y)" + (path.contentScaleFactor > 1 ? "@2x" : "") + ".png" as NSString? {
            if let URL = NSURL(string: URLString) {

/////////////////////////////////////////////////////////////////////////////////////////////////

                let loadInline = true

/////////////////////////////////////////////////////////////////////////////////////////////////

                if (loadInline) {

                    /* Async fetch the URL right here, then call result()
                     * ourselves on the main queue when complete. */

                    if let request = NSURLRequest(URL: URL) as NSURLRequest? {
                        if let task = NSURLSession(configuration: NSURLSessionConfiguration.defaultSessionConfiguration(), delegate: nil, delegateQueue: NSOperationQueue.mainQueue()).dataTaskWithRequest(request, completionHandler: { (data, response, error) in
                            result(data, error)
                        }) as NSURLSessionDataTask? {
                            task.resume()
                        }
                    }

                } else {

                    /* Create a closure that calls result() and pass that to an
                     * async URL load function like we do in MBXMapKit. */

                    let callback = { (data: NSData?, error: NSError?) -> Void in
                        result(data, error)
                    }

                    self.asyncLoadURL(URL, callback: callback)

                }

            }
        }
    }

    func asyncLoadURL(URL: NSURL, callback: (data: NSData?, error: NSError?) -> ()) {

        /* Async load a URL, then pass the results to a callback on the main queue. */

        NSURLConnection.sendAsynchronousRequest(NSURLRequest(URL: URL), queue: NSOperationQueue.mainQueue()) { (response, data, error) in
            callback(data: data, error: error)
        }

    }

}
