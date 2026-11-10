# 第8回：プロビットモデル
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

# 幼児ダミーの作成と就業割合の比較
participation$young_child <- ifelse(participation$kidslt6 > 0, 1, 0)
table(participation$young_child, participation$inlf)

group_rate <- c(
  "No child under 6" = mean(participation$inlf[participation$young_child == 0]),
  "Child under 6" = mean(participation$inlf[participation$young_child == 1])
)
group_rate

# 幼児ダミーの作成と就業割合の比較
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
model_probit$converged

# 連続変数の限界効果
# type = "link" は、確率に変換する前の指数zを返す。
index_hat <- predict(model_probit, type = "link")
# dnorm() は標準正規分布の密度関数φの値を返す（確率Φとは異なる）。
normal_density <- dnorm(index_hat)

marginal_effects <- mean(normal_density) *
  coef(model_probit)[c("educ", "exper", "age", "nwifeinc")]
marginal_effects

# ダミー変数の限界効果
data_no_child <- participation
data_with_child <- participation
data_no_child$young_child <- 0
data_with_child$young_child <- 1

# type = "response" は、Φ(z)に変換した0～1の確率を返す。
prob_no_child <- predict(model_probit, newdata = data_no_child, type = "response")
prob_with_child <- predict(model_probit, newdata = data_with_child, type = "response")

marginal_effect_child <- mean(prob_with_child - prob_no_child)
marginal_effect_child
