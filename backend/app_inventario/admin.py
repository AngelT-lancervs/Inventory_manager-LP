from django.contrib import admin
from .models import Product

@admin.register(Product)
class ProductAdmin(admin.ModelAdmin):
    """
    Configuración del modelo Product para el panel de administración de Django.
    """
    list_display = ('name', 'description', 'stock', 'price')
    search_fields = ('name', 'description')
    list_filter = ('stock',)
