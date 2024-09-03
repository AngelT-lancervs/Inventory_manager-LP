from django.db import models

class Product(models.Model):
    """
    Modelo que representa un producto en el inventario.
    """
    name = models.CharField(max_length=255)
    description = models.TextField(blank=True, null=True)
    stock = models.IntegerField(default=0)
    price = models.DecimalField(max_digits=10, decimal_places=2)
    checked = models.BooleanField(default=False)
    
    def __str__(self):
        return self.name

class Draft(models.Model):
    name = models.CharField(max_length=255)
    date = models.DateTimeField(auto_now_add=True)
    completed = models.BooleanField(default=False)  # Añade este campo
    productsDraft = models.ManyToManyField(Product)

    def __str__(self):
        return self.name

