from django.urls import path
from .views import CreateProductView, ProductExcelReportView, ProductListView, UpdateStockView, DraftView, MarkDraftCompletedView

urlpatterns = [
    path('api/products/', ProductListView.as_view(), name='product_list'),
    path('api/products/<int:product_id>/update-stock/', UpdateStockView.as_view(), name='update_stock'),
    path('api/products/create/', CreateProductView.as_view(), name='create_product'),
    path('drafts/', DraftView.as_view(), name='drafts'),
    path('download-excel/', ProductExcelReportView.as_view(), name='download-excel'),
    path('drafts/<int:pk>/', DraftView.as_view(), name='draft-delete'),
     path('drafts/<int:draft_id>/complete/', MarkDraftCompletedView.as_view(), name='complete-draft'),
]
