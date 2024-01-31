//
//  TableViewCell.swift
//  HyReadTest
//
//  Created by 楊百恩 on 2024/1/25.
//

import UIKit

protocol TableViewCellDelegate: AnyObject {
    func favoriteButtonTapped(book: Book)
}


class TableViewCell: UITableViewCell {
    var bookButtonTapHandler: ((Book) -> Void)?
    weak var delegate: TableViewCellDelegate?
    
    
    var book1: Book!
    var book2: Book!
    var book3: Book!
    
    var book1favorite: Bool = false
    var book2favorite: Bool = false
    var book3favorite: Bool = false
    
    var bookFavoriteArray: [Book] = []
    
    var bookTitle = UILabel()
    @IBOutlet var bookImage1: UIImageView!
    @IBOutlet var bookTitle1: UILabel!
    @IBOutlet var bookButton1Outlet: UIButton!
    @IBOutlet var bookfavoriteImage1: UIImageView!
    @IBOutlet var bookfavoriteButton1Outlet: UIButton!
    
    @IBOutlet var bookImage2: UIImageView!
    @IBOutlet var bookTitle2: UILabel!
    @IBOutlet var bookButton2Outlet: UIButton!
    @IBOutlet var bookfavoriteImage2: UIImageView!
    @IBOutlet var bookfavoriteButton2Outlet: UIButton!
    
    @IBOutlet var bookImage3: UIImageView!
    @IBOutlet var bookTitle3: UILabel!
    @IBOutlet var bookButton3Outlet: UIButton!
    @IBOutlet var bookfavoriteImage3: UIImageView!
    @IBOutlet var bookfavoriteButton3Outlet: UIButton!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        print("awakeFromNib")
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
    func loadData(book: Book, Index: Int){
        if Index % 3 == 0{
            bookTitle2.text = ""
            bookTitle3.text = ""
            bookImage2.image = UIImage(named: "")
            bookImage3.image = UIImage(named: "")
            bookfavoriteImage2.image = UIImage(named: "noFavorite")
            bookfavoriteImage3.image = UIImage(named: "noFavorite")
            bookTitle1.text = book.title
            setImage(UIImageView: bookImage1, book.coverUrl)
            book1 = book
            book1favorite = book.favorite
            bookfavoriteImage1.image = book1.favorite ? UIImage(named: "Favorite") : UIImage(named: "noFavorite")
        }
        if Index % 3 == 1{
            bookTitle3.text = ""
            bookImage3.image = UIImage(named: "")
            bookfavoriteImage3.image = UIImage(named: "noFavorite")
            bookTitle2.text = book.title
            setImage(UIImageView: bookImage2, book.coverUrl)
            book2 = book
            book2favorite = book.favorite
            bookfavoriteImage2.image = book2.favorite ? UIImage(named: "Favorite") : UIImage(named: "noFavorite")
        }
        if Index % 3 == 2{
            bookTitle3.text = book.title
            setImage(UIImageView: bookImage3, book.coverUrl)
            book3 = book
            book3favorite = book.favorite
            bookfavoriteImage3.image = book3.favorite ? UIImage(named: "Favorite") : UIImage(named: "noFavorite")
        }
    }
    
  
    func initView(){
        bookTitle1.text = ""
        bookTitle2.text = ""
        bookTitle3.text = ""
        bookImage1.image = UIImage(named: "")
        bookImage2.image = UIImage(named: "")
        bookImage3.image = UIImage(named: "")
        bookfavoriteImage1.image = UIImage(named: "noFavorite")
        bookfavoriteImage2.image = UIImage(named: "noFavorite")
        bookfavoriteImage3.image = UIImage(named: "noFavorite")
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
    
    @IBAction func checkBookDetailBtn(_ sender: UIButton) {
        if sender == bookButton1Outlet{
            bookButtonTapHandler?(book1)
        } else if sender == bookButton2Outlet{
            bookButtonTapHandler?(book2)
        } else if sender == bookButton3Outlet{
            bookButtonTapHandler?(book3)
        }
    }
    
    @IBAction func favoriteBookBtn(_ sender: UIButton) {
        var book: Book!
        if sender == bookfavoriteButton1Outlet{
            book1.favorite = !book1.favorite
            book = book1
            bookfavoriteImage1.image = book1.favorite ? UIImage(named: "Favorite") : UIImage(named: "noFavorite")
        } else if sender == bookfavoriteButton2Outlet{
            book2.favorite = !book2.favorite
            book = book2
            bookfavoriteImage2.image = book2.favorite ? UIImage(named: "Favorite") : UIImage(named: "noFavorite")
        } else if sender == bookfavoriteButton3Outlet{
            book3.favorite = !book3.favorite
            book = book3
            bookfavoriteImage3.image = book3.favorite ? UIImage(named: "Favorite") : UIImage(named: "noFavorite")
        }
        self.delegate?.favoriteButtonTapped(book: book)
    }

    
    
    
}
