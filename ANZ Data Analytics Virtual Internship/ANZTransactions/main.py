import matplotlib.pyplot as plt
import pandas as pd

pd.set_option('display.max_rows', None)
pd.set_option('display.max_columns', None)
pd.set_option('display.width', 1000)

df = pd.read_excel('anz_dataset.xlsx')

avg = df['amount'].mean()
print('Average: $' + str(format(avg, '.2f')))

df['month'] = pd.to_datetime(df['date'], format='%Y-%m-%d')
df['month'] = pd.DatetimeIndex(df['date']).month_name()
print(df.head(10))

order = ['August', 'September', 'October']
ax = df['month'].value_counts().loc[order].plot(kind = 'bar', rot = 0)
for p in ax.patches:
    ax.annotate("%.0f" % p.get_height(), (p.get_x() + p.get_width() / 2., p.get_height()), ha='center', va='center', xytext=(0, 10), textcoords='offset points')
plt.title('Transaction Volume By Month')
plt.xlabel('Month')
plt.ylabel('Transaction Volume')
plt.gcf().set_size_inches(8, 6)
plt.savefig('fig1.png', dpi = 600)
plt.show()

