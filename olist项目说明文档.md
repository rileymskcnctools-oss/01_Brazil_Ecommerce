# 📑 Olist 跨境电商全链路分析项目白皮书

## 一、项目战略背景与核心逻辑

### 1. 项目概况

- **数据集**：巴西最大 Olist 平台真实脱敏数据（10万+ 订单）。
- **核心逻辑**：通过 **Python（模块化分析）** 定位业务瓶颈，再通过 **Power BI（动态看板）** 实现全链路监控，最终输出业务决策建议。
- **行业视角（面试亮点）**：结合半年**农具外贸经验**，将分析焦点锁定在 **Garden Tools（园林工具）**。该品类在巴西市场具有高 GMV 贡献但高物流复杂度的典型特征。

### 2. 模块化目录结构

- `config.py`：全局配置中心（DB 连接、可视化主题）。
- `sql_scripts/`：核心逻辑库，存储 DBeaver 调试通过的业务查询脚本。
- `01_order_funnel_analysis.ipynb`：订单生命周期漏斗，评估系统健康度。
- `02_review_logistic_analysis.ipynb`：用户满意度归因，定位物流时效对评分的冲击。
- `03_geo_logistics_analysis.ipynb`：巴西地域物流差异，定位“重灾区”州。
- `04_price_retention_analysis.ipynb`：价格敏感度与回购特征，识别高价值 VIP。
- `05_monthly_sales_analysis.ipynb`：营收波动因素拆解，识别季节性增长驱动力。

---

## 二、业务洞察与技术实现（Insights & Tech Stack）

### 1. 履约体验归因（满意度分析）

- **业务逻辑**：利用 `JULIANDAY` 计算送达耗时与预计耗时的偏差，量化物流延迟对评分的直接损伤。
- **技术重点**：利用 `ax1.twinx()` 实现双轴可视化，直观呈现“送达时间越长，评分跌落越快”的趋势。
- **⭐ 面试高频**：如何定义“物流延迟”？你是如何通过数据证明延迟与差评的相关性？

### 2. 地域物流排行榜（地理分析）

- **业务逻辑**：针对巴西 27 个州进行时效排名。发现北部（AP, RR）与经济中心（SP）存在 2–3 倍的物流鸿沟。
- **技术重点**：使用 `HAVING total_orders > 50` 剔除样本噪声，通过 `Reds_r` 颜色渐变实现风险预警可视化。

### 3. 用户回购与价值模型（RFM / Segmentation）

- **业务逻辑**：利用 `customer_unique_id` 穿透订单表，识别复购率。分析显示：**高频回购用户对低客单价商品表现出更强的消费粘性**。
- **技术重点**：SQL 多表下钻（`JOIN`）结合 Python 用户分层标签化（User Segmentation）。

---

## 三、Power BI 看板实战与排产逻辑

### 1. 为什么选择“园林工具”（Garden Tools）？

- **行业背景**：基于半年农具外贸经验，深知该类目在跨境运输中属于“大件/重货”，对物流极度敏感。
- **数据支撑**：在看板中发现 `garden_tools` GMV 贡献高达 **$485,256**，是平台的头部支柱。

### 2. 核心 KPI 看板（指标复盘）

- **GMV_Standard**：$485.256k（约 48.5 万美元）
- **Total_Orders**：99,441 笔订单
- **Avg_Review_Score**：4.09 分
- **Late_Order_Rate**：**7.87%**（风险指标）

---

## 四、核心技术排产与故障 Log（面试必杀技）

### 1. 建模技术点：雪花型模型（Snowflake Schema）

- **结构**：  
  `order_items`（事实表） ⟷ `products`（产品维度） ⟷ `product_category_name_translation`（翻译表）
- **⭐ 面试高频**：
  - 为什么要用翻译表？→ **处理多语言环境**
  - 为什么要设置双向筛选？→ **确保切片器能穿透不同层级的表**

### 2. 故障排查记录（Bug Log）

- **现象 1**：切片器不响应  
  **根源**：关联键存在隐藏空格  
  **解决**：在 Power Query 中执行 `TRIM()`，并在 Python 中用 `pd.merge()` 验证清洗效果

- **现象 2**：表格有数，卡片为空  
  **根源**：视觉对象级存在自相矛盾的筛选（如：`Price < [空白]`）  
  **解决**：重置 Filters 窗格，或将 Table 降级验证后重新转为 Card

#### 3. DAX 进阶公式

- **R值（最近购买天数）**:  
  ```dax
  DATEDIFF(MAX('orders'[purchase_date]), TODAY(), DAY)
* **GMV 占比**: `DIVIDE([GMV], CALCULATE([GMV], ALLSELECTED()))`


