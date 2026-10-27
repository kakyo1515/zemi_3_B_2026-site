# 第2回：Rの基本操作 II ― RStudioとRの基本操作
# Rスクリプトに記録する主要なコード例。
# SourceペインのSourceボタンで、先頭から実行できる。
# 主な講義用コードを授業の順に記載する。


# Chapter 1｜RStudioでコードを実行する

# 1. 画面と各ペインの役割

# 2. Projectを作成する

# 3. スクリプトを作成し、最初の式を実行する
# 基本的な計算
1 + 2  # + は足し算。計算結果をConsoleに表示する。


# 4. Consoleへの直接入力

# Chapter 2｜計算・代入・関数

# 1. 計算式を記述する
10 - 4  # - は引き算。
3 * 5  # * は掛け算。
2^3  # ^ は累乗。2の3乗を求める。
(2 + 3) * 4  # ( ) 内を先に計算する。


# 2. 値に名前を付ける
score <- 82  # <- は右の値を左の名前に代入する。
score  # 名前だけを書くと、保存されている値を表示する。

score + 5
score

score <- score + 5  # 右辺を計算してから同じ名前に代入し、値を更新する。
print(score)  # print() は値を明示的に表示する。


# 3. 関数と引数
sqrt(16)  # sqrt() は平方根を求める。
abs(-8)  # abs() は絶対値を求める。
round(3.1415926, digits = 3)  # round() は指定した桁数に丸める。digits は小数点以下の桁数。


# 4. データ型を確認する
82 + 5

# 引用符で囲むと文字列になる。
student_name <- "Aiko"
score <- 82
attendance <- 0.94
passed <- TRUE  # TRUE は真、FALSE は偽を表す論理値。

class(student_name)  # class() はオブジェクトのデータ型を調べる。
class(score)
class(passed)


# 5. 条件を判定する
score >= 80  # >= は「以上」を判定する。結果はTRUEまたはFALSE。
score == 82  # == は左右の値が等しいかを判定する。
score != 70  # != は左右の値が異なるかを判定する。

score >= 60 & attendance >= 0.80  # & は両方の条件が真かを判定する。
score >= 90 | attendance == 1  # | は少なくとも一方の条件が真かを判定する。
!(score < 60)  # < は「未満」、! は条件の真偽を反転する。


# Chapter 3｜作業の保存と復元

# 1. Projectの作業領域の自動保存・復元

# 2. Projectの再起動と復元の確認
print(score)
print(passed)
