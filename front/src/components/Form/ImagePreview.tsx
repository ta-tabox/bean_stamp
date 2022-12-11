import type { FC } from 'react'

type Props = {
  images: Array<string>
}

export const ImagePreview: FC<Props> = (props) => {
  const { images } = props
  return (
    <>
      <h2 className="e-font text-gray-500 text-center text-sm">〜 Preview 〜</h2>
      <div className="flex flex-wrap">
        {/* NOTE map処理の際のunique keyは正しいか？ */}
        {images.map((image) => (
          <img key={image} className="w-56 h-40 mx-auto mb-4 rounded object-cover" src={image} alt="プレビュー画像" />
        ))}
      </div>
    </>
  )
}
