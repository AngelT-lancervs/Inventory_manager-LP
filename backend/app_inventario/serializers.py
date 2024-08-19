from rest_framework import serializers
from .models import Product, Draft

class ProductSerializer(serializers.ModelSerializer):
    """
    Serializador para convertir los objetos Product a formato JSON.
    """
    class Meta:
        model = Product
        fields = '__all__'



class DraftSerializer(serializers.ModelSerializer):
    productsDraft = ProductSerializer(many=True) 

    class Meta:
        model = Draft
        fields = ['id', 'date', 'name', 'productsDraft']

    def create(self, validated_data):
        products_data = validated_data.pop('productsDraft')
        draft = Draft.objects.create(**validated_data)
        for product_data in products_data:
            product_id = product_data.get('id', None)
            if product_id:
                product = Product.objects.get(id=product_id)
            else:
                product = Product.objects.create(**product_data)
            draft.productsDraft.add(product)
        return draft