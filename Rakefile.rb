require "rubygems"
require "bundler/setup"
require "stringex"

## -- Config -- ##

posts_dir       = "_posts"    # directory for blog files
drafts_dir       = "_drafts"    # directory for blog files
new_post_ext    = "md"  # default new post file extension when using the new_post task
new_page_ext    = "md"  # default new page file extension when using the new_page task


#############################
# Create a new Post or Page #
#############################

# usage rake new_draft
desc "Create a new draft in #{drafts_dir}"
task :new_draft, :title do |t, args|
  if args.title
    title = args.title
  else
    title = get_stdin("Enter a title for your post: ")
  end
  filename = "#{drafts_dir}/#{Time.now.strftime('%Y-%m-%d')}-#{title.to_url}.#{new_post_ext}"
  if File.exist?(filename)
    abort("rake aborted!") if ask("#{filename} already exists. Do you want to overwrite?", ['y', 'n']) == 'n'
  end
  category = get_stdin("Enter category name to group your post in (leave blank for none): ")
  tags = get_stdin("Enter tags to classify your post (comma separated): ")
  puts "Creating new draft: #{filename}"
  open(filename, 'w') do |post|
    post.puts "---"
    post.puts "layout: post"
    post.puts "title: \"#{title.gsub(/&/,'&amp;')}\""
    post.puts "modified: #{Time.now.strftime('%Y-%m-%d %H:%M:%S %z')}"
    post.puts "category: [#{category}]"
    post.puts "tags: [#{tags}]"
    post.puts "image:"
    post.puts "  feature: "
    post.puts "  credit: "
    post.puts "  creditlink: "
    post.puts "comments: True"
    post.puts "share: "
    post.puts "---"
  end
  system "vim \"#{filename}\""
end

# usage rake new_post
desc "Create a new post in #{posts_dir}"
task :new_post, :title do |t, args|
  if args.title
    title = args.title
  else
    title = get_stdin("Enter a title for your post: ")
  end
  filename = "#{posts_dir}/#{Time.now.strftime('%Y-%m-%d')}-#{title.to_url}.#{new_post_ext}"
  if File.exist?(filename)
    abort("rake aborted!") if ask("#{filename} already exists. Do you want to overwrite?", ['y', 'n']) == 'n'
  end
  category = get_stdin("Enter category name to group your post in (leave blank for none): ")
  tags = get_stdin("Enter tags to classify your post (comma separated): ")
  puts "Creating new post: #{filename}"
  open(filename, 'w') do |post|
    post.puts "---"
    post.puts "layout: post"
    post.puts "title: \"#{title.gsub(/&/,'&amp;')}\""
    post.puts "modified: #{Time.now.strftime('%Y-%m-%d %H:%M:%S %z')}"
    post.puts "category: [#{category}]"
    post.puts "tags: [#{tags}]"
    post.puts "image:"
    post.puts "  feature: "
    post.puts "  credit: "
    post.puts "  creditlink: "
    post.puts "comments: True"
    post.puts "share: "
    post.puts "---"
  end
end

# usage rake new_page
desc "Create a new page"
task :new_page, :title do |t, args|
  if args.title
    title = args.title
  else
    title = get_stdin("Enter a title for your page: ")
  end
  filename = "#{title.to_url}.#{new_page_ext}"
  if File.exist?(filename)
    abort("rake aborted!") if ask("#{filename} already exists. Do you want to overwrite?", ['y', 'n']) == 'n'
  end
  tags = get_stdin("Enter tags to classify your page (comma separated): ")
  puts "Creating new page: #{filename}"
  open(filename, 'w') do |page|
    page.puts "---"
    page.puts "layout: page"
    page.puts "permalink: /#{title.to_url}/"
    page.puts "title: \"#{title}\""
    page.puts "modified: #{Time.now.strftime('%Y-%m-%d %H:%M')}"
    page.puts "tags: [#{tags}]"
    page.puts "image:"
    page.puts "  feature: "
    page.puts "  credit: "
    page.puts "  creditlink: "
    page.puts "share: "
    page.puts "---"
  end
end

# build and watch
desc "Build and watch at localhost"
task :b do
    puts "\n## Building site"
    system "jekyll b"
    system "jekyll s --host 0.0.0.0 --watch"
end

# deploy to github
desc "Deploy to github"
task :deploy do
    puts "\n## Deploy current site to Github pages"
    puts "\n## Building site"
    system "jekyll build"
    cd "_site" do
        puts "\n## Committing: Site updated at #{Time.now.utc}"
        system "git add -A"
        message = "Site updated at #{Time.now.utc}"
        system "git commit -m \"#{message}\""
        puts "\n## Pushing generated website"
        system "git push -u origin master"
        puts "\n## Github Pages deploy complete"
    end
end

def get_stdin(message)
  print message
  STDIN.gets.chomp
end

def ask(message, valid_options)
  if valid_options
    answer = get_stdin("#{message} #{valid_options.to_s.gsub(/"/, '').gsub(/, /,'/')} ") while !valid_options.include?(answer)
  else
    answer = get_stdin(message)
  end
  answer
end
