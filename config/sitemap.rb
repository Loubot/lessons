# Set the host name for URL creation
SitemapGenerator::Sitemap.default_host = "https://learn-your-lesson.herokuapp.com"

SitemapGenerator::Sitemap.public_path = 'tmp/'
# store on S3 using Fog
SitemapGenerator::Sitemap.adapter = SitemapGenerator::S3Adapter.new
# inform the map cross-linking where to find the other maps
SitemapGenerator::Sitemap.sitemaps_host = "http://#{ENV['FOG_DIRECTORY']}.s3.amazonaws.com/"
# pick a namespace within your bucket to organize your maps
SitemapGenerator::Sitemap.sitemaps_path = 'sitemaps/'

SitemapGenerator::Sitemap.create do
  # Put links creation logic here.
  #
  # The root path '/' and sitemap index file are added automatically for you.
  # Links are added to the Sitemap in the order they are specified.
  #
  # Usage: add(path, options={})
  #        (default options are used if you don't specify)
  #
  # Defaults: :priority => 0.5, :changefreq => 'weekly',
  #           :lastmod => Time.now, :host => default_host
  #
  # Examples:
  #
  # Add '/articles'
  #
  #   add articles_path, :priority => 0.7, :changefreq => 'daily'
  #
  # Add all articles:

  add how_it_works_path, :priority => 1, :changefreq => 'weekly'
  add browse_categories_path, :priority => 1, changefreq: 'weekly'
  add mailing_list_path, priority: 1, changefreq: 'weekly'

  Teacher.check_if_valid.each do |t|
    t.subjects.each do |s|
      add show_teacher_path(id:t.id, subject_id: s.id), :priority => 0.9, :changefreq => 'daily'
    end
  end
  #
  #   Article.find_each do |article|
  #     add article_path(article), :lastmod => article.updated_at
  #   end
end