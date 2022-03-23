module WantsHelper
  def receipted_badge(want)
    return unless want.offer.receipt_started_at <= Date.current

    if want.receipted_at?
      tag.div '受け取り済み', class: 'receipted'
    else
      tag.div '未受け取り', class: 'unreceipted'
    end
  end
end
