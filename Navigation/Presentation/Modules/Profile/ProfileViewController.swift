//
//  ProfileViewController.swift
//  Navigation
//
//  Created by Maksim Maiorov on 08.02.2022.
//

import UIKit


// MARK: - PROTOCOLS

protocol ProfileHeaderViewProtocol: AnyObject { // расширение вью по нажатии кнопки - делегат
    func buttonAction(inputTextIsVisible: Bool, completion: @escaping () -> Void)
}

final class ProfileViewController: UIViewController {
    
    // MARK: - PROPERTIES
    private var dataSource: [News.Article] = [] // МАССИВ НОВОСТЕЙ

    
    private lazy var jsonDecoder: JSONDecoder = {
        return JSONDecoder()
    }()
    

    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.backgroundColor = .systemGray6
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "DefaultCell")

        tableView.register(PhotosTableViewCell.self, forCellReuseIdentifier: "PhotoCell")
        tableView.register(PostTableViewCell.self, forCellReuseIdentifier: "PostCell")
        tableView.register(ProfileTableHederView.self, forHeaderFooterViewReuseIdentifier: "TableHeder")
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 44
        
        return tableView
    }()
    

    private var isExpanded: Bool = true
    
    // MARK: LIFECYCLE METHODS
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        tapGesturt()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.fetchArticles { [weak self] articles in
            self?.dataSource = articles
            DispatchQueue.main.async {
                self?.tableView.reloadData()
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.isHidden = true
        self.navigationController?.navigationBar.isHidden = true
    }
    
    // MARK: - SETUP SUBVIEW

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
    

    // MARK: Data coder
    private func fetchArticles(completion: @escaping ([News.Article]) -> Void) { // получаем новости
        if let path = Bundle.main.path(forResource: "news", ofType: "json") {
            do {
                let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .alwaysMapped)
                let news = try self.jsonDecoder.decode(News.self, from: data)
                print("json data: \(news)")
                completion(news.articles)
            } catch let error {
                print("parse error: \(error.localizedDescription)")
            }
        } else {
            fatalError("Invalid filename/path.")
        }
    }
    
    func tapGesturt() { // метод скрытия клавиатуры при нажатии на экран
        let tapGesture = UITapGestureRecognizer(target: self.view, action: #selector(view.endEditing))
        self.view.addGestureRecognizer(tapGesture)
    }
}

    // MARK: - EXTENSIONS

extension ProfileViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = tableView.dequeueReusableHeaderFooterView(withIdentifier: "TableHeder") as! ProfileTableHederView
        view.delegate = self
        
        return view
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {

        if section == 0 {
            
            return isExpanded ? 236 : 266
        } else {
            
            return 0
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int { // кол-во секций
        
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int { // ячеек в секц
        if section == 0 {
            
            return 1 // количество скролл вью
        } else {
            
            return self.dataSource.count // количество постов новостей
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 { // коллекшинвью фотографий
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "PhotoCell", for: indexPath) as? PhotosTableViewCell else {
                let cell = tableView.dequeueReusableCell(withIdentifier: "DefaultCell", for: indexPath)
                
                return cell
            }
            cell.delegate = self
            cell.layer.shouldRasterize = true
            cell.layer.rasterizationScale = UIScreen.main.scale
            
            return cell
        } else { // посты новостей
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "PostCell", for: indexPath) as? PostTableViewCell else {
                let cell = tableView.dequeueReusableCell(withIdentifier: "DefaultCell", for: indexPath)
                
                return cell
            }
            let article = self.dataSource[indexPath.row]
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
}

extension ProfileViewController: ProfileHeaderViewProtocol {
    
    func buttonAction(inputTextIsVisible: Bool, completion: @escaping () -> Void) {
        self.tableView.beginUpdates()
        self.isExpanded = !inputTextIsVisible
        self.tableView.endUpdates()
        UIView.animate(withDuration: 0.2, delay: 0.0) {
            self.view.layoutIfNeeded()
        } completion: { _ in
            completion()
        }
    }
}

extension ProfileViewController: PhotosTableViewCellProtocol { // переход в PhotosViewController
    
    func delegateButtonAction(cell: PhotosTableViewCell) {
        let photosViewController = PhotosViewController()
        self.navigationController?.pushViewController(photosViewController, animated: true)
    }
}

