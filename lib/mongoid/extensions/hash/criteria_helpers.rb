# encoding: utf-8
module Mongoid #:nodoc:
  module Extensions #:nodoc:
    module Hash #:nodoc:
      module CriteriaHelpers #:nodoc:
        
        def expand_complex_criteria
          inject({}) do |hsh, (k,v)|
            if k.kind_of? Mongoid::Criterion::Complex
              hsh[k.key] = {"$#{k.operator}" => v}
            else
              hsh[k] = v
            end
            hsh
          end
        end
        
      end
    end
  end
end
