require 'date'

class DataGenerator
  def initialize
    @w1 = ['super', 'ultra', 'mega', 'special', 'power', 'deluxe',
              'cool', 'epic', 'royal']
    @w2 = ['process', 'software', 'solution', 'dependency',
              'architecture', 'strategy', 'object']
    @w1_len = @w1.length
    @w2_len = @w2.length

    @chars = ('a'..'z').to_a + ('A'..'Z').to_a + ('0'..'9').to_a + ["\n"]
    @chars_len = @chars.length
  end

  def array(n)
    ary = []
    n.times { ary << hash }
    ary
  end

  def array_nested(n, mod = 0.8)
    ary = []
    n.times { ary << nested_hash(mod) }
    ary
  end

  def hash
    {
      :num => rand(50000),
      :string => words,
      :date => date
    }
  end

  def nested_hash(nest_mod)
    {
      :num => rand(50000),
      :string => words,
      :date1 => date,
      :date2 => date,
      :text => string(1000),
      :children => (nest_mod > 0 && rand < nest_mod) ?
        array_nested(rand((10*nest_mod).to_i), nest_mod-0.4) : nil
    }
  end

  def words
    [@w1[rand(@w1_len)], @w1[rand(@w1_len)], @w2[rand(@w2_len)]].join(' ')
  end

  def string(size)
    str = ''
    size.times { str << @chars[rand(@chars_len)] }
    str.freeze
  end

  def date
    Time.at(rand(1302174900))
  end
end

