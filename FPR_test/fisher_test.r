args<-commandArgs(T)
a<-read.table(args[1],as.is=T)
sum<-length(a[,1])
for (i in 1:sum){
  compare=matrix(c(ceiling(a[i,4]),ceiling(a[i,5]-a[i,4]),ceiling(a[i,7]),ceiling(a[i,8]-a[i,7])),2)
  p=fisher.test(compare,alternative = "less")$p.value
  cat(a[i,1],a[i,2],a[i,3],a[i,4],a[i,5],a[i,6],a[i,7],a[i,8],a[i,9],a[i,10],p,"\n",sep="\t")  
}

