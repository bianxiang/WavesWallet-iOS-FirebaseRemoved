//
//  MenuViewController.swift
//  WavesWallet-iOS
//
//  Created by Pavel Gubin on 4/28/18.
//  Copyright © 2018 Waves Platform. All rights reserved.
//

import UIKit
import DomainLayer

class MenuViewController: UIViewController {

    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var communitiesLabel: UILabel!
    @IBOutlet weak var whitepaperButton: UIButton!
    @IBOutlet weak var termAndConditionsButton: UIButton!
    @IBOutlet weak var supportWavesplatformButton: UIButton!

    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupLocalization()

        NotificationCenter.default.addObserver(self, selector: #selector(changedLanguage), name: .changedLanguage, object: nil)
    }

    @objc func changedLanguage() {
        setupLocalization()
    }
    
    @IBAction func wavesTapped(_ sender: Any) {
        UIApplication.shared.openURLAsync(URL(string: "https://forum.wavesplatform.com/")!)
    }
    
    @IBAction func gitTapped(_ sender: Any) {
        UIApplication.shared.openURLAsync(URL(string: "https://github.com/wavesplatform/")!)
        
        UseCasesFactory
            .instance
            .analyticManager
            .trackEvent(.menu(.wavesMenuGithub))
    }
    
    @IBAction func telegramTapped(_ sender: Any) {
        
        UseCasesFactory
            .instance
            .analyticManager
            .trackEvent(.menu(.wavesMenuTelegram))
        
        UIApplication.shared.openURLAsync(URL(string: "https://telegram.me/wavesnews")!)
    }
    
    @IBAction func discordTapped(_ sender: Any) {
        
        UseCasesFactory
            .instance
            .analyticManager
            .trackEvent(.menu(.wavesMenuDiscord))
        
        UIApplication.shared.openURLAsync(URL(string: "https://discordapp.com/invite/cnFmDyA")!)
    }
    
    @IBAction func twitterTapped(_ sender: Any) {
        
        UseCasesFactory
            .instance
            .analyticManager
            .trackEvent(.menu(.wavesMenuTwitter))
        
        UIApplication.shared.openURLAsync(URL(string: "https://twitter.com/wavesplatform")!)
    }
    
    @IBAction func redditTapped(_ sender: Any) {
        
        UseCasesFactory
            .instance
            .analyticManager
            .trackEvent(.menu(.wavesMenuReddit))
        
        UIApplication.shared.openURLAsync(URL(string: "https://www.reddit.com/r/Wavesplatform")!)
    }

    @IBAction func whitepaperTapped(_ sender: Any) {
        
        UseCasesFactory
            .instance
            .analyticManager
            .trackEvent(.menu(.wavesMenuWhitepaper))
        
        UIApplication.shared.openURLAsync(URL(string: "https://wavesplatform.com/files/whitepaper_v0.pdf")!)
    }

    @IBAction func termAndConditionsTapped(_ sender: Any) {
        
        UseCasesFactory
            .instance
            .analyticManager
            .trackEvent(.menu(.wavesMenuTermsAndConditions))
        
        UIApplication.shared.openURLAsync(URL(string: "https://wavesplatform.com/files/docs/Waves_terms_and_conditions.pdf")!)
    }

    @IBAction func supportWavesplatformTapped(_ sender: Any) {
        
        UseCasesFactory
            .instance
            .analyticManager
            .trackEvent(.menu(.wavesMenuSupport))
        
        UIApplication.shared.openURLAsync(URL(string: "https://support.wavesplatform.com/")!)
    }
}

extension MenuViewController: Localization {
    func setupLocalization() {

        descriptionLabel.text = Localizable.Waves.Menu.Label.description
        communitiesLabel.text = Localizable.Waves.Menu.Label.communities
        whitepaperButton.setTitle(Localizable.Waves.Menu.Button.whitepaper, for: .normal)
        termAndConditionsButton.setTitle(Localizable.Waves.Menu.Button.termsandconditions, for: .normal)
        supportWavesplatformButton.setTitle(Localizable.Waves.Menu.Button.supportwavesplatform, for: .normal)
    }
}
