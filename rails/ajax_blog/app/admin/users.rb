ActiveAdmin.register User do
  permit_params :email, :password, :password_confirmation

  includes :posts

  index do
    selectable_column
    id_column
    column :email
    column("Posts") { |user| user.posts.size }
    column :created_at
    actions
  end

  filter :email
  filter :created_at

  show do
    attributes_table do
      row :id
      row :email
      row :created_at
      row :updated_at
    end

    panel "Posts" do
      table_for user.posts.order(created_at: :desc) do
        column :title
        column :created_at
        column("Actions") { |post| link_to("View post", admin_post_path(post)) }
      end
    end
  end

  form do |f|
    f.inputs do
      f.input :email
      f.input :password
      f.input :password_confirmation
    end
    f.actions
  end
end
