# payment_method.png

samples = df["payment_method"].value_counts()
font_size = 8

fig, ax = plt.subplots(1, 2, figsize=(15,5))

ax[0].barh(y=samples.index, width=samples.values, height=[0.8, 0.8, 0.8] ,color=["#a839f7",'#6818a1','#571387'][::-1])
ax[0].set_xlabel("Frequency", fontsize=font_size)
ax[0].tick_params(axis="y", labelsize=font_size)
ax[0].tick_params(axis="x", labelsize=font_size)
ax[0].set_frame_on(False)
ax[0].get_xaxis().set_visible(False)

for index, values in enumerate(samples):
    ax[0].text(values+2, index, str(values), va="center", fontsize=8)

ax[1].pie(samples, colors=["#a839f7",'#6818a1','#571387'][::-1], labels=samples.index,autopct="%.2f%%", explode=[0.05, 0.05, 0.05], textprops=dict(fontsize=font_size))


plt.tight_layout(pad=1)
plt.show()


# product_lines_and_unit_price.png

grouped = df.groupby("product_line")

gb_product_line_total = grouped.sum()["total"]
gb_product_line_unit_price = df.groupby("product_line").mean()["unit_price"]

product_lines = [product_line for product_line, series in grouped]

fig, ax1 = plt.subplots()
ax2 = ax1.twinx()

bar_color = "#571387"
ax1.bar(product_lines, gb_product_line_total, color=bar_color, label='Total Revenue')

line_color = "#3b0ef0"
ax2.plot(product_lines, gb_product_line_unit_price, color=line_color, label='Unit Price')

ax1.set_ylabel('Total Revenue', color=bar_color)
ax2.set_ylabel('Unit Price', color=line_color)

ax1.set_xticklabels(product_lines, rotation="vertical")

ax1.tick_params(axis="y", labelsize=font_size)
ax1.tick_params(axis="x", labelsize=font_size)
ax2.tick_params(axis="y", labelsize=font_size)
ax2.tick_params(axis="x", labelsize=font_size)


ax1.set_frame_on(False)
ax2.set_frame_on(False)

plt.tight_layout(pad=1)
plt.show()
