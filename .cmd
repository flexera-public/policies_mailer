bootstrap: true
web: puma -C config/puma.rb -e $RACK_ENV
