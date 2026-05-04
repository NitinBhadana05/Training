ActiveAdmin.register User do
  permit_params :email, :password, :password_confirmation

  includes :posts

  index do
    selectable_column
    id_column
    column("User") do |user|
      div class: "admin-table-primary" do
        strong user.email
        span "User ##{user.id}"
      end
    end
    column("Posts") do |user|
      span user.posts.size, class: "admin-count-badge"
    end
    column("Joined") do |user|
      div class: "admin-table-meta" do
        strong user.created_at.strftime("%d %b %Y")
        span user.created_at.strftime("%I:%M %p")
      end
    end
    actions
  end

  filter :email
  filter :created_at

  show do
    attributes_table do
      row("User") do |user|
        div class: "admin-detail-stack" do
          strong user.email
          span "Account ##{user.id}"
        end
      end
      row("Created") { |user| user.created_at.strftime("%d %b %Y, %I:%M %p") }
      row("Updated") { |user| user.updated_at.strftime("%d %b %Y, %I:%M %p") }
      row("Posts") { |user| span(user.posts.count, class: "admin-count-badge") }
    end

    panel "Posts" do
      table_for user.posts.order(created_at: :desc) do
        column("Post") do |post|
          div class: "admin-table-primary" do
            strong post.title
            span post.slug
          end
        end
        column("Likes") { |post| span(post.likes.count, class: "admin-count-badge") }
        column("Published") do |post|
          div class: "admin-table-meta" do
            strong post.created_at.strftime("%d %b %Y")
            span post.created_at.strftime("%I:%M %p")
          end
        end
        column("Actions") { |post| link_to("View post", admin_post_path(post), class: "admin-table-link") }
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
