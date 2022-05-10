//
//  PostsViewController.swift
//  MyPosts
//
//  Created by Rubbermaid Laverde on 8/05/22.
//

import UIKit
import Lottie

class PostsViewController: UIViewController {
    
    // MARK: - Outlets
    
    @IBOutlet weak var postsTableView: UITableView!
    @IBOutlet weak var filterSegmentedControl: UISegmentedControl!
    @IBOutlet weak var animationContainer: UIView!
    @IBOutlet weak var messageLabel: UILabel!
    
    
    // MARK: - Properties
    
    private lazy var refreshControl = UIRefreshControl()
    private lazy var animationView = AnimationView()
    private let viewModel: PostsViewModelProtocol

    
    // MARK: - Life Cycle
    
    init(viewModel: PostsViewModelProtocol) {
        self.viewModel = viewModel
        super.init(nibName: String(describing: PostsViewController.self), bundle: Bundle.main)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        viewModel.getPosts()
    }
}


// MARK: - Setup

private extension PostsViewController {

    func setupUI() {
        
        // NavigationBar
        title = "Posts"
        let reloadBarButtonItem = UIBarButtonItem(barButtonSystemItem: .refresh, target: self, action: #selector(refresh))
        let deleteAllBarButtonItem = UIBarButtonItem(barButtonSystemItem: .trash, target: self, action: #selector(deleteAll))
        navigationItem.rightBarButtonItem = reloadBarButtonItem
        navigationItem.leftBarButtonItem = deleteAllBarButtonItem
        
        // SegmentedControl
        filterSegmentedControl.addTarget(self, action: #selector(didChangeFilterSegmentedControl(_:)), for: .valueChanged)
        
        // TableView
        postsTableView.delegate = self
        postsTableView.dataSource = self
        postsTableView.estimatedRowHeight = 60
        postsTableView.rowHeight = UITableView.automaticDimension
        postsTableView.register(PostCell.self, forCellReuseIdentifier: PostCell.reuseIdentifier)
        refreshControl.addTarget(self, action: #selector(refresh), for: .valueChanged)
        postsTableView.addSubview(refreshControl)
        
        // Animation
        animationView.frame = animationContainer.bounds
        animationContainer.addSubview(animationView)
        
        // Bindings
        setupBindings()
    }
    
    func setupBindings() {
        
        viewModel.filteredPosts.bind { [weak self] posts in
            
            if posts.isEmpty {
                
                self?.postsTableView.fadeOut()
            } else {
                
                self?.postsTableView.fadeIn( completion: { _ in
                    self?.postsTableView.scrollToRow(at: IndexPath(row: 0, section: 0), at: .top, animated: true)
                })
            }
            
            self?.postsTableView.reloadData()
        }
        
        viewModel.animation.bind { [weak self] animation in
            
            if let animation = animation {
                
                guard !(self?.refreshControl.isRefreshing ?? false) else {
                    return
                }
                
                self?.postsTableView.fadeOut()
                self?.animationView.animation = Animation.named(animation.rawValue)
                self?.animationView.loopMode = .loop
                self?.animationView.play()
                self?.animationContainer.fadeIn()
                self?.messageLabel.text = animation.message
                self?.messageLabel.fadeIn()
            } else {
                
                self?.refreshControl.endRefreshing()
                self?.animationView.stop()
                self?.animationContainer.fadeOut()
                self?.messageLabel.fadeOut()
            }
        }
        
        viewModel.postDetailViewController.bind { [weak self] viewController in
            
            guard let viewController = viewController else {
                return
            }
            
            self?.navigationController?.pushViewController(viewController, animated: true)
        }
    }
}


// MARK: - Actions

private extension PostsViewController {
    
    @objc func didChangeFilterSegmentedControl(_ sender: UISegmentedControl) {
        
        viewModel.filterPosts(by: FilterCriteria(rawValue: sender.selectedSegmentIndex))
    }
    
    @objc func refresh() {
        
        viewModel.getPosts()
    }
    
    @objc func deleteAll() {
        
        guard !viewModel.filteredPosts.value.isEmpty else {
            return
        }
        
        let alertController = UIAlertController(title: nil, message: "Are you sure you want to delete all posts?", preferredStyle: .actionSheet)
        alertController.addAction(UIAlertAction(title: "Delete all", style: .destructive, handler: { [weak self] _ in
            self?.viewModel.deleteAllPosts()
        }))
        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        self.present(alertController, animated: true)
    }
}


// MARK: - TableView Delegate & Datasource

extension PostsViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return viewModel.numberOfRows
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: PostCell.reuseIdentifier, for: indexPath) as! PostCell
        cell.configure(with: viewModel.viewModelForCell(at: indexPath))
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        viewModel.didSelectItem(at: indexPath)
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
