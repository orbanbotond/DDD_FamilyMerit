module FullfillmentsHelper
  def can_still_deliver?(fullfillment)
    if fullfillment.not_delivered || fullfillment.delivered
      false
    else
      true
    end
  end

  def delivery_status_message(fullfillment)
    if fullfillment.not_delivered
      "The fullfillment delivery couldn't be made"
    elsif fullfillment.delivered
      "The fullfillment was already delivered"
    else
      "The fullfillment can still be delivered"
    end
  end
end
