module OpenNotification
  class Populate < Thor
    desc "generate_some_data", "generate some data"
    def generate_some_data
      require 'merb-core'
      ::Merb.start_environment(
        :environment => ENV['MERB_ENV'] || 'development')
      #require 'rangexp'

      (10..1000).of {
        puts 'create user'
        user = User.new({:login => /\w+/.gen,
           :email => "#{/\w+/.gen}.#{/\w+/.gen}@gmail.com",
           :password => 'notification',
           :password_confirmation => 'notification'})
        user.save
        (100..1000).of {
          Jabber.new({:to => "#{/\w+/.gen}.#{/\w+/.gen}@gmail.com",
                     :text => /[:paragraph:]/.generate,
                    :from => user.id}).save
          print '.'
          STDOUT.flush
        }
        print "\n"
        STDOUT.flush
      }
    end
  end
end
