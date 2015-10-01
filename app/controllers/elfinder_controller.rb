require 'el_finder/action'

class ElfinderController < ApplicationController
  skip_before_filter :verify_authenticity_token, :only => ['elfinder']

  def index
     render :layout => false
  end

  def elfinder
    rootpath = File.join(Rails.public_path, '/uploads/images')
    rooturl = '/uploads/images'

    h, r = ElFinder::Connector.new(
      :root => rootpath,
      :url => rooturl,
      :perms => {
         /^(Welcome|README)$/ => {:read => true, :write => false, :rm => false},
         '.' => {:read => true, :write => true, :rm => true}, # '.' is the proper way to specify the home/root directory.
         #/^test$/ => {:read => true, :write => true, :rm => false},
         #'logo.png' => {:read => true},
         #/\.png$/ => {:read => false} # This will cause 'logo.png' to be unreadable.
                                      # Permissions err on the safe side. Once false, always false.
      },
      :extractors => {
         'application/zip' => ['unzip', '-qq', '-o'], # Each argument will be shellescaped (also true for archivers)
         'application/x-gzip' => ['tar', '-xzf'],
      },
      :archivers => {
         'application/zip' => ['.zip', 'zip', '-qr9'], # Note first argument is archive extension
         'application/x-gzip' => ['.tgz', 'tar', '-czf'],
      },
      :thumbs => true
    ).run(params)

    headers.merge!(h)

    if r.empty?
      (render :nothing => true) and return
    end

    render :json => r, :layout => false
  end
end