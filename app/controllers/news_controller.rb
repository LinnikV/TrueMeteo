class NewsController < InheritedResources::Base
  #require_relative '../../lib/assets/news/parser'

  def index
    @pagy, @news = pagy(News.all.where(publish: true).order(date: :desc))
  end

  def show
    @news = News.friendly.where(publish: true).find( params[:id])
  end

  private

    def news_params
      params.require(:news).permit(:title, :body, :date, :source, :header, :image, :publish, :admin_id)
    end

end
