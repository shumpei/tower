require './helper'

class UserModule
  name:           "Lance"
  @defaultName:  "User"

class UserExtendingFunction
  @include UserModule

class UserExtendingClass extends Metro.Support.Class
  constructor: -> super
  
  @include UserModule
  
describe "support", ->
  describe "class", ->
    it "should allow submodules", ->
      expect(UserModule).toEqual(UserModule)

    it "should allow include", ->
      user = new UserExtendingFunction
      expect(user.name).toEqual("Lance")
      user = new UserExtendingClass
      expect(user.name).toEqual("Lance")

    it "should allow extend", ->
      expect(UserExtendingFunction.defaultName).toEqual("User")
      expect(UserExtendingClass.defaultName).toEqual("User")
  
  describe "path", ->
    beforeEach ->
      @path        = "spec/spec-app/app/assets/javascripts/application.js"
      @file        = new Metro.Support.Path(@path)#.Assets.Asset(@environment, @path)
  
    it "should stat file", ->
      expect(@file.stat()).toBeTruthy()
    
    it "should digest file names", ->
      expect(typeof(@file.digest())).toEqual("string")
    
    it "should get the content type", ->
      expect(@file.contentType()).toEqual("application/javascript")
    
    it "should get the mtime", ->
      expect(@file.mtime()).toBeTruthy()
    
    it "should get the file size", ->
      expect(@file.size()).toEqual 54
      
    it "should find entries in a directory", ->
      expect(Metro.Support.Path.entries("spec/spec-app/app/assets/javascripts")[1]).toEqual 'application.coffee'
      
    it "should generate absolute path", ->
      expected = "#{process.cwd()}/spec/spec-app/app/assets/javascripts"
      expect(Metro.Support.Path.absolutePath("spec/spec-app/app/assets/javascripts")).toEqual expected
      
    it "should generate relative path", ->
      expected = "spec/spec-app/app/assets/javascripts"
      expect(Metro.Support.Path.relativePath("spec/spec-app/app/assets/javascripts")).toEqual expected
  
  describe "lookup", ->
    beforeEach ->
      # Metro.Support.Path.glob("spec/spec-app/app/assets/javascripts")
      @lookup = new Metro.Support.Lookup
        paths:      ["spec/spec-app/app/assets/javascripts"]
        extensions: ["js", "coffee"]
        aliases:
          js: ["coffee", "coffeescript"]
          coffee: ["coffeescript"]
          
    it "should normalize extensions and aliases", ->
      expect(@lookup.extensions).toEqual ['.js', '.coffee']
      expect(@lookup.aliases).toEqual
        ".js":      ['.coffee', '.coffeescript']
        ".coffee":  [".coffeescript"]
    
    it "should build a pattern for a basename", ->
      pattern = @lookup.buildPattern("application.js")
      expect(pattern.toString()).toEqual /^application(?:\.js|\.coffee|\.coffeescript).*/.toString()
      
      pattern = @lookup.buildPattern("application.coffee")
      expect(pattern.toString()).toEqual /^application(?:\.coffee|\.coffeescript).*/.toString()
      
      pattern = @lookup.buildPattern("application.js.coffee")
      expect(pattern.toString()).toEqual /^application\.js(?:\.coffee|\.coffeescript).*/.toString()
      
    it "should find", ->
      result = @lookup.find("application.js")
      expect(result.length).toEqual 3
      
      result = @lookup.find("application.coffee")
      expect(result.length).toEqual 1
###  
  describe "mixins", ->
    it "should have string methods", ->
      Metro.Support.toRuby()
      string = "UserModel"
      expect(string.underscore()).toEqual "userModel"
      expect(string.underscore().camelize()).toEqual "UserModel"
      
    it "should convert to underscore", ->
      _ = require('underscore')
      _.mixin Metro.Support.toUnderscore()
      
      expect(_.extractOptions([1, 2, 3, {one: "two"}])).toEqual({one:"two"})
###      
