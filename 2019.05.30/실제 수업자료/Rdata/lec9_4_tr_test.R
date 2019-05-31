# lec9_4_tr_test.R
# classification 
# training data and test data

# set working directory
setwd("C:/Rdata")

# read csv file
iris<-read.csv(file="iris.csv")
head(iris)
str(iris)    # 데이터 특성 확인
attach(iris)

# training/ test data : n=150
set.seed(1000)
# seed 번호를 주어야 난수 생성 시 동일한 표본 대상으로 사용 가능함
# 넣지 않으면 매번 다른 훈련표본 생성성
N=nrow(iris)   
tr.idx=sample(1:N, size=N*2/3, replace=FALSE)
tr.idx

# attributes in training and test
iris.train<-iris[tr.idx,-5]  # 종속변수 제외한 독립변수 데이터
iris.test<-iris[-tr.idx,-5]  # 위 100개의 행을 제외한 50개 데이터
# target value in training and test
trainLabels<-iris[tr.idx,5]  # 종속변수 데이터터
testLabels<-iris[-tr.idx,5]

table(testLabels)
