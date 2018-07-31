//
//  DetailViewController.swift
//  piccy
//
//  Created by Amanda Reinhard on 7/12/18.
//  Copyright © 2018 Amanda Reinhard. All rights reserved.
//

import UIKit
import Nuke

class DetailViewController: UIViewController {

    @IBOutlet weak var detailImageView: UIImageView!
    
    var image: ImgurPost?
    
    @IBOutlet weak var imgurId: UILabel!
    @IBOutlet weak var titleDescription: UILabel!
    @IBOutlet weak var descriptionDescription: UILabel!
    @IBOutlet weak var widthDescription: UILabel!
    @IBOutlet weak var heightDescription: UILabel!
    @IBOutlet weak var deletionDescription: UILabel!
    @IBOutlet weak var imageNameDescription: UILabel!
    @IBOutlet weak var linkDescription: UILabel!
    
    
    func configureView() {
        // Update the user interface for the detail item.
        guard let image = image else { return }
        let secureLink = image.link!.replacingOccurrences(of: "http:", with: "https:")
        Nuke.loadImage(with: URL(string: secureLink)!, into: detailImageView)
        imgurId.text = image.id
        titleDescription.text = image.title
        descriptionDescription.text = image.description
        widthDescription.text = String(image.width ?? 0)
        heightDescription.text = String(image.height ?? 0)
        deletionDescription.text = image.deletehash
        imageNameDescription.text = image.name
        linkDescription.text = image.link
    }

    @IBAction func share(_ sender: Any) {
        let menu = UIAlertController(title: "Share", message: nil, preferredStyle: .actionSheet)
        menu.popoverPresentationController?.barButtonItem = navigationItem.rightBarButtonItem
        menu.addAction(UIAlertAction(title: "Copy URL", style: .default, handler: { (alert) in
            UIPasteboard.general.url = URL(string: self.image!.link!)
        }))
        menu.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (alert) in
            
        }))
        present(menu, animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        configureView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    var detailItem: NSDate? {
        didSet {
            // Update the view.
            configureView()
        }
    }


}

