from django.urls import path
from .views import CreateProductView, ProductListView, UpdateStockView

urlpatterns = [
    path('api/products/', ProductListView.as_view(), name='product_list'),
    path('api/products/<int:product_id>/update-stock/', UpdateStockView.as_view(), name='update_stock'),
    path('api/products/create/', CreateProductView.as_view(), name='create_product'),
]
