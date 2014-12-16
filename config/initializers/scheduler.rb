require 'rufus-scheduler'

# Let's use the rufus-scheduler singleton
#
s = Rufus::Scheduler.singleton


s.cron '30 01 * * *' do
  system "rake sitemap:generate"
end