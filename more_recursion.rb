#Problem 1: You have array of integers. Write a recursive solution to find
#the sum of the integers.

def sum_recur(array)
  return 0 if array == []
  
  array.pop + sum_recur(array)
end


#Problem 2: You have array of integers. Write a recursive solution to
#determine whether or not the array contains a specific value.

def includes?(array, target)
  return true if array.pop == target
  return false if array.count == 0
  
  includes?(array, target)
end


#Problem 3: You have an unsorted array of integers. Write a recursive
#solution to count the number of occurrences of a specific value.

def num_occur(array, target)
  return 0 if array.count == 0
  
  last = array.pop
  
  if last == target
    num_occur(array, target) + 1
  else
    num_occur(array, target)
  end
end


#Problem 4: You have array of integers. Write a recursive solution to
#determine whether or not two adjacent elements of the array add to 12.

def add_to_twelve?(array)
  return true if array[-1] + array[-2] == 12
  return false if array.count == 0
  
  array.pop
  
  add_to_twelve?(array)
end


#Problem 5: You have array of integers. Write a recursive solution to
#determine if the array is sorted.

def sorted?(array)
  return true if array.count < 2
  return false if array[-2] > array[-1]
  
  array.pop
  
  sorted?(array)
end


#Problem 6: Write the code to give the value of a number after it is
#reversed. Must use recursion. (Don't use any #reverse methods!)

def reverse(number)
  
end