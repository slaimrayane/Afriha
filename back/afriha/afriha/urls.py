"""
URL configuration for afriha project.

The `urlpatterns` list routes URLs to views. For more information please see:
    https://docs.djangoproject.com/en/5.0/topics/http/urls/
Examples:
Function views
    1. Add an import:  from my_app import views
    2. Add a URL to urlpatterns:  path('', views.home, name='home')
Class-based views
    1. Add an import:  from other_app.views import Home
    2. Add a URL to urlpatterns:  path('', Home.as_view(), name='home')
Including another URLconf
    1. Import the include() function: from django.urls import include, path
    2. Add a URL to urlpatterns:  path('blog/', include('blog.urls'))
"""
from django.contrib import admin
from django.urls import path , include
from authentication.views import UserRegistrationView, UserLoginView, UserLogoutView , ArtisanRegistrationView , AdministratorRegistrationView , ClientRegistrationView, ArtisanWaitingRegistrationView, SendVerificationEmailView , UserUpdateView


urlpatterns = [

    path('admin/', admin.site.urls),
    path('api/auth/register/', UserRegistrationView.as_view(), name='user-registration'),
    path('api/auth/login/', UserLoginView.as_view(), name='user-login'),
    path('api/auth/logout/', UserLogoutView.as_view(), name='user-logout'),
    path('api/auth/register/artisan/', ArtisanRegistrationView.as_view(), name='artisan-registration'),
    path('api/auth/register/administrator/', AdministratorRegistrationView.as_view(), name='administrator-registration'),
    path('api/auth/register/client/', ClientRegistrationView.as_view(), 
    name='client-registration'),
    path('api/auth/register/artisan-waiting/', ArtisanWaitingRegistrationView.as_view(), name='artisan-waiting-registration'),
    path('api/verification/', SendVerificationEmailView.as_view() , name='verification' ),
    path('existences/', include('existences.urls')),

    path('api/users/<int:pk>/', UserUpdateView.as_view(), name='user-update'),
]
