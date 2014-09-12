require 'debugger'

def range_recur(start, fin)
  return [] if fin <= start + 1

  range_recur(start, fin - 1) << fin - 1
end

def range_it(start, fin)
  range = []
  (start + 1).upto(fin - 1) { |num| range << num }
  range
end

def exponent_1(num, pow)
  return 1 if pow == 0
  num * exponent_1(num, pow - 1)
end

def exponent_2(num, pow)
  return 1 if pow == 0
  if pow.even?
    exponent_2(num, pow / 2) * exponent_2(num, pow / 2)
  elsif pow.odd?
    num * ((exponent_2(num, (pow - 1) / 2)) * (exponent_2(num, (pow - 1) / 2)))
  end
end

def deep_dup(item)
  return item if !item.is_a? Array

  duped_arr = []

  item.each do |inner_item|
    duped_arr << deep_dup(inner_item)
  end

  duped_arr
end

def fib_recur(n) # think about this problem more if time allows
  return [0] if n == 1
  return [0, 1] if n == 2

  fib_recur(n - 1) << fib_recur(n - 1)[-1] + fib_recur(n - 1)[-2]
end

def fib_iter(n)
  return [0] if n == 1
  return [0, 1] if n == 2

  fib_seq = [0, 1]
  (n - 2).times { fib_seq << fib_seq[-1] + fib_seq[-2] }

  fib_seq
end

def bsearch(array, target) # ask lots of questions
  # debugger
  searcher(array, target, 0)
end

def searcher(array, target, index)
  pivot = array.count / 2

  return nil if array.count == 1 && array[0] != target
  return index if array.count == 1 && array[0] == target
  return index + pivot if array[pivot] == target

  if array[pivot] > target
    searcher(array[0...pivot], target, index)
  else
    searcher(array[pivot..-1], target, index + pivot)
  end
end

def make_change_big(amount, coins)
  return [] if amount == 0
  return [amount] if coins.include?(amount)

  big_coin = coins.select { |coin| amount >= coin}.max
  coins.delete(big_coin) unless coins.min == big_coin

  make_change_big(amount - big_coin, coins) << big_coin

end

def make_change_smart(amount, coins)
  return [] if amount == 0

  best_combo = []

  coins.each do |coin|
    next if coin > amount

    new_combo = make_change_smart(amount - coin, coins) << coin
    best_combo = new_combo if best_combo.empty? || new_combo.count < best_combo.count
  end

  best_combo.inject(:+) == amount ? best_combo : []
end

def merge_sort(array)
  return array if array.count <= 1

  array1 = array[0...array.count/2]
  array2 = array[array.count/2..-1]

  our_merge(merge_sort(array1), merge_sort(array2))
end

def our_merge(array1, array2)
  merged = []

  until array1.empty? || array2.empty?
    if array1[0] > array2[0]
      merged << array2.shift
    else
      merged << array1.shift
    end
  end

  merged += array2 if array1.empty?
  merged += array1 if array2.empty?

  merged
end

def subsets(set)
  return [[]] if set == []

  add_me = set.pop

  olds = deep_dup(subsets(set))
  news = deep_dup(olds)
  news.each { |el| el << add_me }


  olds + news
end
