# Be sure to restart your server when you modify this file.

# Version of your assets, change this if you want to expire all your assets.
Rails.application.config.assets.version = '1.0'

# Add additional assets to the asset load path
# Rails.application.config.assets.paths << Emoji.images_path

# Precompile additional assets.
# application.js, application.css, and all non-JS/CSS in app/assets folder are already added.
# Rails.application.config.assets.precompile += %w( search.js )
# Rails.application.config.assets.precompile += %w( base_scripts.js )
Rails.application.config.assets.precompile += %w( jquery-2.2.0.min.js )
Rails.application.config.assets.precompile += %w( annotator-1.2-full.min.js )
# Rails.application.config.assets.precompile += %w( annotator.min.js )
Rails.application.config.assets.precompile += %w( annotator-deploy.js )
Rails.application.config.assets.precompile += %w( annotator.css )
Rails.application.config.assets.precompile += %w( annotator.min.css )
Rails.application.config.assets.precompile += %w( base_styles.css )
