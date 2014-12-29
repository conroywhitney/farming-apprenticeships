require 'spec_helper'

describe Attra::Listing do

  ROGUE_FARMS = "https://attra.ncat.org/attra-pub/internships/farmdetails.php?FarmName=&City=&State=OR&Keyword=&allDate=0&page=1&FarmID=3391"

  context "sanity check" do

    it "should initialize" do
      expect { Attra::Listing.new(ROGUE_FARMS) }.to_not raise_error
    end

  end

  context "query string" do
    context "parsing" do

      before(:each) do
        @listing = Attra::Listing.new(ROGUE_FARMS)
      end

      it "should capture attra id" do
        expect(@listing.attra_id).to eq "3391"
      end

    end
  end

  context "attribute from element" do

    before(:each) do
      @listing = Attra::Listing.new(ROGUE_FARMS)
    end

    it "should handle perfectly clean" do
      expect(@listing.get_attribute_from_element("App Deadline")).to eq :app_deadline
    end

    it "should handle whitespace no colon" do
      expect(@listing.get_attribute_from_element("Minimum Length of Stay ")).to eq :minimum_stay_length
    end

    it "should handle colon no whitespace" do
      expect(@listing.get_attribute_from_element("Housing:")).to eq :housing
    end

    it "should handle whitespace and colon" do
      expect(@listing.get_attribute_from_element("Website: ")).to eq :website
    end

  end

  context "concatenate_attribute" do

    before(:each) do
      @listing = Attra::Listing.new(ROGUE_FARMS)
    end

    it "should handle nil initially" do
      @listing.website = nil
      @listing.concatenate_attribute(:website, "testing")
      expect(@listing.website).to eq "testing"
    end

    it "should handle blank initially" do
      @listing.website = ""
      @listing.concatenate_attribute(:website, "testing")
      expect(@listing.website).to eq "testing"
    end

    it "should handle multiples" do
      @listing.website = nil
      @listing.concatenate_attribute(:website, "testing")
      @listing.concatenate_attribute(:website, "one")
      @listing.concatenate_attribute(:website, "two")
      @listing.concatenate_attribute(:website, "three")
      expect(@listing.website).to eq "testing one two three"
    end

  end

  context "crawling" do

    before(:each) do
      @listing = Attra::Listing.new(ROGUE_FARMS)
      @listing.crawl!
    end

    it "should not error out" do
      expect { @listing.crawl! }.to_not raise_error
    end

    it "should actually find content" do
      expect(@listing.title).to eq "Rogue Farm Corps- FarmsNOW Program"
    end

  end

end
