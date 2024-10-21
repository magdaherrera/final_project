from flask_wtf import FlaskForm
from wtforms import StringField, SubmitField, PasswordField
from wtforms.validators import DataRequired, URL
from flask_ckeditor import CKEditorField


# WTForm for creating a blog post
class CreatePostForm(FlaskForm):
    title = StringField("Título", validators=[DataRequired()])
    subtitle = StringField("Subtítulo", validators=[DataRequired()])
    img_url = StringField("URL de imagen", validators=[DataRequired(), URL()])
    body = CKEditorField("Contenido", validators=[DataRequired()])
    submit = SubmitField("Enviar Post")


# Create a form to register new users
class RegisterForm(FlaskForm):
    email = StringField("Correo", validators=[DataRequired()])
    password = PasswordField("Contraseña", validators=[DataRequired()])
    name = StringField("Nombre", validators=[DataRequired()])
    submit = SubmitField("¡Registrate!")


# Create a form to login existing users
class LoginForm(FlaskForm):
    email = StringField("Correo", validators=[DataRequired()])
    password = PasswordField("Contraseña", validators=[DataRequired()])
    submit = SubmitField("Ingresar")


# Create a form to add comments
class CommentForm(FlaskForm):
    comment_text = CKEditorField("Comentario", validators=[DataRequired()])
    submit = SubmitField("Enviar Comentario")
