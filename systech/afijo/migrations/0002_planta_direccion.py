# Generated by Django 2.2.2 on 2024-02-15 20:54

from django.db import migrations, models
import django.utils.timezone


class Migration(migrations.Migration):

    dependencies = [
        ('afijo', '0001_initial'),
    ]

    operations = [
        migrations.AddField(
            model_name='planta',
            name='direccion',
            field=models.CharField(default=django.utils.timezone.now, max_length=100, verbose_name='Dirección'),
            preserve_default=False,
        ),
    ]