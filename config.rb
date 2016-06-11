activate :dotenv
# This is the website version registered in Mixpanel
# It should match the minor version (e.g. 2.1) of the website
set :website_version, 2.3

Dir['lib/*.rb'].each { |file| require file }

###
# Compass
###

activate :directory_indexes
activate :meta_tags

set :url_root, 'https://craftacademy.se'
activate :search_engine_sitemap

# disable layout
page '.htaccess.apache', layout: false

# rename file after build
after_build do
  File.rename 'build/.htaccess.apache', 'build/.htaccess'
end

# Change Compass configuration
# compass_config do |config|
#   config.output_style = :compact
# end

###
# Page options, layouts, aliases and proxies
###

# Per-page layout changes:
#
# With no layout
# page "/path/to/file.html", layout: false
#
# With alternative layout
# page "/path/to/file.html", layout: :otherlayout
#
# A path which all have the same layout
# with_layout :admin do
#   page "/admin/*"
# end

###
# Helpers
###

# Automatic image dimensions on image_tag helper
# activate :automatic_image_sizes

# Methods defined in the helpers block are available in templates
helpers CurrentPageHelper,
        PartnerLogosHelper,
        MarkdownHelper,
        PossessiveHelper,
        SlugHelper,
        ImageHelper,
        GraduatesHelper,
        RawHelper,
        StatsHelper

# Proxy pages (https://middlemanapp.com/advanced/dynamic_pages/)
data.graduates.each do |grad|
  if grad[:case_study]
    url_slug = graduate_slug(grad)
    proxy "/case-studies/#{url_slug}.html", '/case-studies/template.html', locals: { grad: grad }, ignore: true
  end
end

set :css_dir, 'sass'
set :js_dir, 'javascripts'
set :partials_dir, 'partials'
set :images_dir, 'images'

sprockets.append_path File.join root, 'bower_components'

set :apply_form_url, 'https://makerssweden.typeform.com/to/UlIfGg'
set :apply_sa_form_url, '//apply.thecraftacademy.co.za'
set :hire_form_url, 'https://makerssweden.typeform.com/to/SQcaqh'
set :class_site_url, 'http://class.craftacademy.se'

# Ignore folders with unused templates
ignore 'elements/*'
ignore 'not_in_use/*'
ignore 'case-studies/*' #as long as we don't present students

# Redirects from old site urls
redirect 'payments/new.html', to: "#{config.apply_form_url}"
redirect 'apply.html', to: config.apply_form_url
redirect 'apply-for-ronin.html', to: "#{config.apply_form_url}"
redirect 'blog.html', to: 'https://blog.craftacademy.se'


activate :deploy do |deploy|
  deploy.method          = :rsync
  deploy.host            = 'makersacademy.se'
  deploy.path            = '/var/www/html/newmakers'
  deploy.user            = 'soundblab'
  deploy.build_before    = true
  deploy.clean           = true
end

configure :development do
  activate :livereload

  # custom setting for switching off analytics in development
  set :run_analytics, false

  # turn on to view a baseline grid for setting vertical rhythm
  set :show_baseline_grid, false
end

# Build-specific configuration
configure :build do
  # activate :imageoptim do |options|
  #   options.pngout    = false
  #   options.svgo      = false
  # end

  # For example, change the Compass output style for deployment
  activate :minify_css

  # Minify Javascript on build
  activate :minify_javascript

  # Enable cache buster
  activate :asset_hash

  # Use relative URLs
  # activate :relative_assets

  # Or use a different image path
  # set :http_prefix, "/Content/images/"

  set :run_analytics, true

  set :show_baseline_grid, false

  # Filewatcher ignore list
  set :file_watcher_ignore, [
    /^bin(\/|$)/,
    /^\.bundle(\/|$)/,
    # /^vendor(\/|$)/,
    /^node_modules(\/|$)/,
    /^\.sass-cache(\/|$)/,
    /^\.cache(\/|$)/,
    /^\.git(\/|$)/,
    /^\.gitignore$/,
    /\.DS_Store/,
    /^\.rbenv-.*$/,
    /^Gemfile$/,
    /^Gemfile\.lock$/,
    /~$/,
    /(^|\/)\.?#/,
    /^tmp\//
  ]
end