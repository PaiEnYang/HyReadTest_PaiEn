//
//  FavoriteViewModel.swift
//  HyReadTest
//
//  Created by 楊百恩 on 2024/1/30.
//

import UIKit


protocol favoriteViewModelDelegate: AnyObject{
    func bookDetailCheck(book: Book)
}

class FavoriteViewModel: NSObject, TableViewCellDelegate{
    
    weak var delegate: favoriteViewModelDelegate?
    weak var libraryDelegate: LibraryViewModel?
    var bookFavoriteArray: [Book] = []
    init(delegate: favoriteViewModelDelegate) {
        super.init()
        self.delegate = delegate
        loadFavoriteBook()
    }
    
    func loadFavoriteBook(){
        if let storedBooks = UserDefaults.standard.array(forKey: Constants.KEY_BOOK_FAVORITE) as? [NSDictionary] {
            // 將 NSDictionary 數組轉換為 [Book]
            let books = storedBooks.compactMap { Book(dictionary: $0) }
            bookFavoriteArray = books
            print("bookFavoriteArray = \(bookFavoriteArray)")
        } else {
            // 如果檢索失敗或轉換失敗的處理邏輯
            print("Unable to retrieve or convert to [Book].")
        }
        
    }
    
    func favoriteButtonTapped(book: Book) {
        libraryDelegate?.refreshLibraryData(for: book.uuid)
    }
    
    func handleBookButtonTap(forCell cell: TableViewCell, bookData: Book) {
        // 在這裡處理按鈕點擊事件，使用bookData來獲取點擊的書籍資料
        DispatchQueue.main.async {
            self.delegate?.bookDetailCheck(book: bookData)
        }
    }
}

extension FavoriteViewModel: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let count = bookFavoriteArray.count
        return (count + 2) / 3
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TableViewCell", for: indexPath) as! TableViewCell
        cell.delegate = self
        // 計算書本在整個書本陣列中的索引
        let startIndex = indexPath.row * 3
        let endIndex = min(startIndex + 2, bookFavoriteArray.count - 1)
        print("bookFavoriteArray = \(bookFavoriteArray)")
        for i in startIndex...endIndex {
            // 設置每個按鈕的閉包，並傳遞相應的值
            cell.bookButtonTapHandler = { [weak self] bookData in
                self?.handleBookButtonTap(forCell: cell, bookData: bookData)
            }
            // 關閉收藏的圖示及控制
            cell.bookfavoriteImage1.isHidden = true
            cell.bookfavoriteImage2.isHidden = true
            cell.bookfavoriteImage3.isHidden = true
            cell.bookfavoriteButton1Outlet.isUserInteractionEnabled = false
            cell.bookfavoriteButton2Outlet.isUserInteractionEnabled = false
            cell.bookfavoriteButton3Outlet.isUserInteractionEnabled = false
            
            cell.loadData(book: bookFavoriteArray[i], Index: i)
        }
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 219.0 // 返回你想要的固定高度
    }
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.backgroundColor = UIColor.clear
        cell.selectionStyle = .none //取消點選時的顏色
    }
    
    
}







