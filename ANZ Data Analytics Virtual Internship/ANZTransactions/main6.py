import pandas as pd
from sklearn import linear_model
import statsmodels.api as sm
import matplotlib.pyplot as plt

pd.set_option('display.max_rows', None)
pd.set_option('display.max_columns', None)
pd.set_option('display.width', 1000)

df = pd.read_excel('anz_dataset.xlsx')
print(df.head(10))

df['month'] = pd.to_datetime(df['date'], format = '%Y %m %d')
df['month'] = pd.DatetimeIndex(df['date']).month_name()
df1 = df[df['txn_description'] == 'PAY/SALARY'].groupby(['customer_id','month']).sum('amount').groupby(['customer_id']).mean()['amount'].to_frame(name = 'annual_salary').reset_index()
df1['annual_salary'] = 4 * df1['annual_salary']
print(df1.head(10))
print(df1.columns)

df2 = df1.merge(df[['customer_id','age','gender']], on = 'customer_id', how = 'left')
df2 = df2.drop_duplicates(['customer_id'])

df3 = df[df['movement'] == 'debit'].groupby(['customer_id', 'month']).sum('amount').groupby('customer_id').mean()['amount'].to_frame(name = 'monthly_spending').reset_index()
df3['monthly_spending'] = df3['monthly_spending']/3
df3 = df2.merge(df3, on = 'customer_id', how = 'left')
df3 = df3.reset_index(drop = True)

df3.at[df3['gender'] == 'F', 'gender'] = 0
df3.at[df3['gender'] == 'M', 'gender'] = 1

df3 = df3[['customer_id', 'age', 'gender', 'monthly_spending', 'annual_salary']]
print(df3.head(10))

ax1 = df3.plot(kind = 'scatter', x = 'age', y = 'annual_salary')
plt.savefig('scatter1.png')
plt.show()
ax2 = df3.plot(kind = 'scatter', x = 'monthly_spending', y = 'annual_salary')
plt.savefig('scatter2.png')
plt.show()

x = df3[['age', 'gender', 'monthly_spending']]
y = df3['annual_salary']

reg = linear_model.LinearRegression()
model = reg.fit(x,y)
r_sq = model.score(x,y)
x = sm.add_constant(x)
model1 = sm.OLS(y.astype(float),x.astype(float)).fit()
print('R-sq: ' + str(r_sq))
print('Regression coefficients: ' + str(reg.coef_))
print(model1.summary())