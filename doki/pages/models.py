from django.db import models


class Page(models.Model):
    slug = models.CharField(max_length=200, unique=True)

    def __unicode__(self):
        return self.slug


class Version(models.Model):
    page = models.ForeignKey(Page)
    revision = models.IntegerField()
    created = models.DateTimeField()

    class Meta:
        abstract = True


class Text(Version):
    title = models.CharField(max_length=200, blank=True)
    text = models.TextField(blank=True)

    def __unicode__(self):
        return '{} (rev {})'.format(self.title, self.revision)
