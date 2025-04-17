# mysite/blog/context_processors.py
from taggit.models import Tag

def tags_processor(request):
    """Context processor qui rend tous les tags disponibles dans le template."""
    tags = Tag.objects.all()
    return {'tags': tags}