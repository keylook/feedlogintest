//
//  ViewController.swift
//  WebMastersTest
//
//  Created by Innakentiy Lukin on 5/19/18.
//  Copyright © 2018 Innakentiy Lukin. All rights reserved.
//

import UIKit

class FeedViewController: UIViewController, Navigatable, Alertable {
    
    // MARK: - Outlets
    @IBOutlet weak var statusView: StatusView!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var logoutButton: UIBarButtonItem!
    @IBOutlet weak var searchButton: UIBarButtonItem!
    @IBOutlet weak var searchBartTopConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var statusViewHeightConstraint: NSLayoutConstraint!
    private var presenter: FeedPresenter!
    
    var searchActive: Bool = false
    var offlineMode: Bool {
        return statusViewHeightConstraint.constant == 44
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        presenter = FeedPresenter(delegate: self)
        presenter.listenToNavigation(self)
        setupTable()
        setupRefreshControl()
        setupSearchBar()
        setupLogout()
        presenter.getArticles()
    }
    
    
    private func setupSearchBar() {
        searchButton.target = self
        searchButton.action = #selector(searchTapped)
        searchBar.delegate = self
    }
    
    private func setupLogout() {
        logoutButton.target = self
        logoutButton.action = #selector(logoutTapped)
    }
    
    
    private func setupTable() {
        tableView.backgroundColor = UIColor.clear
        tableView.backgroundView = nil
       
        tableView.rowHeight = 280
        tableView.separatorStyle = .none
        tableView.sectionHeaderHeight = 80
        
        let cellNib = UINib(nibName: "FeedTableCell", bundle: nil)
        tableView.register(cellNib, forCellReuseIdentifier: "FeedCell")
        tableView.register(FeedTableHeader.self, forHeaderFooterViewReuseIdentifier: "UserHeader")
        tableView.dataSource = self
        tableView.delegate = self
    }
    
    private func setupRefreshControl() {
        let control = UIRefreshControl()
        control.tintColor = hexColor(hex: "#002E60")
        control.addTarget(self, action: #selector(pulledToRefresh), for: .valueChanged)
        tableView.refreshControl = control
    }
    
    @objc private func pulledToRefresh() {
        presenter.getArticles()
    }
    
    @objc private func searchTapped() {
        layoutSearchBar()
        searchActive = !searchActive
        UIView.animate(withDuration: 0.33) {
            self.view.layoutIfNeeded()
        }
    }
    
    @objc private func logoutTapped() {
        let actionSheet = UIAlertController(title: "Logout", message: "Are you sure you want to logout?", preferredStyle: .actionSheet)
        let confirmAction = UIAlertAction(title: "Logout", style: .default) { action in
            self.presenter.logout()
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { action in
            actionSheet.dismiss(animated: true, completion: nil)
        }
        
        actionSheet.addAction(confirmAction)
        actionSheet.addAction(cancelAction)
        
        present(actionSheet, animated: true, completion: nil)
    }

    
    private func layoutSearchBar() {
        let defaultPosition: CGFloat = offlineMode ? 44: 0
        let activePosition: CGFloat = offlineMode ? 0: -50
        searchBartTopConstraint.constant = searchActive ? activePosition: defaultPosition
        _ = searchActive ? searchBar.resignFirstResponder(): searchBar.becomeFirstResponder()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
 
}

extension FeedViewController: FeedPresenterDelegate {
    func onArticlesLoaded() {
        tableView.refreshControl?.endRefreshing()
        tableView.reloadData()
    }
    
    
    func onArticlesFailedToLoad(_ error: Error) {
        presentAlertWith(error: error)
    }
    
    func onSearchResultReady() {
        tableView.reloadSections(IndexSet(0...0), with: .right)
    }
    
   
    func onConnectionStatusOffline() {
        statusView.setStatus(.offline, animated: true)
        statusViewHeightConstraint.constant = 44
        UIView.animate(withDuration: 0.33) {
            self.view.layoutIfNeeded()
        }
    }
    
    
    func onConnectionStatusOnline() {
        
        UIView.animate(withDuration: 0.33, animations: {
            self.statusView.setStatus(.connected, animated: true)
        }) { (complete) in
            self.statusViewHeightConstraint.constant = 0
            UIView.animate(withDuration: 0.33) {
                self.view.layoutIfNeeded()
            }
            
        }
    }
    

}

extension FeedViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presenter.articles.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FeedCell", for: indexPath) as! FeedTableCell
            cell.updateWith(article: presenter.articles[indexPath.row])
        return cell
    }

}

extension FeedViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = tableView.dequeueReusableHeaderFooterView(withIdentifier: "UserHeader") as! FeedTableHeader
        if let profile = presenter.getUserProfile() {
            view.updateWith(profile: profile)
        }
        view.contentView.backgroundColor = UIColor.white
        return view
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        presenter.selectedArticle = presenter.articles[indexPath.row]
    }
    
    
}

extension FeedViewController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        presenter.searchWith(text: searchText)
    }
    
    
}









