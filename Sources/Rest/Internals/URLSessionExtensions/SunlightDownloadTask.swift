import Combine
import Foundation

extension URLSession {

  public func sunlightDownloadTaskPublisher(
    for url: URL
  ) -> SunlightDownloadTaskPublisher {
    self.sunlightDownloadTaskPublisher(for: URLRequest(url: url))
  }

  public func sunlightDownloadTaskPublisher(
    for request: URLRequest
  ) -> SunlightDownloadTaskPublisher {
    SunlightDownloadTaskPublisher(request: request, session: self)
  }

  public struct SunlightDownloadTaskPublisher: Publisher {

    public typealias Output = (
      payload: (url: URL?, progress: Progress),
      response: URLResponse?
    )
    public typealias Failure = URLError

    public let request: URLRequest
    public let session: URLSession

    public init(request: URLRequest, session: URLSession) {
      self.request = request
      self.session = session
    }

    public func receive<S>(
      subscriber: S
    ) where S: Subscriber,
            SunlightDownloadTaskPublisher.Failure == S.Failure,
            SunlightDownloadTaskPublisher.Output == S.Input
    {
      let subscription = SunlightDownloadTaskSubscription(
        subscriber: subscriber,
        session: self.session,
        request: self.request
      )
      subscriber.receive(subscription: subscription)
    }
  }
}

extension URLSession {

  final class SunlightDownloadTaskSubscription<
    SubscriberType: Subscriber
  >: Subscription where
    SubscriberType.Input == (
      payload: (url: URL?, progress: Progress),
      response: URLResponse?
    ),
    SubscriberType.Failure == URLError
  {
    private var subscriber: SubscriberType?
    private var session: URLSession
    private var request: URLRequest
    private var task: URLSessionDownloadTask?

    private var progress: NSKeyValueObservation?

    init(subscriber: SubscriberType, session: URLSession, request: URLRequest) {
      self.subscriber = subscriber
      self.session = session
      self.request = request
    }

    func request(_ demand: Subscribers.Demand) {
      guard demand > 0 else {
        return
      }

      self.task = self.session.downloadTask(
        with: request
      ) { [weak self] url, response, error in
        if let error = error as? URLError {
          self?.subscriber?.receive(completion: .failure(error))
          return
        }

        guard let response = response else {
          self?.subscriber?.receive(
            completion: .failure(URLError(.badServerResponse))
          )
          return
        }

        guard let url = url else {
          self?.subscriber?.receive(completion: .failure(URLError(.badURL)))
          return
        }

        do {
          let cacheDir = FileManager.default.urls(
            for: .cachesDirectory,
            in: .userDomainMask
          ).first!
          let fileUrl = cacheDir.appendingPathComponent((UUID().uuidString))
          try FileManager.default.moveItem(
            atPath: url.path, toPath: fileUrl.path
          )
          _ = self?.subscriber?.receive((
            payload: (url: fileUrl, progress: Progress()),
            response: response
          ))
          self?.subscriber?.receive(completion: .finished)
        } catch {
          self?.subscriber?.receive(
            completion: .failure(URLError(.cannotCreateFile))
          )
        }
      }

      if let task = self.task {
        self.progress = task.progress.observe(
          \.fractionCompleted
        ) { progress, _ in
          _ = self.subscriber?.receive((
            payload: (url: nil, progress: progress),
            response: nil
          ))
        }

        task.resume()
      }
    }

    func cancel() {
      if let task = self.task {
        task.cancel()
      }

      if let progress = self.progress {
        progress.invalidate()
      }
    }
  }
}

final class SunlightDownloadTaskSubscriber: Subscriber {
  typealias Input = (
    payload: (url: URL?, progress: Progress),
    response: URLResponse?
  )
  typealias Failure = URLError

  var subscription: Subscription?

  func receive(subscription: Subscription) {
    self.subscription = subscription
    self.subscription?.request(.unlimited)
  }

  func receive(_ input: Input) -> Subscribers.Demand {
    return .unlimited
  }

  func receive(completion: Subscribers.Completion<Failure>) {
    self.subscription?.cancel()
    self.subscription = nil
  }
}
