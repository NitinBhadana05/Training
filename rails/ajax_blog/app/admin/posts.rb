ActiveAdmin.register Post do
  permit_params :title, :content, :user_id

  includes :user, :likes

  index do
    selectable_column
    id_column
    column :title
    column :user
    column("Likes") { |post| post.likes.size }
    column :created_at
    actions
  end

  filter :title
  filter :user
  filter :created_at

  form do |f|
    f.inputs do
      f.input :user
      f.input :title
      f.input :content
    end
    f.actions
  end
end
