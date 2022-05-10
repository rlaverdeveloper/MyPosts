//
//  PostCell.swift
//  MyPosts
//
//  Created by Rubbermaid Laverde on 9/05/22.
//

import UIKit

class PostCell: UITableViewCell {
    
    // MARK: - Properties
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16, weight: .regular)
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var accessoryImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    
    // MARK: - Life Cycle
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: - Helper Methods
    
    func configure(with viewModel: PostCellViewModelProtocol) {
        
        viewModel.title.bind { [weak self] title in
            self?.titleLabel.text = title
        }

        viewModel.accesoryImage.bind { [weak self] accesoryImage in
            self?.accessoryImageView.image = accesoryImage
        }
    }
}


// MARK: - Setup

private extension PostCell {
    
    func setupUI() {
                        
        contentView.addSubview(titleLabel)
        contentView.addSubview(accessoryImageView)
        
        setupConstraints()
    }
    
    func setupConstraints() {
        
        NSLayoutConstraint.activate([
            
            accessoryImageView.widthAnchor.constraint(equalToConstant: 16),
            accessoryImageView.heightAnchor.constraint(equalToConstant: 16),
            accessoryImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            accessoryImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
        
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 12),
            titleLabel.leadingAnchor.constraint(equalTo: accessoryImageView.trailingAnchor, constant: 8),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            titleLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -12),
        ])
    }
}
