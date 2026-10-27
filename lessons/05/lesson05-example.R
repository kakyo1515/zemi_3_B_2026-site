# 第5回：計量経済分析の流れと単回帰分析
# zemi.Rprojを開き、data/data_lesson05.csvを準備する。
# Projectを作業ディレクトリとして、上から順に実行する。
# R標準機能のみ使用。
# データ：2024年家計調査、二人以上の世帯のうち勤労者世帯、52都市。
# 1行は1都市。金額は1世帯当たり1か月間の都市別平均（千円）。
# incomeは可処分所得、consumptionは消費支出。food（食料支出）は今回は使わない。
# city_codeは文字列として扱う。都市平均の関係と個々の世帯の関係を区別する。
# 出典：総務省統計局・e-Stat「家計調査」
# https://www.e-stat.go.jp/stat-search/files?stat_infid=000040247064

# 1. データの読み込みと確認
kakei <- read.csv(
  "data/data_lesson05.csv",
  fileEncoding = "UTF-8",
  colClasses = c(city_code = "character")  # colClasses は指定した列の型を固定する。ここでは都市コードを文字列にする。
)
print(head(kakei))
print(nrow(kakei))
print(colSums(is.na(kakei[c("income", "consumption")])))
print(range(kakei$income))  # range() は最小値と最大値をまとめて返す。
# summary() は各列の最小値・中央値・平均などの要約を表示する。
print(summary(kakei[c("income", "consumption")]))

# 2. 予備的分析：所得と消費支出の散布図と相関係数
plot(
  x = kakei$income,
  y = kakei$consumption,
  xlab = "Monthly disposable income (1,000 yen)",
  ylab = "Monthly consumption expenditure (1,000 yen)",
  pch = 19,
  col = "#007c73"
)

# 相関係数：約0.789。線形の関係の方向と強さを表し、回帰係数とは異なる。
print(cor(kakei$income, kakei$consumption))  # cor() は2変数の相関係数を求める。

# 3. 単回帰モデルの推定
# lm() は回帰モデルを最小二乗法で推定する。式は「被説明変数 ~ 説明変数」。
model <- lm(consumption ~ income, data = kakei)
print(coef(model))  # coef() は推定した回帰係数を取り出す。

# 散布図に推定した回帰直線を追加
plot(
  x = kakei$income,
  y = kakei$consumption,
  xlab = "Monthly disposable income (1,000 yen)",
  ylab = "Monthly consumption expenditure (1,000 yen)",
  pch = 19,
  col = "#007c73"
)
# abline() にモデルを渡すと回帰直線を追加する。lwd は線の太さ。
abline(model, col = "#b24c3d", lwd = 2)

# 4. 所得の係数の仮説検定（H0: b = 0、H1: b != 0、両側、有意水準5%）
# Estimate / Std. Error がt値、Pr(>|t|)が両側p値。
# 回帰モデルのsummary() は係数・標準誤差・t値・p値などを表示する。
print(summary(model))
# Coefficients表のincome行から、係数・標準誤差・t値・p値を読む。
# pは約3.85e-12 < 0.05。帰無仮説を棄却し、係数の推定値は正。
# 結論はモデルと通常のt検定の前提に依存し、因果効果を示すものではない。

# 5. モデルの当てはまり（決定係数R^2）
print(summary(model)$r.squared)  # $r.squared で決定係数を取り出す。
# 約0.622：消費支出のばらつきの約62.2%を回帰直線が説明する。

# 6. 所得の都市平均が500千円のときの消費支出を予測
# predict() は予測値を求める。newdata に予測したい条件のデータを渡す。
print(predict(model, newdata = data.frame(income = 500)))
