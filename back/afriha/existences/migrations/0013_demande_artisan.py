# Generated by Django 5.0.4 on 2024-05-02 11:05

import django.db.models.deletion
from django.db import migrations, models


class Migration(migrations.Migration):

    dependencies = [
        ('existences', '0012_remove_rendezvous_confirme_demande_confirme'),
    ]

    operations = [
        migrations.AddField(
            model_name='demande',
            name='artisan',
            field=models.ForeignKey(blank=True, null=True, on_delete=django.db.models.deletion.CASCADE, to='existences.artisan'),
        ),
    ]
