# Generated by Django 5.0.2 on 2024-04-29 13:02

from django.db import migrations


class Migration(migrations.Migration):

    dependencies = [
        ('existences', '0008_remove_demande_client_id_demande_client'),
    ]

    operations = [
        migrations.RemoveField(
            model_name='client',
            name='client_id',
        ),
    ]
