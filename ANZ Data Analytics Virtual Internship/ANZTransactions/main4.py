import pandas as pd
import matplotlib.pyplot as plt
import squarify

pd.set_option('display.max_rows', None)
pd.set_option('display.max_columns', None)
pd.set_option('display.width', 1000)

df = pd.read_excel('anz_dataset.xlsx')
print(df.head(10))

df1 = df[df['merchant_state'] == 'NSW']
df2 = df1['merchant_suburb'].value_counts().sort_values(ascending = False).reset_index()
df2 = df2.rename(columns = {'index': 'suburb', 'merchant_suburb': 'count'})
print(df2.head(20))
df2 = df2.set_index(pd.Index(list(df2['suburb'])))

squarify.plot(sizes=df2['count'],
              label=df2['suburb'][:10],
              alpha=.6)
plt.title('Top 10 NSW Suburbs By Transaction Volume')
plt.gcf().set_size_inches(8, 6)
plt.savefig('fig5.png', dpi = 600)
plt.show()