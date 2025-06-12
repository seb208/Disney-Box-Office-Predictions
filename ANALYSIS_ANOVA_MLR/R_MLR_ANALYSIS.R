install.packages("leaps")
install.packages('dplyr')
library(dplyr)


# ----- DATA LOADING -----
disney <- read.csv("Clean_Disney_data.csv")
attach(disney)

#------Data Cleaning -------

#Renaming Variables and sorting by Box Office in Decending Order
names(disney) <- c("title","run_time","budget","box_office","imdb","metascore","rotten_tom","director","actor","music","distr","rating","year","month")

#-------Converting Percentages-----------
disney$rotten_tom <- as.numeric(sub("%","",disney$rotten_tom))/100
str(disney$rotten_tom)



#-------Appending inflation columns (Box Office and Budget)

conversion <- read.csv("2022_Inflation_Convertion.csv")#dataframe created using online resources
disney <- disney[order(disney$year),] #Order data by year

#Append Inflation
conv <- c()
for (x in disney$year) {
  print(x)
  index <- which(conversion$Year == x)
  change <- conversion[index,"Conversion"]
  conv <- append(conv, change)
}
disney$Inflation <- conv


#Budget Adjusted for Inflation
disney$Inflation_budg <- disney$Inflation * disney$budget
#Box Office  Adjusted for Inflation
disney$Inflation_office <- disney$Inflation * disney$box_office

str(disney)
plot(disney$year,disney$Inflation_office,xlab="Year",ylab="Box Office", main= "Box Office vs Year")

#Ordering data by box office
disney <- disney[order(-disney$box_office),]
disney$box_office

#---------Checking for outliers-----------
#str(disney)
#checking if there are any outliers that might need to be removed
boxplot(disney$Inflation_budg)$out
boxplot(disney$run_time)$out
boxplot(disney$budget)$out
boxplot(disney$imdb)$out
boxplot(disney$Inflation_office)$out
boxplot(disney$metascore)$out

# Remove outlier from Box office ($36: Index 162)
index <- which.min(table(disney$box_office))

#output -> lowest value : 36
remove <- which(disney$box_office == 36)
disney <-disney[-remove,]
disney$box_office

#------Creating Dummy Variables--------

#------Step 1: Frequency Test(Determining which Dummy variables to include)-------

#5 most frequent directors
direct = table(disney$director)
sort(direct)
  #Ron Clements
  #John Lasseter
  #Jon Turteltaub
  #Andrew Stanton
  #Wolfgang Reitherman

#5 most frequent top billed actor
actor = table(disney$actor)
sort(actor)
  #Johnny Depp
  #Tom Hanks
  #Tim Allen
  #Owen Wilson
  #Nicolas Cage

#5 most frequent music producers
music = table(disney$music)
sort(music)

  #Randy Newman
  #Michael Giacchino
  #Alan Menken
  #John Debney
  #Hans Zimmer

#Top distributor
dist <- table(disney$distr)
dist
  #Buena Vista Pictures
  #Walt Disney Studios
  #Walt Disney Studios Motion Picture Distribution
  #Buena Vista Pictures Distribution
  #Buena Vista Distribution

#Rating Types
sort(table(disney$rating))
  #G PG PG-13 TV-PG TV-Y

#------Part 2: Conversion into Dummy Variables--------

#Rating Types
#G PG PG-13 TV-PG TV-Y

g<- as.numeric(disney$rating=="G")
pg <- as.numeric(disney$rating=="PG")
pg_13 <- as.numeric(disney$rating=="pg_13")

#Distributors
  #Buena Vista Pictures
  #Walt Disney Studios
  #Walt Disney Studios Motion Picture Distribution
  #Buena Vista Pictures Distribution
  #Buena Vista Distribution

bvp<- as.numeric(disney$distr=="Buena Vista Pictures")
wds <- as.numeric(disney$distr=="Walt Disney Studios")
wdsmp <- as.numeric(disney$distr=="Walt Disney Studios Motion Picture Distribution")
bvpd <- as.numeric(disney$distr=="Buena Vista Pictures Distribution")
bvd <- as.numeric(disney$distr=="Buena Vista Distribution")

#Directors
  #Ron Clements
  #John Lasseter
  #Jon Turteltaub
  #Andrew Stanton
  #Wolfgang Reitherman

rc <- as.numeric(disney$director=="Ron Clements")
jl <- as.numeric(disney$director=="John Lasseter")
jt <- as.numeric(disney$director=="Jon Turteltaub")
as <- as.numeric(disney$director=="Andrew Stanton")
wr <- as.numeric(disney$director=="Wolfgang Reitherman")

#Music Producers
  #Randy Newman
  #Michael Giacchino
  #Alan Menken
  #John Debney
  #Hans Zimmer

rw <- as.numeric(disney$music=="Randy Newman")
mg <- as.numeric(disney$music=="Michael Giacchino")
am <- as.numeric(disney$music=="Alan Menken")
jd <- as.numeric(disney$music=="John Debney")
hz <- as.numeric(disney$music=="Hans Zimmer")

#Actors
  #Johnny Depp
  #Tom Hanks
  #Tim Allen
  #Owen Wilson
  #Nicolas Cage

jdd <- as.numeric(disney$actor=="Johnny Depp")
th <- as.numeric(disney$actor=="Tom Hanks")
ta <- as.numeric(disney$actor=="Tim Allen")
ow <- as.numeric(disney$actor=="Owen Wilson")
nc <- as.numeric(disney$actor=="Nicolas Cage")


#-------EDA ------------

#Nominal data- Budget vs Box Office 
plot(disney$budget,disney$box_office,xlab="Budget",ylab="Box Office", main= "Box Office vs Year")
slr <- lm(box_office~ budget)
summary(slr)
#r2 = .528

#Inflation data - Budget vs Box Office
plot(disney$Inflation_budg,disney$Inflation_office,xlab="Inflation Budget",ylab="Box Office Inflation", main= "Box Office Infaltion vs Budget")
slr <- lm(Inflation_office~ Inflation_budg)
summary(slr)
#r2 = 0.4049

#Months vs Box Office
plot(disney$month,disney$Inflation_office,xlab="Months",ylab="Box Office", main= "Box Office vs Months")

#Run Time vs Inflation box Office
plot(disney$run_time,disney$Inflation_office,xlab="Run Time",ylab="Box Office", main= "Inf Box Office vs Run Time")
slr <- lm(Inflation_office~ run_time)
summary(slr)
#r2 = 0.05942

#Year vs Box Office
plot(disney$year,disney$box_office,xlab="Year",ylab="Box Office", main= "Box Office vs Year")
slr <- lm(box_office~ year)
abline(slr,col="red")
summary(slr)
#r2 = 0.1509

#Metascore vs Box Office 
plot(disney$metascore,disney$Inflation_office,xlab="Metascore",ylab="Box Office", main= "Box Office vs Matascore")
slr <- lm(Inflation_office~ metascore)
summary(slr)
#r2 = 0.2783

# IMDb vs Box Office 
plot(disney$IMDB,disney$Inflation_office,xlab="Imdb",ylab="Box Office", main= "Box Office vs ImDb")
slr <- lm(Inflation_office~ imdb)
summary(slr)
#r2 = .3085

#Rotten Tomatoes
slr <- lm(Inflation_office~ rotten_tom)
summary(slr)
#r2 = 0.1792

#Inf Budget vs Inf Box
plot(disney$Inflation_budg,disney$Inflation_office,xlab="Inflation Budget",ylab="Inflation Box Office", main= "Inf Box Office vs Inf Budget")
slr <- lm(Inflation_office~ Inflation_budg)
summary(slr)
#r2 =0.4049

##Budget vs Year
plot(disney$year,disney$Inflation_budg,xlab="Year",ylab="Inflation Budget", main= "Year vs Inflation Budget")
slr <- lm(Inflation_budg~ year)
summary(slr)
#r2 = 0.1771

#Budget vs Rotten Tomatoes
plot(disney$Inflation_budg,disney$rotten_tom,xlab="Inflation Budget",ylab="Metascore", main= "Inflation Budget vs MetaScore")
slr <- lm(Inflation_budg ~ rotten_tom)
summary(slr)
#R^2 0.04174

#Budget vs Metasore
plot(disney$Inflation_budg,disney$metascore,xlab="Inflation Budget",ylab="Metascore", main= "Inflation Budget vs MetaScore")
slr <- lm(Inflation_budg ~ metascore)
summary(slr)
#r2 = .05144

#Budget vs IMDb
plot(disney$Inflation_budg,disney$imdb,xlab="Inflation Budget",ylab="Imdb", main= "Inflation Budget vs Imdb")
slr <- lm(Inflation_budg ~ imdb)
summary(slr)
#r2 = 0.1165

#--------Subsets Predictors---------
"
Notes:
- Decide if im using R2a or R^2 as measurement
- First make catigorical variables into dummies
- Remember that we use variables up to Elbow of data 
    - Mention this in notes and use Graphs to explain why
"
attach(disney)
library(leaps)

#Model 1:All Variables included-----------------
modsel1 <- regsubsets(box_office ~ run_time + budget + 
                      imdb + metascore + rotten_tom + year + month +
                       g + pg + pg_13 + bvp + wds + wdsmp + bvpd + bvd +
                     rc + jl + jt + as + wr + rw + mg + am + jd + hz + jdd 
                     + th + ta + ow + nc,disney,nbest=1)

#Name numbers which were best
vars<-summary(modsel1)$which
vars
# R2a spot plot:
r2a <-  summary(modsel1)$adjr2
r2a
plot(0:9,c(0,r2a),type="b",ylim=c(0,1),xlab="Number m of X's",ylab="Adjusted R2", main= "X's vs Adjusted R2")
abline(h=c(0,1))

    #4 main variables:budget metascore rotten_tom Han Zimmer
    #R2a = 0.6805884

#Model 2: (Actors, Music by, directors, distributor removed)----------------
modsel2 <- regsubsets(box_office ~ run_time + budget + 
                       imdb + metascore + rotten_tom + year + month +
                       g + pg + pg_13,disney,nbest=1)

#Name numbers which were best
vars<-summary(modsel2)$which
vars

# R2a spot plot:
r2a <-  summary(modsel2)$adjr2
r2a
plot(0:8,c(0,r2a),type="b",ylim=c(0,1),xlab="Number m of X's",ylab="Adjusted R2")
abline(h=c(0,1))

        #Elbow at 3 variables main variables:budget metascore rotten_tom
        #R2a = 0.6536656



#-----------------------(Top 9 influential features)-----------

attach(disney)
model_all <- lm(box_office ~ budget + imdb + metascore + rotten_tom + wds + month + rc + hz + ta)
summary(disney)
coef(model_all)

#----------Model 4 (Inflation Data)

#Order data by box office
top_earning <- disney[order(-disney$box_office),]
#Keep top 81 earning films (Half the dataset)
top_earning <-head(top_earning, 80)
names(which.max(table(actors$actor)))

#Actor
sort(table(top_earning$actor), decreasing = TRUE)[1:5] 
#Johnny Depp      Tom Hanks   Nicolas Cage    Owen Wilson Angelina Jolie 

#Directors
sort(table(top_earning$director), decreasing = TRUE)[1:5] 
#John Lasseter  Andrew Stanton  Brad Bird   Gary Trousdale   Gore Verbinski 

#Music By
sort(table(top_earning$music), decreasing = TRUE)[1:5] 
#Randy Newman   Michael Giacchino         Alan Menken         Hans Zimmer James  Newton Howard 



#Order data by Box Office Inflation & keep top 81 earning films [With inflation] (Half the dataset)
top_earning_Inf <- disney[order(-disney$Inflation_office),]
top_earning_Inf <-head(top_earning_Inf, 80)
names(which.max(table(top_earning_Inf$actor)))

#Actors
sort(table(top_earning_Inf$actor), decreasing = TRUE)[1:5] 
# Johnny Depp    Tim Allen    Tom Hanks Jim  Cummings Nicolas Cage 

#Directors
sort(table(top_earning_Inf$director), decreasing = TRUE)[1:5] 
#John Lasseter  Andrew Stanton  Jon Turteltaub      Brad Bird   Gary Trousdale 

#Music By
sort(table(top_earning_Inf$music), decreasing = TRUE)[1:5] 
#Randy Newman Michael Giacchino       Alan Menken       Hans Zimmer       John Debney 

#Updated Dummy Variables

#Directors
#John Lasseter  Andrew Stanton  Jon Turteltaub      Brad Bird   Gary Trousdale 
jl <- as.numeric(disney$director=="John Lasseter")
jas <- as.numeric(disney$director=="Andrew Stanton")
jt <- as.numeric(disney$director=="Jon Turteltaub")
bb <- as.numeric(disney$director=="Brad Bird")
gt <- as.numeric(disney$director=="Gary Trousdale ")


#Music Producers
#Randy Newman Michael Giacchino       Alan Menken       Hans Zimmer       John Debney 
rw <- as.numeric(disney$music=="Randy Newman")
mg <- as.numeric(disney$music=="Michael Giacchino")
am <- as.numeric(disney$music=="Alan Menken")
jd <- as.numeric(disney$music=="John Debney")
hz <- as.numeric(disney$music=="Hans Zimmer")

#Actors
# Johnny Depp    Tim Allen    Tom Hanks  Jim Cummings  Nicolas Cage 
jdd <- as.numeric(disney$actor=="Johnny Depp")
th <- as.numeric(disney$actor=="Tom Hanks")
ta <- as.numeric(disney$actor=="Tim Allen")
jc <- as.numeric(disney$actor=="Jim Cummings")
nc <- as.numeric(disney$actor=="Nicolas Cage")

#----------(Inflation) Model 1 --------------
modsel_Inf <- regsubsets(Inflation_office ~ run_time + Inflation_budg + budget + 
                        imdb + metascore + rotten_tom + year + month +
                        g + pg + pg_13 + bvp + wds + wdsmp + bvpd + bvd +
                        jl + jas + jt + bb + gt + rw + mg + am + jd + hz + jdd 
                      + th + ta + jc + nc,disney,nbest=1)


vars<-summary(modsel_Inf)$which
vars
# R2a spot plot:
r2a <-  summary(modsel_Inf)$adjr2
r2a
plot(0:9,c(0,r2a),type="b",ylim=c(0,1),xlab="Number m of X's",ylab="Adjusted R2", main = "1st Subset Selection")
abline(h=c(0,1))

modsel_Inf <- lm(Inflation_office ~Inflation_budg+ metascore + rotten_tom + hz)
summary(disney)
#Elbow shows at 4 variables ( Inflation_budg, metascore, rotten_tom, hanz zimmer )
        #R2a = 0.6215402


#-------------Check for Quadratic terms--------

#Inflation buget
lin <- lm(Inflation_office ~ Inflation_budg + metascore + rotten_tom + hz)
x1 <- Inflation_budg
x2 <- Inflation_budg^2
quad <- lm(Inflation_office ~ metascore + rotten_tom + hz + x1 + x2)
anova(lin,quad)
#Linear

#meta score
quad <- lm(Inflation_office ~ Inflation_budg + poly(metascore,2,raw=TRUE) + rotten_tom + hz)
cube <- lm(Inflation_office ~ Inflation_budg + poly(metascore,3,raw=TRUE) + rotten_tom + hz)
anova(Inf_model, quad)
anova(quad,cube)
#add meta score^2


#Rotten tom
quad <- lm(Inflation_office ~ Inflation_budg + poly(rotten_tom,2,raw=TRUE) + metascore + hz)
cube <- lm(Inflation_office ~ Inflation_budg + poly(rotten_tom,3,raw=TRUE) + metascore + hz)
anova(Inf_model,quad)
anova(Inf_model,cube)
anova(quad,cube)
#add rotten tom^3


#--------Interactions -----------

#Interactions subgroups 

#Metascore and Inf Budg
meta_rot <- rotten_tom*metascore
mlr_int <- lm(Inflation_office ~ Inflation_budg*metascore + rotten_tom + hz)
anova(Inf_model, mlr_int)
#probability that interaction term is better EX:#We conclude that the relationship between mpg and weight depends on transmission
# type.
#Yes
#P = 0.01471


#Budget and Rotten Tom
meta_bug <- Inflation_budg*metascore
mlr_int <- lm(Inflation_office ~ Inflation_budg*rotten_tom + hz + metascore)
anova(Inf_model, mlr_int)
#Yes
# P= 0.01198

#Budget Imdb
mlr_int <- lm(Inflation_office ~ Inflation_budg*imdb + metascore + rotten_tom + hz)
anova(Inf_model, mlr_int)
#Yes
#P = 0.0009448

#MetaScore and Rotten Tom
mlr_int <- lm(Inflation_office ~ Inflation_budg + metascore*rotten_tom + hz)
anova(Inf_model, mlr_int)
#Yes
#p = 0.0001144

#Combination of the lowest p= scores
mlr_int <- lm(Inflation_office ~ Inflation_budg*imdb + metascore*rotten_tom + hz)
anova(Inf_model, mlr_int)
#P = 3.117e-05



#----------(Inflation) Model 2 -----------------
modsel_Inf2 <- regsubsets(Inflation_office ~ run_time + Inflation_budg + budget + 
                           imdb + poly(metascore,2,raw=TRUE)  + poly(rotten_tom,3,raw=TRUE) + 
                           Inflation_budg*imdb + metascore*rotten_tom + Inflation_budg*rotten_tom+ 
                            year + month + g + pg + pg_13 + bvp + wds + wdsmp + bvpd + bvd +
                           jl + jas + jt + bb + gt + rw + mg + am + jd + hz + jdd 
                         + th + ta + jc + nc,disney,nbest=1)
vars<-summary(modsel_Inf2)$which
vars
# R2a spot plot:
r2a <-  summary(modsel_Inf2)$adjr2
r2a
plot(0:9,c(0,r2a),type="b",ylim=c(0,1),xlab="Number m of X's",ylab="Adjusted R2", main = "2nd Subset Selection")
abline(h=c(0,1))

#Updated Model
modsel_Inf2 <- lm(Inflation_office ~ Inflation_budg:rotten_tom + poly(metascore, 2, raw = TRUE) + poly(rotten_tom, 3, raw = TRUE) + hz)
summary(modsel_Inf2)
#New R2a =0.665

anova(modsel_Inf,modsel_Inf2)

#---------Partial F test (Maybe require further testing and alterations)-------

# fit the larger/full model:
full_model <- Inf_model
# fit the smaller/null model:
null_model <- lm(Inflation_office ~ Inflation_budg + metascore + rotten_tom)
anova(null_model,full_model)
#Full model statistically significant

#---------Finding High Leverage points------

#Imdb and Metascore
mlr <- lm(Inflation_office ~ imdb + metascore)
h <- hatvalues(mlr)
hbar <- mean(h)
plot(imdb,metascore,pch=20)
high_lev <- which(h > 2*hbar)
points(distance[high_lev],stores[high_lev],cex=2,col="orange")
#No high leverage points


#Rotten Tomatoes and MetaScore
mlr <- lm(Inflation_office ~ rotten_tom + metascore)
h <- hatvalues(mlr)
hbar <- mean(h)
plot(rotten_tom,metascore,pch=20)
high_lev <- which(h > 2*hbar)
points(distance[high_lev],stores[high_lev],cex=2,col="orange")
#No high leverage points


#Rotten Tomatoes and Imdb
mlr <- lm(Inflation_office ~ rotten_tom + metascore)
h <- hatvalues(mlr)
hbar <- mean(h)
plot(rotten_tom,imdb,pch=20)
high_lev <- which(h > 2*hbar)
points(distance[high_lev],stores[high_lev],cex=2,col="orange")

#Imdb and Inflation Budget
mlr <- lm(Inflation_office ~ imdb + Inflation_budg)
h <- hatvalues(mlr)
hbar <- mean(h)
plot(imdb,Inflation_budg,pch=20)
high_lev <- which(h > 2*hbar)
disney[high_lev,]
points(distance[high_lev],stores[high_lev],cex=2,col="orange")
#No high leverage points

#No high leverage points

#------Leverage -------Removing High level
h <- hatvalues(modsel_Inf2)
hbar <- mean(h)
plot(imdb,Inflation_budg,pch=20)
high_lev <- which(h > 2*hbar)
disney[high_lev,]

points(disney$Inflation_budg[high_lev],Inflation_office[high_lev],cex=2,col="orange")

# ----- OUTLIERS (a.k.a. conditional Y outliers) -----


# get the studentized residuals:
E_star <- rstudent(modsel_Inf2)

# flag an observation as a (conditional Y) outlier if the studentized residual
# is bigger than 2 in magnitude:
y_out <- which(abs(E_star) > 2)
y_out
disney[y_out,]

#---------Influence----------

D <- cooks.distance(modsel_Inf2)

# flag the high Cook's distance observations:
k=7
summary(disney)
n=161
high_cook <- which(D > 4/(n-k-1))
high_cook
disney[high_cook,]

now <- disney[-high_cook,]
hz <- as.numeric(now$music=="Hans Zimmer")
attach(disney)
attach(now)

modsel_Inf2 <- lm(Inflation_office ~ Inflation_budg:rotten_tom + poly(metascore, 2, raw = TRUE) + poly(rotten_tom, 3, raw = TRUE) + hz)
modsel_Inf3 <- lm(Inflation_office ~ Inflation_budg:rotten_tom + poly(metascore, 2, raw = TRUE) + poly(rotten_tom, 3, raw = TRUE) + hz)
summary(modsel_Inf3)

anova(modsel_Inf2,modsel_Inf3)

# add a red C on the influential points:
points(year[high_cook],Inflation_office[high_cook],col="red",pch="C",cex=1.5)




