#!/usr/bin/ruby -w
#
# Specification for the LinkParser library
# $Id: linkparser_spec.rb 48 2008-12-19 18:30:33Z deveiant $
#
# See the LICENSE file in the distribution for information about copyright and licensing.
#

BEGIN {
	require 'pathname'
	basedir = Pathname.new( __FILE__ ).dirname.parent
	
	libdir = basedir + 'lib'
	extdir = basedir + 'ext'
	
	$LOAD_PATH.unshift( libdir.to_s ) unless $LOAD_PATH.include?( libdir.to_s )
	$LOAD_PATH.unshift( extdir.to_s ) unless $LOAD_PATH.include?( extdir.to_s )
}

require 'spec/runner'
require 'linkparser'


describe LinkParser do

	it "knows what version of the link-grammar library it was built against" do
		LinkParser.link_grammar_version.should =~ /link-grammar-\d+\.\d+\.\d+/i
	end
	
end