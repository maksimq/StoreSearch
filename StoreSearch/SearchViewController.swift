//
//  ViewController.swift
//  StoreSearch
//
//  Created by Максим on 31.01.16.
//  Copyright © 2016 Maxim. All rights reserved.
//

import UIKit

protocol Result {
    func getName() -> String
    func getArtistName() -> String
    func isNoFound() -> Bool
}

class NoFoundResult: Result {
    func getName() -> String {
        return "Nothing found"
    }
    func getArtistName() -> String {
        return ""
    }
    func isNoFound() -> Bool {
        return true
    }
}

class SearchResult: Result {
    private var name: String
    private var artistName: String
    init(name: String, artistName: String){
        self.name = name
        self.artistName = artistName
    }
    func getName() -> String{
        return name
    }
    func getArtistName() -> String {
        return artistName
    }
    func isNoFound() -> Bool {
        return false
    }
}

class SearchViewController: UIViewController {
    
    var searchResults = [Result]()
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        // сдвигаем содержимое TableView на 64 пикселя вниз, что бы была видна первая ячейка
        tableView.contentInset = UIEdgeInsets(top: 64, left: 0, bottom: 0, right: 0)
    
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

extension SearchViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        searchResults.removeAll()
        if (searchBar.text! != "EmptyQuery") {
            searchResults.append(SearchResult(name: "Some name", artistName: searchBar.text!))
        } else {
            searchResults.append(NoFoundResult())
        }
        tableView.reloadData()
    }
    
    func positionForBar(bar: UIBarPositioning) -> UIBarPosition {
        return .TopAttached
    }
}

extension SearchViewController: UITableViewDataSource {
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchResults.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cellIdentifier = "Search Result Cell"
        var cell: UITableViewCell! = tableView.dequeueReusableCellWithIdentifier(cellIdentifier)
        if cell == nil {
            cell = UITableViewCell(style: .Subtitle, reuseIdentifier: cellIdentifier)
        }
//        cell.selectionStyle = UITableViewStyle
        cell.textLabel!.text = searchResults[indexPath.row].getName()
        cell.detailTextLabel!.text = searchResults[indexPath.row].getArtistName()
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
    
    func tableView(tableView: UITableView, willSelectRowAtIndexPath indexPath: NSIndexPath) -> NSIndexPath? {
        if searchResults.isEmpty {
            return nil
        } else {
            if searchResults[indexPath.item].isNoFound() {
                return nil
            }
            return indexPath
        }
    }
}
extension SearchViewController: UITableViewDelegate {
}
