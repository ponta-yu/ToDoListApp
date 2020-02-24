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
    var todoList = [MyTodo]()
    /* ToDoを表示するセル */
    @IBOutlet weak var tableView: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        /* 保存しているToDoの読み込み処理 */
        let userDefaults = UserDefaults.standard
        if let storedTodoList = userDefaults.object(forKey: "todoList") as? Data {
            do {
                if let unarchivedTodoList = try NSKeyedUnarchiver.unarchivedObject(ofClasses: [NSArray.self, MyTodo.self], from: storedTodoList) as? [MyTodo] {
                    todoList.append(contentsOf: unarchivedTodoList)
                }
            } catch {
                print("ToDo読み出しエラー")
            }
        }
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
                let myTodo = MyTodo()
                myTodo.todoTitle = textField.text!
                self.todoList.insert(myTodo, at: 0)
                
                /* テーブルに行が追加されたことをテーブルに通知 */
                self.tableView.insertRows(at: [IndexPath(row: 0, section: 0)], with: UITableView.RowAnimation.right)
                
                /* ToDoの保存処理 */
                let userDefaults = UserDefaults.standard
                do {
                    let data = try NSKeyedArchiver.archivedData(withRootObject: self.todoList, requiringSecureCoding: true)
                    userDefaults.set(data, forKey: "todoList")
                    userDefaults.synchronize()
                } catch {
                    print("ToDo保存エラー")
                }
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
        
        /* 行番号にあったToDoの情報を取得*/
        let myTodo = todoList[indexPath.row]
        
        /* セルのラベルにToDoのタイトルをセット */
        cell.textLabel?.text = myTodo.todoTitle
        
        /* セルのチェックマーク状態をセット */
        if myTodo.todoDone {
            cell.accessoryType = UITableViewCell.AccessoryType.checkmark
        }
        else {
            cell.accessoryType = UITableViewCell.AccessoryType.none
        }
        
        return cell
    }
    
    /* セルをタップした時の処理 */
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let myTodo = todoList[indexPath.row]
        
        /* ToDowの完了or未完了を判定 */
        if myTodo.todoDone {
            myTodo.todoDone = false
        }
        else {
            myTodo.todoDone = true
        }
        
        /* セルの状態を変更 */
        tableView.reloadRows(at: [indexPath], with: UITableView.RowAnimation.fade)
        
        /* データ保存 */
        do {
            let data:Data = try NSKeyedArchiver.archivedData(withRootObject: todoList, requiringSecureCoding: true)
            let userDefaults = UserDefaults.standard
            userDefaults.set(data, forKey: "todoList")
            userDefaults.synchronize()
        } catch {
            print("セル更新エラー")
        }
    }
}

class MyTodo: NSObject, NSSecureCoding {
    static var supportsSecureCoding: Bool {
        return true
    }
    
    /* ToDoのタイトル */
    var todoTitle: String?
    
    /* ToDoを完了したかどうかを表すフラグ */
    var todoDone: Bool = false
    
    /* コンストラクタ */
    override init() {
        
    }
    
    /* NSCodingプロトコル：デシリアライズ処理 */
    required init?(coder aDecoder: NSCoder) {
        todoTitle = aDecoder.decodeObject(forKey: "todoTitle") as? String
        todoDone = aDecoder.decodeBool(forKey: "todoDone")
    }
    
    /* NSCodingプロトコル：シリアライズ処理 */
    func encode(with aCoder: NSCoder) {
        aCoder.encode(todoTitle, forKey: "todoTitle")
        aCoder.encode(todoDone, forKey: "todoDone")
    }
}

