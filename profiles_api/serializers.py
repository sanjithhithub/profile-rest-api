from rest_framework import serializers
from profiles_api import models

class HelloSerializer(serializers.Serializer):
    """Serializers a name field for testing our APIView"""
    name = serializers.CharField(max_length=10)

class UserProfileSerializer(serializers.ModelSerializer):
    """Serializer for the UserProfile model"""

    class Meta:
        model = models.UserProfile
        fields = ('id', 'email', 'name', 'password')
        extra_kwargs = {
            'password': {
                'write_only': True,
                'style': {'input_type': 'password'}
            }
        }

    def create(self, validated_data):
        """Create and return a new user"""
        user = models.UserProfile.objects.create_user(
            email=validated_data['email'],
            name=validated_data['name'],
            password=validated_data['password']
        )
        return user

class ProfilesFeedItemSerializer(serializers.ModelSerializer):
    """Serializer profile feed items"""

    class Meta:
        model = models.ProfilesFeedItem  # corrected the model name
        fields = ('id', 'user_profile', 'status_text', 'created_on')  # corrected the fields attribute
        extra_kwargs = {'user_profile': {'read_only': True}}
