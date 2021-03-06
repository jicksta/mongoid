require "spec_helper"

describe Mongoid::Validations::UniquenessValidator do

  describe "#validate_each" do

    before do
      @document = Person.new
    end

    let(:validator) { Mongoid::Validations::UniquenessValidator.new(:attributes => @document.attributes) }

    context "when a document exists with the attribute value" do

      before do
        @criteria = stub(:empty? => false)
        Person.expects(:where).with(all_of(has_entry(:title, "Sir"), has_value(@document._id))).returns(@criteria)
        validator.validate_each(@document, :title, "Sir")
      end

      it "adds the errors to the document" do
        @document.errors[:title].should_not be_empty
      end

      it "should translate the error in english" do
        @document.errors[:title][0].should == "is already taken"
      end

    end

    context "when no other document exists with the attribute value" do

      before do
        @criteria = stub(:empty? => true)
        Person.expects(:where).with(all_of(has_entry(:title, "Sir"), has_value(@document._id))).returns(@criteria)
        validator.validate_each(@document, :title, "Sir")
      end

      it "adds no errors" do
        @document.errors[:title].should be_empty
      end

    end

  end

end
