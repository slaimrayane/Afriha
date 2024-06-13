# authentication/models.py

from django.db import models
from django.contrib.auth.models import AbstractUser
from django.conf import settings
from rest_framework.authtoken.models import Token

from django.db import models

class VerificationCode(models.Model):
    email = models.EmailField(unique=True)
    code = models.CharField(max_length=6)

    def __str__(self):
        return f"Verification Code for {self.email}: {self.code}"
    


class User(AbstractUser):
    ROLE_CHOICES = (
        ('administrator', 'Administrator'),
        ('artisan', 'Artisan'),
        ('client', 'Client'),
        ('artisanWaiting', 'ArtisanWaiting'),
    )

    role = models.CharField(max_length=30, choices=ROLE_CHOICES)