//
//  PostDetailViewController.swift
//  MyPosts
//
//  Created by Rubbermaid Laverde on 8/05/22.
//

import UIKit
import Lottie

class PostDetailViewController: UIViewController {
    
    // MARK: - Outlets
    
    @IBOutlet weak var postDetailTableView: UITableView!
    @IBOutlet weak var animationContainer: UIView!
    @IBOutlet weak var messageLabel: UILabel!
    
    
    // MARK: - Properties
    
    private lazy var animationView = AnimationView()
    private lazy var favoriteBarButtonItem = UIBarButtonItem()
    private let viewModel: PostDetailViewModelProtocol
    
    
    // MARK: - Life Cycle
    
    init(viewModel: PostDetailViewModelProtocol) {
        
        self.viewModel = viewModel
        super.init(nibName: String(describing: PostDetailViewController.self), bundle: Bundle.main)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        viewModel.getUserInfo()
        viewModel.getPostComments()
    }
}


// MARK: - Setup

private extension PostDetailViewController {

    func setupUI() {
        
        // NavigationBar
        title = "Post"
        favoriteBarButtonItem.target = self
        favoriteBarButtonItem.action = #selector(didTapFavoriteButton)
        let deleteBarButtonItem = UIBarButtonItem(barButtonSystemItem: .trash, target: self, action: #selector(didTapDeleteButton))
        navigationItem.rightBarButtonItems = [favoriteBarButtonItem, deleteBarButtonItem]
        
        // TableView
        postDetailTableView.alpha = 0
        postDetailTableView.rowHeight = UITableView.automaticDimension
        postDetailTableView.delegate = self
        postDetailTableView.dataSource = self
        postDetailTableView.register(PostDetailCell.self, forCellReuseIdentifier: PostDetailCell.reuseIdentifier)
        postDetailTableView.register(PostCommentCell.self, forCellReuseIdentifier: PostCommentCell.reuseIdentifier)
        
        // Animation
        animationView.frame = animationContainer.bounds
        animationContainer.addSubview(animationView)
        
        setupBindings()
    }
    
    func setupBindings() {
        
        viewModel.favoriteButtonImage.bind { [weak self] favoriteButtonImage in
            
            self?.favoriteBarButtonItem.image = favoriteButtonImage
        }
        
        viewModel.user.bind { [weak self] user in
            
            if user == nil {
                
                self?.postDetailTableView.fadeOut()
            } else {
                
                self?.postDetailTableView.reloadData()
                self?.postDetailTableView.fadeIn()
            }
        }
        
        viewModel.comments.bind { [weak self] comments in
            
            if comments.isEmpty {
                
                self?.postDetailTableView.fadeOut()
            } else {
                
                self?.postDetailTableView.fadeIn()
            }
                
            self?.postDetailTableView.reloadData()
        }
        
        viewModel.animation.bind { [weak self] animation in
            
            if let animation = animation {
                
                self?.postDetailTableView.fadeOut()
                self?.animationView.animation = Animation.named(animation.rawValue)
                self?.animationView.loopMode = .loop
                self?.animationView.play()
                self?.animationContainer.fadeIn()
                self?.messageLabel.text = animation.message
                self?.messageLabel.fadeIn()
            } else {
                
                self?.animationView.stop()
                self?.animationContainer.fadeOut()
                self?.messageLabel.fadeOut()
            }
        }
        
        viewModel.dismissViewController.bind { [weak self] dismissViewController in
            
            guard dismissViewController else {
                return
            }
            
            self?.navigationController?.popViewController(animated: true)
        }
    }
}


// MARK: - Actions

private extension  PostDetailViewController {
    
    @objc func didTapFavoriteButton() {
        
        viewModel.addPostToFavorites()
    }
    
    @objc func didTapDeleteButton() {
        
        let alertController = UIAlertController(title: nil, message: "Are you sure you want to delete this post?", preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "Delete", style: .destructive, handler: { [weak self] _ in
            self?.viewModel.removePost()
        }))
        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        self.present(alertController, animated: true)
    }
}


// MARK: - TableView Delegate & Datasource

extension PostDetailViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return viewModel.numberOfSections
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return viewModel.rowsPerSection[section]
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.section == 0 {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: PostDetailCell.reuseIdentifier, for: indexPath) as! PostDetailCell
            cell.configure(with: viewModel.viewModelForDetailCell())
            return cell
        } else {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: PostCommentCell.reuseIdentifier, for: indexPath) as! PostCommentCell
            cell.configure(with: viewModel.viewModelForCommentCell(at: indexPath))
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {

        let titleLabel = UILabel(frame: CGRect(x: 0, y: 0, width: tableView.bounds.width, height: 50))
        titleLabel.font = .systemFont(ofSize: 20, weight: .semibold)
        titleLabel.text = section == 0 ? "Description" : "Comments"

        return titleLabel
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {

        return 50
    }
}
