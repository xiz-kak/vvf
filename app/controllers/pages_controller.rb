class PagesController < ApplicationController
  def faq
  end

  def news
  end

  # GET /pages/news_body/1
  def news_body
    n = News.find(params[:id])

    data = {
             'title': n.title(locale),
             'begin_at': l(n.begin_at, format: :date),
             'body': n.body(locale)
           }
    # render text: n.body(locale)
    render json: data
  end
end
