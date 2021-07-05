# To add a new cell, type '# %%'
# To add a new markdown cell, type '# %% [markdown]'
# %%
import pandas as pd
import numpy as np
import re
import statsmodels.api as sm
import matplotlib.pyplot as plt
import finance_byu.rolling as rolling

import glob

#%%

# %%
def convert_ar_characters(input_str):

    mapping = {
        "ك": "ک",
        "گ": "گ",
        "دِ": "د",
        "بِ": "ب",
        "زِ": "ز",
        "ذِ": "ذ",
        "شِ": "ش",
        "سِ": "س",
        "ى": "ی",
        "ي": "ی",
    }
    return _multiple_replace(mapping, input_str)


def _multiple_replace(mapping, text):
    pattern = "|".join(map(re.escape, mapping.keys()))
    return re.sub(pattern, lambda m: mapping[m.group()], str(text))


def vv(row):
    X = row.split("-")
    return X[0] + X[1] + X[2]


def DriveYearMonthDay(d):
    d["jalaliDate"] = d["jalaliDate"].astype(str)
    d["Year"] = d["jalaliDate"].str[0:4]
    d["Month"] = d["jalaliDate"].str[4:6]
    d["Day"] = d["jalaliDate"].str[6:8]
    d["jalaliDate"] = d["jalaliDate"].astype(int)
    return d


# %%
path = r"G:\Economics\Finance(Prof.Heidari-Aghajanzadeh)\Data\PriceLimit"
n1 = path + "\Stocks_Holders_1396.csv"
n2 = path + "\Stocks_Holders_1397.csv"
n3 = path + "\Stocks_Holders_1398.csv"
n4 = path + "\Stocks_Holders_1399-07-27_From99.csv"
n5 = path + "\Stocks_Prices_1400-02-07.parquet"
n6 = path + "\\InsInd_1399-05-09" + ".csv"
n7 = path + "\Stocks_Holders_From96.csv"
n8 = path + "\Stocks_Holders_From97.csv"
n9 = path + "\Stocks_Holders_From98.csv"
n10 = path + "\Stocks_Holders_1399-10-20_From99.csv"


# %%
df6 = pd.read_csv(n6)
df6 = df6[~df6["ind_sell_volume"].isnull()].rename(
    columns={"ID": "stock_id", "Date": "date"}
)
df6["date"] = df6["date"].apply(vv)
df6["date"] = df6["date"].astype(int)
df6 = df6.drop(columns=["Name", "Unnamed: 0"])
df6.head()


# %%
df1 = pd.read_csv(n1)
df2 = pd.read_csv(n2)
df3 = pd.read_csv(n3)
df4 = pd.read_csv(n4)
df7 = pd.read_csv(n7)
df8 = pd.read_csv(n8)
df9 = pd.read_csv(n9)
df10 = pd.read_csv(n10)

df = pd.DataFrame()
for i in [df1, df2, df3, df4, df7, df8, df9, df10]:
    df = df.append(i)
df = (
    df[
        [
            "name",
            "date",
            "jalaliDate",
            "group_name",
            "PriceMaxLimit",
            "PriceMinLimit",
            "name",
            "Total",
            "close_price",
        ]
    ]
    .drop_duplicates()
    .reset_index(drop=True)
)
df = df.loc[:, ~df.columns.duplicated(keep="first")]
all = glob.glob(
    r"G:\Economics\Finance(Prof.Heidari-Aghajanzadeh)\Data\Stocks_Holders\*.csv"
)
number = 0
for i in all:
    number += 1
    print(number, len(all) + 1)
    tempt = pd.read_csv(i)
    try:
        t = tempt[
            [
                "name",
                "date",
                "jalaliDate",
                "group_name",
                "PriceMaxLimit",
                "PriceMinLimit",
                "Total",
                "close_price",
            ]
        ]
        df = df.append(t)
    except:
        continue
# %%
print(len(df))
df = df.drop_duplicates(subset=["name", "date"])
print(len(df))
pdf = pd.read_parquet(n5)

for col in ["name", "group_name"]:
    print("1")
    #     df6[col] = df6[col].apply(lambda x: convert_ar_characters(x))
    print("2")
    df[col] = df[col].apply(lambda x: convert_ar_characters(x))
    print("3")
    pdf[col] = pdf[col].apply(lambda x: convert_ar_characters(x))


# %%
print(len(df))
df = df.drop_duplicates(subset=["name", "date"])
print(len(df))
len(set(df.name)), len(set(pdf.name))


# %%
pdf.jalaliDate.iloc[-1]


# %%
symbols = [
    "سپرده",
    "هما",
    "وهنر-پذیره",
    "نکالا",
    "تکالا",
    "اکالا",
    "توسعه گردشگری ",
    "وآفر",
    "ودانا",
    "نشار",
    "نبورس",
    "چبسپا",
    "بدکو",
    "چکارم",
    "تراک",
    "کباده",
    "فبستم",
    "تولیددارو",
    "قیستو",
    "خلیبل",
    "پشاهن",
    "قاروم",
    "هوایی سامان",
    "کورز",
    "شلیا",
    "دتهران",
    "نگین",
    "کایتا",
    "غیوان",
    "تفیرو",
    "سپرمی",
    "بتک",
    "آبفا اصفهان",
]
df = df.drop(df[df["name"].isin(symbols)].index)
df = df.drop(
    df[
        (
            (df.close_price == 10000.0)
            | (df.close_price == 1000.0)
            | (df.close_price == 5000.0)
            | (df.close_price == 100.0)
            | (df.close_price == 10.0)
        )
        & (df.volume < 1)
    ].index
)
df = df.drop(df[df["name"].isin(symbols)].index)
df = df.drop(df[df.group_name == "صندوق سرمایه گذاری قابل معامله"].index)
df = df.drop(df[(df.name == 'اتکای')&(df.close_price == 1000)].index)
df = df.drop_duplicates()


pdf = pdf.drop(pdf[pdf["name"].isin(symbols)].index)
pdf = pdf.drop(pdf[pdf.group_name == "صندوق سرمایه گذاری قابل معامله"].index)
pdf = pdf.drop(pdf[(pdf.name == "اتکای") & (pdf.close_price == 1000)].index)
pdf = pdf.drop_duplicates()

pdf.jalaliDate = pdf.jalaliDate.apply(vv)


# %%
pdf = pdf[
    [
        "jalaliDate",
        "stock_id",
        "date",
        "name",
        "group_name",
        "baseVol",
        "max_price",
        "min_price",
        "close_price",
        "last_price",
        "open_price",
        "value",
        "volume",
        "quantity",
    ]
].sort_values(by=["name", "date"])


# %%


# %%
path2 = r"G:\Economics\Finance(Prof.Heidari-Aghajanzadeh)\Data"
index = pd.read_excel(path2 + "\IRX6XTPI0009.xls")[["<COL14>", "<CLOSE>"]].rename(
    columns={"<COL14>": "jalaliDate", "<CLOSE>": "Index"}
)
index["Market_return"] = index["Index"].pct_change(periods=1) * 100
index = DriveYearMonthDay(index)
pdf.jalaliDate = pdf.jalaliDate.astype(int)
index = index[index.jalaliDate >= pdf.jalaliDate.min()]
n = r"G:\Economics\Finance(Prof.Heidari-Aghajanzadeh)\Data" + "\RiskFree.xlsx"
rf = pd.read_excel(n)
rf = rf.rename(columns={"Unnamed: 2": "Year"})
rf["YM"] = rf["YM"].astype(str)
rf["YM"] = rf["YM"] + "00"
rf["YM"] = rf["YM"].astype(int)
index["RiskFree"] = np.nan
index["jalaliDate"] = index["jalaliDate"].astype(int)
for i in rf.YM:
    index.loc[index.jalaliDate >= i, "RiskFree"] = (
        rf.loc[rf["YM"] == i].iloc[0, 1] / 356
    )


# %%
pdf = DriveYearMonthDay(pdf)
pdf = (
    pdf.merge(index, on=["jalaliDate", "Year", "Month", "Day"])
    .sort_values(by=["name", "jalaliDate"])
    .dropna()
)
pdf = pdf[pdf.volume != 0]
pdf["date"] = pdf.date.astype(int)
pdf = pdf[pdf.date >= df.date.min()]
df["jalaliDate"] = df["jalaliDate"].apply(vv)
df["jalaliDate"] = df["jalaliDate"].astype(int)


# %%

data = (
    df.merge(pdf, on=["name", "jalaliDate", "date", "group_name"], how="right")
).sort_values(by=["name", "date"])
#%%
data = data.drop(data[data.volume == 0].index)
gg = data.groupby(["name"])
data["Total"] = gg["Total"].fillna(method="ffill")
data["close_price"] = data.close_price.astype(float)
data["MarketCap"] = data["close_price"] * data["Total"]
m = data.groupby(["date"])["MarketCap"].sum().to_frame().reset_index()

date = list(m.date)
Cap = list(m.MarketCap)
mapingdict = dict(zip(date, Cap))
data["TotalCap"] = data["date"].map(mapingdict)
data["MarketRatio"] = data["MarketCap"] / data["TotalCap"]
gg = data.groupby(["name"])
data["YesterdayPrice"] = gg["close_price"].shift(periods=1)
data["YesterdayLastPrice"] = gg["last_price"].shift(periods=1)
data["YesterdayOpenPrice"] = gg["open_price"].shift(periods=1)

data["TomorrowClosePrice"] = gg["close_price"].shift(periods=-1)
data["TomorrowLastPrice"] = gg["last_price"].shift(periods=-1)
data["TomorrowOpenPrice"] = gg["open_price"].shift(periods=-1)

data["Limit"] = (data["PriceMaxLimit"].divide(data["YesterdayPrice"]) - 1) * 100


data["Limit"] = data["Limit"].round(2)
data["LimitGroup"] = np.nan
data.loc[(abs(data["Limit"]) <= 1), "LimitGroup"] = 1
data.loc[(abs(data["Limit"]) > 1), "LimitGroup"] = 3
data.loc[(abs(data["Limit"]) > 3), "LimitGroup"] = 4
data.loc[(abs(data["Limit"]) > 4), "LimitGroup"] = 5
data.loc[(abs(data["Limit"]) > 5), "LimitGroup"] = 10
data.loc[(abs(data["Limit"]) > 10), "LimitGroup"] = 0


# %%
len(data)


# %%
data = data.dropna()
len(data)


# %%
len(set(data.name))


# %%
symbols = list(set(data.name))
ids = list(range(len(symbols)))
mapingdict = dict(zip(symbols, ids))
data["id"] = data["name"].map(mapingdict)

data["jalaliDate"] = data["jalaliDate"].astype(int)
Dates = list(set(data.jalaliDate))
time = list(range(len(Dates)))
mapingdict = dict(zip(sorted(Dates), time))
data["t"] = data["jalaliDate"].map(mapingdict)


groups = list(set(data.group_name))
ids = list(range(len(groups)))
mapingdict = dict(zip(groups, ids))
data["g_id"] = data["group_name"].map(mapingdict)

data = data.drop_duplicates(["id", "t"])

data = data[data.open_price != 0]
data = data[data.volume != 0]

data["Close/Open"] = (
    (data["close_price"].divide(data["open_price"]) - 1) * 100
).astype(float)
data["Last/Open"] = ((data["last_price"].divide(data["open_price"]) - 1) * 100).astype(
    float
)
data["ClosetoOpen"] = (
    (data["TomorrowOpenPrice"].divide(data["close_price"]) - 1) * 100
).astype(float)
data["TomorrowOpen/last"] = (
    (data["TomorrowOpenPrice"].divide(data["last_price"]) - 1) * 100
).astype(float)
data["TomorrowLast/TomorrowOpen"] = (
    (data["TomorrowLastPrice"].divide(data["TomorrowOpenPrice"]) - 1) * 100
).astype(float)
data["OpentoClose"] = (
    (data["TomorrowClosePrice"].divide(data["TomorrowOpenPrice"]) - 1) * 100
).astype(float)
data["Turn"] = data["value"] / data["MarketCap"]
data["Open/Yclose"] = (
    (data["open_price"].divide(data["YesterdayPrice"]) - 1) * 100
).astype(float)
data["Open/YLast"] = (
    (data["open_price"].divide(data["YesterdayLastPrice"]) - 1) * 100
).astype(float)
data["YClose/YOpen"] = (
    (data["YesterdayPrice"].divide(data["YesterdayOpenPrice"]) - 1) * 100
).astype(float)


def divide_to_mean(g):
    print(g.name, end="\r", flush=True)
    g = g / g.rolling(60, 1).mean()
    return g


tdata = pd.DataFrame()
tdata = tdata.append(data)
tdata["RelTurn"] = np.nan
gg = tdata.groupby(["name"])

tdata["RelTurn"] = gg["Turn"].apply(divide_to_mean)
data = pd.DataFrame()
data = data.append(tdata)
del tdata

data["PastLimit"] = data.groupby(["name"])["LimitGroup"].shift(periods=1)
data["Max/Yclose"] = (
    (data["max_price"].divide(data["YesterdayPrice"]) - 1) * 100
).astype(float)
data["Min/Yclose"] = (
    (data["min_price"].divide(data["YesterdayPrice"]) - 1) * 100
).astype(float)
data = data.replace([np.inf, -np.inf], np.nan)

data["upperHit"] = 0
data.loc[data.max_price == data.PriceMaxLimit, "upperHit"] = 1

data["lowerHit"] = 0
data.loc[data.min_price == data.PriceMinLimit, "lowerHit"] = 1

data["limitChange"] = 0
data.loc[data.PastLimit != data.LimitGroup, "limitChange"] = 1

data["upper"] = 0
data.loc[(data["Max/Yclose"] > (data.Limit) / 2) & (data.upperHit == 0), "upper"] = 1

data["lower"] = 0
data.loc[
    (abs(data["Min/Yclose"]) > (data.Limit) / 2) & (data.lowerHit == 0), "lower"
] = 1

data["middle"] = 0
data.loc[
    (abs(data["Min/Yclose"]) < (data.Limit) / 2)
    & (abs(data["Max/Yclose"]) < (data.Limit) / 2),
    "middle",
] = 1


# %%
len(set(data.name))


# %%

data["v3"] = 0
data.loc[(data["Max/Yclose"] >= 2) & (data.upperHit == 0), "v3"] = 1


data["v2"] = 0
data.loc[(data["Max/Yclose"] >= 4) & (data.upperHit == 0), "v2"] = 1

data["v1"] = 0
data.loc[(data["Max/Yclose"] >= 4.5) & (data.upperHit == 0), "v1"] = 1

for i in [4.7, 4.8, 4.9, 4.95]:

    data["v" + str(i)] = 0
    data.loc[(data["Max/Yclose"] >= i) & (data.upperHit == 0), "v" + str(i)] = 1


data["v4"] = 0
data.loc[
    (data["Min/Yclose"] < 0) & (abs(data["Min/Yclose"]) >= 2) & (data.lowerHit == 0),
    "v4",
] = 1

data["v5"] = 0
data.loc[
    (data["Min/Yclose"] < 0) & (abs(data["Min/Yclose"]) >= 4) & (data.lowerHit == 0),
    "v5",
] = 1

data["v6"] = 0
data.loc[
    (data["Min/Yclose"] < 0) & (abs(data["Min/Yclose"]) >= 4.5) & (data.lowerHit == 0),
    "v6",
] = 1

for i in [4.7, 4.8, 4.9, 4.95]:

    data["v-" + str(i)] = 0
    data.loc[
        (data["Min/Yclose"] < 0) & (data["Max/Yclose"] >= i) & (data.upperHit == 0),
        "v-" + str(i),
    ] = 1


data["vm"] = 0
data.loc[(abs(data["Min/Yclose"]) < 2) & (abs(data["Max/Yclose"]) < 2), "vm"] = 1


# %%
data.columns


# %%
def ols(tempt):
    y, x = "ER", "EMR"
    model = sm.OLS(tempt[y], sm.add_constant(tempt[x])).fit()
    beta = model.params[1]
    alpha = model.params[0]
    return alpha, beta


# %%
ARdata = pd.DataFrame()
ARdata = ARdata.append(
    data[["name", "date", "jalaliDate", "close_price", "Market_return", "RiskFree"]]
)

ARdata["Return"] = ARdata.groupby("name")["close_price"].pct_change(periods=1) * 100
ARdata["ER"] = ARdata["Return"] - ARdata["RiskFree"]
ARdata["EMR"] = ARdata["Market_return"] - ARdata["RiskFree"]
gg = ARdata.groupby("name")
g = gg.get_group("فولاد")
g = g[~g.ER.isnull()]


def ols(tempt):
    y, x = "ER", "EMR"
    model = sm.OLS(tempt[y], sm.add_constant(tempt[x])).fit()
    beta = model.params[1]
    alpha = model.params[0]
    return alpha, beta


def CAPM(g):
    print(g.name, end="\r", flush=True)

    g["AbnormalReturn"] = np.nan
    tempt = g[~g.ER.isnull()]
    if len(tempt) == 0:
        return
    alpha, beta = ols(tempt)
    g.loc[~g.ER.isnull(), "AbnormalReturn"] = tempt["Return"] - (
        tempt["RiskFree"] + alpha + beta * tempt["EMR"]
    )
    return g


ARdata = gg.apply(CAPM)


# %%
ARdata = ARdata[["name", "date", "jalaliDate", "AbnormalReturn"]].reset_index(drop=True)


# %%
data = data.merge(ARdata, on=["name", "date", "jalaliDate"], how="right").sort_values(
    by=["name", "date"]
)
len(data)


# %%
data = data.dropna()
len(data)


# %%
data.head()


# %%
ret = list(range(15))
for i in ret:
    print(i + 1, end="\r", flush=True)
    p = i + 1
    name1 = "Ret_" + str(p)
    gg = data.groupby(["name"])
    data[name1] = gg["close_price"].pct_change(periods=p) * 100
    gg = data.groupby(["name"])
    data[name1] = gg[name1].shift(-p)

    gg = data.groupby(["name"])
    data["E" + name1] = gg["Index"].pct_change(periods=p) * 100
    gg = data.groupby(["name"])
    data["E" + name1] = gg["E" + name1].shift(-p)
    data["E" + name1] = data[name1] - data["E" + name1]

    gg = data.groupby(["name"])
    data["Ab" + name1] = (
        gg["AbnormalReturn"]
        .rolling(p)
        .sum()
        .shift(-(p - 1), axis=0)
        .reset_index(drop=True)
    )

    name1 = "PRet_" + str(p)
    data[name1] = gg["close_price"].pct_change(periods=p) * 100
    gg = data.groupby(["name"])
    data["E" + name1] = gg["Index"].pct_change(periods=p) * 100
    gg = data.groupby(["name"])
    data["E" + name1] = data[name1] - data["E" + name1]
    gg = data.groupby(["name"])
    data["Ab" + name1] = gg["AbnormalReturn"].rolling(p).sum().reset_index(drop=True)

ret = [50, 100, 300]
for p in ret:
    print(p, end="\r", flush=True)
    name1 = "Ret_" + str(p)
    gg = data.groupby(["name"])
    data[name1] = gg["close_price"].pct_change(periods=p) * 100
    gg = data.groupby(["name"])
    data[name1] = gg[name1].shift(-p)

    gg = data.groupby(["name"])
    data["E" + name1] = gg["Index"].pct_change(periods=p) * 100
    gg = data.groupby(["name"])
    data["E" + name1] = gg["E" + name1].shift(-p)
    data["E" + name1] = data[name1] - data["E" + name1]
    gg = data.groupby(["name"])
    data["Ab" + name1] = (
        gg["AbnormalReturn"].rolling(p).sum().shift(-p, axis=0).reset_index(drop=True)
    )


# %%
data["jalaliDate"] = data["jalaliDate"].astype(int)
data = data.sort_values(by=["name", "date"])
data.columns


# %%


# %%
data[
    ["date", "name", "close_price", "Index", "Ret_2", "ERet_2", "AbRet_2", "AbPRet_2"]
].head()


# %%
data2 = data.merge(df6, on=["date", "stock_id"], how="left")
data = pd.DataFrame()
data = data.append(data2)
del data2


# %%
data["Ret_2to5"] = data["Ret_5"] - data["Ret_2"]
data["Ret_5to50"] = data["Ret_50"] - data["Ret_5"]
data["Ret_50to100"] = data["Ret_100"] - data["Ret_50"]
data["Ret_100to300"] = data["Ret_300"] - data["Ret_100"]

data["ERet_2to5"] = data["ERet_5"] - data["ERet_2"]
data["ERet_5to50"] = data["ERet_50"] - data["ERet_5"]
data["ERet_50to100"] = data["ERet_100"] - data["ERet_50"]
data["ERet_100to300"] = data["ERet_300"] - data["ERet_100"]

data["AbRet_2to5"] = data["AbRet_5"] - data["AbRet_2"]
data["AbRet_5to50"] = data["Ret_50"] - data["AbRet_5"]
data["AbRet_50to100"] = data["AbRet_100"] - data["AbRet_50"]
data["AbRet_100to300"] = data["AbRet_300"] - data["AbRet_100"]


data["NetInd"] = data["ind_buy_volume"] - data["ind_sell_volume"]
data["TotalInd"] = data["ind_buy_volume"] + data["ind_sell_volume"]
data["NetIns"] = data["ins_buy_volume"] - data["ins_sell_volume"]
data["TotalIns"] = data["ins_buy_volume"] + data["ins_sell_volume"]

data["IndlImbalance"] = data["NetInd"].divide(data["TotalInd"])
gg = data.groupby(["name"])
data["FIndlImbalance"] = gg["IndlImbalance"].shift(-1)
data["F2IndlImbalance"] = gg["IndlImbalance"].shift(-2)

data["InslImbalance"] = data["NetIns"].divide(data["TotalIns"])

gg = data.groupby(["name"])
data["FInslImbalance"] = gg["InslImbalance"].shift(-1)
data["F2InslImbalance"] = gg["InslImbalance"].shift(-2)


data["NetIndValue"] = data["ind_buy_value"] - data["ind_sell_value"]
data["NetInsValue"] = data["ins_buy_value"] - data["ins_sell_value"]

data["TotalIndValue"] = data["ind_buy_value"] + data["ind_sell_value"]
data["TotalInsValue"] = data["ins_buy_value"] + data["ins_sell_value"]

data["IndlImbalanceValue"] = data["NetIndValue"].divide(data["TotalIndValue"])
data["InslImbalanceValue"] = data["NetInsValue"].divide(data["TotalInsValue"])


data["Amihud"] = data["Ret_1"] / data["volume"]


# %%
llist = [
    "IndlImbalance",
    "InslImbalance",
    "IndlImbalanceValue",
    "InslImbalanceValue",
    "Turn",
    "RelTurn",
    "NetIndValue",
    "NetInsValue",
    "NetInd",
    "NetIns",
    "Amihud",
]
for i in range(15):
    print(i, end="\r", flush=True)
    gg = data.groupby("name")
    for j in llist:
        data["P" + str(i + 1) + j] = gg[j].shift(i + 1)
        data["F" + str(i + 1) + j] = gg[j].shift(-1 * (i + 1))


# %%
index["Positive"] = index.Index.diff()
index.loc[index.Positive < 0, "Positive"] = 0
index.loc[index.Positive > 0, "Positive"] = 1

mapingdict = dict(zip(index.jalaliDate, index.Positive))
data["Positive"] = data["jalaliDate"].map(mapingdict)
data.tail()


# %%
gg = data.groupby("LimitGroup")
gg.groups.keys()


# %%
mdata = data[data.jalaliDate > 13980000][["LimitGroup", "name"]]
gm = mdata.groupby("name")
g = gm.get_group("شستا")


# %%
g.groupby("LimitGroup").size()


# %%
data


# %%
(data[(data.jalaliDate > 13990000) & (data.name == "فولاد")]).jalaliDate.to_list()


# %%
data5 = data[data.LimitGroup == 5.0]


# %%
data5.sort_values(by=["id", "t"]).to_csv(
    path + "\Stock_Price_limit7-5Limit.csv", index=False
)
len(set(data5.name)), data5["upperHit"].mean(), data5.groupby("id")[
    ["upperHit"]
].mean().mean()


# %%


# %%
len(set(data.name))


# %%


# %%
# gg = ORData.groupby('LimitGroup')
# g = gg.get_group(10.0).groupby('name').size()
# g = g.to_frame()
# assets = list(set(g[g[0]>20].index))
# data = data[data.name.isin(assets)]
# # 10Percent limit

# data['v3'] = 0
# data.loc[(data['Max/Yclose']>=5)&(data.upperHit == 0),'v3'] = 1


# data['v2'] = 0
# data.loc[(data['Max/Yclose']>=9)&(data.upperHit == 0),'v2'] = 1

# data['v1'] = 0
# data.loc[(data['Max/Yclose']>=9.5)&(data.upperHit == 0),'v1'] = 1


# data['v4'] = 0
# data.loc[(data['Min/Yclose']<0)&(abs(data['Min/Yclose'])>=5)&(data.lowerHit == 0),'v4'] = 1

# data['v5'] = 0
# data.loc[(data['Min/Yclose']<0)&(abs(data['Min/Yclose'])>=9)&(data.lowerHit == 0),'v5'] = 1

# data['v6'] = 0
# data.loc[(data['Min/Yclose']<0)&(abs(data['Min/Yclose'])>=9.5)&(data.lowerHit == 0),'v6'] = 1


# data['vm'] = 0
# data.loc[(abs(data['Min/Yclose'])<5)&(abs(data['Max/Yclose'])<5),'vm'] = 1
# data.sort_values(by = ['id','t']).to_csv(path + '\Stock_Price_limit7-10Limit.csv',index = False)
# len(set(data.name)),data['upperHit'].mean(),data.groupby('id')[['upperHit']].mean().mean()


# %%


# %%
# gg = ORData.groupby('LimitGroup')
# g = gg.get_group(3.0).groupby('name').size()
# g = g.to_frame()
# assets = list(set(g[g[0]>20].index))
# data = data[data.name.isin(assets)]

# # 3Percent limit

# data['v3'] = 0
# data.loc[(data['Max/Yclose']>=1)&(data.upperHit == 0),'v3'] = 1


# data['v2'] = 0
# data.loc[(data['Max/Yclose']>=2)&(data.upperHit == 0),'v2'] = 1

# data['v1'] = 0
# data.loc[(data['Max/Yclose']>=2.5)&(data.upperHit == 0),'v1'] = 1


# data['v4'] = 0
# data.loc[(data['Min/Yclose']<0)&(abs(data['Min/Yclose'])>=1)&(data.lowerHit == 0),'v4'] = 1

# data['v5'] = 0
# data.loc[(data['Min/Yclose']<0)&(abs(data['Min/Yclose'])>=2)&(data.lowerHit == 0),'v5'] = 1

# data['v6'] = 0
# data.loc[(data['Min/Yclose']<0)&(abs(data['Min/Yclose'])>=2.5)&(data.lowerHit == 0),'v6'] = 1


# data['vm'] = 0
# data.loc[(abs(data['Min/Yclose'])<1)&(abs(data['Max/Yclose'])<1),'vm'] = 1


# data.sort_values(by = ['id','t']).to_csv(path + '\Stock_Price_limit7-3Limit.csv',index = False)
# len(set(data.name)),data['upperHit'].mean(),data.groupby('id')[['upperHit']].mean().mean()


# %%


# %%


# %%


# %%


# %%
