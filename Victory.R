library(R2jags, quietly = TRUE)
load("~/Paleon/group/surface_pollen_data.Rdata")

clean_pollen <-surface_pollen[!is.na(surface_pollen[,10]),]

P_obs<-log(clean_pollen[,6])
V <-log(clean_pollen[,10])
n<-72

logit <- function(x) log(x/(1-x))
expit <- function(x) exp(x)/(1+exp(x))

arcticpollen<-function(){
  #(hyper) priors
  w ~ dunif(0, 100)
  beta0 ~ dnorm(0,.00001)
  beta1 ~ dnorm(0,.00001)
  
  #deterministic transformations
  w2Inv <- 1/(w^2)
  
  #latent process evoloution and likelihood
  for(i in 1:n){
    P_obs[i] ~ dnorm(beta0 + beta1*V[i], w2Inv)
  }
}




traceplot(out, mfrow = c(1, 3), ask = FALSE)


P_obs<-clean_pollen$shrub.total
V <-clean_pollen[,10]
n<-clean_pollen$site.total

arcticpollen<-'model{
#(hyper) priors
beta0 ~ dnorm(0,.00001)
beta1 ~ dnorm(0,.00001)


#latent process evoloution and likelihood
for(i in 1:72){
x[i] <- beta0+beta1*V[i]
p[i] <-  exp(x[i])/(1+exp(x[i])) 
P_obs[i] ~ dbin(p[i], n[i])
}
}'

out <- jags(data = list(P_obs = P_obs, n = n, V=V), parameters.to.save = c('beta0', 'beta1'), 
            n.thin = 1, n.chains = 3, n.iter = 1000, n.burnin = 0, model.file = arcticpollen, DIC = FALSE)



out <- jags.model(file=textConnection(arcticpollen),data = list(P_obs = P_obs, n = n, V=V),n.adapt = 1000,n.chains = 3)

coda<-coda.samples(model=out,variable.names= c('beta0', 'beta1'),n.iter = 1000)
gelman.diag(coda)

samples<-do.call(rbind,coda)
summary(samples)

P_obs<-pollen.all36[,41]
n<-pollen.all36[,42]

arcticpollen2<-'model{
#(hyper) priors

beta0 ~ dnorm(-0.6422,0.001010881)
beta1 ~ dnorm(0.01546,3.177496e-07)


#latent process evoloution and likelihood
for(i in 1:38){
V[i] ~ dunif(0,100)
x[i] <- beta0+beta1*V[i]
p[i] <-  exp(x[i])/(1+exp(x[i])) 
P_obs[i] ~ dbin(p[i], n[i])
}
}'


out <- jags.model(file=textConnection(arcticpollen2),data = list(P_obs = P_obs, n = n),n.adapt = 1000,n.chains = 3)

coda<-coda.samples(model=out,variable.names= c('V'),n.iter = 5000)
gelman.diag(coda)

#out <- jags(data = list(P_obs = P_obs, n = n), parameters.to.save = c('V'), 
#            n.thin = 1, n.chains = 3, n.iter = 1000, n.burnin = 0, model.file = arcticpollen2, DIC = FALSE)

# plot time series

samples<-do.call(rbind,coda)
means <- apply(samples, 2, mean)

quants<- apply(samples,2,quantile,c(.025,.975))
age36 <- arctic_pollen_data[[36]]$chronologies$`Neotoma 1`$age

plot(age36, means, main="Red Green Lake", xlab = 'age', ylab = 'Shrub Cover (%)' )
polygon(cbind(c(age36,rev(age36),1)), c(quants[1,],rev(quants[2,]), quants[1,1]),border=NA,col='lightblue')
lines(age36, means)
points(0,61, pch=8, cex=1.5, col = 'red' )
points(0,61, pch=20, cex=1.5, col = 'red' )
