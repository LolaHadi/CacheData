//
//  ViewController.swift
//  Cache app
//
//  Created by Lola M on 12/13/21.
//

import UIKit

class ViewController: UIViewController {
    
    private let cache = NSCache<NSNumber, UIImage>()
    private let queue = DispatchQueue.global(qos: .utility)
    
    
    @IBOutlet weak var collectioView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectioView.dataSource = self
        collectioView.delegate = self
        collectioView.backgroundColor = .clear
//        collectioView.heightAnchor.constraint(equalToConstant: view.frame.width/2).isActive = true
        
    }
    
    
    private func loadImage(completion: @escaping (UIImage?) -> ()) {
        queue.async {
            let url = URL(string: "https://picsum.photos/200")!
            guard let data = try? Data(contentsOf: url) else { return }
            let image = UIImage(data: data)
            print(data)
            DispatchQueue.main.async {
                completion(image)
            }
            
        }
    }
    
}


//CollectionView
extension ViewController: UICollectionViewDataSource, UICollectionViewDelegate {
     func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        50
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! ImageCell
        cell.backgroundColor = .red
        
        return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        
        guard let cell = cell as? ImageCell else { return }
        let itemNumber = NSNumber(value: indexPath.item)
        if let cachedImage = self.cache.object(forKey: itemNumber) {
            cell.imageView.image = cachedImage
        } else {
            self.loadImage { [weak self] (image) in
                guard  let image = image else {
                    return
                }
                
                cell.imageView.image = image
                self?.cache.setObject(image, forKey: itemNumber)
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
           let width = CGFloat(view.frame.width-view.frame.width/5)
           let height = CGFloat(view.frame.height/3)
           
        return CGSize(width: width, height: height)
       }
}

