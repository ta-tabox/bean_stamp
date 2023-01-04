import type { BeanCreateUpdateData } from '@/features/beans/types'

import type { UseFormSetError } from 'react-hook-form'

type ValidateUploadImagesOption = {
  setError: UseFormSetError<BeanCreateUpdateData>
  targetFiles: FileList
}

type ValidateMaxFileSizeOption = {
  fileList: FileList
  maxMb: number
}

export const useValidateUploadImages = () => {
  const maxImageNum = 4
  const maxImageMb = 5

  const validateMaxFileSize = ({ fileList, maxMb }: ValidateMaxFileSizeOption) => {
    let validationResult = true

    for (let i = 0; i < fileList.length; i += 1) {
      const sizeInMb = fileList[i].size / 1024 / 1024
      // 画像サイズがmaxMbより小さい場合はresult = trueのままループを回す
      if (sizeInMb > maxMb) {
        validationResult = false
        break
      }
    }
    return validationResult
  }

  const validateUploadImages = ({ setError, targetFiles }: ValidateUploadImagesOption): boolean => {
    // 最大画像枚数のバリデーション
    const isUnderMaxImageNum = (): boolean => targetFiles.length <= maxImageNum

    // 最大画像枚数のバリデーション
    const isUnderMaxImageMb = (): boolean => validateMaxFileSize({ fileList: targetFiles, maxMb: maxImageMb })

    const resultIsUnderMaxImageNum = isUnderMaxImageNum()
    const resultIsUnderMaxImageMb = isUnderMaxImageMb()

    // NOTE setErrorは連続して実行すると前回の結果を上書きする→冗長だが各パターンでそれぞれ実行
    if (!resultIsUnderMaxImageNum) {
      setError('images', {
        types: {
          maxLength: `画像は最大${maxImageNum}枚まで投稿できます`,
        },
      })
    }

    if (!resultIsUnderMaxImageMb) {
      setError('images', {
        types: {
          validate: `画像は最大5MBのサイズまで投稿できます. ${maxImageMb}MBより小さいファイルを選択してください.`,
        },
      })
    }

    if (!resultIsUnderMaxImageMb && !resultIsUnderMaxImageNum) {
      setError('images', {
        types: {
          maxLength: `画像は最大${maxImageNum}枚まで投稿できます`,
          validate: `画像は最大5MBのサイズまで投稿できます. ${maxImageMb}MBより小さいファイルを選択してください.`,
        },
      })
    }

    return resultIsUnderMaxImageMb && resultIsUnderMaxImageNum
  }
  return { validateUploadImages }
}
