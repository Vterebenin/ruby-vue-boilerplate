class ApplicationController < ActionController::Base
  before_action :print_params

  private
    def print_params
      puts "-----------------------------------"
      puts params
      puts "-----------------------------------"
    end
end
