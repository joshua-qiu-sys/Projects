import pandas as pd
import matplotlib.pyplot as plt

pd.set_option('display.max_rows', None)
pd.set_option('display.max_columns', None)
pd.set_option('display.width', 1000)

df = pd.read_excel('anz_dataset.xlsx')
print(df.head(50))

ax = df['merchant_state'].value_counts().plot(kind = 'bar', rot = 0)
for p in ax.patches:
    plt.annotate("%.0f" % p.get_height(), (p.get_x() + p.get_width()/2, p.get_height()), ha = 'center', va = 'center', xytext = (0,10), textcoords = 'offset points')
plt.title('Transaction Volume By State')
plt.xlabel("State")
plt.ylabel("Transaction Volume")
plt.gcf().set_size_inches(8, 6)
plt.savefig('fig4.png', dpi = 600)
plt.show()