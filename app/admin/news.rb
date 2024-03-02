ActiveAdmin.register News do
  require_relative '../../lib/assets/news/news_manager'

  permit_params :email, :password, :password_confirmation

  controller do
    def update_news_list
      name = NewsManager.new.call(params[:admin_id])
      flash[:notice] = name
      redirect_to admin_news_index_path
    end

    def find_resource
      scoped_collection.friendly.find(params[:id])
    end
  end

  action_item :create do
    link_to("Update News List", admin_update_news_list_path(admin_id: current_admin), class: :button)
  end

  batch_action :edit do |ids|
  end

  index do
    selectable_column
    id_column
    column :title
    column :date
    column :source
    column :header
    column :image
    column :publish
    column :admin
    actions
  end

  permit_params do
    params = [:title, :body, :date, :source, :header, :image, :publish, :admin_id]
    params.push :title, :body, :date, :source, :header, :image, :publish, :admin_id
    params
  end

  form do |f|
    f.inputs do
      f.input :title
      f.input :body
      f.input :date
      f.input :source
      f.input :header
      f.input :image
      f.input :publish
      f.input :admin_id

    end
    f.actions
  end

end


