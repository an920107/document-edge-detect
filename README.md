# 文件邊緣檢測

## 概述

使用者可以透過裝置拍攝文件或證件的照片，程式將會偵測其邊緣，並做適當的裁切。

## 程式架構

- [backend](backend): 使用 python 開發後端，以 opencv 處理圖像、以 fastapi 提供 restful API 接口。

- [frontend](frontend): 使用 flutter 開發前端，拍攝照片上傳到後端伺服器進行處理，並展示給使用者。

## 其他

這是大三上「電腦視覺」課程的期末專案。
