def consolidate_cart(cart)
  cart_hash = {}
  cart.each do |item|
    item.each do |f, i|
      if cart_hash[f] 
        cart_hash[f][:count] += 1
      else
        cart_hash[f] = i
        cart_hash[f][:count] = 1
      end
    end
  end
  cart_hash
end

def apply_coupons(cart, coupons)
  puts coupons
  coupons.length.times do |i|
    coupon_food = coupons[i][:item]
    if cart[coupon_food] && cart[coupon_food][:count] >= coupons[i][:num]
      cart[coupon_food][:count] -= coupons[i][:num]
      if cart["#{coupon_food} W/COUPON"]
        count = cart["#{coupon_food} W/COUPON"][:count]
        cart["#{coupon_food} W/COUPON"][:count] += coupons[i][:num]
      else
        cart["#{coupon_food} W/COUPON"] = {:price => coupons[i][:cost]/coupons[i][:num], :clearance => cart[coupon_food][:clearance], :count => coupons[i][:num]}
      end
    end
  end
  cart
end

def apply_clearance(cart)
  cart.each do |f, i|
    i[:price] *= 0.8 if i[:clearance] == true
    i[:price] = i[:price].round(1)
  end
  cart
end

def checkout(cart, coupons)
  cart = consolidate_cart(cart)
  cart = apply_coupons(cart, coupons)
  cart = apply_clearance(cart)
  total = 0
  cart.each do |f, i|
    total += i[:price] * i[:count]
  end
  total > 100 ? total *= 0.90 : total 
end