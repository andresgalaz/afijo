# Generated by Django 3.2.7 on 2021-10-10 02:03

from django.db import migrations


class Migration(migrations.Migration):

    dependencies = [
        ('afijo', '0002_alter_planta_sobre_termino'),
    ]

    operations = [
        migrations.RemoveField(
            model_name='planta',
            name='sobre_termino',
        ),
    ]
