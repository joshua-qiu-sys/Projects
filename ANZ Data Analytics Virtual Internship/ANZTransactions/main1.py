import matplotlib.pyplot as plt
import pandas as pd

pd.set_option('display.max_rows', None)
pd.set_option('display.max_columns', None)
pd.set_option('display.width', 1000)

df = pd.read_excel('anz_dataset.xlsx')

df['extraction'] = pd.to_datetime(df['extraction'])
df['time'] = pd.cut(df.extraction.dt.hour, bins = 4, labels = ['Early Morning', 'Morning', 'Afternoon', 'Evening/Night'])
print(df.head(50))

df1 = df.groupby(['date', 'time'])['amount'].agg(['sum', 'count'])
print(df1.head(10))

order = ['Early Morning', 'Morning', 'Afternoon', 'Evening/Night']
ax1 = df.groupby(['date','time'])['amount'].agg(['count']).groupby('time').mean()['count'].loc[order].plot(kind = 'bar', rot = 0)
for p in ax1.patches:
    ax1.annotate("%.0f" % p.get_height(), (p.get_x() + p.get_width() / 2., p.get_height()), ha='center', va='center', xytext=(0, 10), textcoords='offset points')
plt.twinx()
ax2 = df.groupby(['date','time']).sum('amount').groupby('time').mean()['amount'].loc[order].plot(kind = 'line', color = 'red', secondary_y = True, label = 'Amount ($)')
ax1.set_xlabel('Time of day')
ax1.set_ylabel('Transaction Volume')
ax2.set_ylabel('Transaction Amount ($)')
plt.title('Average Daily Transaction Volume/Amount')
plt.legend()
plt.tight_layout()
plt.gcf().set_size_inches(8, 6)
plt.savefig('fig2.png', dpi = 600)
plt.show()

