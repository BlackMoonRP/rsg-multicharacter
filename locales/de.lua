Translations = Translations or {
    notifications = {
        ["char_deleted"] = "Character gelöscht!",
        ["deleted_other_char"] = "Du hast den Charakter mit der Bürger-ID %{citizenid} erfolgreich gelöscht.",
        ["forgot_citizenid"] = " Du hast vergessen, deine Bürger-ID einzugeben!",
    },

    commands = {
        -- /deletechar
        ["deletechar_description"] = "Löscht einen anderen Spielercharakter",
        ["citizenid"] = "Bürger-ID",
        ["citizenid_help"] = "Die Bürger-ID des Charakters, den Sie löschen möchten",

        -- /logout
        ["logout_description"] = " Ausloggen des Charakters (nur Admin)",

        -- /closeNUI
        ["closeNUI_description"] = "Multi NUI schließen"
    },

    misc = {
        ["droppedplayer"] = "Du hast die Verbindung nach RSG getrennt"
    },

    ui = {
        -- Main
        characters_header = "Meine Charactere",
        emptyslot = "Leerer Platz",
        play_button = "Spielen",
        create_button = "Character erstellen",
        delete_button = "Character löschen",

        -- Character Information
        charinfo_header = "Character Information",
        charinfo_description = "Wähle einen Charakterplatz, um alle Informationen über deinen Charakter zu sehen.",
        name = "Name",
        male = "Mann",
        female = "Frau",
        firstname = "Vorname",
        lastname = "Nachname",
        nationality = "Nationalität",
        gender = "Geschlecht",
        birthdate = "Geburtstag",
        job = "Job",
        jobgrade = "Job Grade",
        cash = "Bargeld",
        bank = "Bank",
        phonenumber = "Telefonnummer",
        accountnumber = "Account Number",

        chardel_header = "Character Registration",

        -- Delete character
        deletechar_header = "Charakter löschen",
        deletechar_description = "Bist du sicher, dass du deinen Charakter löschen möchtest?",

        -- Buttons
        cancel = "Abbrechen",
        confirm = "Bestätigen",

        -- Loading Text
        retrieving_playerdata = "Abrufen der Spielerdaten",
        validating_playerdata = "Überprüfen der Spielerdaten",
        retrieving_characters = "Abrufen der Charactere",
        validating_characters = "Überprüfen der Charactere",

        -- Notifications
        ran_into_issue = "Es ist ein Problem aufgetreten",
        profanity = "Es scheint, als ob Du versuchst, irgendeine Art von Obszönität / Schimpfwort in Deinem Namen oder Deiner Nationalität zu verwenden!",
        forgotten_field = "Es scheint, dass du vergessen hast, eines oder mehrere der Felder auszufüllen!"
    }
}

Lang = Lang or Locale:new({
    phrases = Translations,
    warnOnMissing = true
})

