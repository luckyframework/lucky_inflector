require "./spec_helper"

require "../src/lucky_support/inflector"
require "./inflector_test_cases"

include InflectorTestCases

describe LuckySupport::Inflector do
  describe "pluralize" do
    SingularToPlural.each do |singular, plural|
      it "should pluralize #{singular}" do
        LuckySupport::Inflector.pluralize(singular).should eq plural
        LuckySupport::Inflector.pluralize(singular.capitalize).should eq plural.capitalize
      end
    end

    it "should pluralize empty string" do
      LuckySupport::Inflector.pluralize("").should eq ""
    end

    SingularToPlural.each do |singular, plural|
      it "should pluralize #{plural}" do
        LuckySupport::Inflector.pluralize(plural).should eq plural
        LuckySupport::Inflector.pluralize(plural.capitalize).should eq plural.capitalize
      end
    end
  end

  describe "singular" do
    SingularToPlural.each do |singular, plural|
      it "should singularize #{plural}" do
        LuckySupport::Inflector.singularize(plural).should eq singular
        LuckySupport::Inflector.singularize(plural.capitalize).should eq singular.capitalize
      end
    end

    SingularToPlural.each do |singular, plural|
      it "should singularize #{singular}" do
        LuckySupport::Inflector.singularize(singular).should eq singular
        LuckySupport::Inflector.singularize(singular.capitalize).should eq singular.capitalize
      end
    end
  end

  describe "camelize" do
    InflectorTestCases::CamelToUnderscore.each do |camel, underscore|
      it "should camelize #{underscore}" do
        LuckySupport::Inflector.camelize(underscore).should eq camel
      end
    end

    it "should not capitalize" do
      LuckySupport::Inflector.camelize("active_model", false).should eq "activeModel"
      LuckySupport::Inflector.camelize("active_model/errors", false).should eq "activeModel::Errors"
    end

    it "test camelize with lower downcases the first letter" do
      LuckySupport::Inflector.camelize("Capital", false).should eq "capital"
    end

    it "test camelize with underscores" do
      LuckySupport::Inflector.camelize("Camel_Case").should eq "CamelCase"
    end
  end

  describe "underscore" do
    CamelToUnderscore.each do |camel, underscore|
      it "should underscore #{camel}" do
        LuckySupport::Inflector.underscore(camel).should eq underscore
      end
    end

    CamelToUnderscoreWithoutReverse.each do |camel, underscore|
      it "should underscore without reverse #{camel}" do
        LuckySupport::Inflector.underscore(camel).should eq underscore
      end
    end

    CamelWithModuleToUnderscoreWithSlash.each do |camel, underscore|
      it "should camelize with module #{underscore}" do
        LuckySupport::Inflector.camelize(underscore).should eq camel
      end
    end

    CamelWithModuleToUnderscoreWithSlash.each do |camel, underscore|
      it "should underscore with slashes #{camel}" do
        LuckySupport::Inflector.underscore(camel).should eq underscore
      end
    end
  end

  describe "humanize" do
    UnderscoreToHuman.each do |underscore, human|
      it "should humanize #{underscore}" do
        LuckySupport::Inflector.humanize(underscore).should eq human
      end
    end

    UnderscoreToHumanWithoutCapitalize.each do |underscore, human|
      it "should not capitalize #{underscore}" do
        LuckySupport::Inflector.humanize(underscore, capitalize: false).should eq human
      end
    end

    UnderscoreToHumanWithKeepIdSuffix.each do |underscore, human|
    it "should keep id suffix #{underscore}" do
        LuckySupport::Inflector.humanize(underscore, keep_id_suffix: true).should eq human
      end
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
    MixtureToTitleCase.each do |before, titleized|
      it "should titleize mixture to title case #{before}" do
        LuckySupport::Inflector.titleize(before).should eq titleized
      end
    end

    MixtureToTitleCaseWithKeepIdSuffix.each do |before, titleized|
      it "should titleize with keep id suffix mixture to title case #{before}" do
        LuckySupport::Inflector.titleize(before, keep_id_suffix: true).should eq titleized
      end
    end
  end

  describe "tableize" do
    ClassNameToTableName.each do |class_name, table_name|
      it "should tableize #{class_name}" do
        LuckySupport::Inflector.tableize(class_name).should eq table_name
      end
    end
  end

  describe "classify" do
    ClassNameToTableName.each do |class_name, table_name|
      it "should classify #{table_name}" do
        LuckySupport::Inflector.classify(table_name).should eq class_name
        LuckySupport::Inflector.classify("table_prefix." + table_name).should eq class_name
      end
    end

    it "should classify with symbol" do
      LuckySupport::Inflector.classify(:foo_bars).should eq "FooBar"
    end

    it "should classify with leading schema name" do
      LuckySupport::Inflector.classify("schema.foo_bar").should eq "FooBar"
    end
  end

  describe "dasherize" do
    UnderscoresToDashes.each do |underscored, dasherized|
      it "should dasherize #{underscored}" do
        LuckySupport::Inflector.dasherize(underscored).should eq dasherized
      end
    end

    UnderscoresToDashes.each_key do |underscored|
      it "should underscore as reverse of dasherize #{underscored}" do
        LuckySupport::Inflector.underscore(LuckySupport::Inflector.dasherize(underscored)).should eq underscored
      end
    end
  end

  describe "demodulize" do
    demodulize_tests = {
      "MyApplication::Billing::Account" => "Account",
      "Account" => "Account",
      "::Account" => "Account",
      "" => ""
    }

    demodulize_tests.each do |from, to|
      it "should demodulize #{from}" do
        LuckySupport::Inflector.demodulize(from).should eq to
      end
    end
  end

  describe "deconstantize" do
    deconstantize_tests = {
      "MyApplication::Billing::Account" => "MyApplication::Billing",
      "::MyApplication::Billing::Account" => "::MyApplication::Billing",
      "MyApplication::Billing" => "MyApplication",
      "::MyApplication::Billing" => "::MyApplication",
      "Account" => "", 
      "::Account" => "",
      "" => ""
    }

    deconstantize_tests.each do |from, to|
      it "should deconstantize #{from}" do
        LuckySupport::Inflector.deconstantize(from).should eq to
      end
    end
  end

  describe "foreign_key" do
    ClassNameToForeignKeyWithUnderscore.each do |klass, foreign_key|
      it "should foreign key #{klass}" do
        LuckySupport::Inflector.foreign_key(klass).should eq foreign_key
      end
    end

    ClassNameToForeignKeyWithoutUnderscore.each do |klass, foreign_key|
      it "should foreign key without underscore #{klass}" do
        LuckySupport::Inflector.foreign_key(klass, false).should eq foreign_key
      end
    end
  end

  describe "ordinal" do
    OrdinalNumbers.each do |number, ordinalized|
      it "should ordinal #{number}" do
        (number + LuckySupport::Inflector.ordinal(number)).should eq ordinalized
      end
    end
  end

  describe "ordinalize" do
    OrdinalNumbers.each do |number, ordinalized|
      it "should ordinalize #{number}" do
        LuckySupport::Inflector.ordinalize(number).should eq ordinalized
      end
    end
  end
end

