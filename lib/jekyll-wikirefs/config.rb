# frozen_string_literal: true
require "jekyll"

module Jekyll
  module WikiRefs

    class PluginConfig

      ATTR_KEY = "attributes"
      CONFIG_KEY = "wikirefs"
      ENABLED_KEY = "enabled"
      EXCLUDE_KEY = "exclude"
      # css-related
      CSS_KEY = "css"
      NAME_KEY = "name"
      # text styling
      CASE_KEY = "case"
      # names
      ## valid
      TYPED_KEY = "typed"
      WEB_KEY = "web"
      WIKI_KEY = "wiki"
      ## invalid
      INV_WIKI_KEY = "invalid_wiki"
      # INV_WEB_KEY = "invalid_web"
      ## embed
      EMBED_WRAPPER_KEY = "embed_wrapper"
      EMBED_TITLE_KEY = "embed_title"
      EMBED_CONTENT_KEY = "embed_content"
      EMBED_LINK_KEY = "embed_wiki_link"
      EMBED_IMG_WRAPPER_KEY = "embed_image_wrapper"
      EMBED_IMG_KEY = "embed_image"

      def initialize(config)
        @config ||= config
        self.old_config_warn()
        Jekyll.logger.debug("Jekyll-WikiRefs: Excluded jekyll types: #{option(EXCLUDE_KEY)}") unless disabled?
      end

      # util

      def css_name(name_key)
        return option_css_name(name_key) if option_css_name(name_key)
        return "typed"                   if name_key == TYPED_KEY
        # valid
        return "wiki-link"               if name_key == WIKI_KEY
        # invalid
        return "invalid-wiki-link"       if name_key == INV_WIKI_KEY
        # return "invalid-web-link" if name_key == INV_WEB_KEY
        # embeds
        return "embed-wrapper"           if name_key == EMBED_WRAPPER_KEY
        return "embed-title"             if name_key == EMBED_TITLE_KEY
        return "embed-content"           if name_key == EMBED_CONTENT_KEY
        return "embed-wiki-link"         if name_key == EMBED_LINK_KEY
        # img
        return "embed-image-wrapper"     if name_key == EMBED_IMG_WRAPPER_KEY
        return "embed-image"             if name_key == EMBED_IMG_KEY
      end

      def disabled?
        option(ENABLED_KEY) == false
      end

      def disabled_attributes?
        option_attributes(ENABLED_KEY) == false
      end

      def text_case_style
        style = option(CASE_KEY)
        valid_styles = [
          "UPPER CASE", "Train-Case", "Macro_Case",
          "lower case", "kebab-case", "snake_case",
          "camelCase", "PascalCase", "none",
        ]
        return style if valid_styles.include?(style)
        return "lowercase" # default
      end

      def exclude?(type)
        return false unless option(EXCLUDE_KEY)
        return option(EXCLUDE_KEY).include?(type.to_s)
      end

      def excluded_css_names
        return self.option_css(EXCLUDE_KEY)
      end

      # options

      def option(key)
        @config[CONFIG_KEY] && @config[CONFIG_KEY][key]
      end

      def option_attributes(key)
        @config[CONFIG_KEY] && @config[CONFIG_KEY][ATTR_KEY] && @config[CONFIG_KEY][ATTR_KEY][key]
      end

      def option_css(key)
        @config[CONFIG_KEY] && @config[CONFIG_KEY][CSS_KEY] && @config[CONFIG_KEY][CSS_KEY][key]
      end

      def option_css_name(key)
        option_css(NAME_KEY) && @config[CONFIG_KEY][CSS_KEY][NAME_KEY][key]
      end

      # !! deprecated !!

      def option_exist?(key)
        @config[CONFIG_KEY] && @config[CONFIG_KEY].include?(key)
      end

      def old_config_warn()
        if @config.include?("wikilinks_collection")
          Jekyll.logger.warn("Jekyll-WikiRefs: As of 0.0.3, 'wikilinks_collection' is no longer used for configs. Jekyll-WikiRefs will scan all markdown files by default. Check README for details.")
        end
        if option_exist?("assets_rel_path")
          Jekyll.logger.warn("Jekyll-WikiRefs: As of 0.0.5, 'assets_rel_path' is now 'path'.")
        end
        if @config.include?("d3_graph_data")
          Jekyll.logger.warn("Jekyll-WikiRefs: As of 0.0.6, 'd3_graph_data' and graph functionality have been moved to the 'jekyll-graph' plugin.")
        end
      end
    end

  end
end
