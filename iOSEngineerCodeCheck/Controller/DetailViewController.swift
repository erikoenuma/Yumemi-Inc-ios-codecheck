//
//  ViewController2.swift
//  iOSEngineerCodeCheck
//
//  Created by 史 翔新 on 2020/04/21.
//  Copyright © 2020 YUMEMI Inc. All rights reserved.
//

import UIKit

final class DetailViewController: UIViewController {
    
    @IBOutlet private weak var avatorImageView: UIImageView!
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var languageLabel: UILabel!
    @IBOutlet private weak var starsCount: UILabel!
    @IBOutlet private weak var watchersCount: UILabel!
    @IBOutlet private weak var forksCount: UILabel!
    @IBOutlet private weak var issuesCount: UILabel!
    @IBOutlet private weak var goToGithubButton: UIButton!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpView()
        setUpButton()
    }
    
    private func setUpView(){
        ///searchViewControllerで取得したrepositoryの内容を反映させる
        let tableViewDataSource = TableViewDataSource.shared
        let repository = tableViewDataSource.repositories.items[tableViewDataSource.selectedIndex]
        starsCount.text = "\(repository.stargazersCount) stars"
        watchersCount.text = "\(repository.watchersCount) watchers"
        forksCount.text = "\(repository.forksCount) forks"
        issuesCount.text = "\(repository.openIssuesCount) open issues"
        titleLabel.text = repository.fullName
        if let language = repository.language{
            languageLabel.text = "Written in \(language)"
        }else{
            languageLabel.text = ""
        }
        guard let url = URL(string: repository.owner.avatarUrl) else {return}
        setImage(from: url)
        activityIndicator.startAnimating()
    }
    
    private func setUpButton(){
        goToGithubButton.addTarget(self, action: #selector(goToGithubViewController), for: .touchUpInside)
    }
    
    ///searchViewControllerで取得したrepository内のURLからavatorImageViewを取得して反映させる
    private func setImage(from url: URL){
        GithubAPI.GetAvatarImageData.request { (result) in
            switch result{
            case .success(let data):
                let image = UIImage(data: data)
                self.avatorImageView.image = image
            case .failure(let error):
                print(error)
            }
        }
    }
    
    ///githubページに遷移するボタンのメソッド
    @objc private func goToGithubViewController(){
        let github = GithubViewController()
        self.navigationController?.pushViewController(github, animated: true)
    }
}
