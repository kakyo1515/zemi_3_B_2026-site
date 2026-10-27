# 第6回：重回帰分析とダミー変数
# zemi.Rprojを開き、data/data_lesson06.csvを準備する。
# Projectを作業ディレクトリとして、上から順に実行する。R標準機能のみ使用。
# データ：Wooldridgeのwage1、1976年の526人の賃金データ。
# wage：時間当たり賃金（1976年の米ドル）、educ：教育年数。
# exper：経験年数。
# female：女性1、男性0。男性が基準カテゴリーとなる。
# 本プロジェクトのreference_2/lesson06-data/wage1/から4列を収録。

# 1. 読み込みと確認
wages <- read.csv("data/data_lesson06.csv", fileEncoding = "UTF-8")
print(head(wages))
print(nrow(wages))
print(colSums(is.na(wages)))
print(summary(wages))
print(table(wages$female))

# 2. 予備的分析：散布図と相関係数
# 第3・4回と同じ条件抽出で男女を分け、第4・5回と同じx・yの指定で描く。
wages_male <- wages[wages$female == 0, ]
wages_female <- wages[wages$female == 1, ]

# 男女の図で比較できるよう、軸の範囲をそろえる。
wage_limits <- range(wages$wage)
educ_limits <- range(wages$educ)
exper_limits <- range(wages$exper)

# 男性の教育年数と時給
plot(
  x = wages_male$educ,
  y = wages_male$wage,
  xlab = "Education (years)",
  ylab = "Hourly wage (USD)",
  main = "Male: female = 0",
  xlim = educ_limits,  # xlim は横軸の範囲を指定する。
  ylim = wage_limits,  # ylim は縦軸の範囲を指定する。
  pch = 19,
  col = "#007c73"
)

# 女性の教育年数と時給
plot(
  x = wages_female$educ,
  y = wages_female$wage,
  xlab = "Education (years)",
  ylab = "Hourly wage (USD)",
  main = "Female: female = 1",
  xlim = educ_limits,
  ylim = wage_limits,
  pch = 19,
  col = "#b24c3d"
)

# 男性の経験年数と時給
plot(
  x = wages_male$exper,
  y = wages_male$wage,
  xlab = "Experience (years)",
  ylab = "Hourly wage (USD)",
  main = "Male: female = 0",
  xlim = exper_limits,
  ylim = wage_limits,
  pch = 19,
  col = "#007c73"
)

# 女性の経験年数と時給
plot(
  x = wages_female$exper,
  y = wages_female$wage,
  xlab = "Experience (years)",
  ylab = "Hourly wage (USD)",
  main = "Female: female = 1",
  xlim = exper_limits,
  ylim = wage_limits,
  pch = 19,
  col = "#b24c3d"
)

# 男女を合わせた526人全体の相関係数
# cor() に複数の数値列を渡すと、各組合せの相関行列を求める。
print(cor(wages[c("wage", "educ", "exper")]))

# 3. 推定：教育年数のみ→経験年数を追加→女性ダミーを追加
model_simple <- lm(wage ~ educ, data = wages)
# 回帰式の右辺では、+ で説明変数を追加する。
model_multiple <- lm(wage ~ educ + exper, data = wages)
model_dummy <- lm(wage ~ educ + exper + female, data = wages)
print(coef(model_simple))
print(coef(model_multiple))
print(coef(model_dummy))

# 4. 仮説検定：t検定とF検定（有意水準5%）
print(summary(model_dummy))
# t検定：各係数が0かを両側検定する。
# Coefficients表のeduc、exper、femaleの行からp値を読む。
# 教育年数と経験年数を一定としたときの、女性−男性の予測賃金差を読む。
# 全体のF検定：educ、exper、femaleの係数がすべて0かを検定する。
# summary末尾のF-statisticとp-valueを読む。F値は約77.92、自由度は(3, 522)。

# 5. モデルの当てはまり
# 上のsummary(model_dummy)の出力からMultiple R-squaredとAdjusted R-squaredを読む。
# 決定係数は約0.309、自由度調整済み決定係数は約0.305。

# 6. 予測：教育16年・経験年数10年、男性と女性で比較
new_workers <- data.frame(
  educ = c(16, 16),
  exper = c(10, 10),
  female = c(0, 1)
)
predicted_wages <- predict(model_dummy, newdata = new_workers)
print(predicted_wages)
# 差（女性−男性）は女性ダミーの係数と一致する。
print(c(
  # unname() は値に付いた名前を取り除く。
  female_minus_male = unname(predicted_wages[2] - predicted_wages[1]),
  female_coefficient = unname(coef(model_dummy)["female"])
))

# 補足：関数形を広げる場合（基本の3モデルと区別して確認する）
# 交差項：教育年数の傾きも男女で異なることを認める。
# 回帰式の * は主効果と交差項をまとめて含める指定。
model_interaction <- lm(wage ~ educ * female + exper, data = wages)
print(coef(model_interaction))
# 対数モデル：賃金はすべて正であることを確認して用いる。
model_log <- lm(log(wage) ~ educ + exper + female, data = wages)
print(coef(model_log))
# 二次項：経験年数と賃金の関係を曲線で近似する。
# I() は式の中で算術計算をそのまま扱う。ここでは経験年数の2乗。
model_quadratic <- lm(wage ~ educ + exper + I(exper^2) + female, data = wages)
print(coef(model_quadratic))
