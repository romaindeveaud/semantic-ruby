#!/usr/bin/ruby

require 'linkparser_ext'


#  The LinkParser top-level namespace.
#  
#  == Authors
#  
#  * Michael Granger <ged@FaerieMUD.org>
#  * Martin Chase <stillflame@FaerieMUD.org>
#  
#  == Version
# 
#   $Id: linkparser.rb 48 2008-12-19 18:30:33Z deveiant $
#  
#  == License
# 
#  :include: LICENSE
#--
#  
#  See the LICENSE file for copyright/licensing information.
module LinkParser

	require 'linkparser/sentence'
	require 'linkparser/linkage'

	# Release version
	VERSION = '1.0.3'

	# SVN Revision
	SVNRev = %q$Rev: 48 $

	# SVN Id
	SVNId = %q$Id: linkparser.rb 48 2008-12-19 18:30:33Z deveiant $

end # class LinkParser
