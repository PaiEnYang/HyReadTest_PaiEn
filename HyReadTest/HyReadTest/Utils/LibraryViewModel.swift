//
//  LibraryViewModel.swift
//  HyReadTest
//
//  Created by 楊百恩 on 2024/1/25.
//

import UIKit


protocol libraryViewModelDelegate: AnyObject{
    func reloadTableView()
    func bookDetailCheck(book: Book)
}

class LibraryViewModel: NSObject, TableViewCellDelegate{
    weak var delegate: libraryViewModelDelegate?
    var libraryData: [Book]? = []
    var bookFavoriteArray: [Book] = []
    init(delegate: libraryViewModelDelegate) {
        super.init()
        self.delegate = delegate
        loadFavoriteBook()
        dataLoad()
    }
    
    // 圖書庫資料讀取
    func dataLoad(){
        // 創建一個 URL 實例
        let url = URL(string: "https://mservice.ebook.hyread.com.tw/exam/user-list")!
        // 創建一個 URLRequest 實例
        var request = URLRequest(url: url)
        // 設定請求方法為 GET
        request.httpMethod = "GET"
        // 創建一個 URLSession 實例
        let session = URLSession.shared
        // 創建一個 data task 來發送請求
        let task = session.dataTask(with: request) { [self] (data, response, error) in
            // 檢查是否有錯誤發生
            if let error = error {
                print("Error: \(error)")
                return
            }
            // 檢查伺服器回應的狀態碼
            if let httpResponse = response as? HTTPURLResponse {
                print("Status Code: \(httpResponse.statusCode)")
            }
            // 檢查是否有資料回傳
            if let responseData = data {
                // 檢查 Content-Type 標頭
                if let contentType = response?.mimeType {
                    print("Content-Type: \(contentType)")
                    // 根據 Content-Type 進行不同的資料處理
                    if contentType == "application/json" {
                        // 處理 JSON 資料
                        do {
                            let jsonObject = try JSONSerialization.jsonObject(with: responseData, options: [])
                            print("JSON Data: \(jsonObject)")
                            // JSON 資料 解碼
                            decode(jsonArray: jsonObject as! Array<Any>)
                        } catch {
                            print("Error decoding JSON: \(error)")
                        }
                    } else if contentType == "text/plain" {
                        // 處理純文字資料
                        if let text = String(data: responseData, encoding: .utf8) {
                            print("Text Data: \(text)")
                        }
                    } else {
                        // 處理其他類型的資料
                        print("Unsupported Content-Type")
                    }
                }
            }
        }
        // 開始執行 data task
        task.resume()
    }
    
    func decode(jsonArray: Array<Any>){
        // 遍歷每個元素
        for item in jsonArray {
            if let bookDict = item as? [String: Any] {
                // 將每個元素轉換為 Book 結構或類別
                var book = Book(
                    author: bookDict["author"] as? String ?? "",
                    coverUrl: bookDict["coverUrl"] as? String ?? "",
                    publishDate: bookDict["publishDate"] as? String ?? "",
                    publisher: bookDict["publisher"] as? String ?? "",
                    title: bookDict["title"] as? String ?? "",
                    uuid: bookDict["uuid"] as? Int64 ?? 1000,
                    favorite: false
                )
                // 將有加入到收藏的書籍標記起來
                let bookTitle = book.title
                let foundBooks = bookFavoriteArray.filter { $0.title == bookTitle }
                if foundBooks.isEmpty {
                    print("No Books found with title '\(bookTitle)'")
                } else {
                    print("Found Books with title '\(bookTitle)': \(foundBooks)")
                    book.favorite = true
                }
                // 統一放到管理庫中
                libraryData?.append(book)
                // 在這裡處理書籍資訊
                print("Author: \(book.author)")
                print("Cover URL: \(book.coverUrl)")
                print("Publish Date: \(book.publishDate)")
                print("Publisher: \(book.publisher)")
                print("Title: \(book.title)")
                print("UUID: \(book.uuid)")
                print("-----")
            }
        }
        // 解碼完成後更新 tableView
        DispatchQueue.main.async {
            self.delegate?.reloadTableView()
        }
    }
    
    func refreshLibraryData(for bookUUID: Int64){
        // 監控 title 屬性的變動
        guard let bookIndex = libraryData?.firstIndex(where: { $0.uuid == bookUUID }) else {
            print("Book with UUID \(bookUUID) not found")
            return
        }
        libraryData![bookIndex].favorite = !libraryData![bookIndex].favorite
        // 使用 filter 建立新的清單，並且只包含收藏的書籍
        let filteredBooks = libraryData?.filter { $0.favorite == true }
        // 將 [Book] 轉換為包含 NSDictionary 的 NSArray
        if let filteredBooks = filteredBooks{
            let bookDictArray = filteredBooks.map { $0.dictionaryRepresentation() }
            // 將轉換後的 NSArray 存儲到 UserDefaults 中
            UserDefaults.standard.set(bookDictArray, forKey: Constants.KEY_BOOK_FAVORITE)
        }
    }
    
    // 讀取收藏的書籍
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
        refreshLibraryData(for: book.uuid)
    }
    
    func handleBookButtonTap(forCell cell: TableViewCell, bookData: Book) {
        // 在這裡處理按鈕點擊事件，使用bookData來獲取點擊的書籍資料
        DispatchQueue.main.async {
            self.delegate?.bookDetailCheck(book: bookData)
        }
    }
}

extension LibraryViewModel: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let libraryData = libraryData else {
            return 0
        }
        let totalBooks = libraryData.count
        let numberOfFullRows = totalBooks / 3
        let numberOfRemainingBooks = totalBooks % 3
        // 如果有剩餘書籍，則需要再添加一行
        return numberOfFullRows + (numberOfRemainingBooks > 0 ? 1 : 0)
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TableViewCell", for: indexPath) as! TableViewCell
        cell.delegate = self
        // 計算書本在整個書本陣列中的索引
        if let libraryData = libraryData{
            let startIndex = indexPath.row * 3
            let endIndex = min(startIndex + 2, libraryData.count - 1)
            for i in startIndex...endIndex {
                print("看這裡啦:\(i), startIndex = \(startIndex), endIndex = \(endIndex)", "UUID = \(libraryData[i].uuid)")
                // 設置每個按鈕的閉包，並傳遞相應的值
                cell.bookButtonTapHandler = { [weak self] bookData in
                    self?.handleBookButtonTap(forCell: cell, bookData: bookData)
                }
                cell.loadData(book: libraryData[i], Index: i)
            }
            
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






