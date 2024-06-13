from django.urls import path
from existences import views

urlpatterns = [
    
    path('api/administrators/', views.AdministratorList.as_view(), name='administrator-list'),
    path('api/administrators/<int:pk>/', views.AdministratorDetail.as_view(), name='administrator-detail'),

    path('api/users/<int:pk>/notifications/' , views.NotificationList.as_view() , name='Liste-Notifications'),
    path('api/users/<int:pk>/notifications/send/' , views.Notifier.as_view() , name='send-notification'),
    path('api/users/<int:pk>/notifications/vue/' , views.NotificationVue.as_view() , name='read-notification'),

    
    path('api/artisans/', views.ArtisanList.as_view(), name='artisan-list'),
    path('api/artisans/<int:pk>/', views.ArtisanDetail.as_view(), name='artisan-detail'),
    path('api/artisans/<int:pk>/demandes/', views.Demande_artisan.as_view(), name='demande-create'),
    path('api/artisans/<int:pk1>/demandes/<int:pk2>/', views.AcceptDemande.as_view() , name = 'post-demande'),
    path('api/artisans/<int:pk>/commentaires/' , views.CommentairesList.as_view() , name = 'listeInterventions'),
    

    path('api/clients/', views.ClientList.as_view(), name='client-list'),
    path('api/clients/<int:pk>/', views.ClientDetail.as_view(), name='client-detail'),
    path('api/clients/<int:pk>/demandes/', views.DemandeList.as_view(), name='demande-list'),
    path('api/clients/<int:pk>/demandes/<int:key>', views.listeArtisan.as_view(), name='Artisan-list'),
    path('api/clients/<int:pk>/demandes/<int:key>/confirmer/<int:id>', views.Confirmer_Rendezvous.as_view(), name='Artisan-list'),
    path('api/clients/<int:pk>/demandes/<int:key>/commentaires/' , views.Commenter.as_view(), name='commentaire_create'),
    
    path('api/artisan-waiting/', views.ArtisanWaitingList.as_view(), name='artisanwaiting-list'),
    path('api/artisan-waiting/<int:pk>/', views.ArtisanWaitingDetail.as_view(), name='artisanwaiting-detail'),
    
    path('api/get_messages/<sender_id>/<reciever_id>/',views.GetMessage.as_view(), name = 'GetMessages'),
    path('api/send_message/<int:pk1>/<int:pk2>/',views.SendMessage.as_view(), name = 'SendMessage'),

    #path('api/commentaires/', views.CommentairesList.as_view(), name='commentaires-list'),
    path('api/commentaires/<int:pk>/', views.CommentairesDetail.as_view(), name='commentaires-detail'),
    
    #path('api/demandes/', views.DemandeList.as_view(), name='demande-list'),
    path('api/demandes/<int:pk>/', views.DemandeDetail.as_view(), name='demande-detail'),
    
    path('api/prestations/', views.PrestationList.as_view(), name='prestation-list'),
    path('api/prestations/<int:pk>/', views.PrestationDetail.as_view(), name='prestation-detail'),
    

    path('api/domaines/', views.DomaineList.as_view(), name='domaine-list'),
    path('api/domaines/<int:pk>/', views.DomaineDetail.as_view(), name='domaine-detail'),
    
    path('api/notifications/', views.NotificationList.as_view(), name='notification-list'),
    path('api/notifications/<int:pk>/', views.NotificationDetail.as_view(), name='notification-detail'),
    
    path('api/rendezvous/', views.RendezVousList.as_view(), name='rendezvous-list'),
    path('api/rendezvous/<int:pk>/', views.RendezVousDetail.as_view(), name='rendezvous-detail'),
    
    path('api/dialogues/', views.DialogueList.as_view(), name='dialogue-list'),
    path('api/dialogues/<int:pk>/', views.DialogueDetail.as_view(), name='dialogue-detail'),
    
    path('api/messages/', views.MessageList.as_view(), name='message-list'),
    path('api/messages/<int:pk>/', views.MessageDetail.as_view(), name='message-detail'),

    path('api/clients/view/', views.ClientListView.as_view(), name='client-list'),

    path('api/demandes/', views.Demander.as_view(), name='demande-create'),
    path('api/rendezvous/<int:pk1>/<int:pk2>/', views.Confirmer_Rendezvous.as_view(), name='rendezvous-confirm'),
    path('api/prestations/domaine/', views.PrestationListByDomaine.as_view(), name='prestation-list-by-domaine'),
    #path('api/domaines/<int:pk1>/Prestations/<int:pk2>/demande/', views.Demander.as_view(), name='demande_create'),
    path('api/clients/<int:key>/domaines/<int:pk1>/Prestations/<int:pk2>/demande/', views.Demander.as_view(), name='demande_create'),
    path('api/domaines/<int:pk>/Prestations/' , views.PrestationList_Demande.as_view() , name="prestation de domaine "),
    #path('api/domaines/<int:pk>/Prestations/<int:pk2>/' , views.PrestationDetail_Demande.as_view() , name="prestation_id_domaine"),
]
