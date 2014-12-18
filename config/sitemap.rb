# Change this to your host. See the readme at https://github.com/lassebunk/dynamic_sitemaps
# for examples of multiple hosts and folders.
host "learn-your-lesson.herokuapp.com"

sitemap :site do
  url root_url, last_mod: Time.now, change_freq: "daily", priority: 1.0
  # url teacher_url(:id) lastmod: Time.now, change_freq: 'daily', priority: 1.0
end

# You can have multiple sitemaps like the above – just make sure their names are different.

# Automatically link to all pages using the routes specified
# using "resources :pages" in config/routes.rb. This will also
# automatically set <lastmod> to the date and time in page.updated_at:
#
  sitemap_for Teacher.check_if_valid

# For products with special sitemap name and priority, and link to comments:
#
  # sitemap_for Teacher.check_if_valid, name: :active_teachers do |teacher|
  #   url teacher, last_mod: teacher.updated_at, priority: 1.0
  #   url show_teacher_path(teacher)
  # end

# If you want to generate multiple sitemaps in different folders (for example if you have
# more than one domain, you can specify a folder before the sitemap definitions:
# 
#   Site.all.each do |site|
#     folder "sitemaps/#{site.domain}"
#     host site.domain
#     
#     sitemap :site do
#       url root_url
#     end
# 
#     sitemap_for site.products.scoped
#   end

# Ping search engines after sitemap generation:
#
  ping_with "http://#{host}/sitemap.xml"