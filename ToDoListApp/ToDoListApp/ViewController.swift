//
//  ViewController.swift
//  ToDoListApp
//
//  Created by yuta naito on 2020/02/24.
//  Copyright © 2020 yuta naito. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    /* ToDoを格納した配列 */
    var todoList = [String]()
    /* ToDoを表示するセル */
    @IBOutlet weak var tableView: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    /* +ボタンをタップした時の処理 */
    @IBAction func tapAddButton(_ sender: Any) {
        /* アラートダイアログを作成 */
        let alertController = UIAlertController(title: "ToDo追加", message: "ToDoを入力してください", preferredStyle: UIAlertController.Style.alert)
        
        /* テキストエリアを設定 */
        alertController.addTextField(configurationHandler: nil)
        
        /* OKボタンを追加 */
        let okAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.default) { (action: UIAlertAction) in
            /* OKボタンがタップされた時の処理 */
            if let textField = alertController.textFields?.first {
                /* ToDoの配列を先頭に追加 */
                self.todoList.insert(textField.text!, at: 0)
                /* テーブルに行が追加されたことをテーブルに通知 */
                self.tableView.insertRows(at: [IndexPath(row: 0, section: 0)], with: UITableView.RowAnimation.right)
            }
        }
        
        /* CANCELボタンを追加 */
        let cancelButton = UIAlertAction(title: "CANCEL", style: UIAlertAction.Style.cancel, handler: nil)
        
        /* OKボタンをアラートダイアログに追加 */
        alertController.addAction(okAction)
        
        /* CANCELボタンをアラートダイアログに追加 */
        alertController.addAction(cancelButton)
        
        /* アラートダイアログを表示 */
        present(alertController, animated: true, completion: nil)
    }
    
    /* テーブルの行数を返却 */
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return todoList.count
    }
    
    /* テーブルの行ごとのセルを返却する */
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        /* StoryBoardで指定したtodoCell識別子を利用して再利用可能なセルを取得する */
        let cell = tableView.dequeueReusableCell(withIdentifier: "todoCell", for: indexPath)
        
        /* 行番号にあったToDoのタイトルを取得*/
        let todoTitle = todoList[indexPath.row]
        
        /* セルのラベルにToDoのタイトルをセット */
        cell.textLabel?.text = todoTitle
        
        return cell
    }
    

}

