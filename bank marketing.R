head(bank)
data <- bank
bank_data <- bank
# Kiểm tra dữ liệu thiếu
colSums(is.na(data))
data <- na.omit(data)
install.packages("mice")
library(mice)
data <- mice(data, method = 'mean', m = 1)
# Boxplot cho các biến số lượng
boxplot(data$balance, main="Balance", ylab="Số dư")
boxplot(data$age, main="Age", ylab="Tuổi")
# Mở cửa sổ đồ thị lớn hơn
dev.new(width = 20, height = 15)
# Loại bỏ ngoại lai dựa trên khoảng dữ liệu
data <- data[data$balance < quantile(data$balance, 0.99), ]
# Mã hóa các biến phân loại
data$job <- as.factor(data$job)
data$marital <- as.factor(data$marital)
data$education <- as.factor(data$education)
data$contact <- as.factor(data$contact)
# Thống kê mô tả cho các biến số lượng
summary(data$balance)
summary(data$age)

# Vẽ biểu đồ phân phối
hist(data$age, main="Distribution of Age", xlab="Age", col="lightblue")
hist(data$balance, main="Distribution of Balance", xlab="Balance", col="lightgreen")

# Phân tích đơn biến
summary(data$deposit)

# Vẽ biểu đồ hộp
boxplot(data$duration, main="Duration of Last Contact", ylab="Seconds")

# Boxplot cho thời gian liên hệ cuối cùng
boxplot(data$duration, main="Boxplot of Duration", ylab="Duration (seconds)", col="orange")

# Boxplot cho số lần liên hệ
boxplot(data$campaign, main="Boxplot of Campaign Contacts", ylab="Number of Contacts", col="purple")
# Biểu đồ tần suất cho loại công việc
job_counts <- table(data$job)
barplot(job_counts, main="Frequency of Job Types", col="lightblue", xlab="Job Type", ylab="Frequency", las=2)

# Biểu đồ tần suất cho tình trạng hôn nhân
marital_counts <- table(data$marital)
barplot(marital_counts, main="Frequency of Marital Status", col="lightgreen", xlab="Marital Status", ylab="Frequency", las=2)
# Ma trận tương quan cho các biến số lượng
correlation_matrix <- cor(data[, sapply(data, is.numeric)])
heatmap(correlation_matrix, main="Heatmap of Correlation", col=heat.colors(10))

# Tạo biểu đồ tần suất cho từng biến phân loại
categorical_vars <- c("job", "marital", "education", "default", "housing", "loan", "contact")

par(mfrow = c(3, 3)) # Chia ô cho các biểu đồ

for (var in categorical_vars) {
  barplot(table(data[[var]]), 
          main = paste("Tần suất cho biến:", var),
          xlab = var,
          ylab = "Tần suất",
          col = "lightblue",
          las = 2) 
}

# Tạo biểu đồ histogram cho các biến số lượng
numerical_vars <- c("age", "balance", "duration", "campaign", "pdays")

par(mfrow = c(3, 2)) # Chia ô cho các biểu đồ

for (var in numerical_vars) {
  hist(data[[var]], 
       main = paste("Histogram cho biến:", var),
       xlab = var,
       ylab = "Tần suất",
       col = "lightgreen", 
       breaks = 20) # Số lượng các thanh trong histogram
}

# Hồi quy logistic
model <- glm(deposit ~ age + balance + duration + campaign, family = binomial, data = data)
summary(model)

# Tạo biểu đồ tần suất cho từng biến phân loại theo biến deposit
categorical_vars <- c("job", "marital", "education", "default", "housing", "loan", "contact")

par(mfrow = c(3, 3)) # Chia ô cho các biểu đồ

for (var in categorical_vars) {
  barplot(table(data[[var]], data$deposit), 
          main = paste("Tần suất cho biến:", var, "theo Deposit"),
          xlab = var,
          ylab = "Tần suất",
          col = c("lightblue", "orange","black","lightgreen","purple","pink","red"),
          legend = TRUE,
          beside = TRUE) # beside = TRUE để vẽ các thanh cạnh nhau
}



# Tạo biểu đồ histogram cho các biến số lượng theo biến deposit
numerical_vars <- c("age", "balance", "duration", "campaign", "pdays")

par(mfrow = c(3, 2)) # Chia ô cho các biểu đồ

for (var in numerical_vars) {
  hist(data[[var]][data$deposit == "yes"], 
       main = paste("Histogram cho", var, "khi Deposit = Yes"),
       xlab = var,
       ylab = "Tần suất",
       col = "lightgreen", 
       breaks = 20)
  
  hist(data[[var]][data$deposit == "no"], 
       main = paste("Histogram cho", var, "khi Deposit = No"),
       xlab = var,
       ylab = "Tần suất",
       col = "lightcoral", 
       breaks = 20, add = TRUE)
  
  legend("topright", legend = c("Deposit = Yes", "Deposit = No"), fill = c("lightgreen", "lightcoral"))
}

# Kiểm tra giá trị của biến deposit
table(data$deposit)
# Kiểm tra giá trị và kiểu dữ liệu của các biến số lượng
# Tạo biểu đồ histogram cho các biến số lượng theo biến deposit
numerical_vars <- c("age", "balance", "duration", "campaign", "pdays")

par(mfrow = c(3, 2)) # Chia ô cho các biểu đồ

for (var in numerical_vars) {
  if (sum(!is.na(data[[var]])) > 0) {  # Kiểm tra xem biến có dữ liệu không
    # Vẽ histogram cho nhóm deposit = 1
    hist(data[[var]][data$deposit == 1], 
         main = paste("Histogram cho", var, "khi Deposit = 1"),
         xlab = var,
         ylab = "Tần suất",
         col = "lightgreen", 
         breaks = 20, 
         xlim = range(data[[var]], na.rm = TRUE)) # Đặt giới hạn trục x
    
    # Vẽ histogram cho nhóm deposit = 0
    hist(data[[var]][data$deposit == 0], 
         main = paste("Histogram cho", var, "khi Deposit = 0"),
         xlab = var,
         ylab = "Tần suất",
         col = "lightcoral", 
         breaks = 20, 
         xlim = range(data[[var]], na.rm = TRUE), 
         add = TRUE) # Thêm histogram cho deposit = 0 vào cùng một biểu đồ
    
    # Thêm chú thích
    legend("topright", legend = c("Deposit = 1", "Deposit = 0"), fill = c("lightgreen", "lightcoral"))
  } else {
    warning(paste("Biến", var, "không có dữ liệu để vẽ histogram."))
  }
}

# Mô hình hồi quy logistic với các biến độc lập
model <- glm(deposit ~ age + balance + duration + campaign + job + marital, family = binomial, data = data)

# Xem kết quả mô hình
summary(model)

# Lập mô hình hồi quy logistic
model <- glm(deposit ~ age + job + marital + education + default + balance + housing + loan + contact + day + month + duration + campaign + pdays + previous + poutcome, 
             data = data, 
             family = binomial)

# Tóm tắt mô hình
summary_model <- summary(model)

# Lấy thông tin từ mô hình
coefficients <- summary_model$coefficients

# Chọn biến có giá trị p nhỏ hơn 0.05
significant_vars <- coefficients[coefficients[, 4] < 0.05, ]

# Tạo bảng kết quả
result_table <- data.frame(
  Variable = rownames(significant_vars),
  Coefficient = significant_vars[, 1],
  P_Value = significant_vars[, 4]
)

# Thêm cột "Significant"
result_table$Significant <- ifelse(result_table$P_Value < 0.05, "Yes", "No")

# Hiển thị bảng kết quả
print(result_table)

# Lấy thông tin từ mô hình
coefficients <- summary_model$coefficients

# Chọn biến định lượng
quantitative_vars <- c("age", "balance", "duration", "campaign", "pdays")

# Lọc các biến định lượng có giá trị p nhỏ hơn 0.05
significant_quantitative_vars <- coefficients[rownames(coefficients) %in% quantitative_vars & coefficients[, 4] < 0.05, ]

# Tạo bảng kết quả
quantitative_result_table <- data.frame(
  Variable = rownames(significant_quantitative_vars),
  Coefficient = significant_quantitative_vars[, 1],
  P_Value = significant_quantitative_vars[, 4]
)

# Thêm cột "Significant"
quantitative_result_table$Significant <- ifelse(quantitative_result_table$P_Value < 0.05, "Yes", "No")

# Hiển thị bảng kết quả
print(quantitative_result_table)

# Tạo một dataframe với các giá trị khác nhau cho age, balance, duration, campaign, pdays
new_data <- expand.grid(
  age = seq(18, 90, by = 5),            # Giới hạn tuổi từ 18 đến 90 với bước nhảy 5
  balance = seq(0, 5000, by = 500),     # Số dư từ 0 đến 5000 với bước nhảy 500
  duration = seq(0, 3000, by = 500),    # Thời gian liên hệ từ 0 đến 3000 giây
  campaign = seq(1, 10, by = 1),        # Số lần liên hệ từ 1 đến 10
  pdays = seq(-1, 30, by = 5)           # Số ngày kể từ lần liên hệ trước đó từ -1 đến 30
)

# Hiển thị các giá trị trong new_data
head(new_data)

# Dự đoán xác suất gửi tiền cho từng khách hàng trong new_data
new_data$predicted_prob <- predict(model, newdata = new_data, type = "response")

# Hiển thị các kết quả dự đoán
head(new_data)

# Tạo dataframe mới với các giá trị khác nhau cho các biến số lượng
new_data <- expand.grid(
  age = seq(18, 90, by = 5),
  balance = seq(0, 5000, by = 500),
  duration = seq(0, 3000, by = 500),
  campaign = seq(1, 10, by = 1),
  pdays = seq(-1, 30, by = 5),
  job = c("admin.", "technician", "services", "management", "blue-collar", "student") # Thêm các giá trị mẫu cho job
)
# Chuyển đổi các biến phân loại sang dạng số
new_data <- model.matrix(~ job + age + balance + duration + campaign + pdays, data = new_data)[,-1]

# Dự đoán xác suất gửi tiền cho từng khách hàng trong new_data
new_data$predicted_prob <- predict(model, newdata = new_data, type = "response")

# Hiển thị các kết quả dự đoán
head(new_data)

# Tạo dataframe mới với các giá trị khác nhau cho các biến số lượng và một số giá trị mẫu cho biến phân loại
new_data <- expand.grid(
  age = seq(18, 90, by = 5),
  balance = seq(0, 5000, by = 500),
  duration = seq(0, 3000, by = 500),
  campaign = seq(1, 10, by = 1),
  pdays = seq(-1, 30, by = 5),
  job = c("admin.", "technician", "services", "management", "blue-collar", "student")  # Thêm các giá trị mẫu cho job
)

# Chuyển đổi các biến phân loại sang dạng số bằng One-Hot Encoding
new_data_matrix <- model.matrix(~ job + age + balance + duration + campaign + pdays, data = new_data)

# Chuyển đổi ma trận về dạng dataframe
new_data_df <- as.data.frame(new_data_matrix)

# Dự đoán xác suất gửi tiền cho từng khách hàng trong new_data_df
new_data_df$predicted_prob <- predict(model, newdata = new_data_df, type = "response")

# Hiển thị các kết quả dự đoán
head(new_data_df)

install.packages("caret")
library(caret)
confusionMatrix(predict(model, age), data$deposit)
install.packages("randomForest")
library(randomForest)
set.seed(123)
rf_model <- randomForest(deposit ~ ., data = bank_data, importance = TRUE)
importance(rf_model)
varImpPlot(rf_model)

cor_matrix <- cor(numeric_data, method = "pearson")
corrplot(cor_matrix, method = "color")

# Thư viện ggplot2
library(ggplot2)

# Chuyển poutcome và deposit thành factor nếu chúng chưa là factor
data$poutcome <- as.factor(data$poutcome)
data$deposit <- as.factor(data$deposit)

# Tạo biểu đồ thể hiện mối quan hệ giữa poutcome và deposit
ggplot(data, aes(x = poutcome, fill = deposit, group = deposit)) +
  geom_bar(position = "fill") +  # Dùng geom_bar với position="fill" để biểu diễn tỷ lệ
  theme(axis.text.x = element_text(angle = 45, hjust = 1)) +  # Xoay nhãn trục x
  ggtitle("Relationship between Previous Campaign Outcome (poutcome) and Deposit Subscription") +  # Tiêu đề
  xlab("Outcome of Previous Campaign (poutcome)") +  # Nhãn trục x
  ylab("Proportion")  # Nhãn trục y

# Chuyển biến deposit thành nhị phân (0: no, 1: yes)
data$deposit_binary <- ifelse(data$deposit == "yes", 1, 0)

# Chọn các biến số
numeric_data <- data[, sapply(data, is.numeric)]

# Tính ma trận tương quan
cor_matrix <- cor(numeric_data, use = "complete.obs")

# Xem mối tương quan giữa các biến số và deposit
cor_matrix["deposit_binary", ]

# Cài đặt gói randomForest nếu chưa có
# install.packages("randomForest")

# Thư viện
library(randomForest)

# Xây dựng mô hình Random Forest
rf_model <- randomForest(deposit ~ ., data = data, importance = TRUE)

# Hiển thị tầm quan trọng của các biến
importance(rf_model)

# Biểu diễn tầm quan trọng của các biến bằng biểu đồ
varImpPlot(rf_model)
cor_matrix <- cor(numeric_data, method = "pearson")
corrplot(cor_matrix, method = "color")
# Kiểm tra phương sai của các biến số
apply(numeric_data, 2, var)

# Lọc các biến có phương sai bằng 0
zero_variance_vars <- apply(numeric_data, 2, function(x) var(x) == 0)
# Loại bỏ các biến có phương sai bằng 0
numeric_data_clean <- numeric_data[, !zero_variance_vars]

# Tính lại ma trận tương quan
cor_matrix <- cor(numeric_data_clean, use = "complete.obs")
# Tính toán ma trận tương quan cho dữ liệu đã loại bỏ các biến có phương sai bằng không
cor_matrix <- cor(numeric_data_clean, use = "complete.obs", method = "pearson")

# Kiểm tra kết quả
cor_matrix["deposit_binary", ]

# Kiểm định Chi-square giữa biến job và deposit
chisq_test <- chisq.test(table(data$job, data$deposit))
chisq_test

# Chuyển đổi các biến phân loại thành kiểu factor
data$job <- as.factor(data$job)
data$marital <- as.factor(data$marital)
data$education <- as.factor(data$education)
data$default <- as.factor(data$default)
data$housing <- as.factor(data$housing)
data$loan <- as.factor(data$loan)
data$contact <- as.factor(data$contact)
data$month <- as.factor(data$month)
data$poutcome <- as.factor(data$poutcome)

# Nếu có biến khác là phân loại, bạn cũng nên chuyển đổi chúng thành factor
# Ví dụ:
data$some_other_variable <- as.factor(data$some_other_variable) # Thay thế bằng tên biến thực tế
# Xây dựng mô hình hồi quy logistic
logistic_model <- glm(deposit ~ ., data = data, family = "binomial")

# Xem kết quả hồi quy
summary(logistic_model)


# Chuyển đổi các biến phân loại sang dạng factor
bank$job <- as.factor(bank$job)
bank$marital <- as.factor(bank$marital)
bank$education <- as.factor(bank$education)
bank$default <- as.factor(bank$default)
bank$housing <- as.factor(bank$housing)
bank$loan <- as.factor(bank$loan)
bank$contact <- as.factor(bank$contact)
bank$month <- as.factor(bank$month)
bank$poutcome <- as.factor(bank$poutcome)
bank$deposit <- as.factor(bank$deposit)
bank$age <- as.factor(bank$age)
bank$balance <- as.factor(bank$balance)
bank$duration <- as.factor(bank$duration)
bank$campaign <- as.factor(bank$campaign)
# Kiểm tra số lượng hàng và cột trong dữ liệu
nrow(bank)
ncol(bank)

# Kiểm tra các giá trị bị thiếu
summary(bank)
# Loại bỏ các hàng có giá trị bị thiếu
bank <- na.omit(bank)

# Chia dữ liệu thành tập huấn luyện (70%) và kiểm tra (30%)
set.seed(123)  # Đặt seed để đảm bảo kết quả có thể lặp lại
sample_size <- floor(0.7 * nrow(bank))

train_index <- sample(seq_len(nrow(bank)), size = sample_size)

# Chia dữ liệu thành tập huấn luyện và kiểm tra
train_data <- bank[train_index, ]
test_data <- bank[-train_index, ]
# Xây dựng mô hình Random Forest
rf_model <- randomForest(deposit ~ ., data = train_data, importance = TRUE, ntree = 100)

# Xem kết quả của mô hình
print(rf_model)

# Dự đoán trên tập kiểm tra
predictions <- predict(rf_model, newdata = test_data)

# Ma trận nhầm lẫn (Confusion Matrix)
confusion_matrix <- table(predictions, test_data$deposit)
print(confusion_matrix)

# Tính độ chính xác
accuracy <- sum(predictions == test_data$deposit) / nrow(test_data)
print(paste("Độ chính xác của mô hình: ", round(accuracy * 100, 2), "%"))

# Xem mức độ quan trọng của các biến
var_importance <- importance(rf_model)
print(var_importance)

# Vẽ biểu đồ tầm quan trọng của các biến
varImpPlot(rf_model)

# Install the necessary package if you haven't
install.packages("randomForest")

# Load libraries
library(randomForest)

# Define features and target
features <- bank[, c("age", "balance", "duration", "campaign", "previous", "job", "marital", "education", "contact", "day_of_week", "poutcome")]
target <- bank$deposit

# Fit the Random Forest model
set.seed(123)  # for reproducibility
rf_model <- randomForest(features, target, ntree = 100, importance = TRUE)

bank_filtered <- bank_data_filtered

# Tải gói dplyr để dễ dàng xử lý dữ liệu
# install.packages("dplyr")
library(dplyr)

# Giả sử bạn đã tải dữ liệu từ 'bank.csv'
# bank_data <- read.csv("bank.csv")

# Bước 1: Hàm để lọc outlier bằng IQR cho một cột
filter_outliers_IQR <- function(df, column) {
  Q1 <- quantile(df[[column]], 0.25, na.rm = TRUE)
  Q3 <- quantile(df[[column]], 0.75, na.rm = TRUE)
  IQR_value <- Q3 - Q1
  
  lower_bound <- Q1 - 1.5 * IQR_value
  upper_bound <- Q3 + 1.5 * IQR_value
  
  # Lọc các hàng nằm trong khoảng [Q1 - 1.5*IQR, Q3 + 1.5*IQR]
  df_filtered <- df %>%
    filter(df[[column]] >= lower_bound & df[[column]] <= upper_bound)
  
  return(df_filtered)
}

# Bước 2: Áp dụng hàm này cho các biến định lượng bạn quan tâm
variables <- c("age", "balance", "duration", "campaign", "day","pdays","previous")

# Lặp qua từng biến định lượng và lọc outliers
for (var in variables) {
  bank_data <- filter_outliers_IQR(bank_data, var)
}

# In ra dữ liệu đã lọc outliers
print(bank_data)
write.csv(bank_data, "bank_data_filtered.csv", row.names = FALSE)
write.csv(bank_data, "C:\ Users\ SAMSUNG\ OneDrive - National Economics University\ Documents\ bank_data_filtered.csv", row.names = FALSE)
