# authentication/views.py

from authentication.models import User
from authentication.serializers import UserSerializer , UserUpdateSerializer
from django.contrib.auth import authenticate, login
from rest_framework import status , generics
from rest_framework.response import Response
from rest_framework.views import APIView
from rest_framework.authtoken.views import ObtainAuthToken
from rest_framework.authtoken.models import Token
from rest_framework.permissions import IsAuthenticated

from existences.models import Administrator, Artisan, Client, ArtisanWaiting

from existences.serializers import (
    AdministratorSerializer,
    ArtisanSerializer,
    ClientSerializer,
    ArtisanWaitingSerializer,
)

from django.core.mail import send_mail
from .serializers import SendVerificationEmailSerializer
from .models import VerificationCode  # Import your VerificationCode model

class SendVerificationEmailView(APIView):
    def post(self, request):
        serializer = SendVerificationEmailSerializer(data=request.data)
        if serializer.is_valid():
            email = serializer.validated_data['email']
            # Generate verification code
            verification_code = '135893'
            # Save verification code to the database
            VerificationCode.objects.create(email=email, code=verification_code)
            # Send email
            send_mail(
                'Verification Code',
                f'Your verification code is: {verification_code}',
                'mm_hamroun@esi.dz',  # Replace with your sender's email address
                [email],  # Recipient's email address
                fail_silently=False,
            )
            return Response({'message': 'Verification email sent successfully'}, status=status.HTTP_200_OK)
        return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)


class UserUpdateView(generics.UpdateAPIView):
    queryset = User.objects.all()
    serializer_class= UserUpdateSerializer

class UserRegistrationView(APIView):
    def post(self, request):
        serializer = UserSerializer(data=request.data)
        if serializer.is_valid():
            serializer.save()
            return Response(serializer.data, status=status.HTTP_201_CREATED)
        return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)

class ArtisanRegistrationView(APIView):
    def post(self, request):
        serializer = ArtisanSerializer(data=request.data)
        if serializer.is_valid():
            # Create the user and artisan profile
            user = serializer.save()
            # You can perform additional actions here if needed
            return Response(serializer.data, status=status.HTTP_201_CREATED)
        return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)

class ClientRegistrationView(APIView):
    def post(self, request):
        serializer = ClientSerializer(data=request.data)
        if serializer.is_valid():
            serializer.save()
            return Response(serializer.data, status=status.HTTP_201_CREATED)
        else:
            return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)

class ArtisanWaitingRegistrationView(APIView):
    def post(self, request):
        serializer = ArtisanWaitingSerializer(data=request.data)
        if serializer.is_valid():
            # Create the user and artisan waiting profile
            user = serializer.save()
            # You can perform additional actions here if needed
            return Response(serializer.data, status=status.HTTP_201_CREATED)
        return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)

class AdministratorRegistrationView(APIView):
    def post(self, request):
        serializer = AdministratorSerializer(data=request.data)
        if serializer.is_valid():
            # Create the user and administrator profile
            user = serializer.save()
            # You can perform additional actions here if needed
            return Response(serializer.data, status=status.HTTP_201_CREATED)
        return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)

class UserLoginView(ObtainAuthToken):
    def post(self, request, *args, **kwargs):
        username = request.data.get('username')
        password = request.data.get('password')

        user = authenticate(request, username=username, password=password)
        if user is not None:
            login(request, user)
            token, created = Token.objects.get_or_create(user=user)
            if created:
                token.delete()  # Delete the token if it was already created
                token = Token.objects.create(user=user)

            response_data = {
                'token': token.key,
                'username': user.username,
                'role': user.role,
            }

            if user.role == 'administrator':
                administrator = user.administrator_account
                if administrator is not None:
                    # Add administrator data to the response data
                    administrator_data = AdministratorSerializer(administrator).data
                    response_data['data'] = administrator_data

            elif user.role == 'artisan':
                artisan = user.artisan_account
                if artisan is not None:
                    # Add artisan data to the response data
                    artisan_data = ArtisanSerializer(artisan).data
                    response_data['data'] = artisan_data

            elif user.role == 'client':
                client = user.client_account
                if client is not None:
                    # Add client data to the response data
                    client_data = ClientSerializer(client).data
                    response_data['data'] = client_data

            elif user.role == 'artisan_waiting':
                artisan_waiting = user.artisanwaiting_account
                if artisan_waiting is not None:
                    # Add artisan waiting data to the response data
                    artisan_waiting_data = ArtisanWaitingSerializer(artisan_waiting).data
                    response_data['data'] = artisan_waiting_data

            return Response(response_data)
        else:
            return Response({'message': 'Invalid username or password'}, status=status.HTTP_401_UNAUTHORIZED)

class UserLogoutView(APIView):
    permission_classes = [IsAuthenticated]

    def post(self, request):
        print(request.headers) 
        token_key = request.auth.key
        token = Token.objects.get(key=token_key)
        token.delete()

        return Response({'detail': 'Successfully logged out.'})