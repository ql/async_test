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
    rescue Faraday::SSLError
      next
    end

    render :saved_pages
  end

  def parallel_io_load
    # TODO

    render :saved_pages
  end

  def async_io_load
    # TODO

    render :saved_pages
  end
end
