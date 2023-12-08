from rest_framework.views import APIView
from rest_framework.response import Response
from rest_framework import status
from rest_framework import viewsets
from profiles_api import serializers

class HelloApiView(APIView):
    """Test API view"""
    serializer_class = serializers.HelloSerializer

    def get(self, request, format=None):
        """Returns a list of APIview feature"""
        an_apiview = [
            'User HTTP method as function (get,post,patch,put,delete)',
            'Is similar to a traditional Django View ',
            'Gives you the most control over your application logic',
            'Is mapped manually to URLS',
        ]
        return Response({'messages': 'Hello', 'an_apiview': an_apiview})

    def post(self, request):
        """Create a hello message with our name"""
        serializer = self.serializer_class(data=request.data)

        if serializer.is_valid():
            name = serializer.validated_data.get('name')
            message = f'hello {name}'
            return Response({'message': message})
        else:
            return Response(
                serializer.errors,
                status=status.HTTP_400_BAD_REQUEST
            )

    def put(self, request, pk=None):
        """Handle updating an object"""
        return Response({'method':'PUT'})

    def patch(self, request, pk=None):
        """ Handle a partital update of an object"""
        return Response({'method':'PATCH'})


    def delete(self, request, pk=None):
        """Delete an object"""
        return Response({'method':'DELETE'})

class HelloViewSets(viewsets.ViewSet):
    """Test ApI ViewSets"""

    def list(self, request):
        """Return a hello message"""

        a_viewsets = [
          'User actions (list,create,retrieve,update,partial_update),'
          ''


        ]
