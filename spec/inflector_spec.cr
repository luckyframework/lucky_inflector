require "./spec_helper"

require "../src/inflector"
# TODO: add more comprehensive test cases
# require "./inflector_test_cases"

describe LuckySupport::Inflector do
  describe "plurals" do
    it "should pluralize" do
      tests = {
        "post" => "posts",
        "octopus" => "octopi",
        "sheep" => "sheep",
        "words" => "words",
        "CamelOctopus" => "CamelOctopi"
      }

      tests.each do |from, to |
        LuckySupport::Inflector.pluralize(from).should eq to
      end
    end

    it "should pluralize empty string" do
      LuckySupport::Inflector.pluralize("").should eq ""
    end
  end

  describe "singular" do
    it "should singularize" do
      tests = {
        "posts" => "post",
        "octopi" => "octopus",
        "sheep" => "sheep",
        "word" => "word",
        "CamelOctopi" => "CamelOctopus"
      }

      tests.each do |from, to|
        LuckySupport::Inflector.singularize(from).should eq to
      end
    end
  end

  describe "camelize" do
    it "should camelize" do
      tests = {
        "active_model" => "ActiveModel",
        "active_model/errors" => "ActiveModel::Errors",
      }

      tests.each do |from, to|
        LuckySupport::Inflector.camelize(from).should eq to
      end
    end

    it "should not capitalize" do
      LuckySupport::Inflector.camelize("active_model", false).should eq "activeModel"
      LuckySupport::Inflector.camelize("active_model/errors", false).should eq "activeModel::Errors"
    end
  end

  describe "humanize" do
    it "should humanize" do
      tests = {
        "employee_salary" => "Employee salary",
        "author_id" => "Author",
        "_id" => "Id"
      }

      tests.each do |from, to|
        LuckySupport::Inflector.humanize(from).should eq to
      end
    end

    it "should not capitalize" do
      LuckySupport::Inflector.humanize("author_id", capitalize: false).should eq "author"
    end

    it "should not capitalize" do
      LuckySupport::Inflector.humanize("author_id", keep_id_suffix: true).should eq "Author id"
    end
  end

  describe "upcase_first" do
    it "should upcase first" do
      tests = {
        "what a Lovely Day" => "What a Lovely Day",
        "w" => "W",
        "" => ""
      }

      tests.each do |from, to|
        LuckySupport::Inflector.upcase_first(from).should eq to
      end
    end
  end

  describe "titleize" do
    it "should titleize" do
      tests = {
        "man from the boondocks" => "Man From The Boondocks",
        "x-men: the last stand" => "X Men: The Last Stand",
        "TheManWithoutAPast" => "The Man Without A Past",
        "raiders_of_the_lost_ark" => "Raiders Of The Lost Ark",
      }

      tests.each do |from, to|
        LuckySupport::Inflector.titleize(from).should eq to
      end
    end

    it "should keep id suffix" do
      LuckySupport::Inflector.titleize("string_ending_with_id", keep_id_suffix: true).should eq "String Ending With Id"
    end
  end

  describe "tableize" do
    it "should tableize" do
      tests = {
        "RawScaledScorer" => "raw_scaled_scorers",
        "ham_and_egg" => "ham_and_eggs",
        "fancyCategory" => "fancy_categories"
      }

      tests.each do |from, to|
        LuckySupport::Inflector.tableize(from).should eq to
      end
    end
  end

  describe "classify" do
    it "should classify" do
      tests = {
        "ham_and_eggs" => "HamAndEgg",
        "posts" => "Post"
      }

      tests.each do |from, to|
        LuckySupport::Inflector.classify(from).should eq to
      end
    end

    it "should not Calculus" do
      LuckySupport::Inflector.classify("calculus").should_not eq "Calculus"
    end
  end

  describe "dasherize" do
    it "should dasherize" do
      tests = {
        "puni_puni" => "puni-puni"
      }

      tests.each do |from, to|
        LuckySupport::Inflector.dasherize(from).should eq to
      end
    end
  end

  describe "demodulize" do
    it "should demodulize" do
      tests = {
        "ActiveSupport::Inflector::Inflections" => "Inflections",
        "Inflections" => "Inflections",
        "::Inflections" => "Inflections",
        "" => ""
      }

      tests.each do |from, to|
        LuckySupport::Inflector.demodulize(from).should eq to
      end
    end
  end

  describe "deconstantize" do
    it "should deconstantize" do
      tests = {
        "Net::HTTP" => "Net",
        "::Net::HTTP" => "::Net",
        "String" => "",
        "::String" => "",
        "" => ""
      }

      tests.each do |from, to|
        LuckySupport::Inflector.deconstantize(from).should eq to
      end
    end
  end

  describe "foreign_key" do
    it "should foreign_key" do
      tests = {
        "Message" => "message_id",
        "Admin::Post" => "post_id"
      }

      tests.each do |from, to|
        LuckySupport::Inflector.foreign_key(from).should eq to
      end
    end

    it "should" do
      LuckySupport::Inflector.foreign_key("Message", false).should eq "messageid"
    end
  end

  describe "ordinal" do
    it "should ordinal" do
      tests = {
        1 => "st",
        2 => "nd",
        1002 => "nd",
        1003 => "rd",
        -11 => "th",
        -1021 => "st"
      }

      tests.each do |from, to|
        LuckySupport::Inflector.ordinal(from).should eq to
      end
    end
  end

  describe "ordinalize" do
    it "should ordinalize" do
      tests = {
        1 => "1st",
        2 => "2nd",
        1002 => "1002nd",
        1003 => "1003rd",
        -11 => "-11th",
        -1021 => "-1021st"
      }

      tests.each do |from, to|
        LuckySupport::Inflector.ordinalize(from).should eq to
      end
    end
  end
end

