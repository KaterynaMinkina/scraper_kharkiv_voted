require_relative 'get_page'
require_relative 'scrape_all_votes'
require_relative 'get_mps'


class GetPages
  def initialize
    url = "https://www.lvivrada.gov.ua/zasidannia/rezultaty-golosuvan"
    page = GetPage.page(url)
    pagination = page.css('.k2Pagination').text.split(' ').last
    @all_page = get_all_page(pagination)
    $all_mp = GetMp.new
  end
  def get_all_page(size)
    hash = []
    end_page = size.to_i - 1
    (0..end_page).each do |p|
      start = p * 10
      uri = "https://www.lvivrada.gov.ua/zasidannia/rezultaty-golosuvan?start=#{start}"
      result_votes_html= GetPage.page(uri)
      result_votes_html.css('#itemListLeading a').each do |a|
        text_date= a.text.split(' ').last

        if text_date.include?('-')
          date = Date.parse(text_date.split('-').last, '%d.%m.%Y')
        else
          date = Date.parse(text_date, '%d.%m.%Y')
        end
       hash << { date: date,
                url: "https://www.lvivrada.gov.ua#{a[:href]}"
        }
      end
    end
    return hash
  end
  def get_all_votes
    p @all_page
  end
  def get_votes(date)
    page_votes_day = @all_page.find{date}
    GetAllVotes.votes(page_votes_day[:url], page_votes_day[:date])
  end
end
