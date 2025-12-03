from dooit.ui.api import DooitAPI, subscribe
from dooit.ui.api.events import Startup
from rich.style import Style
from dooit.api.theme import DooitThemeBase
from dooit_extras.formatters import *
from dooit_extras.bar_widgets import *
from dooit_extras.scripts import *
from rich.text import Text

class Nord(DooitThemeBase):
    _name = "dooit-nord"

    background1: str = "#282a36"  # Darkest
    background2: str = "#44475a"  # Lighter
    background3: str = "#434C5E"  # Lightest

    # foreground colors
    foreground1: str = "#f8f8f2"  # Darkest
    foreground2: str = "#E5E9F0"  # Lighter
    foreground3: str = "#ECEFF4"  # Lightest

    # other colors
    red: str = "#ff5555"
    orange: str = "#ffb86c"
    yellow: str = "#f1fa8c"
    green: str = "#50fa7b"
    blue: str = "#6272a4"
    purple: str = "#bd93f9"
    magenta: str = "#ff79c6"
    cyan: str = "#8be9fd"

    # accent colors
    primary: str = cyan
    secondary: str = blue


@subscribe(Startup)
def setup_colorscheme(api: DooitAPI, _):
    api.css.set_theme(Nord)


@subscribe(Startup)
def setup_formatters(api: DooitAPI, _):
    fmt = api.formatter
    theme = api.vars.theme

    # ------- WORKSPACES -------
    format = Text(" ({}) ", style=theme.primary).markup
    fmt.workspaces.description.add(description_children_count(format))

    # --------- TODOS ---------
    # status formatter
    fmt.todos.status.add(status_icons(completed=" ", pending="󰞋 ", overdue="󰅗 "))

    # urgency formatte
    u_icons = {1: "  󰎤", 2: "  󰎧", 3: "  󰎪", 4: "  󰎭"}
    fmt.todos.urgency.add(urgency_icons(icons=u_icons))

    # due formatter
    fmt.todos.due.add(due_casual_format())
    fmt.todos.due.add(due_icon(completed=" ", pending=" ", overdue=" "))

    # description formatter
    format = Text("  {completed_count}/{total_count}", style=theme.green).markup
    fmt.todos.description.add(todo_description_progress(fmt=format))
    fmt.todos.description.add(description_highlight_tags(fmt=" {}"))


@subscribe(Startup)
def setup_bar(api: DooitAPI, _):
    theme = api.vars.theme

    widgets = [
        Mode(api),
        Spacer(api, width=0),
        StatusIcons(api, bg=theme.background2),
        TextBox(api, text=" 󰥔 ", bg=theme.primary),
        Clock(api, format="%I:%M %p", fg=theme.foreground3, bg=theme.background3),
    ]
    api.bar.set(widgets)


@subscribe(Startup)
def setup_dashboard(api: DooitAPI, _):
    from datetime import datetime

    theme = api.vars.theme

    now = datetime.now()
    formatted_date = now.strftime(" 󰸘 %A, %d %b ")

    header = Text(
        "I alone shall stand against the darkness of my overdue tasks",
        style=Style(color=theme.primary, bold=True, italic=True),
    )

    ascii_art = r"""
                     .
                    / V\
                  / `  /
                 <<   |
                 /    |
               /      |
             /        |
           /    \  \ /
          (      ) | |
  ________|   _/_  | |
<__________\______)\__)
    """

    items = [
        header,
        "",
        Text(ascii_art, style=api.vars.theme.primary),
        "",
        Text(
            formatted_date,
            style=Style(color=theme.secondary, bold=True, italic=True),
        ),
    ]
    api.dashboard.set(items)
