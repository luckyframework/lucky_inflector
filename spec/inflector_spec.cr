require "./spec_helper"

require "../src/lucky_inflector/inflector/**"
require "../src/lucky_inflector/inflections"
require "./support/inflector_test_cases"

include InflectorTestCases

describe LuckyInflector do
  describe "pluralize" do
    SingularToPlural.each do |singular, plural|
      it "should pluralize #{singular}" do
        LuckyInflector.pluralize(singular).should eq plural
        LuckyInflector.pluralize(singular.capitalize).should eq plural.capitalize
      end
    end

    it "should pluralize empty string" do
      LuckyInflector.pluralize("").should eq ""
    end

    SingularToPlural.each do |singular, plural|
      it "should pluralize #{plural}" do
        LuckyInflector.pluralize(plural).should eq plural
        LuckyInflector.pluralize(plural.capitalize).should eq plural.capitalize
      end
    end
  end

  describe "singular" do
    SingularToPlural.each do |singular, plural|
      it "should singularize #{plural}" do
        LuckyInflector.singularize(plural).should eq singular
        LuckyInflector.singularize(plural.capitalize).should eq singular.capitalize
      end
    end

    SingularToPlural.each do |singular, plural|
      it "should singularize #{singular}" do
        LuckyInflector.singularize(singular).should eq singular
        LuckyInflector.singularize(singular.capitalize).should eq singular.capitalize
      end
    end
  end

  describe "camelize" do
    InflectorTestCases::CamelToUnderscore.each do |camel, underscore|
      it "should camelize #{underscore}" do
        LuckyInflector.camelize(underscore).should eq camel
      end
    end

    it "should not capitalize" do
      LuckyInflector.camelize("active_model", false).should eq "activeModel"
      LuckyInflector.camelize("active_model/errors", false).should eq "activeModel::Errors"
    end

    it "test camelize with lower downcases the first letter" do
      LuckyInflector.camelize("Capital", false).should eq "capital"
    end

    it "test camelize with underscores" do
      LuckyInflector.camelize("Camel_Case").should eq "CamelCase"
    end
  end

  describe "underscore" do
    CamelToUnderscore.each do |camel, underscore|
      it "should underscore #{camel}" do
        LuckyInflector.underscore(camel).should eq underscore
      end
    end

    CamelToUnderscoreWithoutReverse.each do |camel, underscore|
      it "should underscore without reverse #{camel}" do
        LuckyInflector.underscore(camel).should eq underscore
      end
    end

    CamelWithModuleToUnderscoreWithSlash.each do |camel, underscore|
      it "should camelize with module #{underscore}" do
        LuckyInflector.camelize(underscore).should eq camel
      end
    end

    CamelWithModuleToUnderscoreWithSlash.each do |camel, underscore|
      it "should underscore with slashes #{camel}" do
        LuckyInflector.underscore(camel).should eq underscore
      end
    end
  end

  describe "humanize" do
    UnderscoreToHuman.each do |underscore, human|
      it "should humanize #{underscore}" do
        LuckyInflector.humanize(underscore).should eq human
      end
    end

    UnderscoreToHumanWithoutCapitalize.each do |underscore, human|
      it "should not capitalize #{underscore}" do
        LuckyInflector.humanize(underscore, capitalize: false).should eq human
      end
    end

    UnderscoreToHumanWithKeepIdSuffix.each do |underscore, human|
      it "should keep id suffix #{underscore}" do
        LuckyInflector.humanize(underscore, keep_id_suffix: true).should eq human
      end
    end
  end

  describe "upcase_first" do
    it "should upcase first" do
      tests = {
        "what a Lovely Day" => "What a Lovely Day",
        "w"                 => "W",
        ""                  => "",
      }

      tests.each do |from, to|
        LuckyInflector.upcase_first(from).should eq to
      end
    end
  end

  describe "titleize" do
    MixtureToTitleCase.each do |before, titleized|
      it "should titleize mixture to title case #{before}" do
        LuckyInflector.titleize(before).should eq titleized
      end
    end

    MixtureToTitleCaseWithKeepIdSuffix.each do |before, titleized|
      it "should titleize with keep id suffix mixture to title case #{before}" do
        LuckyInflector.titleize(before, keep_id_suffix: true).should eq titleized
      end
    end
  end

  describe "tableize" do
    ClassNameToTableName.each do |class_name, table_name|
      it "should tableize #{class_name}" do
        LuckyInflector.tableize(class_name).should eq table_name
      end
    end
  end

  describe "classify" do
    ClassNameToTableName.each do |class_name, table_name|
      it "should classify #{table_name}" do
        LuckyInflector.classify(table_name).should eq class_name
        LuckyInflector.classify("table_prefix." + table_name).should eq class_name
      end
    end

    it "should classify with symbol" do
      LuckyInflector.classify(:foo_bars).should eq "FooBar"
    end

    it "should classify with leading schema name" do
      LuckyInflector.classify("schema.foo_bar").should eq "FooBar"
    end
  end

  describe "dasherize" do
    UnderscoresToDashes.each do |underscored, dasherized|
      it "should dasherize #{underscored}" do
        LuckyInflector.dasherize(underscored).should eq dasherized
      end
    end

    UnderscoresToDashes.each_key do |underscored|
      it "should underscore as reverse of dasherize #{underscored}" do
        LuckyInflector.underscore(LuckyInflector.dasherize(underscored)).should eq underscored
      end
    end
  end

  describe "demodulize" do
    demodulize_tests = {
      "MyApplication::Billing::Account" => "Account",
      "Account"                         => "Account",
      "::Account"                       => "Account",
      ""                                => "",
    }

    demodulize_tests.each do |from, to|
      it "should demodulize #{from}" do
        LuckyInflector.demodulize(from).should eq to
      end
    end
  end

  describe "deconstantize" do
    deconstantize_tests = {
      "MyApplication::Billing::Account"   => "MyApplication::Billing",
      "::MyApplication::Billing::Account" => "::MyApplication::Billing",
      "MyApplication::Billing"            => "MyApplication",
      "::MyApplication::Billing"          => "::MyApplication",
      "Account"                           => "",
      "::Account"                         => "",
      ""                                  => "",
    }

    deconstantize_tests.each do |from, to|
      it "should deconstantize #{from}" do
        LuckyInflector.deconstantize(from).should eq to
      end
    end
  end

  describe "foreign_key" do
    ClassNameToForeignKeyWithUnderscore.each do |klass, foreign_key|
      it "should foreign key #{klass}" do
        LuckyInflector.foreign_key(klass).should eq foreign_key
      end
    end

    ClassNameToForeignKeyWithoutUnderscore.each do |klass, foreign_key|
      it "should foreign key without underscore #{klass}" do
        LuckyInflector.foreign_key(klass, false).should eq foreign_key
      end
    end
  end

  describe "ordinal" do
    OrdinalNumbers.each do |number, ordinalized|
      it "should ordinal #{number}" do
        (number + LuckyInflector.ordinal(number)).should eq ordinalized
      end
    end
  end

  describe "ordinalize" do
    OrdinalNumbers.each do |number, ordinalized|
      it "should ordinalize #{number}" do
        LuckyInflector.ordinalize(number).should eq ordinalized
      end
    end
  end

  describe "irregularities" do
    Irregularities.each do |singular, plural|
      it "should handle irregularity between #{singular} and #{plural}" do
        LuckyInflector.inflections.irregular(singular, plural)
        LuckyInflector.singularize(plural).should eq singular
        LuckyInflector.pluralize(singular).should eq plural
      end
    end

    Irregularities.each do |singular, plural|
      it "should pluralize irregularity #{plural} should be the same" do
        LuckyInflector.inflections.irregular(singular, plural)
        LuckyInflector.pluralize(plural).should eq plural
      end
    end

    Irregularities.each do |singular, plural|
      it "should singularize irregularity #{singular} should be the same" do
        LuckyInflector.inflections.irregular(singular, plural)
        LuckyInflector.singularize(singular).should eq singular
      end
    end
  end

  describe "acronyms" do
    LuckyInflector.inflections.acronym("API")
    LuckyInflector.inflections.acronym("HTML")
    LuckyInflector.inflections.acronym("HTTP")
    LuckyInflector.inflections.acronym("RESTful")
    LuckyInflector.inflections.acronym("W3C")
    LuckyInflector.inflections.acronym("PhD")
    LuckyInflector.inflections.acronym("RoR")
    LuckyInflector.inflections.acronym("SSL")

    #  camelize             underscore            humanize              titleize
    [
      ["API", "api", "API", "API"],
      ["APIController", "api_controller", "API controller", "API Controller"],
      ["Nokogiri::HTML", "nokogiri/html", "Nokogiri/HTML", "Nokogiri/HTML"],
      ["HTTPAPI", "http_api", "HTTP API", "HTTP API"],
      ["HTTP::Get", "http/get", "HTTP/get", "HTTP/Get"],
      ["SSLError", "ssl_error", "SSL error", "SSL Error"],
      ["RESTful", "restful", "RESTful", "RESTful"],
      ["RESTfulController", "restful_controller", "RESTful controller", "RESTful Controller"],
      ["Nested::RESTful", "nested/restful", "Nested/RESTful", "Nested/RESTful"],
      ["IHeartW3C", "i_heart_w3c", "I heart W3C", "I Heart W3C"],
      ["PhDRequired", "phd_required", "PhD required", "PhD Required"],
      ["IRoRU", "i_ror_u", "I RoR u", "I RoR U"],
      ["RESTfulHTTPAPI", "restful_http_api", "RESTful HTTP API", "RESTful HTTP API"],
      ["HTTP::RESTful", "http/restful", "HTTP/RESTful", "HTTP/RESTful"],
      ["HTTP::RESTfulAPI", "http/restful_api", "HTTP/RESTful API", "HTTP/RESTful API"],
      ["APIRESTful", "api_restful", "API RESTful", "API RESTful"],

      # misdirection
      ["Capistrano", "capistrano", "Capistrano", "Capistrano"],
      ["CapiController", "capi_controller", "Capi controller", "Capi Controller"],
      ["HttpsApis", "https_apis", "Https apis", "Https Apis"],
      ["Html5", "html5", "Html5", "Html5"],
      ["Restfully", "restfully", "Restfully", "Restfully"],
      ["RoRails", "ro_rails", "Ro rails", "Ro Rails"],
    ].each do |words|
      camel, under, human, title = words
      it "should handle acronym #{camel}" do
        LuckyInflector.camelize(under).should eq camel
        LuckyInflector.camelize(camel).should eq camel
        LuckyInflector.underscore(under).should eq under
        LuckyInflector.underscore(camel).should eq under
        LuckyInflector.titleize(under).should eq title
        LuckyInflector.titleize(camel).should eq title
        LuckyInflector.humanize(under).should eq human
      end
    end

    it "should handle acronym override" do
      LuckyInflector.inflections.acronym("API")
      LuckyInflector.inflections.acronym("LegacyApi")

      LuckyInflector.camelize("legacyapi").should eq "LegacyApi"
      LuckyInflector.camelize("legacy_api").should eq "LegacyAPI"
      LuckyInflector.camelize("some_legacyapi").should eq "SomeLegacyApi"
      LuckyInflector.camelize("nonlegacyapi").should eq "Nonlegacyapi"
    end

    it "should handle acronyms camelize lower" do
      LuckyInflector.inflections.acronym("API")
      LuckyInflector.inflections.acronym("HTML")

      LuckyInflector.camelize("html_api", false).should eq "htmlAPI"
      LuckyInflector.camelize("htmlAPI", false).should eq "htmlAPI"
      LuckyInflector.camelize("HTMLAPI", false).should eq "htmlAPI"
    end

    it "should handle underscore acronym sequence" do
      LuckyInflector.inflections.acronym("API")
      LuckyInflector.inflections.acronym("JSON")
      LuckyInflector.inflections.acronym("HTML")

      LuckyInflector.underscore("JSONHTMLAPI").should eq "json_html_api"
    end
  end

  describe "clear" do
    it "should clear all" do
      # ensure any data is present
      LuckyInflector.inflections.plural(/(quiz)$/i, "\\1zes")
      LuckyInflector.inflections.singular(/(database)s$/i, "\\1")
      LuckyInflector.inflections.uncountable("series")
      LuckyInflector.inflections.human("col_rpted_bugs", "Reported bugs")

      LuckyInflector.inflections.clear :all

      LuckyInflector.inflections.plurals.empty?.should be_true
      LuckyInflector.inflections.singulars.empty?.should be_true
      LuckyInflector.inflections.uncountables.empty?.should be_true
      LuckyInflector.inflections.humans.empty?.should be_true
    end

    it "should clear with default" do
      # ensure any data is present
      LuckyInflector.inflections.plural(/(quiz)$/i, "\\1zes")
      LuckyInflector.inflections.singular(/(database)s$/i, "\\1")
      LuckyInflector.inflections.uncountable("series")
      LuckyInflector.inflections.human("col_rpted_bugs", "Reported bugs")

      LuckyInflector.inflections.clear

      LuckyInflector.inflections.plurals.empty?.should be_true
      LuckyInflector.inflections.singulars.empty?.should be_true
      LuckyInflector.inflections.uncountables.empty?.should be_true
      LuckyInflector.inflections.humans.empty?.should be_true
    end
  end

  describe "humans" do
    it "should humanize by rule" do
      LuckyInflector.inflections.human(/_cnt$/i, "\\1_count")
      LuckyInflector.inflections.human(/^prefx_/i, "\\1")

      LuckyInflector.humanize("jargon_cnt").should eq "Jargon count"
      LuckyInflector.humanize("prefx_request").should eq "Request"
    end

    it "should humanize by string" do
      LuckyInflector.inflections.human("col_rpted_bugs", "Reported bugs")

      LuckyInflector.humanize("col_rpted_bugs").should eq "Reported bugs"
      LuckyInflector.humanize("COL_rpted_bugs").should eq "Col rpted bugs"
    end

    it "should humanize with acronyms" do
      LuckyInflector.inflections.acronym("LAX")
      LuckyInflector.inflections.acronym("SFO")

      LuckyInflector.humanize("LAX ROUNDTRIP TO SFO").should eq "LAX roundtrip to SFO"
      LuckyInflector.humanize("LAX ROUNDTRIP TO SFO", capitalize: false).should eq "LAX roundtrip to SFO"
      LuckyInflector.humanize("lax roundtrip to sfo").should eq "LAX roundtrip to SFO"
      LuckyInflector.humanize("lax roundtrip to sfo", capitalize: false).should eq "LAX roundtrip to SFO"
      LuckyInflector.humanize("Lax Roundtrip To Sfo").should eq "LAX roundtrip to SFO"
      LuckyInflector.humanize("Lax Roundtrip To Sfo", capitalize: false).should eq "LAX roundtrip to SFO"
    end
  end
end
