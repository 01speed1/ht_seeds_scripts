#Create Age Range lists

  AgeRangeList.find_or_create_by(description: 'Indiferente')
  AgeRangeList.find_or_create_by(description: '18 - 24')
  AgeRangeList.find_or_create_by(description: '25 - 34')
  AgeRangeList.find_or_create_by(description: '35 - 44')
  AgeRangeList.find_or_create_by(description: '45 - 54')
  AgeRangeList.find_or_create_by(description: 'más de 54')

#filter the offer with a age range

offers_with_age_range = Offer.all.select { |o| o.age_range.present? }

#create a hash to update the offer

b = offers_with_age_range.map {|o| {offer_id: o.id, from: o.age_range_from, to: o.age_range_to} }

# method to add the associate the age range list to offer

def suitable_age_range_lists(offer)

  list = []

  if offer[:from] <= 24 && offer[:to] >= 18
    list = [*list, AgeRangeList.find_or_create_by(description: '18 - 24')]
  end

  if offer[:from] <= 34 && offer[:to] >= 25
    list = [*list, AgeRangeList.find_or_create_by(description: '25 - 34')]
  end

  if offer[:from] <= 44 && offer[:to] >= 35
    list = [*list, AgeRangeList.find_or_create_by(description: '35 - 44')]
  end

  if  && offer[:from] <= 54 && offer[:to] >= 45
    list = [*list, AgeRangeList.find_or_create_by(description: '45 - 54')]
  end

  if offer[:to] >= 54
    list = [*list, AgeRangeList.find_or_c
  reate_by(description: 'más de 54')]
  end

  if list.empty?
    list = [AgeRangeList.find_or_create_by(description: 'Indiferente')]
  end

  list
end

# update the offers

c = b.map do |o|
  offer = Offer.find(o[:offer_id])
  offer.age_range_lists = suitable_age_range_lists(o)
  offer.save
  o.merge(ar_ids: Offer.find(o[:offer_id]).age_range_lists.pluck(:description))
end
