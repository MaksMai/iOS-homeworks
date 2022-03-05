//
//  ProfileViewController.swift
//  Navigation
//
//  Created by Maksim Maiorov on 08.02.2022.
//

import UIKit

final class ProfileViewController: UIViewController {
    
    // MARK: - Data
    private var dataSource: [News.Article] = [] // получаем новости
    
    private lazy var jsonDecoder: JSONDecoder = {
        return JSONDecoder()
    }()
    
    // MARK: - TableView
    private lazy var tableView: UITableView = { // создаем таблвью
        let tableView = UITableView()
        tableView.backgroundColor = .systemGray6
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "DefaultCell")
        tableView.register(PhotosTableViewCell.self, forCellReuseIdentifier: "PhotoCell")
        tableView.register(PostTableViewCell.self, forCellReuseIdentifier: "PostCell")
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 44
        
        return tableView
    }()
    
    // MARK: - HaderTableView
    private lazy var tableHeaderView: ProfileHeaderView = { // сщздаем хедер
        let view = ProfileHeaderView(frame: .zero) // создаем вью ProfileHeaderView
        view.delegate = self
        view.translatesAutoresizingMaskIntoConstraints = false // отключаем AutoresizingMask
        
        return view
    }()
    
    private var heightConstraint: NSLayoutConstraint? // делегируем управление высотой вью
  
    // MARK: - Lifecycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTableView()
        tapGesturt() // скрывать клавиатуру
       
        self.fetchArticles { [weak self] articles in
            self?.dataSource = articles
            self?.tableView.reloadData()
        }
      
        self.tableView.tableHeaderView = tableHeaderView // хедер
        setupProfileHeadView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.isHidden = true // скрываем таббар
        self.navigationController?.navigationBar.isHidden = true // скрываем верх
    }
    
    override func viewWillLayoutSubviews() { // обновляем мзменения хедера
        super.viewWillLayoutSubviews()
        updateHeaderViewHeight(for: tableView.tableHeaderView)
    }
    
    // MARK: - Setup SubView
    private func setupTableView() { // констрейны к таблвью
        self.view.addSubview(self.tableView)
        
        let topConstraint = self.tableView.topAnchor.constraint(equalTo: self.view.topAnchor)
        let leadingConstraint = self.tableView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor)
        let trailingConstraint = self.tableView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor)
        let bottomConstraint = self.tableView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor)
        
        NSLayoutConstraint.activate([
            topConstraint, leadingConstraint, trailingConstraint, bottomConstraint
        ])
    }
    
    private func setupProfileHeadView() {  // Создаем констрейты к хедеру
        self.view.backgroundColor = .lightGray // Задаем базовый цвет
        
        let topConstraint = self.tableHeaderView.topAnchor.constraint(equalTo: tableView.topAnchor) // верх
        let leadingConstraint = self.tableHeaderView.leadingAnchor.constraint(equalTo: tableView.leadingAnchor) // левый край
        let trailingConstraint = self.tableHeaderView.trailingAnchor.constraint(equalTo: tableView.trailingAnchor) // левый край
        let widthConstraint = self.tableHeaderView.widthAnchor.constraint(equalTo: tableView.widthAnchor)
        self.heightConstraint = self.tableHeaderView.heightAnchor.constraint(equalToConstant: 220) // высота
        let bottomConstraint = self.tableHeaderView.bottomAnchor.constraint(equalTo: tableView.bottomAnchor)
        
        NSLayoutConstraint.activate([
            topConstraint, leadingConstraint, trailingConstraint, bottomConstraint,
            heightConstraint, widthConstraint
        ].compactMap( {$0} ))
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
    
    func updateHeaderViewHeight(for header: UIView?) { // изменяем высоту хедера
        guard let header = header else { return }
        header.frame.size.height = header.systemLayoutSizeFitting(CGSize(width: view.bounds.width, height: CGFloat(heightConstraint!.constant))).height
    }
}

// MARK: - UITableView Data Source
extension ProfileViewController: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int { // кол-во секций
        return 2 // количество секций
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
            let viewModel = PostTableViewCell.ViewModel(author: article.author, description: article.description, image: article.image, likes: article.likes, views: article.views)
            cell.setup(with: viewModel)
            
            return cell
        }
    }
}

// MARK: - Delegate Button Action
extension ProfileViewController: ProfileHeaderViewProtocol {
    
    func buttonAction(inputTextIsVisible: Bool, completion: @escaping () -> Void) { // разширение разширения вью
        self.heightConstraint?.constant = inputTextIsVisible ? 250 : 220

        self.tableView.beginUpdates()
        self.tableView.reloadSections(IndexSet(0..<1), with: .automatic)
        self.tableView.endUpdates()
        
        UIView.animate(withDuration: 0.2, delay: 0.0) { // замедляем открытие/закрытие текстового поля
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
