# 第8回：プロビットモデル・ロジットモデル
# 実行場所：zemi.Rprojを開いたProjectのルート
# data/data_lesson08.csvを保存し、上から順に実行する。
# 今回の仮説：他の条件を一定とすると、教育年数は就業確率と正、幼児の存在は負の関係。

# データの読み込みと確認
participation <- read.csv("data/data_lesson08.csv")

# データの読み込みと確認
head(participation)
nrow(participation)
colSums(is.na(participation))
summary(participation)
table(participation$inlf)
mean(participation$inlf)

# 幼児の有無別の就業割合
table(participation$young_child, participation$inlf)

# 6歳未満の子どもがいない人（young_child == 0）と、いる人（== 1）のinlfを別々に取り出す。
# inlfは就業者が1、それ以外が0なので、各群の平均はその群の就業割合になる。
# 二つの割合に名前を付け、c()で一つのベクトルにまとめてgroup_rateに保存する。
group_rate <- c(
  "No child under 6" = mean(participation$inlf[participation$young_child == 0]),
  "Child under 6" = mean(participation$inlf[participation$young_child == 1])
)
group_rate

# 幼児の有無別の就業割合
barplot(
  group_rate,
  ylim = c(0, 1),
  ylab = "Share employed",
  col = c("#007c73", "#b24c3d")
)

# 5. パラメータの推定
# glm() は一般化線形モデルを推定する。
# binomial() は二項分布、link = "probit" は標準正規分布による確率変換を指定する。
model_probit <- glm(
  inlf ~ educ + exper + age + young_child + nwifeinc,
  data = participation,
  family = binomial(link = "probit")
)
summary(model_probit)

# 連続変数の限界効果
# 1. 各人の指数を求める。
# type = "link" は、確率に変換する前の指数zを返す。
index_hat <- predict(model_probit, type = "link")

# 2. 各人の限界効果に使う密度関数の値を求める。
# dnorm() は標準正規分布の密度関数φの値を返す（確率Φとは異なる）。
# この値に注目する変数の係数を掛けると、各人の限界効果になる。
normal_density <- dnorm(index_hat)

# 3. 全員の限界効果を平均する。
# 係数は全員に共通なので、密度関数の値を先に平均し、各変数の係数を掛ける。
# coef()から教育年数・経験年数・年齢・家族所得の係数を取り出す。
marginal_effects <- mean(normal_density) *
  coef(model_probit)[c("educ", "exper", "age", "nwifeinc")]
# 四つの変数の平均限界効果を表示する。
marginal_effects

# ダミー変数の限界効果
# 1. 幼児あり・なしの二つのデータを用意する。
# 元データをコピーし、全員の幼児ダミーを1（幼児あり）にする。
data_with_child <- participation
data_with_child$young_child <- 1
# もう一つコピーし、全員の幼児ダミーを0（幼児なし）にする。
# どちらも、他の説明変数は各人の実際の値のままにする。
data_no_child <- participation
data_no_child$young_child <- 0

# 2. 各人の確率の差を求める。
# type = "response" は、指数をΦ(z)で変換した就業確率を返す。
# 「幼児あり」とした場合の各人の就業確率を計算する。
prob_with_child <- predict(model_probit, newdata = data_with_child, type = "response")
# 「幼児なし」とした場合の各人の就業確率を計算する。
prob_no_child <- predict(model_probit, newdata = data_no_child, type = "response")
# 同じ人の「幼児あり－幼児なし」の確率差が、その人の限界効果になる。
individual_effect_child <- prob_with_child - prob_no_child

# 3. 全員の限界効果を平均する。
# 各人の確率差の平均を求める。
marginal_effect_child <- mean(individual_effect_child)
# 幼児ダミーの平均限界効果を表示する。
marginal_effect_child
