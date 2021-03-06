library(gcookbook)
library(ggplot2)
library(magrittr)
library(dplyr)
library(tidyr)
library(maps)
library(igraph)
#製作簡單的資料(女生版1歲前身高曲線97分位) 
BabyGowth <- data.frame( 
  month = c(1, 2, 4, 6, 8, 10, 12), 
  height = c(57, 61, 67, 71, 74, 76, 79)) 
BabyGowth %>% ggplot(mapping = aes(month, height)) + 
  geom_line() + geom_point(size = 2.5, shape = 22, colour = "darkred", fill = "pink") +
  ylim(50,max(BabyGowth$height))

#條狀圖
BabyGowth %>% ggplot(mapping = aes(factor(month), height)) + 
  geom_bar(stat = "identity")

#總結牙齒成長紀錄(60筆彙總成6筆) 
tg1 <- ToothGrowth %>% group_by(supp, dose) %>% summarise(length = mean(len) )
#用給藥方式來畫線(colour) 
tg1 %>% ggplot(mapping = aes(dose, length, colour = supp)) +
  geom_line(linetype = "dashed", size = 2) +
  geom_point(shape = 22, size = 3, fill = "white")
tg2 <- ToothGrowth

#盒狀圖
tg2 %>% ggplot(mapping = aes(supp, len, fill = supp)) +
  geom_boxplot(width = .5) + 
  geom_dotplot(binaxis = "y", binwidth = .5, stackdir = "center")

#利用世紀帝國分數繪製山形圖
AoeStatistics <- data.frame( 
  ethnic = c("法蘭西", "匈奴", "土耳其", "中國", 
             "法蘭西", "匈奴", "土耳其", "中國",
             "法蘭西", "匈奴", "土耳其", "中國",
             "法蘭西", "匈奴", "土耳其", "中國"), 
  score = c(25, 25, 25, 25, 30, 20, 20, 30, 40, 10, 40, 10, 30, 0, 20, 50), 
  year = c(-3000, -3000, -3000, -3000, -1000, -1000, -1000, -1000, 0, 0, 0, 0, 500, 500, 500, 500))

AoeStatistics %>% ggplot(mapping = aes(year, score, fill = ethnic)) + 
  geom_area(colour = "black", size = .2, alpha = .4) + 
  scale_fill_brewer(palette = "Blues", breaks = rev(levels(AoeStatistics$ethnic))) +
  theme(text=element_text(family="黑體-繁 中黑", size=14))

#長條圖區塊顯示
df <- data.frame(x = seq(1:100), y = rnorm(100)*10)
df$pos <- df$y >= 0
df %>% ggplot(mapping = aes(x, y, fill = pos)) +
  geom_bar(stat = "identity", position = "identity")

#小提琴圖結合盒狀圖
heightweight %>% ggplot(mapping = aes(sex, heightIn)) +
  geom_violin(adjust = 1.4) + geom_boxplot(fill = "black", width = .1, outlier.colour = NA)

#鑽石品質顏色大小散布圖
diamonds %>% ggplot(mapping = aes(carat, price, colour = color, alpha = clarity)) +
  geom_point(size = .1) + facet_grid(cut~color)

#鑽石克拉數密度圖
diamonds %>% ggplot(mapping = aes(carat)) + 
  geom_density(colour = "#a0a0a0", fill = "#999999")

#鳶尾花2D密度圖
iris %>% ggplot(mapping = aes(Petal.Width, Petal.Length, colour = Species)) +
  geom_point() + geom_density2d()

#畫地圖
world_map = map_data("world")
ct <- c("Taiwan", "China")
chinese <- map_data("world", region = ct)
ch <- chinese %>% ggplot(mapping = aes(x = long, y = lat, group = group, fill = region)) + 
  geom_polygon(colour = "black") + 
  scale_fill_brewer(palette = "Set2") 

#人口>1e+城市式點
data("world.cities")
ch_cities <- world.cities %>% filter((capital == 1 | pop >= 1e+6) & country.etc %in% ct) 
ch_cities$group <- 1
ch_cities$region <- ch_cities$country.etc
ch + geom_point(aes(x = long, y = lat, size = pop), data = ch_cities, alpha = .7) 

# 網路圖
flightSchedule <- data.frame( 
  from = c("台北", "台中", "高雄", "台東", "台東"), 
  to   = c("台中", "高雄", "台東", "綠島", "台北")) 

gd <- graph.data.frame(flightSchedule) 
#directed = FALSE
plot(gd, family = "黑體-繁 中黑", layout = layout.fruchterman.reingold) 
#另一種寫法
#line <- c("台北", "台中", "台中", "高雄", "高雄", "台東", "台東", "綠島", "台東", "台北")
#gd <- graph(line)
#plot(gd, layout = layout.fruchterman.reingold) 

#madmen 關聯圖
g <- graph.data.frame(madmen, directed = FALSE)
par(mar = c(0, 0, 0, 0)) # Remove unnecessary margins
plot(g, layout = layout.circle, vertex.size = 8, vertex.label = NA)


