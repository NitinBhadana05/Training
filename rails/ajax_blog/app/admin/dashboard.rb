# frozen_string_literal: true
ActiveAdmin.register_page "Dashboard" do
  menu priority: 1, label: proc { I18n.t("active_admin.dashboard") }

  content title: proc { I18n.t("active_admin.dashboard") } do
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

    columns do
      column do
        panel "Recent Posts" do
          table_for Post.includes(:user).order(created_at: :desc).limit(6) do
            column(:title) { |post| link_to post.title, admin_post_path(post) }
            column(:author) { |post| post.user.email }
            column("Likes") { |post| post.likes.count }
            column(:created_at)
          end
        end
      end

      column do
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

    columns do
      column do
        panel "Newest Users" do
          table_for User.order(created_at: :desc).limit(5) do
            column(:email) { |user| link_to user.email, admin_user_path(user) }
            column(:created_at)
          end
        end
      end

      column do
        panel "Admin Notes" do
          ul class: "admin-note-list" do
            li "Public users can read every post."
            li "Only the post owner can edit or delete content on the public site."
            li "Admins can manage all users and posts from this panel."
            li "Guest likes are tracked per browser session."
          end
        end
      end
    end
  end # content
end
