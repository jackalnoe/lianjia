library("xml2")

library("rvest")

library("dplyr")

library("stringr")

#对爬取页数进行设定并创建数据框

i<-1:100

house_inf<-data.frame()

#使用for循环进行批量数据爬取
citys = c('jianye','gulou','qinhuai','xuanwu','yuhuatai','qixia','jiangning','pukou','liuhe','lishui','gaochun')
for (j in citys){
url = str_c('http://nj.lianjia.com/ershoufang/',j)
for (i in 1:100){

web<- read_html(str_c(url,"/pg",i))

#定位节点信息并爬取房名

house_name<-web%>%html_nodes(".houseInfo a")%>%html_text()

#爬取二手房基本信息并消除空格

house_basic_inf<-web%>%html_nodes(".houseInfo")%>%html_text()
house_basic_inf<-str_replace_all(house_basic_inf," ","")
#将二手房基本信息按“|”分割
houseInfo<-strsplit(house_basic_inf, "[|]")
#提取二手房户型信息
zone<-unlist(lapply(houseInfo, function(houseInfo) houseInfo[2]))
#提取二手房面积信息
meters<-unlist(lapply(houseInfo, function(houseInfo) houseInfo[3]))
#提取二手房朝向信息
direction<-unlist(lapply(houseInfo, function(houseInfo) houseInfo[4]))
#提取二手房装修信息
decora<-unlist(lapply(houseInfo, function(houseInfo) houseInfo[5]))
#提取二手房电梯信息
Elevator<-unlist(lapply(houseInfo, function(houseInfo) houseInfo[6]))

#二手房位置信息
positionInfo<- web%>% html_nodes("div.positionInfo") %>% html_text()
#所在楼层
floor<-str_extract(positionInfo, "\\d+")
#建设年份
year<-str_extract(positionInfo, "[0-9]{4}")
#所在区域
region<-word(positionInfo,2,sep=fixed("-"))
#高中低楼层提取
floorh<-str_sub(positionInfo, 1, 3)
#str_extract_all(positionInfo,"\\[0-9]+")
#有无地铁
subway<- web%>% html_nodes("span.subway") %>% html_text()
#是否满5年
#taxfree<- web%>% html_nodes("span.taxfree") %>% html_text()
#总价
totalPrice<- str_extract(web%>% html_nodes("div.totalPrice") %>% html_text(), "\\d+")
#单价
unitPrice<- str_extract(web%>% html_nodes("div.unitPrice") %>% html_text(), "\\d+")

#创建数据框存储以上信息

house<-data.frame(house_name,zone,meters,direction,decora,Elevator,floor,year,floorh,totalPrice,unitPrice)

house_inf<-rbind(house_inf,house)
}
}

#将数据写入csv文档

write.csv(house_inf,file="D:/R/lianjia/house_inf1.csv")

