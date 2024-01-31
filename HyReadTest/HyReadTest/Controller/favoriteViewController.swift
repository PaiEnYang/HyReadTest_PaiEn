//
//  favoriteViewController.swift
//  HyReadTest
//
//  Created by 楊百恩 on 2024/1/30.
//

import UIKit
import Foundation

class favoriteViewController: UIViewController, favoriteViewModelDelegate{
   
    var favoriteViewModel: FavoriteViewModel!
    @IBOutlet var favoriteTableView: UITableView!
    @IBOutlet var bookDetailView: UIView!
    var backgroundView = UIView()
    

    override func viewDidLoad() {
        print("favoriteViewController ViewDidLoad.......")
        super.viewDidLoad()
        bookDetailView.isHidden = true
        favoriteViewModel = FavoriteViewModel(delegate: self)
        //告訴 TableView 我們要使用這個名稱的 cell 當內容
        favoriteTableView.delegate = favoriteViewModel
        favoriteTableView.dataSource = favoriteViewModel
        // 設置 UITableViewDataSourcePrefetching 代理
        let cellNib = UINib(nibName: "TableViewCell", bundle: nil)
        favoriteTableView.register(cellNib, forCellReuseIdentifier: "TableViewCell")
        favoriteTableView.showsVerticalScrollIndicator = false
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        print("favoriteViewController ViewDidAppear.......")
        reloadTableView()
        
    }
    
    func reloadTableView() {
        favoriteViewModel.loadFavoriteBook()
        favoriteTableView.reloadData()
    }
    
    func bookDetailCheck(book: Book) {
        bookDetailView.isHidden = false
        makeBackgroundView(FrontView: bookDetailView, BackView: backgroundView)
        let containerVC = children.first as? bookDetailViewController
        containerVC?.loadData(book: book)
    }
    
    private func makeBackgroundView(FrontView: UIView, BackView: UIView){
        // 创建一个透明灰色的背景
        BackView.backgroundColor = UIColor.black.withAlphaComponent(0.8)
        BackView.translatesAutoresizingMaskIntoConstraints = false
        view.insertSubview(BackView, belowSubview: FrontView)
        NSLayoutConstraint.activate([
            BackView.topAnchor.constraint(equalTo: view.topAnchor),
            BackView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            BackView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            BackView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        // 添加一个点击手势识别器到背景视图
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(backgroundTapped))
        backgroundView.addGestureRecognizer(tapGesture)
        backgroundView.isUserInteractionEnabled = true // 启用用户交互
    }
    
    @objc func backgroundTapped() {
        backgroundView.removeFromSuperview()
        bookDetailView.isHidden = true
    }
    

}
