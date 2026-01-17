import streamlit as st
import pandas as pd
import plotly.express as px

df = pd.read_csv("Sample_Superstore.csv", encoding="latin-1")
df["Order Date"] = pd.to_datetime(df['Order Date'])
df['Year'] = df['Order Date'].dt.year
df['Month'] = df['Order Date'].dt.month_name()

st.title("Superstore Sales Dashboard")

total_sales = df["Sales"].sum()
total_profit = df["Profit"].sum()
total_quantity = df["Quantity"].sum()
st.metric("Total Sales", f"${total_sales:,.2f}")
st.metric("Total profit", f"${total_profit:,.2f}")
st.metric("Total Quantity", total_quantity)

category_sales = df.groupby("Category")['Sales'].sum().reset_index()
fig1 = px.line(category_sales, x = 'Category', y="Sales", title = "Sales by Category")
st.plotly_chart(fig1)

region_Sales = df.groupby('Region')["Sales"].sum().reset_index()
fig2 = px.bar(region_Sales, x= 'Region', y='Sales', title="Sales by Region")
st.plotly_chart(fig2)

monthly_sales =df.groupby(["Year", 'Month'])['Sales'].sum().reset_index()
fig3 = px.line(monthly_sales, x = 'Month', y='Sales', color='Year', title='Monthly Sales Trend')
st.plotly_chart(fig3)

top_customers = df.groupby("Customer Name")['Sales'].sum().sort_values(ascending = False).head(10).reset_index()
fig4 = px.bar(top_customers, x= 'Customer Name', y='Sales', title="Top 10 Customers by Sales")
st.plotly_chart(fig4)
