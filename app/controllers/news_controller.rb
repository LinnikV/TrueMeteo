class NewsController < InheritedResources::Base
  #require_relative '../../lib/assets/news/parser'

  def index
    @news = News.all.where(publish: true).order(date: :desc)
  end

  def show
    @news = News.where(publish: true).find( params[:id])
  end

  private

    def news_params
      params.require(:news).permit(:title, :body, :date, :source, :header, :image, :publish, :admin_id)
    end

end
