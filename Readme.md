# SFP Flash 
オリジナルのSNをダンプして、チェックサムを計算してダンプ済みの奴にマージして書き込むやつ

## 使い方
- オリジナルのSNをダンプして、チェックサムを計算してダンプ済みの奴にマージして書き込む
`./modsn.sh ./bin/fin-10G.bin`

- ダンプ
`./dump.sh ./bin/hoge.bin`

- 書き込み
`./write.sh ./bin/hoge.bin`

- ファイルのチェックサムの確認
`./checksum.sh ./bin/hoge.bin`

- FINISAR のトランシーバの書き込みアンロック
`./unlock.sh`

## 設定
`settings.sh` で i2c のバスがいじれる