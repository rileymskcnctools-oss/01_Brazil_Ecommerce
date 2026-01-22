#管理数据库连接 (engine) 和全局绘图配置
import pandas as pd
import matplotlib.pyplot as plt
import seaborn as sns
from matplotlib.font_manager import FontProperties
import os
from sqlalchemy import create_engine


# 1. 环境配置与字体修复 (关键步骤)
# ==========================================
# 统一数据库连接路径
conn = create_engine("sqlite:///../data/olist.db")
# 暴力指向 Windows 微软雅黑字体路径，解决白方块问题
font_path = 'C:/Windows/Fonts/msyh.ttc' 
if os.path.exists(font_path):
    prop = FontProperties(fname=font_path)
    # 设置全局默认字体名称
    plt.rcParams['font.sans-serif'] = [prop.get_name()] 
    plt.rcParams['axes.unicode_minus'] = False 
    print(f"✅ 字体加载成功: {prop.get_name()}")
else:
    print("❌ 未找到字体文件，请检查路径")