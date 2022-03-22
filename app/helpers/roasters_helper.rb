module RoastersHelper
  def link_to_edit_roaster(roaster)
    return unless current_user.belonged_roaster?(roaster)

    link_to '編集', edit_roaster_path, class: 'link'
  end

  def note_for_no_actions(offers)
    return if offers.on_roasting.any? || offers.on_selling.any?

    tag.p 'お知らせはありません', class: 'text-sm text-gray-500'
  end

  def note_for_on_roasting(offers)
    return unless offers.on_roasting.any?

    if cookies[:roaster_id]
      link_to search_offers_path(search: Offer.statuses[:on_roasting]) do
        tag.p "#{Offer.statuses_i18n[:on_roasting]}のオファーが#{offers.on_roasting.count}件あります", class: 'link text-sm'
      end
    else
      link_to search_wants_path(search: Offer.statuses[:on_roasting]) do
        tag.p "#{Offer.statuses_i18n[:on_roasting]}のウォンツが#{offers.on_roasting.count}件あります", class: 'link text-sm'
      end
    end
  end

  def note_for_on_selling(offers)
    return unless offers.on_selling.any?

    if cookies[:roaster_id]
      link_to search_offers_path(search: Offer.statuses[:on_selling]) do
        tag.p "#{Offer.statuses_i18n[:on_selling]}のオファーが#{offers.on_selling.count}件あります", class: 'link text-sm'
      end
    else
      link_to search_wants_path(search: Offer.statuses[:on_selling]) do
        tag.p "#{Offer.statuses_i18n[:on_selling]}のウォンツが#{offers.on_selling.count}件あります", class: 'link text-sm'
      end
    end
  end
end
