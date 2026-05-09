#!/bin/bash

# ─────────────────────────────────────────
# Linux User Management & Audit Script
# Author: Jayesh Thombare
# Description: Automates user creation,
# group assignment, and audit log generation
# ─────────────────────────────────────────

LOGFILE="/var/log/user_audit.log"
DATE=$(date '+%Y-%m-%d %H:%M:%S')

# ── Get inputs ──
read -p "Enter username to create: " USERNAME
read -p "Enter group to assign (will be created if missing): " GROUPNAME

# ── Create group if it doesn't exist ──
if ! getent group "$GROUPNAME" > /dev/null 2>&1; then
    groupadd "$GROUPNAME"
    echo "[$DATE] GROUP CREATED: $GROUPNAME" >> "$LOGFILE"
fi

# ── Create user and assign to group ──
if id "$USERNAME" > /dev/null 2>&1; then
    echo "User $USERNAME already exists."
    echo "[$DATE] FAILED: User $USERNAME already exists." >> "$LOGFILE"
else
    useradd -m -G "$GROUPNAME" "$USERNAME"
    echo "[$DATE] USER CREATED: $USERNAME | GROUP: $GROUPNAME" >> "$LOGFILE"
    echo "User $USERNAME created and added to $GROUPNAME."
fi

# ── Set password expiry policy ──
chage -M 90 "$USERNAME"
echo "[$DATE] PASSWORD POLICY SET: $USERNAME - Max 90 days" >> "$LOGFILE"

# ── Confirm audit log ──
echo ""
echo "Audit log updated at $LOGFILE"
echo "[$DATE] AUDIT COMPLETE for $USERNAME" >> "$LOGFILE"
