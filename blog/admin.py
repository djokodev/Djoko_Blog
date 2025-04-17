from django.contrib import admin
from .models import Post, Comment
from django.db import models
from django_ckeditor_5.widgets import CKEditor5Widget


@admin.register(Post)
class PostAdmin(admin.ModelAdmin):
    list_display = ["title", "slug", "author", "publish", "status"]
    list_filter = ["status", "created", "publish", "author"]
    search_fields = ["title", "body"]
    prepopulated_fields = {"slug": ("title",)}
    raw_id_fields = ["author"]
    date_hierarchy = "publish"
    ordering = ["status", "publish"]
    show_facets = admin.ShowFacets.ALWAYS

    formfield_overrides = {
        models.TextField: {
            "widget": CKEditor5Widget(
                config_name="extends",
                attrs={"style": "width: 100%;"},
            )
        },
    }

    fieldsets = (
        (
            "Post Information",
            {"fields": ("title", "slug", "author", "status", "tags", "image")},
        ),
        ("Content", {"fields": ("body",), "classes": ("wide",)}),
    )


@admin.register(Comment)
class CommentAdmin(admin.ModelAdmin):
    list_display = ["name", "email", "post", "created", "active"]
    list_filter = ["active", "created", "updated"]
    search_fields = ["name", "email", "body"]
