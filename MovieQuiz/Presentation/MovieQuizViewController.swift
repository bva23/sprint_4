import UIKit

final class MovieQuizViewController: UIViewController, MovieQuizViewControllerProtocol, AlertPresenterDelegate {
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

    @IBOutlet private var noButton: UIButton!
    @IBOutlet private var yesButton: UIButton!
    @IBOutlet private var imageView: UIImageView!
    @IBOutlet private var textLabel: UILabel!
    @IBOutlet private var counterLabel: UILabel!
    @IBOutlet private var activityIndicator: UIActivityIndicatorView!

    private var presenter: MovieQuizPresenter!
    private var alertPresenter: AlertPresenterProtocol?

    func show(quiz step: QuizStepViewModel) {
        imageView.image = step.image
        textLabel.text = step.question
        counterLabel.text = step.questionNumber
    }
    func show(quiz model: AlertModel) {
        alertPresenter?.showAlert(model: model)
    }

    func highlightImageBorder(isCorrect: Bool) {
        imageView.layer.masksToBounds = true
        imageView.layer.borderWidth = 8
        imageView.layer.borderColor = isCorrect ? UIColor.ypGreen.cgColor : UIColor.ypRed.cgColor
    }

    func hideImageBorder() {
        imageView.layer.borderWidth = 0
        noButton.isEnabled = true
        yesButton.isEnabled = true
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

        alertPresenter = AlertPresenter(delegate: self)
        showLoadingIndicator()
    }
}
