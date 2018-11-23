//
//  TabBarController.swift
//  Task1_CustomCell
//
//  Created by Pavlo Ratushnyi on 11/21/18.
//  Copyright © 2018 Pavlo Ratushnyi. All rights reserved.
//

import UIKit

class TabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()

        self.tabBar.items?[3].selectedImage = UIImage(named: "Earth_sel")?.withRenderingMode(.alwaysOriginal)
        self.tabBar.items?[3].image = UIImage(named: "Earth_unsel")?.withRenderingMode(.alwaysOriginal)
        self.tabBar.items?[2].selectedImage = UIImage(named: "Properties_sel")?.withRenderingMode(.alwaysOriginal)
        self.tabBar.items?[2].image = UIImage(named: "Properties_unsel")?.withRenderingMode(.alwaysOriginal)
    }
    
}
