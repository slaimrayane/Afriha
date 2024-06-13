from django.contrib import admin

from .models import Client ,Artisan,Domaine,Prestation,Demande , Demandeacceptee

class ClientAdmin(admin.ModelAdmin):
    
    list_display = [ 'user' ,  'num_phone']

    def get_list_display(self, request):
      """
      Override get_list_display method to prevent changing list_display
      """
      return self.list_display
  
    def get_list_display_links(self, request, list_display):
      """
      Override get_list_display_links method to prevent changing list_display_links
      """
      return (None, )
    

admin.site.register(Client , ClientAdmin)

class ArtisanAdmin(admin.ModelAdmin):
  list_editable = ['banni' , 'confirmer']
  list_display = [ 'user' , 'diplome' , 'notation' , 'domaine' , 'banni' , 'confirmer' ]
  
  def get_list_display(self, request):
    """
    Override get_list_display method to prevent changing list_display
    """
    return self.list_display
  
  def get_list_display_links(self, request, list_display):
    """
    Override get_list_display_links method to prevent changing list_display_links
    """
    return ( None )

admin.site.register(Artisan , ArtisanAdmin)

admin.site.register(Domaine)

admin.site.register(Prestation)

class DemandeAdmin(admin.ModelAdmin):
  list_display = ['localisation' , 'date' , 'heure_debut' , 'heure_fin' , 'description' , 'Tarif' ,  'client' , 'domaine' , 'prestation' , 'Confirme' , 'artisan' , 'notee']
  
  def get_list_display(self, request):
    """
    Override get_list_display method to prevent changing list_display
    """
    return self.list_display

  def get_list_display_links(self, request, list_display):
    """
    Override get_list_display_links method to prevent changing list_display_links
    """
    return (None, )

     

admin.site.register(Demande , DemandeAdmin)


class DemandeaccepteAdmin(admin.ModelAdmin):
  list_display=['demande_id' , 'artisan_id']
  def get_list_display(self, request):
    """
    Override get_list_display method to prevent changing list_display
    """
    return self.list_display

  def get_list_display_links(self, request, list_display):
    """
    Override get_list_display_links method to prevent changing list_display_links
    """
    return (None, )

admin.site.register(Demandeacceptee , DemandeaccepteAdmin)
# Register your models here.