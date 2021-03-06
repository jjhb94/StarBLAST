require 'erb'

module SequenceServer
  # Module to contain methods for generating sequence retrieval links.
  module Links
    # Provide a method to URL encode _query parameters_. See [1].
    include ERB::Util
    alias encode url_encode

    NCBI_ID_PATTERN    = /gi\|(\d+)\|/
    UNIPROT_ID_PATTERN = /sp\|(\w+)\|/
    PFAM_ID_PATTERN = /(PF\d{5}\.?\d*)/
    RFAM_ID_PATTERN = /(RF\d{5})/

    # Link generators are methods that return a Hash as defined below.
    #
    # {
    #   # Required. Display title.
    #   :title => "title",
    #
    #   # Required. Generated url.
    #   :url => url,
    #
    #   # Optional. Left-right order in which the link should appear.
    #   :order => num,
    #
    #   # Optional. Classes, if any, to apply to the link.
    #   :class => "class1 class2",
    #
    #   # Optional. Class name of a FontAwesome icon to use.
    #   :icon => "fa-icon-class"
    # }
    #
    # If no url could be generated, return nil.
    #
    # Helper methods
    # --------------
    #
    # Following helper methods are available to help with link generation.
    #
    #   encode:
    #     URL encode query params.
    #
    #     Don't use this function to encode the entire URL. Only params.
    #
    #     e.g:
    #         sequence_id = encode sequence_id
    #         url = "http://www.ncbi.nlm.nih.gov/nucleotide/#{sequence_id}"
    #
    #   dbtype:
    #     Returns the database type (nucleotide or protein) that was used for
    #     BLAST search.
    #
    #   whichdb:
    #     Returns the databases from which the hit could have originated. To
    #     ensure that one and the correct database is returned, ensure that
    #     your sequence ids are unique across different FASTA files.
    #     NOTE: This method is slow.
    #
    #   coordinates:
    #     Returns min alignment start and max alignment end coordinates for
    #     query and hit sequences.
    #
    #     e.g.,
    #     query_coords = coordinates[0]
    #     hit_coords = coordinates[1]

    def ncbi
      return nil unless id.match(NCBI_ID_PATTERN) or title.match(NCBI_ID_PATTERN)
      ncbi_id = Regexp.last_match[1]
      ncbi_id = encode ncbi_id
      url = "https://www.ncbi.nlm.nih.gov/#{dbtype}/#{ncbi_id}"
      {
        order: 2,
        title: 'NCBI',
        url:   url,
        icon:  'fa-external-link'
      }
    end

    def uniprot
      return nil unless id.match(UNIPROT_ID_PATTERN) or title.match(UNIPROT_ID_PATTERN)
      uniprot_id = Regexp.last_match[1]
      uniprot_id = encode uniprot_id
      url = "https://www.uniprot.org/uniprot/#{uniprot_id}"
      {
        order: 2,
        title: 'UniProt',
        url:   url,
        icon:  'fa-external-link'
      }
    end
 
    def pfam
      return nil unless id.match(PFAM_ID_PATTERN) or title.match(PFAM_ID_PATTERN)
      pfam_id = Regexp.last_match[1]
      pfam_id = encode pfam_id
      url = "https://pfam.xfam.org/family/#{pfam_id}"
      {
        order: 2,
        title: 'Pfam',
        url:   url,
        icon:  'fa-external-link'
      }
    end

    def rfam
      return nil unless id.match(RFAM_ID_PATTERN) or title.match(RFAM_ID_PATTERN)
      rfam_id = Regexp.last_match[1]
      rfam_id = encode rfam_id
      url = "https://rfam.xfam.org/family/#{rfam_id}"
      {
        order: 2,
        title: 'Rfam',
        url:   url,
        icon:  'fa-external-link'
      }
    end
  end
end

# [1]: https://stackoverflow.com/questions/2824126/whats-the-difference-between-uri-escape-and-cgi-escape
