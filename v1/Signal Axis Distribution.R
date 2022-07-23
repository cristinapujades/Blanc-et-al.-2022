readdata = function(){
  setwd("G:/DATA/Analyzed v3/06-Quantification 02 2of4 min/Axis distribution/HuC x Vglut")
  file <- "DistributionVglut.xlsx"
  library(readxl)
  ddap <- read_excel(file, sheet = "AP",
                     col_names = FALSE)
  dddv <- read_excel(file, sheet = "DV",
                     col_names = FALSE)
  ddlml <- read_excel(file, sheet = "LML",
                     col_names = FALSE)
  return(list(dtap=ddap, dtdv=dddv, dtlml=ddlml))
}



Distribdt <- readdata()
names(Distribdt[["dtap"]]) <- c("slice", paste("E", 1:(ncol(Distribdt[["dtap"]])-1), sep=''))
names(Distribdt[["dtdv"]]) <- c("slice", paste("E", 1:(ncol(Distribdt[["dtdv"]])-1), sep=''))
names(Distribdt[["dtlml"]]) <- c("slice", paste("E", 1:(ncol(Distribdt[["dtlml"]])-1), sep=''))
# data cleaning
# 24hpf has E4 empty
#Distribdt[["dt24"]] = Distribdt[["dt24"]][,-5]

DistribdtRM <- lapply(Distribdt, 
                    function(dt){ dt[apply(dt, 1, function(x){!any(is.na(x))}),]
                    })

# put data in a two column format, Ratio and Slice
to_RS = function(dt){
  dt = unname(as.matrix(dt))
  rs = matrix(data=0, nrow=0, ncol=2)
  for (cc in 2:(ncol(dt))) {
    rs = rbind(rs, dt[,c(1,cc)], deparse.level = 0)    
  }
  rs=as.data.frame(rs, optional=TRUE, col.names =  c("Slice","Ratio"))
  colnames(rs) =  c("Slice","Ratio")
  rownames(rs) <- NULL
  return(rs)
}

# Pere Lopez suggestions:
# RS <- data.frame(Slice=rep(dt[,1], times=ncol(dt)-1), Ratio=unlist(dt[-1]))
# així si que funciona
# RS <- data.frame(Slice=unlist(rep(dt[,1], times=ncol(dt)-1)), Ratio=unlist(dt[-1]))
# library(reshape2)
# RS2 <- melt(dt, 1, value.name="Ratio")



RSdt = lapply(Distribdt, FUN=to_RS)


### I don't use fda right now
# library(fda.usc)
# 
# to_fdata=function(dt){
#   fd <- fdata(t(as.matrix(dt[,-1])),
#                argvals = dt$slice,
#                rangeval = range(dt[,1]),
#                names = list( main="phc AP", xlab = "Slice", ylab="Ratio"),
#                fdata2d = FALSE)
#   fd[5]<-"" # don't know why it gives an error otherwise
#   return(fd)
#   }
# 
# phc.fd = lapply(phcAPdt, FUN=to_fdata)
# phc.fd$dt24$names$main="24 hpf phc AP ratio"
# phc.fd$dt36$names$main="36 hpf phc AP ratio"
# phc.fd$dt48$names$main="48 hpf phc AP ratio"
# 
# phcRM.fd = lapply(phcAPdtRM, FUN=to_fdata)
# phcRM.fd$dt24$names$main="24 hpf phc AP ratio"
# phcRM.fd$dt36$names$main="36 hpf phc AP ratio"
# phcRM.fd$dt48$names$main="48 hpf phc AP ratio"
# 
# 
# 
# smooth by basis method

smoothBasis =
  function(dt, nBasis=13, type.basis = "bspline"){
    embasis7 <- create.fourier.basis(c(0,400), nbasis = nBasis)
    valsBasis <- eval.basis(seq(0,400), basisobj = embasis7) # dim 400 x nBasis
    dt.basis <- fdata2fd(dt, type.basis= type.basis, nbasis= nBasis)
    dtSm <- fdata(dt.basis, # $data
                  argvals = dt$argvals,
                  rangeval = range(dt$argvals),
                  names = dt$names)
    nr=nrow(dtSm$data)
    plot(dtSm, col=rainbow(nr), main = dt$names$main)
    for (li in 1:nr){
      lines(x=dtSm$argvals, y=dtSm$data[li,], col=rainbow(nr)[li])}
    lines(x=dtSm$argvals, y=apply(dtSm$data, 2, mean), lwd=3)
    return(dtSm)
  }

# Plot Regression + confidence interval + Data points

library(npregfast)
modap = frfast(RSdt$dtap$Ratio ~ RSdt$dtap$Slice, der=0, p=1)
summary(modap)
pdf("APRaw.pdf")
autoplot(modap, der=0, cex=0.2)
dev.off()

moddv = frfast(RSdt$dtdv$Ratio ~ RSdt$dtdv$Slice, der=0, p=1)
summary(moddv)
pdf("DVRaw.pdf")
autoplot(moddv, der=0, cex=0.2)
dev.off()

modlml = frfast(RSdt$dtlml$Ratio ~ RSdt$dtlml$Slice, der=0, p=1)
summary(modlml)
pdf("LMLRaw.pdf")
autoplot(modlml, der=0, cex=0.2)
dev.off()

# Plot Data + average + regression 

indPlot = function(dt, mod, tlab=""){
  plot(0, type="n", xlim=range(dt$slice), ylim=range(dt[,-1], na.rm = TRUE),
       main = paste(tlab, "Ratio vs slice for N =", ncol(dt)-1, "embryos"),
       xlab="slice", ylab="ratio")
  # points(phcAPdata[,c("slice", "E1")], col="red")
  for (i in 2:ncol(dt)) {
    lines(dt[,c(1, i)], col=hcl.colors(ncol(dt)-1)[i-1])
  }
  lines(mod$x, mod$p[,1,1], lty=1, lwd=2, col="blue")
  lines(x=dt$slice, y = apply(dt[,-1],1,function(x) mean(x,na.rm = TRUE)),
        lty=3, col="red")
  legend(x="topleft",
         legend=c(colnames(dt)[-1], "Average", "npFit"),
         text.col=c(hcl.colors(ncol(dt)-1), "red", "blue"))
}
pdf("AP.pdf")
indPlot(Distribdt$dtap, modap, tlab="AP")
dev.off()

pdf("DV.pdf")
indPlot(Distribdt$dtdv, moddv, tlab="DV")
dev.off()

pdf("LML.pdf")
indPlot(Distribdt$dtlml, modlml, tlab="LML")
dev.off()
