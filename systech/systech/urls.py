from django.contrib import admin
from django.contrib.auth.views import LoginView, LogoutView
from django.urls import include, path

from afijo.views import HomeView, PlantaList, PlantaDetail, PlantaDepreciacion \
                      , PlantaDepreciacionAnual, PlantaDepreciacionMensual
from afijo.activoView import ActivoListView
from afijo.depreciacionView import DepreciacionListView, DepreciacionAcumView
from afijo.forms import PlantaForm

app_name = 'afijo'
urlpatterns = [
    path('', HomeView.as_view(), name='home'),
    path('home/', HomeView.as_view()),
    path('admin/', admin.site.urls),
    path('login/', LoginView.as_view(), name='login'),
    path('logout/', LogoutView.as_view(), name='logout'),
    path('activoList', ActivoListView.as_view(), name='activoList'),
    path('activoListCsv', ActivoListView.toCSV, name='activoListCsv'),
    path('depreciacionAcum',
         DepreciacionAcumView.as_view(),
         name='depreciacionAcum'),
    path('depreciacionAcumCsv',
         DepreciacionAcumView.toCSV,
         name='depreciacionAcumCsv'),
    path('depreciacionList',
         DepreciacionListView.as_view(),
         name='depreciacionList'),
    path('depreciacionCsv', DepreciacionListView.toCSV,
         name='depreciacionCsv'),
    path('lisActivosPlanta/', PlantaList.as_view(), name='lisActivosPlanta'),
    path('lisDepreciacionPlanta/',
         PlantaDepreciacion.as_view(),
         name='lisDepreciacionPlanta'),
    path('csvDepreciacionPlanta/',
         PlantaDepreciacion.toCSV,
         name='csvDepreciacionPlanta'),
    path('cambioPlanta/', PlantaForm.cambioPlanta, name='cambioPlanta'),
    path('plantaDepreciacion/<int:pk>',
         PlantaDepreciacionAnual.as_view(),
         name='plantaDepreciacion'),
    path('plantaDepreciacion/<int:year>/<int:pk>',
         PlantaDepreciacionMensual.as_view(),
         name='plantaDepreciacion'),
]

admin.site.site_header = 'Administración de Systech'
admin.site.site_title = 'Sitio de administración de Systech'
