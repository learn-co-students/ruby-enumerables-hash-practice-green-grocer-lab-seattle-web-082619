require "pry"

def consolidate_cart(item)
  final = Hash.new 
  count = :count #setting our count variable 
  item.each do |hash|
    hash.each do |food, description|

     if final.has_key?(food) == false # if food doesnt exist in the final hash
  
        final[food] = description #set food equal to descrption 
        final[food][count] = 1 # if the food never was not counted before, set initial value to 1. 
     else if final.has_key?(food)
       # if it does exist we are incrementing count by 1. 
      final[food][:count] +=1
        end 
      end #end of if statement 
    end #end of hash.each
  end # end for item.do 
final
end # final end to method 


def apply_coupons(cart, coupons)
  coupons.each do |coupon|  #going into iteration over the array
    # coupon.each do |attribute, value|  #going into the hash within the array 


      name = coupon[:item]#.to_s  #variable name for coupon[:item] to clean up how I view my code
      
      if cart[name] # if cart[name] exits as truthy if coupon didnt exist it wouldnt be truthy 
      
        if cart[name][:count] >= coupon[:num] 
          # if cart[name][:count] is greater than or equal to coupons number requirement 
        
        item_with_coupon = "#{name} W/COUPON" 
        #cleaning up applied coupon name
        
        if cart[item_with_coupon] #if it exists... 
        
          #***** CHANGED with just an equal.didnt + or - effect results. 
           cart[item_with_coupon][:count] += coupon[:num]
           # we are adding to the final coupons count, the coupons required number to fufill the coupon (wordy but true)
           
        else 
          cart[item_with_coupon] = {:price => coupon[:cost]/coupon[:num], 
          :clearance => cart[name][:clearance], :count => coupon[:num]} 
          # else, a coupon has not been applied, first time applying it. 
        end 
         cart[name][:count] -= coupon[:num]  
          # outside of our iteration. is it though? subtract number from cart count so that we are keeping our net even. 
      end 
    end 
  end 
#end 
  cart 
  # return the cart 
end

def apply_clearance (cart)
  #takes 20% off of price of item if clearance equals true 
  cart.each do |food, descrption|
    if (descrption[:clearance] == true)
      descrption[:price] = (descrption[:price]*(0.8)).round(2)
    end 
  end 
end

def checkout(cart,coupons)
  total = 0
  final = apply_clearance(apply_coupons(consolidate_cart(cart), coupons))
  
    final.each do |food,description|
  
    total += description[:price]*(description[:count])
    
    end 
    if (total > 100)
      total = (0.90*total)
    end 
    return total 
end 