def consolidate_cart(cart)
  prod_amount = {}

  cart.each do |key, val|
    key.each do |key, val|
      if prod_amount.has_key?(key)
        prod_amount[key] += 1
      else
        prod_amount[key] = 1
      end
    end
  end

  new_cart = cart.uniq { |ele| ele.keys}

  new_cart.each do |key, val|
    key.each do |key, val|
      if prod_amount.has_key?(key)
        temp_count = prod_amount[key]
        val[:count] = temp_count
        prod_amount[key] = val
      else
        puts "ERROR"
      end
    end
  end
  return prod_amount
end

def apply_coupons(cart, coupons)
  coupon_amount = {}
  cart.each do |cart_key, cart_val|
    coupons.each do |coupon_ele|
      if cart_key == coupon_ele[:item] && cart_val[:count] >= coupon_ele[:num]
        cart_val[:count] -= coupon_ele[:num]
        puts coupon_amount
        if coupon_amount["#{cart_key} W/COUPON"]
          coupon_amount["#{cart_key} W/COUPON"][:count] += coupon_ele[:num]
        else
          coupon_amount["#{cart_key} W/COUPON"] = {
            :price => ((coupon_ele[:cost]/coupon_ele[:num]).round(2)),
            :clearance => cart_val[:clearance], :count => coupon_ele[:num]
            }
        end
      end
    end
    coupon_amount[cart_key] = cart_val
  end
  cart = coupon_amount
  return cart
end


def apply_clearance(cart)
  cart.each do |key, val|
    if val[:clearance] == true
        val[:price] *= 0.80
        val[:price] = val[:price].round(2)
    end
  end
  return cart
end


def checkout(cart, coupons)
  cart = consolidate_cart(cart)
  cart = apply_coupons(cart, coupons)
  cart = apply_clearance(cart)
  total = 0

  cart.each do |key, val|
    total += (val[:price] * val[:count])
  end

  if total > 100
    total *= 0.9
  end
  return total
end
