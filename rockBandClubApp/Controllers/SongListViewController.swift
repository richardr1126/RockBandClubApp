//
//  SongListViewController.swift
//  rockBandClubApp
//
//  Created by Richard Roberson on 2/21/20.
//  Copyright © 2020 Richard Roberson. All rights reserved.
//

import UIKit
import Firebase

class SongListViewController: UITableViewController {

    let ref = Database.database().reference()
    let cellId = "cellId"
    var songList = [Song]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        tableView.register(SongCell.self, forCellReuseIdentifier: cellId)
        getData()
        
        
        
    }

    // MARK: - Table view data source


    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return songList.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath)
        
        let song = songList[indexPath.row]
        
        cell.textLabel?.text = song.songName
        cell.detailTextLabel?.text = song.songArtist
        
        
        return cell
    }
    
    func getData() {
        
        ref.child("songs").observe(.childAdded, with: { (snapshot) in
            if let dictionary = snapshot.value as? [String: AnyObject] {
                
                var song = Song(songName: "", songArtist: "", genre: "", year: 0)
                
                song.songName = dictionary["name"] as! String
                song.songArtist = dictionary["artist"] as! String
                song.year = dictionary["year"] as! Int
                song.genre = dictionary["genre"] as! String
            
                self.songList.append(song)
                
                DispatchQueue.main.async {
                    
                    self.tableView.reloadData()
                }
                
            }
        }, withCancel: nil)
        
    }
    
    class SongCell: UITableViewCell {
        override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
            super.init(style: .subtitle, reuseIdentifier: reuseIdentifier)
        }
        
        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
    }

}
