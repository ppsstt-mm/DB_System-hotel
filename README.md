# DB_System-hotel

酒店管理数据库课程设计项目。系统以 MySQL 数据库设计为核心，通过 Spring Boot 后端、Vue 管理端和前台网页把客房、预订、入住、账单、房态、清扫、维修、统计视图和存储过程可视化展示出来。

## 项目结构

```text
hotel_management/
  back/       Spring Boot 后端
  front/      Vue 管理端
  docs/       数据库视图、业务说明与展示材料
  database/   数据库 SQL 导出文件
outputs/      展示介绍稿与答辩材料
database_course/ 课程设计过程文档
```

## 技术栈

- 后端：Spring Boot、MyBatis-Plus、Maven
- 前端：Vue、Element UI、Axios、ECharts
- 数据库：MySQL 8，包含基础表、视图、触发器、存储过程
- 运行环境：JDK 17、Node.js、npm、MySQL

## 数据库导入

数据库 SQL 位于：

```text
hotel_management/database/hotel_management.sql
```

导入示例：

```bash
mysql -uroot -p < hotel_management/database/hotel_management.sql
```

默认数据库名为 `hotel_management`。后端默认连接本机 MySQL：

```text
DB_URL=jdbc:mysql://127.0.0.1:3306/hotel_management...
DB_USERNAME=root
DB_PASSWORD=123456
```

也可以通过环境变量覆盖。

## 启动后端

```bash
cd hotel_management/back
mvn spring-boot:run
```

后端默认地址：

```text
http://localhost:8080/springbootb1g8z
```

## 启动管理端

```bash
cd hotel_management/front
npm install
npm run serve -- --port 8081
```

管理端默认地址：

```text
http://localhost:8081
```

## 演示账号

```text
管理员：admin / 123456
顾客：user1 / 123456
员工：EMP001 / 123456
```

## 主要展示点

- 订单预订业务线：房源检索、创建预订、支付、入住、退房、账单收款。
- 房态业务线：房间实体状态、批量房态调整、清扫任务、维修上报。
- 数据库视图：房源库存、订单明细、账单支付、月度营收、客户价值、员工绩效等。
- 存储过程：可用房检索、创建订单、入住确认、退房结算、账单收款、清扫维修、统计报表与考核生成。
