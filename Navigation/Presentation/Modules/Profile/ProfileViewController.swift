//
//  ProfileViewController.swift
//  Navigation
//
//  Created by Maksim Maiorov on 08.02.2022.
//

import UIKit

final class ProfileViewController: UIViewController {
    
    // MARK: - PROPERTIES
    
    private lazy var tableView: UITableView = { // создаем таблвью
        let tableView = UITableView()
        tableView.backgroundColor = .systemGray6
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "DefaultCell")
        tableView.register(PhotosTableViewCell.self, forCellReuseIdentifier: "PhotoCell")
        tableView.register(PostTableViewCell.self, forCellReuseIdentifier: "PostCell")
        tableView.register(ProfileTableHeaderView.self, forHeaderFooterViewReuseIdentifier: "TableHeder")
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 44
       
        return tableView
    }()
   
    private var isExpanded: Bool = true // I-й способ измения высоты Header
    private var height = 236 // II-й способ измения высоты Header
      
      // MARK: - LIFECYCLE METHODS
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.isHidden = true
        self.navigationController?.navigationBar.isHidden = true
    }
    
    // MARK: - SETUP SUBVIEWS
    private func setupTableView() {
        self.view.addSubview(self.tableView)
        
        let topConstraint = self.tableView.topAnchor.constraint(equalTo: self.view.topAnchor)
        let leadingConstraint = self.tableView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor)
        let trailingConstraint = self.tableView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor)
        let bottomConstraint = self.tableView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor)
        
        NSLayoutConstraint.activate([
            topConstraint, leadingConstraint, trailingConstraint, bottomConstraint
        ])
    }
}

    // MARK: - EXTENSIONS
extension ProfileViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = tableView.dequeueReusableHeaderFooterView(withIdentifier: "TableHeder") as! ProfileTableHeaderView
        view.delegate = self
        
        return view
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if (section == 0) {
            return isExpanded ? 236 : 266 // I-й способ
            // CGFloat(height) // II-й способ
        } else {
            return 0
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        } else {
            return newsArticles.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "PhotoCell", for: indexPath) as? PhotosTableViewCell else {
                let cell = tableView.dequeueReusableCell(withIdentifier: "DefaultCell", for: indexPath)
                
                return cell
            }
            cell.delegate = self
            cell.layer.shouldRasterize = true
            cell.layer.rasterizationScale = UIScreen.main.scale
            
            return cell
        } else {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "PostCell", for: indexPath) as? PostTableViewCell else {
                let cell = tableView.dequeueReusableCell(withIdentifier: "DefaultCell", for: indexPath)
                
                return cell
            }
            
            cell.delegate = self
            let article = newsArticles[indexPath.row]
            let viewModel = PostTableViewCell.ViewModel(
                author: article.author,
                description: article.description,
                image: article.image,
                likes: article.likes,
                views: article.views)
            cell.setup(with: viewModel)
            
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let presentPostViewController = FullPostView()
        var article = newsArticles[indexPath.row]
        let viewModel = FullPostView.ViewModel(
            author: article.author,
            description: article.description,
            image: article.image,
            likes: article.likes,
            views: article.views)
        
        presentPostViewController.setup(with: viewModel)
        self.view.addSubview(presentPostViewController)
       
        presentPostViewController.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            presentPostViewController.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            presentPostViewController.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            presentPostViewController.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            presentPostViewController.topAnchor.constraint(equalTo: view.topAnchor)
            ])
        
        article.views += 1
        
        tableView.reloadData()
    }
}

extension ProfileViewController: ProfileTableHeaderViewProtocol {

    func buttonAction(inputTextIsVisible: Bool, completion: @escaping () -> Void) {  self.tableView.beginUpdates()
        self.isExpanded = !inputTextIsVisible // I-й способ
        // self.height = inputTextIsVisible ? 266 : 236 // II-й способ
        self.tableView.endUpdates()
        UIView.animate(withDuration: 0.2, delay: 0.0) {
            self.view.layoutIfNeeded()
        } completion: { _ in
            completion()
        }
    }
    
    func delegateAction(cell: ProfileTableHeaderView) {
     
        let animatedAvatarViewController = AnimatedAvatarViewController()
        self.view.addSubview(animatedAvatarViewController.view)
        self.addChild(animatedAvatarViewController)
        animatedAvatarViewController.view.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            animatedAvatarViewController.view.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            animatedAvatarViewController.view.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            animatedAvatarViewController.view.topAnchor.constraint(equalTo: view.topAnchor),
            animatedAvatarViewController.view.bottomAnchor.constraint(equalTo: view.bottomAnchor)
            ])

        animatedAvatarViewController.didMove(toParent: self)
    }
}

extension ProfileViewController: PhotosTableViewCellProtocol { // переход в PhotosViewController
    func delegateButtonAction(cell: PhotosTableViewCell) {
        let photosViewController = PhotosViewController()
        self.navigationController?.pushViewController(photosViewController, animated: true)
    }
}

extension ProfileViewController: PostTableViewCellProtocol {
    func delegateLabelAction(cell: PostTableViewCell) {
        
    } 
}
