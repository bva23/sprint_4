import UIKit

final class MovieQuizViewController: UIViewController, QuestionFactoryDelegate, AlertPresenterDelegate {
    func didReceiveNextQuestion(question: QuizQuestion?) {
        presenter.didRecieveNextQuestion(question: question)
    }

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
    private let presenter = MovieQuizPresenter()
    var questionFactory: QuestionFactoryProtocol?
    var correctAnswers: Int = 0

    func show(quiz step: QuizStepViewModel) {
        imageView.image = step.image
        textLabel.text = step.question
        counterLabel.text = step.questionNumber
    }
    func show(quiz model: AlertModel) {
        alertPresenter?.showAlert(model: model)
    }
    func showAnswerResult(isCorrect: Bool) {
        if isCorrect {
            correctAnswers += 1
        }
        imageView.layer.masksToBounds = true
        imageView.layer.borderWidth = 8
        imageView.layer.borderColor = isCorrect ? UIColor.ypGreen.cgColor : UIColor.ypRed.cgColor

        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { [weak self] in
            guard let self = self else { return }
            self.presenter.correctAnswers = self.correctAnswers
            self.presenter.questionFactory = self.questionFactory
            self.presenter.showNextQuestionOrResults()
        }
    }
        private func showLoadingIndicator() {
            activityIndicator.isHidden = false
            activityIndicator.startAnimating()
        }

        private func hideLoadingIndicator() {
            activityIndicator.isHidden = true
        }

        private func showNetworkError(message: String) {
            hideLoadingIndicator()

            let alertModel = AlertModel(
                title: "Ошибка",
                message: "Не удалось загрузить данные",
                buttonText: "Попробовать ещё раз") { [weak self] in
                    self?.presenter.resetQuestionIndex()
                    self?.correctAnswers = 0
                    self?.questionFactory?.requestNextQuestion()
            }
            self.alertPresenter?.showAlert(model: alertModel)
        }

        func didLoadDataFromServer() {
            activityIndicator.isHidden = true
            questionFactory?.requestNextQuestion()
        }

        func didFailToLoadData(with error: Error) {
            showNetworkError(message: error.localizedDescription)
        }

        // MARK: - Lifecycle
        override func viewDidLoad() {
            super.viewDidLoad()
            presenter.viewController = self

            imageView.layer.cornerRadius = 20

            statisticService = StatisticServiceImplementation(
                userDefaults: UserDefaults(),
                decoder: JSONDecoder(),
                encoder: JSONEncoder()
            )
            alertPresenter = AlertPresenter(delegate: self)
            questionFactory = QuestionFactory(moviesLoader: MoviesLoader(networkClient: NetworkClient()), delegate: self)
            showLoadingIndicator()
            questionFactory?.loadData()
        }
}
