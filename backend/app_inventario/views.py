from rest_framework import generics
from rest_framework.response import Response
from rest_framework.views import APIView
from .models import Product
from .serializers import ProductSerializer

class ProductListView(generics.ListAPIView):
    """
    Vista que maneja la solicitud GET para listar todos los productos.
    """
    queryset = Product.objects.all()
    serializer_class = ProductSerializer

class UpdateStockView(APIView):
    """
    Vista que maneja la solicitud POST para actualizar el stock de un producto específico.
    """
    def post(self, request, product_id):
        product = generics.get_object_or_404(Product, id=product_id)
        new_stock = request.data.get('stock')
        if new_stock is not None:
            product.stock = int(new_stock)
            product.save()
            return Response({'message': 'Stock updated successfully', 'stock': product.stock})
        return Response({'error': 'Invalid stock value'}, status=400)
    

class CreateProductView(generics.CreateAPIView):
    """
    Vista que maneja la solicitud POST para crear un producto.
    """
    queryset = Product.objects.all()
    serializer_class = ProductSerializer
