require_relative 'regex'

module Jekyll
  module WikiRefs

    class LinkIndex
      attr_reader :index

      def initialize(site)
        @baseurl = site.baseurl
        @index = {}
        site.doc_mngr.all.each do |doc|
          @index[doc.url] = DocLinks.new()
        end
      end

      def assign_metadata(doc)
        doc.data['attributed'] = @index[doc.url].attributed.uniq
        doc.data['attributes'] = @index[doc.url].attributes.uniq
        doc.data['backlinks']  = @index[doc.url].backlinks.uniq
        doc.data['forelinks']  = @index[doc.url].forelinks.uniq
        doc.data['missing']    = @index[doc.url].missing.uniq
      end

      def populate(doc, wikilink_blocks, wikilink_inlines)
        #        #
        # blocks #
        #        #
        wikilink_blocks.each do |wlbl|
          if wlbl.is_valid?
            #
            # attributes
            #
            target_attr = @index[doc.url].attributes.detect { |atr| atr['type'] == wlbl.link_type }
            # create
            if target_attr.nil?
              @index[doc.url].attributes << wlbl.linked_fm_data
            # append
            else
              target_attr['urls'] += wlbl.urls 
            end
            ## append missing docs
            @index[doc.url].missing += wlbl.missing_doc_filenames 
            #
            # attributed
            #
            wlbl.linked_docs.each do |linked_doc|
              target_attr = @index[linked_doc.url].attributed.detect { |atr| atr['type'] == wlbl.link_type }
              # create
              if target_attr.nil?
                @index[linked_doc.url].attributed << wlbl.context_fm_data
              # append
              else
                target_attr['urls'] << doc.url
              end
            end
          else
            #
            # invalid || empty
            #
            @index[doc.url].missing += wlbl.missing_doc_filenames
          end
        end
        #         #
        # inlines #
        #         #
        wikilink_inlines.each do |wlil|
          return if wlil.is_img?
          if wlil.is_valid?
            # forelink
            @index[doc.url].forelinks << wlil.linked_fm_data
            # backlink
            @index[wlil.linked_doc.url].backlinks << wlil.context_fm_data
          else
            @index[doc.url].missing << wlil.filename
          end
        end
      end

      # def remove_baseurl(url)
      #   return url.gsub(@baseurl, '') if !@baseurl.nil?
      #   return url
      # end

      class DocLinks
        attr_accessor :attributes, :attributed, :backlinks, :forelinks, :missing

        def initialize
          @attributed = [] # block typed backlinks;            { 'type' => str, 'urls' => [ str ] }
          @attributes = [] # block typed forelinks;            { 'type' => str, 'urls' => [ str ] }
          @backlinks  = [] # inline typed and basic backlinks; { 'type' => str, 'url'  => str }
          @forelinks  = [] # inline typed and basic forelinks; { 'type' => str, 'url'  => str }
          @missing    = [] # missing forelinks + attributes;   ( built from (missing) filenames )
        end
      end
    end

  end
end
