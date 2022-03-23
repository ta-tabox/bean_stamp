module Users::UsersHelper
  def link_to_edit_user(user)
    return unless current_user == user

    link_to '編集', edit_user_registration_path, class: 'link'
  end

  # shared/_user_asideで使用するNotification
  # ロースト中のウォンツと未受け取りのウォンツのお知らせがない時
  def no_notes_for_user(wants)
    return if note_for_on_roasting_wants(wants) || note_for_unreceipted_wants(wants)

    tag.p 'お知らせはありません', class: 'text-sm text-gray-500'
  end

  # ロースト中のウォンツのお知らせ
  def note_for_on_roasting_wants(wants)
    on_roasting_wants = wants.includes(:offer).select { |want| want.offer.on_roasting? == true }
    return unless on_roasting_wants.any?

    link_to search_wants_path(search: Offer.statuses[:on_roasting]) do
      tag.p "#{Offer.statuses_i18n[:on_roasting]}のウォンツが#{on_roasting_wants.count}件あります", class: 'link text-sm'
    end
  end

  # 未受け取りのウォンツのお知らせ
  def note_for_unreceipted_wants(wants)
    on_selling_wants = wants.includes(:offer).select { |want| want.offer.on_selling? == true }
    return unless on_selling_wants.any?

    unreceipted_wants = on_selling_wants.select { |want| want.receipted_at? == false }
    return unless unreceipted_wants.any?

    link_to search_wants_path(search: Offer.statuses[:on_selling]) do
      tag.p "未受け取りのウォンツが#{unreceipted_wants.count}件あります", class: 'link text-sm'
    end
  end
end
