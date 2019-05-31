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

























