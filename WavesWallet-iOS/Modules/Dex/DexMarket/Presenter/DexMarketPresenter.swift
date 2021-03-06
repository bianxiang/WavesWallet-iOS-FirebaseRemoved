//
//  DexMarketPresenter.swift
//  WavesWallet-iOS
//
//  Created by Pavel Gubin on 8/9/18.
//  Copyright © 2018 Waves Platform. All rights reserved.
//

import Foundation
import RxSwift
import RxFeedback
import RxCocoa
import DomainLayer

final class DexMarketPresenter: DexMarketPresenterProtocol {
 
    var interactor: DexMarketInteractorProtocol!
    weak var moduleOutput: DexMarketModuleOutput?

    private let disposeBag = DisposeBag()

    func system(feedbacks: [DexMarketPresenterProtocol.Feedback]) {
        var newFeedbacks = feedbacks
        newFeedbacks.append(modelsQuery())
        newFeedbacks.append(searchModelsQuery())

        Driver.system(initialState: DexMarket.State.initialState,
                      reduce: { [weak self] state, event -> DexMarket.State in
                        guard let self = self else { return state }
                        return self.reduce(state: state, event: event) },
                      feedback: newFeedbacks)
            .drive()
            .disposed(by: disposeBag)
    }
    
    private func modelsQuery() -> Feedback {
        return react(request: { state -> Bool? in
            return true
        }, effects: { [weak self] _ -> Signal<DexMarket.Event> in
            
            guard let self = self else { return Signal.empty() }
            return self.interactor.pairs().map { .setPairs($0) }.asSignal(onErrorSignalWith: Signal.empty())
        })
    }
    
    private func searchModelsQuery() -> Feedback {
        return react(request: { state -> Bool? in
            return true
        }, effects: { [weak self] _ -> Signal<DexMarket.Event> in
            
            guard let self = self else { return Signal.empty() }
            return self.interactor.searchPairs().map { .setPairs($0) }.asSignal(onErrorSignalWith: Signal.empty())
        })
    }
    
    private func reduce(state: DexMarket.State, event: DexMarket.Event) -> DexMarket.State {
        
        switch event {
        case .readyView:
            return state.changeAction(.none)
            
        case .setPairs(let pairs):
            
            return state.mutate { state in
                
                let items = pairs.map { DexMarket.ViewModel.Row.pair($0) }
                let section = DexMarket.ViewModel.Section(items: items)
                state.section = section
                
            }.changeAction(.update)
        
        case .tapCheckMark(let index):
            
            if let pair = state.section.items[index].pair {
                interactor.checkMark(pair: pair)
            }
            
            return state.mutate { state in
                if let pair = state.section.items[index].pair {
                    state.section.items[index] = DexMarket.ViewModel.Row.pair(pair.mutate {$0.isChecked = !$0.isChecked})
                }
            }.changeAction(.update)
            
        case .tapInfoButton(let index):
            
            if let pair = state.section.items[index].pair {
                
                let infoPair = DexInfoPair.DTO.Pair(amountAsset: pair.amountAsset, priceAsset: pair.priceAsset, isGeneral: pair.isGeneral)
                moduleOutput?.showInfo(pair: infoPair)
            }
            return state.changeAction(.none)
            
        case .searchTextChange(let text):
            
            interactor.searchPair(searchText: text)
            return state.changeAction(.none)
        }
    }
}

fileprivate extension DexMarket.ViewModel.Row {
    
    var pair: DomainLayer.DTO.Dex.SmartPair? {
        switch self {
        case .pair(let pair):
            return pair
        }
    }
}

fileprivate extension DexMarket.State {
    static var initialState: DexMarket.State {
        let section = DexMarket.ViewModel.Section(items: [])
        return DexMarket.State(action: .none, section: section)
    }
    
    func changeAction(_ action: DexMarket.State.Action) -> DexMarket.State {
        
        return mutate { state in
            state.action = action
        }
    }
}
