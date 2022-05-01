import pandas as pd
import numpy as np


def num_missing(x):
    return sum(x.isnull())


if __name__ == "__main__":
    # 读入数据
    data = pd.read_csv("train.csv", index_col="Date", header=None)

    # 是否存在缺失值:
    data.info()
    print("Missing values per column:")
    print(data.apply(num_missing, axis=0))  # axis=0代表函数应用于每一列
    print("nMissing values per row:")
    print(data.apply(num_missing, axis=1))  # axis=1代表函数应用于每一行

    # 缺失值删除
    data.dropna(how='any')

    # 对某列使用均值和中位数进行填充
    data['price'].fillna(data['price'].mean())
    data['price'].fillna(data['price'].median())

    # 保存文件
    data.to_csv("output.csv")
