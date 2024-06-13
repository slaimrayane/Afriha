from django.contrib import admin
from django.contrib.auth.admin import UserAdmin as BaseUserAdmin
from django.contrib.auth import get_user_model

User = get_user_model()

class CustomUserAdmin(BaseUserAdmin):
  model = User
  fieldsets = BaseUserAdmin.fieldsets + (
    (None, {'fields': ('role',)}),
  )
  list_display = ('username', 'email', 'first_name', 'last_name', 'is_staff', 'role')
  list_filter = ('is_staff', 'is_superuser', 'is_active', 'role')
  search_fields = ('username', 'email', 'first_name', 'last_name')
  readonly_fields = ('username', 'email', 'first_name', 'last_name', 'role')  # Make all fields readonly

admin.site.register(User, CustomUserAdmin)