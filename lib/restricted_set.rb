# The following copyright notice is included because parts of this
# library are modified from code in Ruby's codebase.

# Copyright (c) 2002-2013 Akinori MUSHA <knu@iDaemons.org>
#
# Documentation by Akinori MUSHA and Gavin Sinclair.
#
# All rights reserved.  You can redistribute and/or modify it under the same
# terms as Ruby.

require "set"
require "restricted_set/version"

class RestrictedSet < Set
  def initialize(enum = nil, &block)
    raise ArgumentError, "must provide a block" unless block_given?

    @proc = if block.arity == 2
              block.curry[self]
            else
              block
            end

    # Pass the identity proc to super to prevent
    # passing the given block argument through
    super(enum) { |o| o }
  end

  def add(o)
    if @proc.call(o)
      @hash[o] = true
    end
    self
  end
  alias << add

  def add?(o)
    if include?(o) || !@proc.call(o)
      nil
    else
      @hash[o] = true
      self
    end
  end

  def restriction_proc
    @proc
  end
end
