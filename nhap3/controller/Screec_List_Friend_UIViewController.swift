//
//  Screec_List_Friend_UIViewController.swift
//  nhap3
//
//  Created by vuminhtam on 4/1/19.
//  Copyright © 2019 vuminhtam. All rights reserved.
//

import UIKit

class Screec_List_Friend_UIViewController: UIViewController,UITableViewDataSource,UITabBarDelegate {
    
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // nhung cai viet trong potocol chinh taoverride lai
        tableView.dataSource = self
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return 10
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let Cell = tableView.dequeueReusableCell(withIdentifier: "CELL")
        Cell?.textLabel?.text = "Vu minh tam"
        return Cell!
    }

}
