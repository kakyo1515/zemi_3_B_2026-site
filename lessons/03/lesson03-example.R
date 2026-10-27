# 第3回：Rの基本操作 III ― Rのデータ構造
# Chapter 1〜5の主要なコード例。
# SourceペインのSourceボタンで、先頭から実行できる。
# 主な講義用コードを授業の順に記載する。


# Chapter 1｜ベクトル

# 1. 複数の値をまとめる
scores <- c(72, 85, 91, 68, 77)  # c() は複数の値を一つのベクトルにまとめる。
student_names <- c("Aiko", "Ken", "Mei", "Sora", "Yuki")

scores
student_names

length(scores)  # length() は要素の数を求める。
class(scores)
class(student_names)

1:5  # : は1ずつ増減する整数の並びを作る。
seq(from = 0, to = 10, by = 2)  # seq() はfromからtoまで、by刻みの数列を作る。
rep("A", times = 4)  # rep() は値をtimes回繰り返す。


# 2. ベクトルを使って計算する
scores + 5  # ベクトルと数値の計算は、各要素に対して行われる。
scores / 100

sum(scores)  # sum() は合計を求める。
mean(scores)  # mean() は平均を求める。
min(scores)  # min() は最小値を求める。
max(scores)  # max() は最大値を求める。

quiz_1 <- c(8, 7, 9, 6)
quiz_2 <- c(7, 9, 8, 8)

quiz_1 + quiz_2
(quiz_1 + quiz_2) / 2


# 3. 必要な要素を取り出す
scores[1]  # [ ] 内に位置を指定して要素を取り出す。位置は1から数える。
scores[c(1, 3, 5)]  # 位置をベクトルで指定すると、複数の要素を取り出せる。
scores[2:4]

scores >= 80

scores[scores >= 80]  # [ ] 内に条件を書くと、条件が真の要素を取り出せる。

names(scores) <- student_names  # names() への代入で、各要素に名前を付ける。

scores
scores["Mei"]  # 位置の代わりに要素名を指定して取り出す。

revised_scores <- scores
revised_scores["Ken"] <- 88  # 取り出した位置に代入すると、その要素だけを変更する。
revised_scores


# 4. 欠損値を扱う
scores_missing <- c(70, 85, NA, 90)  # NA は欠損値を表す。

mean(scores_missing)

mean(scores_missing, na.rm = TRUE)  # na.rm = TRUE は欠損値を除いて計算する指定。

is.na(scores_missing)  # is.na() は欠損値の位置をTRUEで示す。
scores_missing[!is.na(scores_missing)]


# Chapter 2｜行列（matrix）

# 1. 行と列を持つデータを作成する
# matrix() は値を行と列に配置し、行列を作る。
score_matrix <- matrix(
  c(80, 75,
    68, 72,
    91, 88),
  nrow = 3,  # nrow は行数を指定する。
  byrow = TRUE  # byrow = TRUE は行方向に値を並べる。
)

score_matrix

matrix(1:6, nrow = 3)
matrix(1:6, nrow = 3, byrow = TRUE)

dim(score_matrix)  # dim() は各次元の大きさを返す。行列では行数と列数。
nrow(score_matrix)  # nrow() は行数を求める。
ncol(score_matrix)  # ncol() は列数を求める。


# 2. 行名・列名を付け、要素を取り出す
rownames(score_matrix) <- c("Aiko", "Ken", "Mei")  # rownames() への代入で行名を設定する。
colnames(score_matrix) <- c("Test1", "Test2")  # colnames() への代入で列名を設定する。
score_matrix

score_matrix[2, 1]  # [行, 列] の順に位置を指定する。
score_matrix["Ken", "Test1"]
score_matrix[, "Test2"]  # 行の指定を空欄にすると、その列の全行を取り出す。
score_matrix[1:2, ]  # 列の指定を空欄にすると、指定した行の全列を取り出す。


# 3. 行・列ごとに計算する
rowMeans(score_matrix)  # rowMeans() は行ごとの平均を求める。
colMeans(score_matrix)  # colMeans() は列ごとの平均を求める。

rbind(score_matrix, Yuki = c(76, 81))  # rbind() は行方向に結合する。
cbind(score_matrix, Average = rowMeans(score_matrix))  # cbind() は列方向に結合する。


# Chapter 3｜配列（array）

# 1. 三つ以上の次元を持つデータ
# array() は複数の次元を持つ配列を作る。
score_array <- array(
  c(80, 68, 91, 75, 72, 88,
    84, 70, 93, 78, 76, 90),
  dim = c(3, 2, 2)  # dim は各次元の大きさ。ここでは3行・2列・2層。
)

score_array

dim(score_array)
length(score_array)


# 2. 次元ごとに位置を指定する
score_array[2, 1, 2]  # 三次元配列は [行, 列, 層] の順で位置を指定する。
score_array[, , 1]
score_array[1, , ]


# 3. 一部を取り出して集計する
week2_scores <- score_array[, , 2]
rowMeans(week2_scores)
mean(week2_scores)


# Chapter 4｜データフレーム

# 1. 表形式のデータを作成する
# data.frame() は名前の付いた列をまとめて表を作る。
student_data <- data.frame(
  name = student_names,
  class = c("A", "A", "B", "B", "A"),
  score = c(72, 85, 91, 68, 77),
  attendance = c(0.90, 0.95, 1.00, 0.75, 0.88)
)

student_data

dim(student_data)
names(student_data)
str(student_data)  # str() は全体の構造や各列の型を表示する。

nrow(student_data)
ncol(student_data)
head(student_data, n = 3)  # head() は先頭の行を表示する。n は表示する行数。


# 2. 列・行・条件による抽出
student_data$score  # $列名 は指定した列を取り出す。
mean(student_data$score)

student_data[2, 3]
student_data[2, ]
student_data[, c("name", "score")]

student_data[
  student_data$score >= 80,
  c("name", "score")
]


# 3. 列を追加する
student_data$passed <- student_data$score >= 60  # $新しい列名 への代入で列を追加する。
student_data


# Chapter 5｜リスト（list）

# 1. 異なる構造のデータをまとめる
# list() は型や構造の異なるオブジェクトをまとめる。
course_result <- list(
  course = "R入門",
  students = student_data,
  test_scores = score_matrix,
  weekly_scores = score_array
)

names(course_result)
str(course_result)


# 2. リストから取り出す
course_result$course
course_result[["test_scores"]]  # [[ ]] は指定した要素の中身を取り出す。
course_result[[1]]

course_result[c("course", "students")]  # リストの [ ] は、選んだ要素を含むリストを返す。

class(course_result["students"])
class(course_result[["students"]])

result_students <- course_result[["students"]]
mean(result_students$score)


# 3. 要素を追加する
course_result$average_score <- mean(student_data$score)
course_result$average_score
names(course_result)
