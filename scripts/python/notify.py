import boto3
import os
from telegram import Bot

# Set up Telegram bot
telegram_token = os.environ["NOTIFY_TOKEN"]
chat_id = "388104355"

# Create EC2 client
ec2 = boto3.client("ec2")


def get_ec2_usage():
    # Query EC2 usage data
    instances = ec2.describe_instances()

    # Format the usage data into a message
    message = "AWS Usage Notification:\n\n"
    message += "EC2 Instances:\n"
    for reservation in instances["Reservations"]:
        for instance in reservation["Instances"]:
            message += f"- Instance ID: {instance['InstanceId']}\n"
            message += f"  Instance Type: {instance['InstanceType']}\n"
            message += f"  State: {instance['State']['Name']}\n"
            message += f"  Launch Time: {instance['LaunchTime']}\n"
            message += "\n"

    return message


def send_notification(bot, message):
    # Send the message to Telegram
    bot.send_message(chat_id=chat_id, text=message)


def main():
    # Create Telegram bot instance
    bot = Bot(token=telegram_token)

    # Get EC2 usage data
    usage_message = get_ec2_usage()

    # Send the usage notification to Telegram
    send_notification(bot, usage_message)


if __name__ == "__main__":
    main()
