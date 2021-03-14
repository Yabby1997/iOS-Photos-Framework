//
//  ViewController.swift
//  Photos Framework
//
//  Created by Seunghun Yang on 2021/03/14.
//

import UIKit
import Photos

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    // MARK: - IBOutlets
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: - Properties
    var fetchResult: PHFetchResult<PHAsset>!
    let imageManager: PHCachingImageManager = PHCachingImageManager()
    let cellIdentifier: String = "cell"
    
    // MARK: - View methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        let photoAuthorizationStatus = PHPhotoLibrary.authorizationStatus()
        
        switch photoAuthorizationStatus {
        case .authorized:
            print("허가됨")
            self.requestCollection()
            OperationQueue.main.addOperation {
                self.tableView.reloadData()
            }
        case .denied:
            print("거부됨")
        case .notDetermined:
            print("응답없음")
            PHPhotoLibrary.requestAuthorization({ (status) in
                switch status {
                case .authorized:
                    print("허용함")
                    self.requestCollection()
                    OperationQueue.main.addOperation {
                        self.tableView.reloadData()
                    }
                case .denied:
                    print("거부함")
                default:
                    break
                }
            })
        case .restricted:
            print("제한됨")
        default:
            break
        }
    }
    
    // MARK: - Functions
    func requestCollection() {
        let cameraRoll: PHFetchResult<PHAssetCollection> = PHAssetCollection.fetchAssetCollections(with: .smartAlbum, subtype: .smartAlbumUserLibrary, options: nil)
        guard let cameraRollCollection = cameraRoll.firstObject else {
            return
        }
        
        let fetchOptions = PHFetchOptions()
        fetchOptions.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]
        self.fetchResult = PHAsset.fetchAssets(in: cameraRollCollection, options: fetchOptions)
    }
    
    // MARK: - TableView Delegate Methods
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.fetchResult?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: UITableViewCell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let asset: PHAsset = fetchResult.object(at: indexPath.row)
        
        imageManager.requestImage(
            for: asset,
            targetSize: CGSize(width: 30, height: 30),
            contentMode: .aspectFill,
            options: nil,
            resultHandler: { image, _ in
                cell.imageView?.image = image
            })
        
        return cell
    }
    
    // MARK: - IBActions

}

