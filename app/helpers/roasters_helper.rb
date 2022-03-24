module RoastersHelper
  def link_to_edit_roaster(roaster)
    return unless current_user.belonged_roaster?(roaster)

    link_to '編集', edit_roaster_path, class: 'link'
  end

  # shared/_roaster_asideで使用するNotification
  def no_notes_for_roaster(offers)
    return if offers.on_roasting.any? || offers.on_selling.any?

    tag.p 'お知らせはありません', class: 'text-sm text-gray-500'
  end

  # ロースト中のオファーのお知らせ
  def note_for_on_roasting_offers(offers)
    return unless offers.on_roasting.any?

    link_to search_offers_path(search: Offer.statuses[:on_roasting]) do
      tag.p "#{Offer.statuses_i18n[:on_roasting]}のオファーが#{offers.on_roasting.count}件あります", class: 'link text-sm'
    end
  end

  # 販売中のオファーのお知らせ
  def note_for_on_selling_offers(offers)
    return unless offers.on_selling.any?

    link_to search_offers_path(search: Offer.statuses[:on_selling]) do
      tag.p "#{Offer.statuses_i18n[:on_selling]}のオファーが#{offers.on_selling.count}件あります", class: 'link text-sm'
    end
  end
end
