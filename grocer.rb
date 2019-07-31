require 'pry'

def consolidate_cart(cart)
  hash = {}
  cart.each do |item| #operate on each hash inside array
    item.each do |name, item_hash| #iterate over key,value pairs
      hash[name] = item_hash
      if hash[name][:count]
         hash[name][:count] += 1
      else
         hash[name][:count] = 1
      end #if
    end #item.each
  end #cart.each
  hash
end #consolidate_cart


def apply_coupons(cart, coupons)

  coupons.each do |coupon_hash|
    coupon_hash.each do |attribute, value|
      item = coupon_hash[:item]

      if cart[item] && cart[item][:count] >= coupon_hash[:num]

        if cart["#{item} W/COUPON"]
          cart["#{item} W/COUPON"][:count] += coupon_hash[:num]
        else
          cart["#{item} W/COUPON"] = {
            :clearance => cart[item][:clearance], :count => coupon_hash[:num], :price => (coupon_hash[:cost] / coupon_hash[:num])
          }
        end #if

        cart[item][:count] -= coupon_hash[:num]
      end #if
    end #coupon_hash.each
  end #coupons.each
  cart
end

def apply_clearance(cart)

  cart.each do |item, attributes|

      if attributes[:clearance] == true
        attributes[:price] = (attributes[:price] * 0.8).round(2)
      end #if
  end #cart.each

  cart
end

def checkout(cart, coupons)
  total = 0
  cart1 = consolidate_cart(cart)
  cart2 = apply_coupons(cart1, coupons)
  cart3 = apply_clearance(cart2)

  cart3.reduce(total) do |memo, (key, values)|

    total += (values[:price] * values[:count])
    memo
  end #cart.reduce

  if total >= 100
    total = (total * 0.9).round(2)
  end #if
  return total
end
