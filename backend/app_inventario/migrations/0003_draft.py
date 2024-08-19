# Generated by Django 5.1 on 2024-08-19 08:41

from django.db import migrations, models


class Migration(migrations.Migration):

    dependencies = [
        ('app_inventario', '0002_product_checked'),
    ]

    operations = [
        migrations.CreateModel(
            name='Draft',
            fields=[
                ('id', models.BigAutoField(auto_created=True, primary_key=True, serialize=False, verbose_name='ID')),
                ('date', models.DateTimeField(auto_now_add=True)),
                ('name', models.CharField(max_length=255)),
                ('productsDraft', models.ManyToManyField(to='app_inventario.product')),
            ],
        ),
    ]
