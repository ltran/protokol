require "../spec_helper"

enum EnumTest
end

class Foo < Protokol::Message
  protokol do
    required :str_field, :String, 1
  end
end

describe Protokol::Buffer do
  describe "simple" do
    it "handles empty buffer" do
      buf = Protokol::Buffer.new
      buf.to_s.should eq("")
    end

    it "handles asdf" do
      buf = Protokol::Buffer.new
      buf << "asdf"
      buf.to_s.should eq("asdf")
    end

    it "handles =" do
      buf = Protokol::Buffer.new
      buf << "asdf"
      buf.buf = ""
      buf.to_s.should eq("")
    end
  end

  describe "wire_for" do
    it "handles integer types" do
      Protokol::Buffer.wire_for(:int32).should eq(0)
      Protokol::Buffer.wire_for(:uint32).should eq(0)
      Protokol::Buffer.wire_for(:sint32).should eq(0)
      Protokol::Buffer.wire_for(:int32).should eq(0)
    end

    it "handles float types" do
      Protokol::Buffer.wire_for(:fixed64).should eq(1)
      Protokol::Buffer.wire_for(:sfixed64).should eq(1)
      Protokol::Buffer.wire_for(:float64).should eq(1)
    end

    it "handles string types" do
      Protokol::Buffer.wire_for(:string).should eq(2)
      Protokol::Buffer.wire_for(:bytelist).should eq(2)
    end

    it "handles fixed types" do
      Protokol::Buffer.wire_for(:fixed32).should eq(5)
      Protokol::Buffer.wire_for(:sfixed32).should eq(5)
      Protokol::Buffer.wire_for(:float32).should eq(5)
    end

    it "handles enums" do
      Protokol::Buffer.wire_for(EnumTest).should eq(0)
    end

    it "handles classes as string" do
      Protokol::Buffer.wire_for("Foo").should eq(2)
    end

    it "handles classes as class" do
      Protokol::Buffer.wire_for(Foo).should eq(2)
    end

    it "raises error for unknown type" do
      expect_raises(Protokol::Buffer::UnknownType) do
        Protokol::Buffer.wire_for(:asdf)
      end
    end
  end
end
