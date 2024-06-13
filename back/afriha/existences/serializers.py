from rest_framework import serializers

from existences.models import (
    Administrator, Artisan, Client, ArtisanWaiting,
    Commentaires, Demande, Prestation, Domaine, RendezVous,
    Dialogue, Message, Notification, Demandeacceptee
)

from authentication.models import User 
from authentication.serializers import UserSerializer  # Assuming you have a UserSerializer in authentication.serializers

class AdministratorSerializer(serializers.ModelSerializer):
    user = UserSerializer()
    
    class Meta:
        model = Administrator
        fields = '__all__'
    def create(self, validated_data):
        user_data = validated_data.pop('user')
        user = User.objects.create_user(**user_data)
        administrator = Administrator.objects.create(user=user, **validated_data)
        return administrator

class ArtisanSerializer(serializers.ModelSerializer):
    user = UserSerializer()
    
    class Meta:
        model = Artisan
        fields = [ 'num_phone', 'status', 'diplome', 'nb_interventions', 'banni', 'notation', 'domaine', 'confirmer' , 'id' , 'user' , 'latitude' , 'longitude']
    def create(self, validated_data):
        user_data = validated_data.pop('user')  # Extract 'user' data from validated_data
        user = User.objects.create_user(**user_data)  # Create a new User instance
        artisan = Artisan.objects.create(user=user, **validated_data)  # Create an Artisan instance associated with the new User
        return artisan  # Return the created Artisan instance

class ClientSerializer(serializers.ModelSerializer):
    user = UserSerializer()  # Use UserSerializer for nested user data

    class Meta:
        model = Client
        fields = ['num_phone', 'id', 'user']

    def create(self, validated_data):
        user_data = validated_data.pop('user')  # Extract user data
        user = UserSerializer().create(user_data)  # Create user instance
        client = Client.objects.create(user=user, **validated_data)  # Create client instance
        return client
    
class ArtisanWaitingSerializer(serializers.ModelSerializer):
    user = UserSerializer()
    
    class Meta:
        model = ArtisanWaiting
        fields = '__all__'
    def create(self, validated_data):
        user_data = validated_data.pop('user')
        user = User.objects.create_user(**user_data)
        artisan_waiting = ArtisanWaiting.objects.create(user=user, **validated_data)
        return artisan_waiting

class CommentairesSerializer(serializers.ModelSerializer):

    demande = serializers.ReadOnlyField(source = 'demande.id')
    
    class Meta:
        model = Commentaires
        fields = '__all__'

class DemandeSerializer(serializers.ModelSerializer):
    TYPE_CHOICES = [
        ('urgent', 'Urgent'),
        ('simple', 'Simple'),
    ]
    
    type = serializers.ChoiceField(choices=TYPE_CHOICES, default='simple')
    date = serializers.DateField(required=True)
    client = serializers.ReadOnlyField(source='client.id')
    domaine = serializers.ReadOnlyField(source='domaine.id')
    prestation = serializers.ReadOnlyField(source='prestation.id')
    Tarif= serializers.ReadOnlyField()
    class Meta:
        model = Demande
        fields = '__all__'

class PrestationSerializer(serializers.ModelSerializer):
    
    class Meta:
        model = Prestation
        fields = '__all__'

class DomaineSerializer(serializers.ModelSerializer):
    
    class Meta:
        model = Domaine
        fields = '__all__'

class RendezVousSerializer(serializers.ModelSerializer):
    
    class Meta:
        model = RendezVous
        fields = '__all__'

class DialogueSerializer(serializers.ModelSerializer):
    
    class Meta:
        model = Dialogue
        fields = '__all__'

class MessageSerializer(serializers.ModelSerializer):
    
    sender = serializers.ReadOnlyField(source='User.id')
    reciever = serializers.ReadOnlyField(source='User.id')
    is_sender=serializers.ReadOnlyField()

    class Meta:
        model = Message
        fields = '__all__'

class NotificationSerializer(serializers.ModelSerializer):

    receiver = serializers.ReadOnlyField(source='User.id')

    
    class Meta:
        model = Notification
        fields = '__all__'

class NotiVueSerializer(serializers.ModelSerializer):
    class Meta:
        model = Notification
        fields = []

class DemandeaccepteeSerializer(serializers.ModelSerializer):
    class Meta:
        model = Demandeacceptee
        fields = ['demande_id', 'artisan_id']  # Only include the foreign key fields

    def create(self, validated_data):
        # Extract demand and artisan IDs from validated data
        demande_id = validated_data.pop('demande_id')
        artisan_id = validated_data.pop('artisan_id')
        
        # Create and return Demandeacceptee instance
        demandeacceptee_instance = Demandeacceptee.objects.create(demande_id=demande_id, artisan_id=artisan_id)
        return demandeacceptee_instance
