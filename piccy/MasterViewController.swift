//
//  MasterViewController.swift
//  piccy
//
//  Created by Amanda Reinhard on 7/12/18.
//  Copyright © 2018 Amanda Reinhard. All rights reserved.
//

import UIKit
import Nuke

class MasterViewController: UITableViewController, UITextViewDelegate, NewImageViewControllerDelegate {
    
    var detailViewController: DetailViewController? = nil

    var images = [ImgurPost]()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        navigationItem.leftBarButtonItem = editButtonItem

        let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(uploadNewImage))
        navigationItem.rightBarButtonItem = addButton
        if let split = splitViewController {
            let controllers = split.viewControllers
            detailViewController = (controllers[controllers.count-1] as! UINavigationController).topViewController as? DetailViewController
        }
        readFromDisk()
    }

    override func viewWillAppear(_ animated: Bool) {
        clearsSelectionOnViewWillAppear = splitViewController!.isCollapsed
        super.viewWillAppear(animated)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @objc func uploadNewImage() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "uploadViewController") as? NewImageViewController
        controller?.delegate = self
        let navController = UINavigationController(rootViewController: controller!)
        present(navController, animated: true, completion: nil)
    }

    // MARK: - Segues

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showDetail" {
            if let indexPath = tableView.indexPathForSelectedRow {
//                let object = objects[indexPath.row] as! NSDate
//                let controller = (segue.destination as! UINavigationController).topViewController as! DetailViewController
//                controller.detailItem = object
//                controller.navigationItem.leftBarButtonItem = splitViewController?.displayModeButtonItem
//                controller.navigationItem.leftItemsSupplementBackButton = true
                let image = images[indexPath.row]
                let controller = (segue.destination as! UINavigationController).topViewController as! DetailViewController
                controller.image = image
            }
        }
    }
    
    func newImageViewControllerDidCreate(image: ImgurImageUpload) {
        imgurAPI().upload(image: image) { (response) in
            DispatchQueue.main.async {
                guard let post = response.data else { return }
                self.images.insert(post, at: 0)
                self.tableView.insertRows(at: [IndexPath(item: 0, section: 0)], with: .automatic)
                self.writeToDisk()
            }
        }
    }
    
    func readFromDisk() {
        let manager = FileManager.default
        if let url = try? manager.url(for: .documentDirectory,
                                      in: .userDomainMask,
                                      appropriateFor: nil,
                                      create: false).appendingPathComponent("uploads.json"),
            let data = try? Data(contentsOf: url),
            let uploads = try? JSONDecoder().decode([ImgurPost].self, from: data) {
            self.images = uploads
        }
    }
    
    func writeToDisk() {
        let manager = FileManager.default
        if let data = try? JSONEncoder().encode(images),
            let url = try? manager.url(for: .documentDirectory,
                                       in: .userDomainMask,
                                       appropriateFor: nil,
                                       create: true).appendingPathComponent("uploads.json") {
            try? data.write(to: url)
        }
    }

    // MARK: - Table View

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return images.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! ListTableViewCell
        let image  = images[indexPath.row]
        let thumbURL = URL(string: "https://i.imgur.com/\(image.id!)s.jpg")

        cell.titleLabel.text = image.title
        cell.descriptionLabel.text = image.description
        Nuke.loadImage(with: thumbURL!, options: .shared, into: cell.thumbImageView, progress: nil) { (_, _) in
            cell.setNeedsLayout()
            cell.layoutIfNeeded()
        }
        return cell
    }

    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }

    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            images.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            writeToDisk()
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
        }
    }

}

