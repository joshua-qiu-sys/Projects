import matplotlib.pyplot as plt
import pandas as pd

pd.set_option('display.max_rows', None)
pd.set_option('display.max_columns', None)
pd.set_option('display.width', 1000)

df = pd.read_excel('anz_dataset.xlsx')

df['extraction'] = pd.to_datetime(df['extraction'])
df['day_of_week'] = df.extraction.dt.day_name()
print(df.head(50))

df1 = df.groupby(['date'])['amount'].agg(['count'])
print(df1.head(10))

order = ['Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday']
ax1 = df.groupby(['date', 'day_of_week'])['amount'].agg(['count']).groupby('day_of_week').mean()['count'].loc[order].plot(kind = 'bar', rot = 0)
for p in ax1.patches:
    ax1.annotate("%.0f" % p.get_height(), (p.get_x() + p.get_width() / 2., p.get_height()), ha='center', va='center', xytext=(0, 10), textcoords='offset points')
plt.twinx()
ax2 = df.groupby(['date','day_of_week'])['amount'].sum('amount').groupby(['day_of_week']).mean().loc[order].plot(kind = 'line', color = 'red', secondary_y = True, label = 'Amount ($)')
ax1.set_xlabel('Day of Week')
ax1.set_ylabel('Transaction Volume')
ax2.set_ylabel('Transaction Amount ($)')
plt.title('Average Weekly Transaction Volume/Amount')
plt.legend()
plt.tight_layout()
plt.gcf().set_size_inches(8, 6)
plt.savefig('fig3.png', dpi = 600)
plt.show()