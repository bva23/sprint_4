import UIKit

final class MovieQuizViewController: UIViewController, AlertPresenterDelegate {
    @IBAction private func noButtonClicked(_ sender: UIButton) {
        presenter.noButtonClicked()
        noButton.isEnabled = false
        yesButton.isEnabled = false
    }
    @IBAction private func yesButtonClicked(_ sender: UIButton) {
        presenter.yesButtonClicked()
        noButton.isEnabled = false
        yesButton.isEnabled = false
    }

    @IBOutlet var noButton: UIButton!
    @IBOutlet var yesButton: UIButton!
    @IBOutlet var imageView: UIImageView!
    @IBOutlet private var textLabel: UILabel!
    @IBOutlet private var counterLabel: UILabel!
    @IBOutlet private var activityIndicator: UIActivityIndicatorView!

    private var alertPresenter: AlertPresenterProtocol?
    var statisticService: StatisticService?
    private var presenter: MovieQuizPresenter!

    func show(quiz step: QuizStepViewModel) {
        imageView.image = step.image
        textLabel.text = step.question
        counterLabel.text = step.questionNumber
    }
    func show(quiz model: AlertModel) {
        alertPresenter?.showAlert(model: model)
    }
    func showAnswerResult(isCorrect: Bool) {
        presenter.didAnswer(isCorrect: isCorrect)

        imageView.layer.masksToBounds = true
        imageView.layer.borderWidth = 8
        imageView.layer.borderColor = isCorrect ? UIColor.ypGreen.cgColor : UIColor.ypRed.cgColor

        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { [weak self] in
            guard let self = self else { return }
            self.presenter.showNextQuestionOrResults()
        }
    }
        func showLoadingIndicator() {
            activityIndicator.isHidden = false
            activityIndicator.startAnimating()
        }

        func hideLoadingIndicator() {
            activityIndicator.isHidden = true
        }

        func showNetworkError(message: String) {
            hideLoadingIndicator()

            let alertModel = AlertModel(
                title: "Ошибка",
                message: "Не удалось загрузить данные",
                buttonText: "Попробовать ещё раз") { [weak self] in
                    self?.presenter.restartGame()
            }
            self.alertPresenter?.showAlert(model: alertModel)
        }

        // MARK: - Lifecycle
        override func viewDidLoad() {
            super.viewDidLoad()
            presenter = MovieQuizPresenter(viewController: self)
        
            imageView.layer.cornerRadius = 20

            statisticService = StatisticServiceImplementation(
                userDefaults: UserDefaults(),
                decoder: JSONDecoder(),
                encoder: JSONEncoder()
            )
            alertPresenter = AlertPresenter(delegate: self)
            showLoadingIndicator()
        }
}
