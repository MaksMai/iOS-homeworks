//
//  ProfileViewController.swift
//  Navigation
//
//  Created by Maksim Maiorov on 08.02.2022.
//

import UIKit

final class ProfileViewController: UIViewController {
    
    // MARK: Properties
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
        self.tableView.tableHeaderView = tableHeaderView // хедер
        
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
    
    func updateHeaderViewHeight(for header: UIView?) { // изменяем высоту хедера
        guard let header = header else { return }
        header.frame.size.height = header.systemLayoutSizeFitting(CGSize(width: view.bounds.width, height: CGFloat(heightConstraint!.constant))).height
    }
}

    // MARK: Extension
extension ProfileViewController: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int { // кол-во секций
        return 2 // количество секций
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int { // ячеек в секц
        if section == 0 {
            return 1 // количество скролл вью
        } else {
            return newsArticles.count // количество постов новостей
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

            let article = newsArticles[indexPath.row]
            let viewModel = PostTableViewCell.ViewModel(author: article.author, description: article.description, image: article.image, likes: String(article.likes), views: String(article.views))
            cell.setup(with: viewModel)
            
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let presentPostViewController = FullPostView()
        
        let article = newsArticles[indexPath.row]
        let viewModel = FullPostView.ViewModel(author: article.author, description: article.description, image: article.image, likes: String(article.likes), views: String(article.views))
        presentPostViewController.setup(with: viewModel)
         // Создаем InfoViewController
//        presentPostViewController.modalPresentationStyle = .automatic  //  должен показаться модально
        self.view.addSubview(presentPostViewController)// Вызываем InfoViewController
       
        presentPostViewController.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            presentPostViewController.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            presentPostViewController.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            presentPostViewController.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            presentPostViewController.topAnchor.constraint(equalTo: view.topAnchor)
            ])
    }
    
}

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
    
    func delegateAction(cell: ProfileHeaderView) {
     
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
