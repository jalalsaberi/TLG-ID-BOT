from telegram import Update
from telegram.ext import Updater, MessageHandler, Filters, CommandHandler

TOKEN = ''

def private_message(update: Update, _):

    message = update.effective_message
    forwarded = message.forward_date or message.forward_from

    if forwarded:
        user = message.forward_from
    else:
        user = message.from_user

    user_id = user.id if user else None
    first_name = user.first_name if user and user.first_name else ''
    last_name = user.last_name if user and user.last_name else ''
    username = user.username if user and user.username else None
    try:
        chat = update.effective_chat.bot.get_chat(user_id)
        user_bio = chat.bio if chat.bio else None
    except:
        user_bio = None

    if user_id is not None:
        reply_text = f"👤 Name: {'<i>None</i>' if first_name is None and last_name is None else f'{first_name} {last_name}'}\n📝 Bio: {'<i>None</i>' if user_bio is None else user_bio}\n🆔 ID: <code>{user_id}</code>\n📱 Username: {'<i>None</i>' if username is None else f'@{username}'}"
    else:
        reply_text = "⚠️ Privacy is enabled. Information cannot be displayed. ⚠️"

    message.reply_text(reply_text, parse_mode='HTML', quote=True, reply_to_message_id=message.message_id)

def start(update, _):
    update.message.reply_text("Welcome to the Telegram ID Bot! 👋\nSend or Forward me a message to get Telegram ID.")

def main():
    updater = Updater(TOKEN, use_context=True)
    dp = updater.dispatcher
    dp.add_handler(CommandHandler("start", start))
    dp.add_handler(MessageHandler(Filters.text & ~Filters.command, private_message))
    updater.start_polling()
    updater.idle()

if __name__ == '__main__':
    main()
