# create_db.py
import pandas as pd
import sqlite3
import os

# 设置路径
project_root = os.path.dirname(os.path.abspath(__file__))  # 当前脚本所在目录
data_dir = os.path.join(project_root, 'data')
db_path = os.path.join(data_dir, 'olist.db')

# 确保 data 目录存在
os.makedirs(data_dir, exist_ok=True)

# 定义所有 CSV 文件和对应的表名
csv_files = {
    'olist_customers_dataset': 'olist_customers_dataset.csv',
    'olist_geolocation_dataset': 'olist_geolocation_dataset.csv',
    'olist_order_items_dataset': 'olist_order_items_dataset.csv',
    'olist_order_payments_dataset': 'olist_order_payments_dataset.csv',
    'olist_order_reviews_dataset': 'olist_order_reviews_dataset.csv',
    'olist_orders_dataset': 'olist_orders_dataset.csv',
    'olist_products_dataset': 'olist_products_dataset.csv',
    'olist_sellers_dataset': 'olist_sellers_dataset.csv',
    'product_category_name_translation': 'product_category_name_translation.csv'
}

# 创建 SQLite 数据库
conn = sqlite3.connect(db_path)

print(f"🎉 开始创建数据库: {db_path}\n")

for table_name, csv_file in csv_files.items():
    file_path = os.path.join(data_dir, csv_file)
    if os.path.exists(file_path):
        print(f"📊 正在导入: {table_name} ...")
        df = pd.read_csv(file_path, encoding='utf-8')  # 防止中文乱码
        df.to_sql(table_name, conn, if_exists='replace', index=False)
        print(f"✅ 成功导入 {len(df)} 行数据到表 '{table_name}'\n")
    else:
        print(f"❌ 警告: {csv_file} 不存在，请检查路径\n")

print(f"🎉 数据库已成功生成: {db_path}")
print(f"🔍 可以在 DBeaver 或 VS Code 中连接: {db_path}")