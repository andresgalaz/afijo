# Generated by Django 2.2.2 on 2021-09-03 01:30

from django.db import migrations, models


class Migration(migrations.Migration):

    dependencies = [
        ('afijo', '0023_auto_20210830_2214'),
    ]

    operations = [
        migrations.AddField(
            model_name='activo',
            name='numero_interno',
            field=models.CharField(default=1, max_length=3, verbose_name='Número Interno'),
        ),
    ]