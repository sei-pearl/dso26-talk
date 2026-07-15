from django.shortcuts import render, redirect

from .forms import MessageForm
from .models import Message


def home(request):

    if request.method == "POST":
        form = MessageForm(request.POST)

        if form.is_valid():
            Message.objects.create(
                text=form.cleaned_data["text"]
            )
            return redirect("/")

    else:
        form = MessageForm()

    return render(
        request,
        "textapp/home.html",
        {
            "form": form,
            "messages": Message.objects.all(),
        },
    )
