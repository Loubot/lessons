require 'rufus-scheduler'

# Let's use the rufus-scheduler singleton
#
s = Rufus::Scheduler.singleton


s.cron '* * 17 * *' do
	puts "rake sitemap:generate"
  system "rake sitemap:refresh"
end