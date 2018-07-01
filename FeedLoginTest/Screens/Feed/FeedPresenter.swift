//
//  FeedPresenter.swift
//  WebMastersTest
//
//  Created by Innakentiy Lukin on 5/19/18.
//  Copyright © 2018 Innakentiy Lukin. All rights reserved.
//

import Foundation

protocol FeedPresenterDelegate: class {
    
    /// Notifies the delegate that data was succesfully loaded and ready to be presented
    func onArticlesLoaded()
    
    /// Called when there was an error during data loging process
    func onArticlesFailedToLoad(_ error: Error)
    
    /// Called when dataSource is updated based on original search query
    func onSearchResultReady()
    
    /// Called when `Reachability` sends `ConnectionLostNotification`
    func onConnectionStatusOffline()
    
    /// Called when `Reachability` sends `ConnectionRestoredNotification`
    func onConnectionStatusOnline()
}


class FeedPresenter {
    
    /// A network service that retrieves articles from API
    private var networkDataProvider: ArticleService
    
    /// A local service that retrieves articles from Cache
    private var localDataProvider: ArticleService
    
    private var navigationListener: Navigatable?
    
    private weak var delegate: FeedPresenterDelegate?
    
    var articles: [Article] = []
    private var originalArticles: [Article] = []
    
    var selectedArticle: Article! {
        didSet {
            handleArticleSelection()
        }
    }
    
    private var offlineMode: Bool = false
    
    init(delegate: FeedPresenterDelegate) {
        self.delegate = delegate
        
        networkDataProvider = NetworkService(enableCache: true)
        localDataProvider = CacheService()
        
        getInitialNetworkState()
        listenToNetworkChange()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    
    public func listenToNavigation(_ listener: Navigatable) {
        navigationListener = listener
    }
    
    /// Subscribe to network related notifications
    private func listenToNetworkChange() {
        NotificationCenter.default.addObserver(self, selector: #selector(handleOffline), name: ConnectionLostNotification , object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(handleOnline), name: ConnectionRestoredNotification, object: nil)
    }
    
    /// While Reachabiliy sends notificaions on change,
    /// this retrieves immediate network state
    private func getInitialNetworkState() {
        let status = ConnectionListener.shared.getStatus()
        offlineMode = status == .offline
    }
    
    
    /// Fetches the articles depending on the application mode.
    /// If application is in online mode, will get articles from API.
    /// If application is in offline mode, will try to get chached version.
    public func getArticles() {
        if offlineMode {
            getArticlesWith(provider: localDataProvider)
        } else {
            getArticlesWith(provider: networkDataProvider)
        }
    }
    
    public func getUserProfile() -> UserProfile? {
        return VKService.shared.getProfile()
    }
    
    
    public func logout() {
        guard let vc = Navigator.shared.restoreStackWith(key: loginStackKey) else { return }
        ImageLoader.clearCache()
        VKService.shared.logout()
        navigationListener?.switchTo(viewController: vc)
    }
    
    /// Gets articles list from server or cached depending on passed provider
    /// - parameter provider: any service conforming to `ArticleService` protocol
    private func getArticlesWith(provider: ArticleService) {
        provider.getArticles { (articles, error) in
            self.handleArticleData(articles: articles, error: error)
        }
    }

    
    /// Works with the retrieved Article data and handles errors if any
    /// - parameter articles: an array of Article objects, could be `nil`
    /// - parameter error: Error from any of underlying services, dfeault is `nil`
    private func handleArticleData(articles: [Article]?, error: Error?) {
       
        guard let articles = articles else {
            DispatchQueue.main.async {
                self.delegate?.onArticlesFailedToLoad(error!)
            }
            return
        }
        
        self.articles = articles
        originalArticles = articles
        
        DispatchQueue.main.async {
            self.delegate?.onArticlesLoaded()
        }
    }
    
    
    

    /// Search by text match (characters, words)
    /// - parameter text: `String` original text query
    func searchWith(text: String) {
        
        /// Check if user cleared the search query
        /// Display original articles
        guard text != "" else {
            articles = originalArticles
            delegate?.onSearchResultReady()
            return
        }
        
        /// Search via higher order function
        let searchResult = articles.filter({
            /// Make search case-insensetive
            $0.title.lowercased().contains(text.lowercased())
        })
        
        /// Check that the number of articles changed
        /// to avoid triggering the animation when it didn't
        if searchResult.count != articles.count {
            articles = searchResult
            delegate?.onSearchResultReady()
        }
    }
    
    /// Change mode & notify delegate
    @objc private func handleOffline() {
        offlineMode = true
        delegate?.onConnectionStatusOffline()
    }
    
     /// Change mode & notify delegate
    @objc private func handleOnline() {
        offlineMode = false
        delegate?.onConnectionStatusOnline()
    }
    
    
    private func handleArticleSelection() {
        guard let targetVC = navigationListener?.viewController(with: "DetailViewController") as? DetailViewController else { return }
        targetVC.article = selectedArticle
        targetVC.delegate = self
        navigationListener?.navigateTo(viewController: targetVC, modally: false)
    }
    
}

extension FeedPresenter: DetailViewDelegate {
    
    func onArticleImageChanged() {
        getArticles()
    }
    
}







