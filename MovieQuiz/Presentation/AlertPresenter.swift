//
//  AlertPresenter.swift
//  MovieQuiz
//
//  Created by Владимир Богомолов on 19.03.2023.
//

import UIKit

final class AlertPresenter: AlertPresenterProtocol {
    weak var delegate: AlertPresenterDelegate?
    init(delegate: AlertPresenterDelegate?) {
        self.delegate = delegate
    }

    func showAlert(model: AlertModel) {
        let alert = UIAlertController(
            title: model.title,
            message: model.message,
            preferredStyle: .alert)
        let action = UIAlertAction(title: model.buttonText, style: .default) { _ in
            model.completion?()
        }
        alert.addAction(action)
        delegate?.present(alert, animated: true, completion: nil)
    }
}
