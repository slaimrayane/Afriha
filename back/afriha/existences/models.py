 
from pygments.lexers import get_lexer_by_name
from pygments.formatters.html import HtmlFormatter
from pygments import highlight
from django.db import models
from authentication.models import User
import datetime
from datetime import time



class Administrator(models.Model):
    # other fields related to student ...
    administrator_id = models.CharField(max_length=10, unique=True)
    user = models.OneToOneField(User, on_delete=models.CASCADE, related_name="administrator_account")

class Artisan(models.Model):
    
    num_phone = models.IntegerField(unique=True)
    latitude = models.FloatField(null=True, blank=False)  
    longitude = models.FloatField(null=True, blank=False)
    status = models.BooleanField(default=False)
    diplome = models.TextField()
    nb_interventions = models.IntegerField(default=0)
    banni = models.BooleanField(default=False)
    notation = models.FloatField(default=4)
    domaine = models.ForeignKey('Domaine', on_delete=models.CASCADE)

    confirmer = models.BooleanField(default=False) #Admin plus tard peut le confirmer

    
    user = models.OneToOneField(User, on_delete=models.CASCADE, related_name="artisan_account")

class Client(models.Model):
    
    num_phone = models.IntegerField(unique=True)
    #client_id = models.CharField(max_length=10, unique=True)
    user = models.OneToOneField(User, on_delete=models.CASCADE, related_name="client_account")

class ArtisanWaiting(models.Model):
    nom = models.CharField(max_length=255)
    prenom = models.CharField(max_length=255)
    num_phone = models.IntegerField(unique=True)
    wilaya = models.CharField(max_length=255)
    commune = models.CharField(max_length=255)
    photo = models.BinaryField(null=True, blank=True)
    domaine_expertise = models.CharField(max_length=255)
    diplome = models.TextField()
    artisan = models.ForeignKey('Artisan', on_delete=models.CASCADE)
    artisanWaiting_id = models.CharField(max_length=10, unique=True)
    user = models.OneToOneField(User, on_delete=models.CASCADE, related_name="artisanWaiting_account")

class Commentaires(models.Model):
    id = models.AutoField(primary_key=True)
    commentaire = models.TextField()
    demande = models.ForeignKey('Demande', on_delete=models.CASCADE)
    notation = models.FloatField(null=True, blank=False)

class Demande(models.Model):
    id = models.AutoField(primary_key=True)
    created_at = models.DateTimeField(auto_now_add=True)
    type = models.CharField(max_length=255,default='simple')
    latitude = models.FloatField(null=True, blank=False)  # Store latitude coordinate
    longitude = models.FloatField(null=True, blank=False)
    localisation=models.CharField(max_length=255) 
    date = models.DateField()
    heure_debut = models.TimeField(null=True)
    heure_fin = models.TimeField(null=True)
    description = models.TextField(null=True)
    Tarif = models.FloatField()
    client = models.ForeignKey(Client, related_name='demandes', on_delete=models.CASCADE , null = False)
    domaine = models.ForeignKey('Domaine', on_delete=models.CASCADE)
    prestation = models.ForeignKey('Prestation', on_delete=models.CASCADE)

    Confirme = models.BooleanField(default=False)
    notee = models.BooleanField(default=False)
    artisan = models.ForeignKey("Artisan" , on_delete=models.CASCADE , null=True , blank=True)
    
    def calculer_supplement_nuit_ou_ferie(self):
    
     supplément = 0.0  # Supplément par défaut

   
     if self.heure_debut and self.heure_fin:
        heure_debut_nuit = time(hour=22)  # Définir l'heure de début pour la nuit (ex : 22h)
        heure_fin_nuit = time(hour=6)  # Définir l'heure de fin pour la nuit (ex : 6h)
        liste_jours_fériés = [  # Liste des dates de jours fériés (à ajuster)
            datetime.date(year=2024, month=1, day=1),  
            datetime.date(year=2024, month=1, day=12),
            datetime.date(year=2024, month=4, day=10),
            datetime.date(year=2024, month=5, day=1),
            datetime.date(year=2024, month=6, day=16),
            datetime.date(year=2024, month=7, day=5),
            datetime.date(year=2024, month=7, day=7),
            datetime.date(year=2024, month=9, day=16),
            datetime.date(year=2024, month=11, day=1),
        ]
        heure_debut_demande = self.heure_debut
        heure_fin_demande = self.heure_fin
        # Vérifier la plage horaire de nuit
        nuit_passée = heure_debut_nuit <= heure_fin_nuit
        nuit = (heure_debut_demande >= heure_debut_nuit or heure_debut_demande < heure_fin_nuit) \
               or (heure_fin_demande > heure_debut_nuit or heure_fin_demande <= heure_fin_nuit)

        if (nuit):
            supplément = 0.2  # Définir le supplément pour la nuit
        
        date_demande = self.date
        if date_demande.weekday() == 4 or date_demande in liste_jours_fériés:
            supplément += 0.3  # Définir le supplément pour jour férié ou weekned


     return supplément
    
    def save(self, *args, **kwargs):
     if not self.Tarif and self.prestation:
        self.Tarif = self.prestation.prix_approximatif

        # Calculate and apply surcharge if applicable
        surcharge = self.calculer_supplement_nuit_ou_ferie()
        print(surcharge)
        if surcharge > 0:
            self.Tarif =  self.Tarif*(1 + surcharge)
        
     super().save(*args, **kwargs)
    
    class Meta:
        ordering = ['-created_at']

class Demandeacceptee(models.Model):
   demande_id = models.ForeignKey('Demande', on_delete=models.CASCADE)
   artisan_id =models.ForeignKey('Artisan',on_delete=models.CASCADE)
    
class Prestation(models.Model):
    id = models.AutoField(primary_key=True)
    nom_prestation = models.CharField(max_length=255)
    domaine_id = models.ForeignKey('Domaine', on_delete=models.CASCADE)
    prix_approximatif = models.FloatField()
    duree_de_realisation = models.TimeField()
    materiel_necessaire = models.TextField()

class Domaine(models.Model):
    id = models.AutoField(primary_key=True)
    nom_domaine = models.CharField(max_length=255)
    photo = models.CharField(max_length=255 ,null=True,blank=True)   

class RendezVous(models.Model):
    id = models.AutoField(primary_key=True)
    date = models.DateField()
    artisan = models.ForeignKey(Artisan, on_delete=models.CASCADE,null=True)
    demande = models.ForeignKey(Demande, on_delete=models.CASCADE)

class Dialogue(models.Model):
    id = models.AutoField(primary_key=True)
    client = models.ForeignKey(Client, on_delete=models.CASCADE)
    artisan = models.ForeignKey(Artisan, on_delete=models.CASCADE)

class Message(models.Model):
    
    sender=models.ForeignKey(User, on_delete=models.CASCADE,related_name='sender')
    reciever=models.ForeignKey(User, on_delete=models.CASCADE,related_name='reciever')
    date=models.DateTimeField(auto_now_add=True)
    Message = models.CharField(max_length=1000)
    is_sender= models.BooleanField(default=False)

    class Meta:
        ordering = ['date']

class Notification(models.Model):
    id = models.AutoField(primary_key=True)
    receiver = models.ForeignKey(User, on_delete=models.CASCADE,related_name='receiver')
    notification = models.CharField(max_length=255)
    vue = models.BooleanField(default=False)
    date_envoie = models.DateTimeField(auto_now_add=True)

    class Meta:
        ordering = ['date_envoie']


