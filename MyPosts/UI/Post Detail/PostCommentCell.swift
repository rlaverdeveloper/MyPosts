//
//  PostCommentCell.swift
//  MyPosts
//
//  Created by Rubbermaid Laverde on 9/05/22.
//

import UIKit

class PostCommentCell: UITableViewCell {
    
    // MARK: - Properties

    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16, weight: .regular)
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
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
    
    func configure(with viewModel: PostCommentCellViewModelProtocol) {
        
        viewModel.title.bind { [weak self] title in
            self?.titleLabel.text = title
        }
    }
}


// MARK: - Setup

private extension PostCommentCell {
    
    func setupUI() {
        
        selectionStyle = .none
        
        contentView.addSubview(titleLabel)
        
        setupConstraints()
    }
    
    func setupConstraints() {
        
        NSLayoutConstraint.activate([

            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 12),
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            titleLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -12)
        ])
    }
}
