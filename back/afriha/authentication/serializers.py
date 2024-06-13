# authentication/serializers.py

from rest_framework import serializers
from .models import User
from django.core.validators import validate_email

class UserSerializer(serializers.ModelSerializer):
    class Meta:
        model = User
        fields = ['username', 'email', 'role', 'password' , 'id']
        extra_kwargs = {'password': {'write_only': True}}

    def create(self, validated_data):
        user = User.objects.create_user(**validated_data)
        return user
    
class UserUpdateSerializer(serializers.ModelSerializer):
    class Meta:
        model = User
        fields = ['email', 'username']

class SendVerificationEmailSerializer(serializers.Serializer):
    email = serializers.EmailField(validators=[validate_email])

