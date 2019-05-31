### 11강 SVM



(1) 서포트 벡터머신



지도모델 - 분류모델 - SVM

```
장점 : 정확도가 상대적으로 좋음, 다양한 데이터(범주, 연속형)를 다룰 수 있음
단점 : 해석상의 어려움, 데이터가 많을 때 속도와 메모리가 많이 듦
```



* 선형 SVM

![캡처](https://user-images.githubusercontent.com/43332543/58538542-52297300-8230-11e9-96f6-efe38ff918c8.PNG)

동그라미 쳐진 3개의 데이터 사이의 거리를 마진(margin)이라고 부름

SVM은 마진을 최대로 하는 함수를 찾는 것(최적화 문제)



* 비선형 SVM : 대부분의 패턴은 선형적으로 분리 불가능하다

비선형 패턴의 입력공간을 선형 패턴의 feature space로 변환한다

Kernel method로 비선형 경계면 도출 



고차원(커널) 공간으로의 변환 -> 2차원에서는 분리가 되지 않지만, 3차원으로는 분리 가능하다

![캡처2](https://user-images.githubusercontent.com/43332543/58538824-e72c6c00-8230-11e9-8021-fb075126cc80.PNG)



* 실습

```R
install.packages("e1071")
library (e1071)

m1<- svm(Species ~., data = iris, kernel="linear")   # svm(y변수 ~ x변수, data=)
summary(m1)
```



```
Call:
svm(formula = Species ~ ., data = iris, kernel = "linear")

# svm에서 기본으로 주어지는 옵션(default) 
Parameters:
  SVM-Type:  C-classification 
SVM-Kernel:  linear 
      cost:  1 
     gamma:  0.25 

Number of Support Vectors:  29

 ( 2 15 12 )

Number of Classes:  3 

Levels: 
 setosa versicolor virginica
```



```R
x<-iris[, -5]  # 독립변수들만 있는 데이터
pred <- predict(m1, x)   # svm 모델을 적용해 예측된 범주값을 pred에 저장

y<-iris[,5]   # 실제값(종속변수)
table(pred, y)  # 테이블 -> 5/150 = 3.333%
```



```
plot(m1, iris,  Petal.Width~Petal.Length, slice=list(Sepal.Width=3, Sepal.Length=4))
# Petal.Width와 Petal.Length가 중요한 변수이다
```



* 커널

x 데이터의 새로운 특징을 추출하는 변환함수이자 기저함수를 커널함수라고 부른다

![커널](https://user-images.githubusercontent.com/43332543/58611446-12bf5d00-82ea-11e9-9909-d6cd2300608f.PNG)

x데이터를 새로운 차원으로 이동시킴 -> 2차원에서는 분리할 수 없었지만, 고차원에서는 분리 가능

ex) radial, polynomial, sigmoid



```R
library (e1071)
library(caret)

# ... 데이터 추출 및 샘플링

m1<-svm(Species~., data = train)  # radial(기본)
summary(m1)
m2<-svm(Species~., data = train,kernel="polynomial")
summary(m2)
m3<-svm(Species~., data = train,kernel="sigmoid")
summary(m3)
m4<-svm(Species~., data = train,kernel="linear")
summary(m4)
```



```
Call:
svm(formula = Species ~ ., data = train)


Parameters:
   SVM-Type:  C-classification 
 SVM-Kernel:  radial    # 커널 함수 종류
       cost:  1 
      gamma:  0.25    # 1 / 데이터 dimension

Number of Support Vectors:  42

 ( 17 7 18 )
```



```R
pred11<-predict(m1,test) # radial basis
confusionMatrix(pred11, test$Species)   # 예측 데이터와 실제 데이터 혼동표 그림
```



```
Confusion Matrix and Statistics

            Reference
Prediction   setosa versicolor virginica
  setosa         16          0         0
  versicolor      0         15         1
  virginica       0          0        18

Overall Statistics
                                          
               Accuracy : 0.98            
                 95% CI : (0.8935, 0.9995)
    No Information Rate : 0.38            
    P-Value [Acc > NIR] : < 2.2e-16       
                                          
                  Kappa : 0.9699          
                                          
 Mcnemar's Test P-Value : NA              

Statistics by Class:

                     Class: setosa Class: versicolor Class: virginica
Sensitivity                   1.00            1.0000           0.9474
Specificity                   1.00            0.9714           1.0000
Pos Pred Value                1.00            0.9375           1.0000
Neg Pred Value                1.00            1.0000           0.9688
Prevalence                    0.32            0.3000           0.3800
Detection Rate                0.32            0.3000           0.3600
Detection Prevalence          0.32            0.3200           0.3600
Balanced Accuracy             1.00            0.9857           0.9737
```



이와 같이 여러 개의 커널 함수를 비교해 가장 정확도가 높은 함수 선정함 -> 왜 정확도가 낮은지, 어떤 부분에서 오분류가 되었는지 검증할 것

cf) polynomial의 경우 degree(차수) 선정 가능 - 3이 기본



* breast cancer 실습

![breast cancer](https://user-images.githubusercontent.com/43332543/58612269-e9ec9700-82ec-11e9-9c8e-fb238ef29a13.PNG)



```
library(e1071)
library(caret)

cancer<-read.csv("cancer.csv")

cancer<-cancer[, names(cancer) != "X1"]   # 첫 번째 열인 ID는 제거함
attach(cancer)

N=nrow(cancer)
set.seed(998)
tr.idx=sample(1:N, size=N*2/3, replace=FALSE)    # 데이터 분할
train <- cancer[ tr.idx,]
test  <- cancer[-tr.idx,]

# 커널 함수별 svm 생성
m1<-svm(Y~., data = train)
m2<-svm(Y~., data = train,kernel="polynomial")
m3<-svm(Y~., data = train,kernel="sigmoid")
m4<-svm(Y~., data = train,kernel="linear")
summary(m4)

pred11<-predict(m1,test)    # radial basis -> 함수별 혼동표 생성
confusionMatrix(pred11, test$Y)
```



```
           Reference
Prediction  benign malignant   # polynomial 함수의 svm 결과
  benign       142        13   # false negative(실제로 악성인데 정상으로 분류함)
  malignant      0        73   # false positive(실제로 음성인데 질병으로 분류함)
```



* 정확도만 놓고 보면 linear가 높으나, false-positive / false-negative도 고려하면 radial 커널 함수를 선택하는 것이 좋다





