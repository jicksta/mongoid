# encoding: utf-8
module Mongoid #:nodoc:
  module Associations #:nodoc:
    class EmbeddedIn #:nodoc:
      include Proxy

      # Creates the new association by setting the internal
      # target as the passed in Document. This should be the
      # parent.
      #
      # All method calls on this object will then be delegated
      # to the internal document itself.
      #
      # Options:
      #
      # target: The parent +Document+
      # options: The association options
      def initialize(target, options)
        @target, @options = target, options
        extends(options)
      end

      # Returns the parent document. The id param is present for
      # compatibility with rails, however this could be overwritten
      # in the future.
      def find(id)
        @target
      end

      class << self
        # Creates the new association by setting the internal
        # document as the passed in Document. This should be the
        # parent.
        #
        # Options:
        #
        # document: The parent +Document+
        # options: The association options
        def instantiate(document, options)
          target = document._parent
          target.nil? ? nil : new(target, options)
        end

        # Returns the macro used to create the association.
        def macro
          :embedded_in
        end

        # Perform an update of the relationship of the parent and child. This
        # is initialized by setting a parent object as the association on the
        # +Document+. Will properly set an embeds_one or an embeds_many.
        #
        # Returns:
        #
        # A new +EmbeddedIn+ association proxy.
        def update(target, child, options)
          child.parentize(target, options.inverse_of)
          child.notify
          instantiate(child, options)
        end
      end
    end
  end
end
