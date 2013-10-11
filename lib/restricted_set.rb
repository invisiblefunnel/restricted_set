# The following copyright notice is included because parts of this
# library are modified from code in MRI's codebase.

# Copyright (c) 2002-2013 Akinori MUSHA <knu@iDaemons.org>
#
# Documentation by Akinori MUSHA and Gavin Sinclair.
#
# All rights reserved.  You can redistribute and/or modify it under the same
# terms as Ruby.

require "set"

class RestrictedSet < Set
  Identity = ->(o){ o }

  def initialize(enum = nil, &block)
    raise ArgumentError, "must provide a block" unless block_given?

    @proc = if block.arity == 2
              block.curry[self]
            else
              block
            end

    super(enum, &Identity)
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

  VERSION = "1.0.0"
end
