//
//  bookDetailViewController.swift
//  HyReadTest
//
//  Created by 楊百恩 on 2024/1/29.
//

import UIKit

class bookDetailViewController: UIViewController {
    
    @IBOutlet var bookImage: UIImageView!
    
    
    @IBOutlet var authorLabel: UILabel!
    @IBOutlet var publisherLabel: UILabel!
    @IBOutlet var publishDateLabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    func loadData(book: Book) {
        print("Button tapped for book: \(book.title)")
        setImage(UIImageView: bookImage, book.coverUrl)
        authorLabel.text = book.author
        publisherLabel.text = book.publisher
        publishDateLabel.text = book.publishDate
    }

    func setImage(UIImageView: UIImageView, _ url: String?){
        let imageURLString = url
        // 使用可選綁定確保 imageURLString 有值
        if let imageURLString = imageURLString, let imageURL = URL(string: imageURLString) {
            // 使用 URLSession 載入圖片資料
            URLSession.shared.dataTask(with: imageURL) { (data, _, error) in
                if let data = data, let image = UIImage(data: data) {
                    // 在主線程更新 UI，因為 UIImage 操作需要在主線程進行
                    DispatchQueue.main.async {
                        // 將下載的圖片設定給 imageView
                        UIImageView.image = image
                    }
                } else {
                    print("Error loading image: \(error?.localizedDescription ?? "Unknown error")")
                }
            }.resume()
        } else {
            print("Invalid imageURLString")
        }
        // 設置圓角
        UIImageView.layer.cornerRadius = 4.4
    }
    
    
    
    

}
