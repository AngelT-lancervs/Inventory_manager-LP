from rest_framework import serializers
from .models import Product

class ProductSerializer(serializers.ModelSerializer):
    """
    Serializador para convertir los objetos Product a formato JSON.
    """
    class Meta:
        model = Product
        fields = '__all__'


