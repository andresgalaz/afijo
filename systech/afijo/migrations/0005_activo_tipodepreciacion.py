# Generated by Django 2.2.2 on 2021-04-29 20:26

from django.db import migrations, models
import django.db.models.deletion


class Migration(migrations.Migration):

    dependencies = [
        ('afijo', '0004_tipodepreciacion'),
    ]

    operations = [
        migrations.AddField(
            model_name='activo',
            name='tipoDepreciacion',
            field=models.ForeignKey(default=1, on_delete=django.db.models.deletion.CASCADE, to='afijo.TipoDepreciacion'),
        ),
    ]
