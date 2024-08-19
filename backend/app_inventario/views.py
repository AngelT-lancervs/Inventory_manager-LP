from rest_framework import generics
from rest_framework.response import Response
from rest_framework.views import APIView
from .models import Product
from .serializers import ProductSerializer

class ProductListView(generics.ListAPIView):
    """
    Vista que maneja la solicitud GET para listar todos los productos.
    """
    def get_queryset(self):
        queryset = Product.objects.all()
        checkedParam = self.request.query_params.get('checked', None)
        if checkedParam:
            queryset = queryset.filter(checked = checkedParam)
        return queryset
    
    serializer_class = ProductSerializer

class UpdateStockView(APIView):
    """
    Vista que maneja la solicitud PUT para actualizar el stock de un producto específico y su estado "checked".
    """
    def put(self, request, product_id):
        product = generics.get_object_or_404(Product, id=product_id)
        new_stock = request.data.get('stock')
        new_checked = request.data.get('checked', None)  # Obtener el estado "checked" desde la solicitud

        if new_stock is not None:
            try:
                product.stock = int(new_stock)
                if new_checked is not None:
                    product.checked = bool(new_checked)  # Actualizar el estado "checked" del producto
                product.save()
                return Response({
                    'message': 'Stock and checked status updated successfully',
                    'stock': product.stock,
                    'checked': product.checked
                })
            except ValueError:
                return Response({'error': 'Invalid stock value'}, status=400)
        return Response({'error': 'Stock value is required'}, status=400)
    

class CreateProductView(generics.CreateAPIView):
    """
    Vista que maneja la solicitud POST para crear un producto.
    """
    queryset = Product.objects.all()
    serializer_class = ProductSerializer

