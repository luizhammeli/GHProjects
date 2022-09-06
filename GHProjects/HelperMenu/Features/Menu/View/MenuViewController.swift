//
//  MenuViewController.swift
//  HelperMenu
//
//  Created by Luiz Hammerli on 05/09/22.
//  Copyright © 2022 PEBMED. All rights reserved.
//

import DependencyCompositionContainer
import UIKit

public class MenuViewController: UIViewController {
    //let service: MenuService
    let container: DependencyCompositionContainer

    lazy var button: UIButton = {
        let button = UIButton()
        button.setTitle("Teste", for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(handleButton), for: .touchUpInside)
        return button
    }()
    
    public init(container: DependencyCompositionContainer) {
        //self.service = service
        self.container = container
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    public override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .red
        
        view.addSubview(button)
        button.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        button.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
    }
    
    @objc private func handleButton() {
        let coordinator = container.route(to: "UserDetail", with: ["id": "luizhammeli"], controller: self.navigationController!)
    }
}
