from django.shortcuts import render,get_object_or_404
from .utils import calculate_distance

from authentication.models import User

from existences.models import ( 
    Administrator,
    Artisan,
    Client,
    ArtisanWaiting,
    Commentaires,
    Demande,
    Prestation,
    Domaine,
    RendezVous,
    Dialogue, 
    Message, 
    Notification,
    Demandeacceptee,
)

from existences.serializers import (
    AdministratorSerializer,
    ArtisanSerializer,
    ClientSerializer,
    ArtisanWaitingSerializer,
    CommentairesSerializer,
    DemandeSerializer,
    PrestationSerializer,
    DomaineSerializer,
    NotificationSerializer,
    NotiVueSerializer ,
    RendezVousSerializer,
    DialogueSerializer,
    MessageSerializer,
    DemandeaccepteeSerializer,
)

from rest_framework import generics ,permissions ,status
from rest_framework.views import APIView
from rest_framework.response import Response


# views.py

#this views was added yesterday to check if user are created successfully
class ClientListView(APIView):
    def get(self, request):
        clients = Client.objects.all()
        serializer = ClientSerializer(clients, many=True)
        return Response(serializer.data, status=status.HTTP_200_OK)

# Create your views here.

class AdministratorList(generics.ListCreateAPIView):
    queryset = Administrator.objects.all()
    serializer_class = AdministratorSerializer

class AdministratorDetail(generics.RetrieveUpdateDestroyAPIView):
    queryset = Administrator.objects.all()
    serializer_class = AdministratorSerializer

class ArtisanList(generics.ListCreateAPIView):
    queryset = Artisan.objects.all()
    serializer_class = ArtisanSerializer

class ArtisanDetail(generics.RetrieveUpdateDestroyAPIView):
    queryset = Artisan.objects.all()
    serializer_class = ArtisanSerializer

class ClientList(generics.ListCreateAPIView):
    queryset = Client.objects.all()
    serializer_class = ClientSerializer

class ClientDetail(generics.RetrieveUpdateDestroyAPIView):
    queryset = Client.objects.all()
    serializer_class = ClientSerializer 

class ArtisanWaitingList(generics.ListCreateAPIView):
    queryset = ArtisanWaiting.objects.all()
    serializer_class = ArtisanWaitingSerializer 

class ArtisanWaitingDetail(generics.RetrieveUpdateDestroyAPIView):
    queryset = ArtisanWaiting.objects.all()
    serializer_class = ArtisanWaitingSerializer

class CommentairesList(generics.ListCreateAPIView):
    queryset = Commentaires.objects.all()
    serializer_class = CommentairesSerializer

    def get_queryset(self):
        #Filter Commentaires pour un artisan
        artisan = self.kwargs.get('pk')
        return Commentaires.objects.filter(demande__artisan = artisan)

class CommentairesDetail(generics.RetrieveUpdateDestroyAPIView):
    queryset = Commentaires.objects.all()
    serializer_class = CommentairesSerializer  

class DemandeList(generics.ListCreateAPIView):
    queryset = Demande.objects.all()
    serializer_class = DemandeSerializer

    def get_queryset(self):
        # Filter Demandes by Client
        client = self.kwargs.get('pk')
        return Demande.objects.filter(client=client)

class DemandeDetail(generics.RetrieveUpdateDestroyAPIView):
    queryset = Demande.objects.all()
    serializer_class = DemandeSerializer

class PrestationList(generics.ListCreateAPIView):
    queryset = Prestation.objects.all()
    serializer_class = PrestationSerializer

class PrestationDetail(generics.RetrieveUpdateDestroyAPIView):
    queryset = Prestation.objects.all()
    serializer_class = PrestationSerializer

class DomaineList(generics.ListCreateAPIView):
    queryset = Domaine.objects.all()
    serializer_class = DomaineSerializer

class DomaineDetail(generics.RetrieveUpdateDestroyAPIView):
    queryset = Domaine.objects.all()
    serializer_class = DomaineSerializer

class NotificationList(generics.ListCreateAPIView):
    queryset = Notification.objects.all()
    serializer_class = NotificationSerializer

    def get_queryset(self):
        #Filter notifications pour un artisan
        user = self.kwargs.get('pk')
        return Notification.objects.filter(receiver = user)

class NotificationDetail(generics.RetrieveUpdateDestroyAPIView):
    queryset = Notification.objects.all()
    serializer_class = NotificationSerializer

class Notifier(generics.CreateAPIView):
    serializer_class = NotificationSerializer

    def post(self , request , pk):
        try:
            user = User.objects.get(id = pk)

        except Notification.DoesNotExist:
            return Response({'error': 'Notification not found'}, status=status.HTTP_404_NOT_FOUND)
        
        serializer = self.serializer_class(data=request.data)
        serializer.is_valid(raise_exception=True)

        serializer.validated_data['receiver'] = user
        serializer.save()
        
        return Response(serializer.data, status=status.HTTP_201_CREATED)

class NotificationVue(generics.UpdateAPIView):
    serializer_class = NotiVueSerializer

    def update(self , *args, **kwargs):

        notifications = NotificationList.get_queryset(self)

        for notification in notifications:
            notification.vue = True
            notification.save()
        
        serializer = NotificationSerializer(notifications, many=True)
        serialized_data = serializer.data

        return Response(serialized_data, status=status.HTTP_200_OK)
        
class RendezVousList(generics.ListCreateAPIView):
    queryset = RendezVous.objects.all()
    serializer_class = RendezVousSerializer

class RendezVousDetail(generics.RetrieveUpdateDestroyAPIView):
    queryset = RendezVous.objects.all()
    serializer_class = RendezVousSerializer

class DialogueList(generics.ListCreateAPIView):
    queryset = Dialogue.objects.all()
    serializer_class = DialogueSerializer

class DialogueDetail(generics.RetrieveUpdateDestroyAPIView):
    queryset = Dialogue.objects.all()
    serializer_class = DialogueSerializer

class MessageList(generics.ListCreateAPIView):
    queryset = Message.objects.all()
    serializer_class = MessageSerializer
    
class MessageDetail(generics.RetrieveUpdateDestroyAPIView):
    queryset = Message.objects.all()
    serializer_class = MessageSerializer

class Confirmer_Rendezvous(generics.UpdateAPIView):
    serializer_class = DemandeSerializer

    def update(self, request, *args, **kwargs):
       
        id = self.kwargs['id']
        key = self.kwargs['key']
        queryset = Demande.objects.filter(id=key, artisan=None)
        queryset.update(Confirme=True, artisan=id)

        updated_demande = queryset.first()
        serialized_demande = self.get_serializer(updated_demande)
        return Response(serialized_demande.data)

class PrestationListByDomaine2(APIView):
    def get(self, request, domain_id):
        prestations = Prestation.objects.filter(domaine_id=domain_id)
        serializer = PrestationSerializer(prestations, many=True)
        return Response(serializer.data)

class PrestationListByDomaine(generics.ListAPIView):
    serializer_class = PrestationSerializer

    def get_queryset(self):
        # Get the domaine_id from the query parameters
        domaine_id = self.request.query_params.get('domaine_id')
        if domaine_id is not None:
            # Convert the domaine_id to an integer
            domaine_id = int(domaine_id)
            # Filter the queryset based on the provided domain_id
            queryset = Prestation.objects.filter(domaine_id=domaine_id)
        else:
            # Return an empty queryset if domaine_id is not provided
            queryset = Prestation.objects.none()
        return queryset

class Commenter(generics.CreateAPIView):
    serializer_class = CommentairesSerializer

    def post(self ,request , pk , key):
        
        try:
            demande = Demande.objects.get(id=key)

        except Demande.DoesNotExist:
            return Response({'error': 'Demande not found'}, status=status.HTTP_404_NOT_FOUND)
        

        serializer = self.serializer_class(data=request.data)
        serializer.is_valid(raise_exception=True)

        serializer.validated_data['demande'] = demande
        serializer.save()

        # Update related Demande instance
        demande.notee = True
        demande.save()

        #calculer la nouvelle notation de l'artisan
        notation = serializer.validated_data['notation']
        artisan = demande.artisan
        new_notation = (artisan.notation*artisan.nb_interventions + notation ) / (artisan.nb_interventions + 1)

        artisan.notation = new_notation
        artisan.nb_interventions += 1
        artisan.save()

        return Response(serializer.data, status=status.HTTP_201_CREATED)
        
class Demander(generics.CreateAPIView):
    serializer_class = DemandeSerializer

    def post(self, request, pk1, pk2, key):
        try:
            domaine = Domaine.objects.get(pk=pk1)
            prestation = Prestation.objects.get(pk=pk2,domaine_id=pk1)
            client = Client.objects.get(pk=key)
        except (Domaine.DoesNotExist, Prestation.DoesNotExist):
            return Response({'error': 'Domaine or Prestation not found'}, status=status.HTTP_404_NOT_FOUND)

        # Create the serializer instance with request data
        serializer = self.serializer_class(data=request.data)
        serializer.is_valid(raise_exception=True)

        # Assign domaine and prestation from URL parameters
        serializer.validated_data['domaine'] = domaine
        serializer.validated_data['prestation'] = prestation
        serializer.validated_data['client'] = client

        # Save the Demande instance without specifying the owner
        serializer.save()

        # Return response with serialized data and 201 status code
        return Response(serializer.data, status=status.HTTP_201_CREATED)
    
class PrestationList_Demande(generics.ListCreateAPIView):
    queryset = Prestation.objects.all()
    serializer_class = PrestationSerializer
    permission_classes = [permissions.IsAuthenticatedOrReadOnly]

    def get_queryset(self):
        # Filter Prestations by Domaine
        domaine_pk = self.kwargs.get('pk')
        return Prestation.objects.filter(domaine_id=domaine_pk)

    def perform_create(self, serializer):
        # Set the domaine_id when creating a new Prestation
        domaine_pk = self.kwargs.get('pk')
        serializer.save(domaine_id=domaine_pk)

class PrestationDetail_Demande(generics.RetrieveUpdateDestroyAPIView):
    queryset = Prestation.objects.all()
    serializer_class = PrestationSerializer
    permission_classes = [permissions.IsAuthenticatedOrReadOnly]

class DemandeDetail_all(generics.RetrieveUpdateDestroyAPIView):
    queryset = Demande.objects.all()
    serializer_class = DemandeSerializer

class Demande_artisan(generics.ListCreateAPIView):
    serializer_class = DemandeSerializer

    def get_queryset(self):
        artisan_id = self.kwargs.get('pk')
        artisan = get_object_or_404(Artisan, pk=artisan_id)
        artisan_lat = artisan.latitude
        artisan_lon = artisan.longitude
        art_dom = artisan.domaine
        
        # Retrieve all demandes associated with the artisan
        demandes = Demande.objects.all()
        # Filter demandes based on distance and domaine
        filtered_demandes = []
        for demande in demandes:
            heure_out = demande.heure_fin 
            distance = calculate_distance(artisan_lat, artisan_lon, demande.latitude, demande.longitude)
            print(distance)
            if distance < 50 and demande.domaine == art_dom :
                filtered_demandes.append(demande)
            
        return filtered_demandes
    
class AcceptDemande(generics.CreateAPIView):
   serializer_class = DemandeaccepteeSerializer
    
   def post(self, request, pk1, pk2):
        try:
            artisan = Artisan.objects.get(pk=pk1)
            demande = Demande.objects.get(pk=pk2)  # Ensure the demande is associated with the artisan
        except (Artisan.DoesNotExist, Demande.DoesNotExist):
            return Response({'error': 'Artisan or Demande not found'}, status=status.HTTP_404_NOT_FOUND)

        # Create the serializer instance with request data
        serializer = self.serializer_class(data=request.data)
        serializer.is_valid(raise_exception=True)

        # Assign the IDs to the serializer's validated data
        serializer.validated_data['demande_id'] = demande
        serializer.validated_data['artisan_id'] = artisan

        
        # Save the Demandeacceptee instance
        serializer.save()

        # Return response with serialized data and 201 status code
        return Response(serializer.data, status=status.HTTP_201_CREATED)

class GetMessage(generics.ListAPIView):
   serializer_class=MessageSerializer
   
   def get_queryset(self):
        sender_id= self.kwargs['sender_id']
        reciever_id=self.kwargs['reciever_id']
        messgaes=Message.objects.filter(
            sender__in=[sender_id,reciever_id],
            reciever__in=[sender_id,reciever_id]
        )
        return messgaes
   def update_is_sender_field(self, queryset, sender_id):
        for message in queryset:
            message.is_sender = message.sender_id == int(sender_id)
        return queryset
   
   def list(self, request, *args, **kwargs):
        queryset = self.get_queryset()
        sender_id = self.kwargs['sender_id']
        queryset = self.update_is_sender_field(queryset, sender_id)
        serializer = self.get_serializer(queryset, many=True)
        return Response(serializer.data)

class SendMessage(generics.CreateAPIView):
       serializer_class=MessageSerializer

       def post(self, request, pk1, pk2):
        try:
            sender = User.objects.get(pk=pk1)
            reciever = User.objects.get(pk=pk2)
        except (User.DoesNotExist, User.DoesNotExist):
            return Response({'error': 'user not found'}, status=status.HTTP_404_NOT_FOUND)

        serializer = self.serializer_class(data=request.data)
        serializer.is_valid(raise_exception=True)

        serializer.validated_data['sender'] = sender
        serializer.validated_data['reciever'] = reciever
        
        serializer.save()
        return Response(serializer.data, status=status.HTTP_201_CREATED)

class listeArtisan(generics.ListAPIView):
    queryset = Demandeacceptee.objects.all()
    #serializer_class = DemandeaccepteeSerializer
    serializer_class = ArtisanSerializer

    def get_queryset(self):
        demande_id = self.kwargs.get('key')
        demande_acceptee_objects = Demandeacceptee.objects.filter(demande_id=demande_id)
        artisans = [demande.artisan_id for demande in demande_acceptee_objects]
        return artisans