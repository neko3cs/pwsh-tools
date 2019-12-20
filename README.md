# pwsh-tools

PowerShell Coreを使った汎用ツール達。

道具がなければ道具を作れ！

## Common PowerShell Modules

一部のスクリプトでは共通のコマンドレットを使用しています。

共通のコマンドレットはPowerShell Moduleとして定義されており、事前に登録が必要です。

以下の方法で必要なモジュールを登録してください。

```
PS> Import-Module <モジュールファイルパス>
```

### Module list

- ```./Module/Use-Disposable.psm1```
