ActiveAdmin.register Post do
  permit_params :title, :content, :user_id

  includes :user, :likes

  index do
    selectable_column
    id_column
    column("Post") do |post|
      div class: "admin-table-primary" do
        strong post.title
        span post.slug
      end
    end
    column("Author") do |post|
      div class: "admin-table-meta" do
        strong post.user.email
        span "User ##{post.user_id}"
      end
    end
    column("Likes") { |post| span(post.likes.size, class: "admin-count-badge") }
    column("Published") do |post|
      div class: "admin-table-meta" do
        strong post.created_at.strftime("%d %b %Y")
        span post.created_at.strftime("%I:%M %p")
      end
    end
    actions
  end

  filter :title
  filter :user
  filter :created_at

  show do
    attributes_table do
      row("Title") do |post|
        div class: "admin-detail-stack" do
          strong post.title
          span post.slug
        end
      end
      row("Author") { |post| post.user.email }
      row("Likes") { |post| span(post.likes.count, class: "admin-count-badge") }
      row("Published") { |post| post.created_at.strftime("%d %b %Y, %I:%M %p") }
      row("Updated") { |post| post.updated_at.strftime("%d %b %Y, %I:%M %p") }
      row("Content") do |post|
        div class: "admin-long-copy" do
          simple_format(post.content)
        end
      end
    end
  end

  form do |f|
    f.inputs do
      f.input :user
      f.input :title
      f.input :content
    end
    f.actions
  end
end
