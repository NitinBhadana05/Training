# frozen_string_literal: true
ActiveAdmin.register_page "Dashboard" do
  menu priority: 1, label: proc { I18n.t("active_admin.dashboard") }

  content title: proc { I18n.t("active_admin.dashboard") } do
    div class: "admin-dashboard-shell" do
      div class: "admin-dashboard-main" do
        div class: "admin-dashboard-hero" do
          div class: "admin-dashboard-copy" do
            span "Control center"
            h2 "Manage authors, posts, and reactions from one polished admin workspace."
            para "Track publishing activity, moderate content, and review guest engagement without leaving the dashboard."
          end

          div class: "admin-dashboard-pillbox" do
            div class: "admin-stat-card" do
              h3 "Users"
              strong User.count
              span "registered authors"
            end

            div class: "admin-stat-card" do
              h3 "Posts"
              strong Post.count
              span "published articles"
            end

            div class: "admin-stat-card" do
              h3 "Likes"
              strong Like.count
              span "total reactions"
            end
          end
        end

        panel "Recent Posts" do
          table_for Post.includes(:user).order(created_at: :desc).limit(6) do
            column("Post") do |post|
              div class: "admin-table-primary" do
                strong post.title
                span(post.slug.presence || "Post ##{post.id}")
              end
            end
            column("Author") do |post|
              div class: "admin-table-meta" do
                strong post.user.email
                span "User ##{post.user_id}"
              end
            end
            column("Likes") { |post| span(post.likes.count, class: "admin-count-badge") }
            column("Published") do |post|
              div class: "admin-table-meta" do
                strong post.created_at.strftime("%d %b %Y")
                span post.created_at.strftime("%I:%M %p")
              end
            end
          end
        end

        panel "Newest Users" do
          table_for User.order(created_at: :desc).limit(5) do
            column("User") do |user|
              div class: "admin-table-primary" do
                strong user.email
                span "User ##{user.id}"
              end
            end
            column("Posts") { |user| span(user.posts.count, class: "admin-count-badge") }
            column("Joined") do |user|
              div class: "admin-table-meta" do
                strong user.created_at.strftime("%d %b %Y")
                span user.created_at.strftime("%I:%M %p")
              end
            end
          end
        end
      end

      div class: "admin-dashboard-side" do
        panel "Guest Activity" do
          div class: "admin-metric-stack" do
            div class: "admin-inline-metric" do
              strong Like.where.not(guest_token: nil).count
              span "guest likes"
            end

            div class: "admin-inline-metric" do
              strong Post.joins(:likes).distinct.count
              span "posts with reactions"
            end
          end

          para "Visitors can like public posts without signing in. Admins can monitor guest engagement here."
        end
      end
    end
  end # content
end
