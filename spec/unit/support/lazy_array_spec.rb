require File.expand_path(File.join(File.dirname(__FILE__), '..', '..', 'spec_helper'))

describe LazyArray do
  before do
    @nancy  = 'nancy'
    @bessie = 'bessie'
    @steve  = 'steve'

    @lazy_array = LazyArray.new
    @lazy_array.load_with { |la| la.push(@nancy, @bessie) }

    @other = LazyArray.new
    @other.load_with { |la| la.push(@steve) }
  end

  describe '#at' do
    it 'should provide #at' do
      @lazy_array.should respond_to(:at)
    end

    it 'should lookup the element by index' do
      @lazy_array.at(0).should == @nancy
    end
  end

  describe '#clear' do
    it 'should provide #clear' do
      @lazy_array.should respond_to(:clear)
    end

    it 'should return self' do
      @lazy_array.clear.object_id.should == @lazy_array.object_id
    end

    it 'should make the lazy_array become empty' do
      @lazy_array.clear.should be_empty
    end
  end

  describe '#collect!' do
    it 'should provide #collect!' do
      @lazy_array.should respond_to(:collect!)
    end

    it 'should return self' do
      @lazy_array.collect! { |element| element }.object_id.should == @lazy_array.object_id
    end

    it 'should iterate over the lazy_array' do
      lazy_array = []
      @lazy_array.collect! { |element| lazy_array << element; element }
      lazy_array.should == @lazy_array.entries
    end

    it 'should update the lazy_array with the result of the block' do
      @lazy_array.collect! { |element| @steve }.entries.should == [ @steve, @steve ]
    end
  end

  describe '#concat' do
    it 'should provide #concat' do
      @lazy_array.should respond_to(:concat)
    end

    it 'should return self' do
      @lazy_array.concat(@other).object_id.should == @lazy_array.object_id
    end

    it 'should concatenate another lazy_array with #concat' do
      concatenated = @lazy_array.concat(@other)
      concatenated.length.should == 3
      concatenated[0].should == @nancy
      concatenated[1].should == @bessie
      concatenated[2].should == @steve
    end
  end

  describe '#delete' do
    it 'should provide #delete' do
      @lazy_array.should respond_to(:delete)
    end

    it 'should delete the matching element from the lazy_array' do
      @lazy_array.delete(@nancy).should == @nancy
      @lazy_array.size.should == 1
      @lazy_array[0].should == @bessie
    end

    it 'should use the passed-in block when no element was removed' do
      @lazy_array.size.should == 2
      @lazy_array.delete(@steve) { @steve }.should == @steve
      @lazy_array.size.should == 2
    end
  end

  describe '#delete_at' do
    it 'should provide #delete_at' do
      @lazy_array.should respond_to(:delete_at)
    end

    it 'should delete the element from the lazy_array with the index' do
      @lazy_array.delete_at(0).should == @nancy
      @lazy_array.size.should == 1
      @lazy_array[0].should == @bessie
    end
  end

  describe '#each' do
    it 'should provide #each' do
      @lazy_array.should respond_to(:each)
    end

    it 'should return self' do
      @lazy_array.each { |element| }.object_id.should == @lazy_array.object_id
    end

    it 'should iterate over the lazy_array' do
      lazy_array = []
      @lazy_array.each { |element| lazy_array << element }
      lazy_array.should == @lazy_array.entries
    end
  end

  describe '#each_index' do
    it 'should provide #each_index' do
      @lazy_array.should respond_to(:each_index)
    end

    it 'should return self' do
      @lazy_array.each_index { |element| }.object_id.should == @lazy_array.object_id
    end

    it 'should iterate over the lazy_array by index' do
      indexes = []
      @lazy_array.each_index { |index| indexes << index }
      indexes.should == [ 0, 1 ]
    end
  end

  describe '#empty?' do
    it 'should provide #empty?' do
      @lazy_array.should respond_to(:empty?)
    end

    it 'should return true if the lazy_array has entries' do
      @lazy_array.length.should == 2
      @lazy_array.empty?.should be_false
    end

    it 'should return false if the lazy_array has no entries' do
      @lazy_array.clear
      @lazy_array.length.should == 0
      @lazy_array.empty?.should be_true
    end
  end

  describe '#eql?' do
    it 'should provide #eql?' do
      @lazy_array.should respond_to(:eql?)
    end

    it 'should return true if for the same lazy_array' do
      @lazy_array.object_id.should == @lazy_array.object_id
      @lazy_array.should be_eql(@lazy_array)
    end

    it 'should return true for duplicate lazy_arrays' do
      dup = @lazy_array.dup
      dup.should be_kind_of(LazyArray)
      dup.object_id.should_not == @lazy_array.object_id
      dup.should be_eql(@lazy_array)
    end

    it 'should return false for different lazy_arrays' do
      @lazy_array.should_not be_eql(@other)
    end
  end

  describe '#fetch' do
    it 'should provide #fetch' do
      @lazy_array.should respond_to(:fetch)
    end

    it 'should lookup the element with an index' do
      @lazy_array.fetch(0).should == @nancy
    end

    it 'should throw an IndexError exception if the index is outside the array' do
      lambda { @lazy_array.fetch(99) }.should raise_error(IndexError)
    end

    it 'should subsitute the default if the index is outside the array' do
      element = 'cow'
      @lazy_array.fetch(99, element).object_id.should == element.object_id
    end

    it 'should substitude the value returned by the default block if the index is outside the array' do
      element = 'cow'
      @lazy_array.fetch(99) { element }.object_id.should == element.object_id
    end
  end

  describe '#first' do
    it 'should provide #first' do
      @lazy_array.should respond_to(:first)
    end

    describe 'with no arguments' do
      it 'should return the first element in the lazy_array' do
        @lazy_array.first.should == @nancy
      end
    end

    describe 'with number of results specified' do
      it 'should return a LazyArray ' do
        lazy_array = @lazy_array.first(2)
        lazy_array.should be_kind_of(LazyArray)
        lazy_array.object_id.should_not == @lazy_array.object_id
        lazy_array.length.should == 2
        lazy_array[0].should == @nancy
        lazy_array[1].should == @bessie
      end
    end
  end

  describe '#index' do
    it 'should provide #index' do
      @lazy_array.should respond_to(:index)
    end

    it 'should return an Integer' do
      @lazy_array.index(@nancy).should be_kind_of(Integer)
    end

    it 'should return the index for the first matching element in the lazy_array' do
      @lazy_array.index(@nancy).should == 0
    end
  end

  describe '#insert' do
    it 'should provide #insert' do
      @lazy_array.should respond_to(:insert)
    end

    it 'should return self' do
      @lazy_array.insert(1, @steve).object_id.should == @lazy_array.object_id
    end

    it 'should insert the element at index in the lazy_array' do
      @lazy_array.insert(1, @steve)
      @lazy_array[0].should == @nancy
      @lazy_array[1].should == @steve
      @lazy_array[2].should == @bessie
    end
  end

  describe '#last' do
    it 'should provide #last' do
      @lazy_array.should respond_to(:last)
    end

    describe 'with no arguments' do
      it 'should return the last element in the lazy_array' do
        @lazy_array.last.should == @bessie
      end
    end

    describe 'with number of results specified' do
      it 'should return a LazyArray ' do
        lazy_array = @lazy_array.last(2)
        lazy_array.should be_kind_of(LazyArray)
        lazy_array.object_id.should_not == @lazy_array.object_id
        lazy_array.length.should == 2
        lazy_array[0].should == @nancy
        lazy_array[1].should == @bessie
      end
    end
  end

  describe '#length' do
    it 'should provide #length' do
      @lazy_array.should respond_to(:length)
    end

    it 'should return an Integer' do
      @lazy_array.length.should be_kind_of(Integer)
    end

    it 'should return the length of the lazy_array' do
      @lazy_array.length.should == 2
    end
  end

  describe '#loaded?' do
    it 'should provide #loaded?' do
      @lazy_array.should respond_to(:loaded?)
    end

    it 'should return true for an initialized lazy_array' do
      @lazy_array.at(0)  # initialize the array
      @lazy_array.should be_loaded
    end

    it 'should return false for an uninitialized lazy_array' do
      uninitialized = LazyArray.new
      uninitialized.should_not be_loaded
    end
  end

  describe '#pop' do
    it 'should provide #pop' do
      @lazy_array.should respond_to(:pop)
    end

    it 'should remove the last element using #pop' do
      @lazy_array.pop.should == @bessie
      @lazy_array.length.should == 1
      @lazy_array[0].should == @nancy
    end
  end

  describe '#push' do
    it 'should provide #push' do
      @lazy_array.should respond_to(:push)
    end

    it 'should return self' do
      @lazy_array.push(@steve).object_id.should == @lazy_array.object_id
    end

    it 'should append a element using #push' do
      @lazy_array.push(@steve)
      @lazy_array.length.should == 3
      @lazy_array[0].should == @nancy
      @lazy_array[1].should == @bessie
      @lazy_array[2].should == @steve
    end
  end

  describe '#reject' do
    it 'should provide #reject' do
      @lazy_array.should respond_to(:reject)
    end

    it 'should return a LazyArray with elements that did not match the block' do
      rejected = @lazy_array.reject { |element| false }
      rejected.should be_kind_of(LazyArray)
      rejected.object_id.should_not == @lazy_array.object_id
      rejected.length.should == 2
      rejected[0].should == @nancy
      rejected[1].should == @bessie
    end

    it 'should return an empty Collection if elements matched the block' do
      rejected = @lazy_array.reject { |element| true }
      rejected.should be_kind_of(LazyArray)
      rejected.object_id.should_not == @lazy_array.object_id
      rejected.length.should == 0
    end
  end

  describe '#reject!' do
    it 'should provide #reject!' do
      @lazy_array.should respond_to(:reject!)
    end

    it 'should return self if elements matched the block' do
      @lazy_array.reject! { |element| true }.object_id.should == @lazy_array.object_id
    end

    it 'should return nil if no elements matched the block' do
      @lazy_array.reject! { |element| false }.should be_nil
    end

    it 'should remove elements that matched the block' do
      @lazy_array.reject! { |element| true }
      @lazy_array.should be_empty
    end

    it 'should not remove elements that did not match the block' do
      @lazy_array.reject! { |element| false }
      @lazy_array.length.should == 2
      @lazy_array[0].should == @nancy
      @lazy_array[1].should == @bessie
    end
  end

  describe '#reverse' do
    it 'should provide #reverse' do
      @lazy_array.should respond_to(:reverse)
    end

    it 'should return a LazyArray with reversed entries' do
      reversed = @lazy_array.reverse
      reversed.should be_kind_of(LazyArray)
      reversed.object_id.should_not == @lazy_array.object_id
      reversed.entries.should == @lazy_array.entries.reverse
    end
  end

  describe '#reverse!' do
    it 'should provide #reverse!' do
      @lazy_array.should respond_to(:reverse!)
    end

    it 'should return self' do
      @lazy_array.reverse!.object_id.should == @lazy_array.object_id
    end

    it 'should reverse the order of elements in the lazy_array inline' do
      entries = @lazy_array.entries
      @lazy_array.reverse!
      @lazy_array.entries.should == entries.reverse
    end
  end

  describe '#reverse_each' do
    it 'should provide #reverse_each' do
      @lazy_array.should respond_to(:reverse_each)
    end

    it 'should return self' do
      @lazy_array.reverse_each { |element| }.object_id.should == @lazy_array.object_id
    end

    it 'should iterate through the lazy_array in reverse' do
      lazy_array = []
      @lazy_array.reverse_each { |element| lazy_array << element }
      lazy_array.should == @lazy_array.entries.reverse
    end
  end

  describe '#rindex' do
    it 'should provide #rindex' do
      @lazy_array.should respond_to(:rindex)
    end

    it 'should return an Integer' do
      @lazy_array.rindex(@nancy).should be_kind_of(Integer)
    end

    it 'should return the index for the last matching element in the lazy_array' do
      @lazy_array.rindex(@nancy).should == 0
    end
  end

  describe '#select' do
    it 'should provide #select' do
      @lazy_array.should respond_to(:select)
    end

    it 'should return a LazyArray with elements that matched the block' do
      selected = @lazy_array.select { |element| true }
      selected.should be_kind_of(LazyArray)
      selected.object_id.should_not == @lazy_array.object_id
      selected.entries.should == @lazy_array.entries
    end

    it 'should return an empty Collection if no elements matched the block' do
      selected = @lazy_array.select { |element| false }
      selected.should be_kind_of(LazyArray)
      selected.object_id.should_not == @lazy_array.object_id
      selected.should be_empty
    end
  end

  describe '#shift' do
    it 'should provide #shift' do
      @lazy_array.should respond_to(:shift)
    end

    it 'should remove the first element using #shift' do
      @lazy_array.shift.should == @nancy
      @lazy_array.length.should == 1
      @lazy_array[0].should == @bessie
    end
  end

  describe '#slice' do
    it 'should provide #slice' do
      @lazy_array.should respond_to(:slice)
    end

    describe 'with an index' do
      it 'should not modify the lazy_array' do
        @lazy_array.slice(0)
        @lazy_array.size.should == 2
      end
    end

    describe 'with a start and length' do
      it 'should return a LazyArray' do
        sliced = @lazy_array.slice(0, 1)
        sliced.should be_kind_of(LazyArray)
        sliced.object_id.should_not == @lazy_array.object_id
        sliced.length.should == 1
        sliced[0].should == @nancy
      end

      it 'should not modify the lazy_array' do
        @lazy_array.slice(0, 1)
        @lazy_array.size.should == 2
      end
    end

    describe 'with a Range' do
      it 'should return a LazyArray' do
        sliced = @lazy_array.slice(0..1)
        sliced.should be_kind_of(LazyArray)
        sliced.object_id.should_not == @lazy_array.object_id
        sliced.length.should == 2
        sliced[0].should == @nancy
        sliced[1].should == @bessie
      end

      it 'should not modify the lazy_array' do
        @lazy_array.slice(0..1)
        @lazy_array.size.should == 2
      end
    end
  end

  describe '#slice!' do
    it 'should provide #slice!' do
      @lazy_array.should respond_to(:slice!)
    end

    describe 'with an index' do
      it 'should modify the lazy_array' do
        @lazy_array.slice!(0)
        @lazy_array.size.should == 1
      end
    end

    describe 'with a start and length' do
      it 'should return a LazyArray' do
        sliced = @lazy_array.slice!(0, 1)
        sliced.should be_kind_of(LazyArray)
        sliced.object_id.should_not == @lazy_array.object_id
        sliced.length.should == 1
        sliced[0].should == @nancy
      end

      it 'should modify the lazy_array' do
        @lazy_array.slice!(0, 1)
        @lazy_array.size.should == 1
      end
    end

    describe 'with a Range' do
      it 'should return a LazyArray' do
        sliced = @lazy_array.slice(0..1)
        sliced.should be_kind_of(LazyArray)
        sliced.object_id.should_not == @lazy_array.object_id
        sliced.length.should == 2
        sliced[0].should == @nancy
        sliced[1].should == @bessie
      end

      it 'should modify the lazy_array' do
        @lazy_array.slice!(0..1)
        @lazy_array.size.should == 0
      end
    end
  end

  describe '#sort' do
    it 'should provide #sort' do
      @lazy_array.should respond_to(:sort)
    end

    it 'should return a LazyArray' do
      sorted = @lazy_array.sort { |a,b| a <=> b }
      sorted.should be_kind_of(LazyArray)
      sorted.object_id.should_not == @lazy_array.object_id
    end

    it 'should sort the elements' do
      sorted = @lazy_array.sort { |a,b| a <=> b }
      sorted.entries.should == @lazy_array.entries.reverse
    end
  end

  describe '#sort!' do
    it 'should provide #sort!' do
      @lazy_array.should respond_to(:sort!)
    end

    it 'should return self' do
      @lazy_array.sort! { |a,b| 0 }.object_id.should == @lazy_array.object_id
    end

    it 'should sort the Collection in place' do
      original_entries =  @lazy_array.entries
      @lazy_array.length.should == 2
      @lazy_array.sort! { |a,b| a <=> b }
      @lazy_array.length.should == 2
      @lazy_array.entries.should == original_entries.reverse
    end
  end

  describe '#unshift' do
    it 'should provide #unshift' do
      @lazy_array.should respond_to(:unshift)
    end

    it 'should return self' do
      @lazy_array.unshift(@steve).object_id.should == @lazy_array.object_id
    end

    it 'should prepend a element' do
      @lazy_array.unshift(@steve)
      @lazy_array.length.should == 3
      @lazy_array[0].should == @steve
      @lazy_array[1].should == @nancy
      @lazy_array[2].should == @bessie
    end
  end

  describe '#values_at' do
    it 'should provide #values_at' do
      @lazy_array.should respond_to(:values_at)
    end

    it 'should return a LazyArray' do
      values = @lazy_array.values_at(0)
      values.class.should == LazyArray
      values.should be_kind_of(LazyArray)
      values.object_id.should_not == @lazy_array.object_id
    end

    it 'should return a LazyArray of the elements at the index' do
      @lazy_array.values_at(0).entries.should == [ @nancy ]
    end
  end

  describe 'an unknown method' do
    it 'should raise an exception' do
      lambda { @lazy_array.unknown }.should raise_error(NoMethodError)
    end
  end
end