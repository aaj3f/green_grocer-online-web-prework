require 'pry'

def consolidate_cart(cart)
  #an array of hashes, each key is an item with a hash as a variable
  #each hash has attribute keys and values
  #creating a hash with items as keys values are hashes
  new_hash = Hash.new
  cart.each do |item_hash|
    item_hash.each do |item_name, att_hash|
      #binding.pry
      if new_hash[item_name] == nil
        new_hash[item_name] = att_hash
        #binding.pry
        new_hash[item_name][:count] = 1
      else
        #binding.pry
        new_hash[item_name][:count] += 1
      end
    end
  end
  new_hash
end

def apply_coupons(cart, coupons)
  post_coupon_cart = Hash.new
  post_coupon_cart = cart
  coupons.each do |hash|
    if cart.keys.include?(hash[:item])
      post_coupon_cart["#{hash[:item]} W/COUPON"] = {}
    end
  end
  #binding.pry
  cart.each do |item_name, att_hash|
    #binding.pry
    coupons.each do |hash|
      if item_name == hash[:item] && att_hash[:count] >= hash[:num]
        #binding.pry
        post_coupon_cart["#{item_name} W/COUPON"] = {price: hash[:cost], clearance: post_coupon_cart[item_name][:clearance], count: ((att_hash[:count] / hash[:num]).to_i)}
        post_coupon_cart[item_name][:count] = (att_hash[:count] % hash[:num])
        #binding.pry
      end
    end
  end
  post_coupon_cart
end

def apply_clearance(cart)
  post_clear_cart = Hash.new
  post_clear_cart = cart
  cart.each do |item, att_hash|
    if att_hash[:clearance] == true
      post_clear_cart[item][:price] = (att_hash[:price] * 0.8).round(1)
    end
  end
  post_clear_cart
end

def checkout(cart, coupons)
  consol_cart = consolidate_cart(cart)
  post_coupon_cart = apply_coupons(consol_cart, coupons)
  #binding.pry
  post_clear_cart = apply_clearance(post_coupon_cart)
  total = 0
  post_clear_cart.each do |item, att_hash|
    total += (att_hash[:price] * att_hash[:count])
  end
  if total > 100
    total = (total * 0.9).round(2)
  end
  total
end
