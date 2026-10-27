# 第4回：Rの基本操作 IV ― 関数・CSV・パッケージ・作図
# zemi.Rprojを開き、data/data_lesson02.csvとoutputフォルダを準備する。
# readrは事前にインストールする。作図にはRの標準機能を使う。
# Chapter 1〜4の主要なコード例を授業の順に記載する。
# output内の同名ファイルは上書きされるため、実行前に保存先を確認する。


# Chapter 1｜関数を作成する

# 1. 計算式を関数にまとめる
add_five <- function(x) {  # function(x) { } で、引数xを受け取る関数を定義する。
  result <- x + 5
  return(result)  # return() は関数の結果として返す値を指定する。
}

add_five(72)


# ベクトルを引数に渡す
scores <- c(72, 85, 91, 68, 77)
adjusted_scores <- add_five(scores)
adjusted_scores
scores


# 2. 複数の引数と既定値
# 引数の定義で = を使うと、省略時に使う既定値を設定できる。
calculate_score <- function(quiz, exam, quiz_weight = 0.40) {
  result <- quiz * quiz_weight + exam * (1 - quiz_weight)
  return(result)
}

calculate_score(quiz = 78, exam = 92)
calculate_score(quiz = 78, exam = 92, quiz_weight = 0.50)

calculate_score(78, 92)
calculate_score(exam = 92, quiz = 78)


# 3. 条件に応じて処理を分ける
judge_result <- function(score) {
  if (score >= 60) {  # if は条件が真のときに { } 内を実行する。
    return("合格")
  } else {  # else は条件が偽のときの処理。
    return("不合格")
  }
}

judge_result(82)
judge_result(48)

ifelse(scores >= 80, "80点以上", "80点未満")  # ifelse() は各要素について、条件に応じた値を返す。


# Chapter 2｜CSVを読み込み、データを確認する

# 1. データファイルを準備する

# 2. Projectを基準にパスを指定する
getwd()  # getwd() は現在の作業ディレクトリを表示する。
list.files("data")  # list.files() は指定フォルダのファイル名を一覧にする。


# 3. read.csv()で読み込む
# read.csv() はCSVファイルをデータフレームとして読み込む。
students <- read.csv(
  "data/data_lesson02.csv",
  na.strings = c("", "NA")  # na.strings は欠損値として扱う文字列を指定する。
)
head(students)


# 4. 構造と欠損値を確認する
class(students)
dim(students)
names(students)
str(students)

sum(is.na(students$score))
colSums(is.na(students))  # colSums() は列ごとに合計する。TRUEを1として欠損数を数える。

mean(students$score, na.rm = TRUE)


# 5. 必要な行と列を取り出す
high_scores <- students[
  !is.na(students$score) & students$score >= 80,
  c("student_id", "score")
]
high_scores

# write.csv() はデータをCSVファイルに保存する。
write.csv(
  high_scores,
  "output/high-scores.csv",
  row.names = FALSE  # row.names = FALSE は行番号を出力しない指定。
)


# Chapter 3｜外部パッケージを利用する

# 1. 機能を追加する

# 2. インストールと読み込みを区別する
library(readr)  # library() は現在のRセッションでパッケージを読み込む。


# 3. readrで同じCSVを読む
# read_csv() はreadrのCSV読み込み関数。
students_readr <- read_csv(
  "data/data_lesson02.csv",
  na = c("", "NA"),  # na は欠損値として扱う文字列を指定する。
  show_col_types = FALSE  # show_col_types = FALSE は列の型のメッセージを省略する。
)
class(students_readr)
head(students_readr)

dim(students_readr)
mean(students_readr$score, na.rm = TRUE)


# 4. パッケージ名を明示する
# パッケージ名::関数名 で、使う関数の所属を明示する。
readr::read_csv("data/data_lesson02.csv", show_col_types = FALSE)


# Chapter 4｜グラフを作成し、保存する

# 1. 確認したい内容とグラフの種類

# 2. 散布図を作成する
plot_data <- students[
  !is.na(students$study_hours) & !is.na(students$score),
]
nrow(plot_data)

# plot() は指定したxとyの散布図を描く。
plot(
  x = plot_data$study_hours,  # x は横軸に使う値。
  y = plot_data$score,  # y は縦軸に使う値。
  xlab = "Study hours per week",  # xlab は横軸のラベル。
  ylab = "Score",  # ylab は縦軸のラベル。
  main = "Study hours and score",  # main は図のタイトル。
  pch = 19,  # pch は点の形。19は塗りつぶした丸。
  col = "steelblue"  # col は色を指定する。
)


# 3. ヒストグラムを作成する
score_values <- students$score[!is.na(students$score)]
length(score_values)

# hist() はヒストグラムを描く。
hist(
  score_values,
  breaks = seq(40, 100, by = 10),  # breaks は階級の区切りを指定する。
  col = "skyblue3",
  border = "white",  # border は棒の枠線の色。
  xlab = "Score",
  main = "Distribution of scores"
)


# 4. 図を保存する
# png() は描画先を画像ファイルにする。width・heightは画素数、resは解像度。
png("output/study-score.png", width = 1120, height = 720, res = 160)
plot(
  x = plot_data$study_hours,
  y = plot_data$score,
  xlab = "Study hours per week",
  ylab = "Score",
  main = "Study hours and score",
  pch = 19,
  col = "steelblue"
)
dev.off()  # dev.off() は描画を終了し、画像ファイルの保存を完了する。


# 確認事項

# 実行結果の確認
print(dim(students))
print(colSums(is.na(students)))
print(high_scores)
