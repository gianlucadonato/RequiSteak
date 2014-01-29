#from http://ruby.railstutorial.org/chapters/following-users#sec-sample_following_data
namespace :db do
  desc "Fill database with sample data"
  task populate: :environment do
    make_sources
  end
end

def make_sources
  Source.create!( title: "Capitolato")
  Source.create!( title: "Interno")
  Source.create!( title: "Verbale-2013-12-05")
	Source.create!( title: "Verbale-2013-12-18")
end