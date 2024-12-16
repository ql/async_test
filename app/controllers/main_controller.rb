require 'async'
class MainController < ApplicationController
  URLS = %w[
    https://kemkes.go.id/eng/home
    https://moh.gov.la/
    https://en.med.gov.mn/
    https://www.gov.bw/ministries/ministry-nationality-immigration-and-gender-affairs
    https://www.employment.govt.nz/
    https://www.health.govt.nz/
    https://www.transport.govt.nz/
    https://www.mpwt.gov.la/en/
    https://moh.gov.vn/web/ministry-of-health
    https://www.mod.gov.vn/en/mond
    https://www.education.govt.nz/
  ]

  def ordinary_load
    @page = Page.last!
    1000000.times { 1 + 1 }
    render :ordinary_load
  end

  def sequential_io_load
    @saved_pages = []
    URLS.each do |url|
      start = Time.now
      response = Faraday.new.get(url)

      @saved_pages << SavedPage.create(url: url, saved_body: response.body, elapsed_time: Time.now - start)
    rescue Faraday::SSLError, Faraday::ConnectionFailed
      next
    end

    render :saved_pages
  end

  def parallel_io_load
    @saved_pages = []
    Parallel.each(URLS, in_threads: 10) do |url|
      start = Time.now
      response = Faraday.new.get(url)
      Rails.logger.silence do
        @saved_pages << SavedPage.create(url: url, saved_body: response.body, elapsed_time: Time.now - start)
      end
    rescue Faraday::SSLError, Faraday::ConnectionFailed
      next
    end

    render :saved_pages
  end

  def async_io_load
    @saved_pages = []
    tasks = []
    Async do
      tasks = URLS.map do |url|
        Async do
          start = Time.now
          response = Faraday.new.get(url)
          next unless response

          @saved_pages << SavedPage.create(url: url, saved_body: response.body, elapsed_time: Time.now - start)
        rescue Faraday::SSLError, Faraday::ConnectionFailed
          next
        end
      end
    end

    tasks.each(&:wait)

    render :saved_pages
  end

  # for test purposes only:

  def async_io_load_db_outside
    @saved_pages = []
    tasks = []
    Async do
      tasks = URLS.map do |url|
        Async do
          start = Time.now
          response = Faraday.new.get(url)
          [start, url, response]
        rescue Faraday::SSLError, Faraday::ConnectionFailed
          next
        end
      end

    end

    tasks.each do |task|
      Rails.logger.silence do
        start, url, response = task.wait
        if response.nil?
          Rails.logger.info "skipping empty response for url #{url}"
          next
        end

        @saved_pages << SavedPage.create(url: url, saved_body: response.body, elapsed_time: Time.now - start)
      end
    end

    render :saved_pages
  end
end
