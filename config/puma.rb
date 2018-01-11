# encoding: utf-8
# !/usr/bin/env puma

require 'rubygems'
require 'bundler/setup'
require 'praxis'
require 'pry'

bind 'tcp://0.0.0.0:8080'


mworker = 1
mthread = 1
timeout = 600

# Code to run immediately before the master starts workers.
# Irrevocably drop privileges to non-root user via setresuid system call.
if @config.environment == 'production'
  before_fork do
    pwent = Etc.getpwnam('www-data')
    Process::Sys.setresgid(pwent.gid, pwent.gid, pwent.gid)
    Process::Sys.setresuid(pwent.uid, pwent.uid, pwent.uid)
    true
  end
end

threads mthread, mthread
workers mworker
worker_timeout timeout
