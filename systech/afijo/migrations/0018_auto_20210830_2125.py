# Generated by Django 2.2.2 on 2021-08-31 01:25

from django.db import migrations, models
import django.db.models.deletion


class Migration(migrations.Migration):

    dependencies = [
        ('afijo', '0017_auto_20210514_2036'),
    ]

    operations = [
        migrations.CreateModel(
            name='Region',
            fields=[
                ('id', models.AutoField(auto_created=True, primary_key=True, serialize=False, verbose_name='ID')),
                ('codigo', models.CharField(max_length=2, unique=True, verbose_name='Código')),
                ('nombre', models.CharField(max_length=80, unique=True, verbose_name='Nombre')),
            ],
        ),
        migrations.DeleteModel(
            name='depreciacion',
        ),
        migrations.AddField(
            model_name='planta',
            name='region',
            field=models.ForeignKey(blank=True, null=True, on_delete=django.db.models.deletion.SET_NULL, to='afijo.Region'),
        ),
    ]