// DO NOT EDIT. This is code generated via package:intl/generate_localized.dart
// This is a library that provides messages for a it locale. All the
// messages from the main program should be duplicated here with the same
// function name.

// Ignore issues from commonly used lints in this file.
// ignore_for_file:unnecessary_brace_in_string_interps, unnecessary_new
// ignore_for_file:prefer_single_quotes,comment_references, directives_ordering
// ignore_for_file:annotate_overrides,prefer_generic_function_type_aliases
// ignore_for_file:unused_import, file_names, avoid_escaping_inner_quotes
// ignore_for_file:unnecessary_string_interpolations, unnecessary_string_escapes

import 'package:intl/intl.dart';
import 'package:intl/message_lookup_by_library.dart';

final messages = new MessageLookup();

typedef String MessageIfAbsent(String messageStr, List<dynamic> args);

class MessageLookup extends MessageLookupByLibrary {
  String get localeName => 'it';

  final messages = _notInlinedMessages(_notInlinedMessages);
  static Map<String, Function> _notInlinedMessages(_) => <String, Function>{
        "account": MessageLookupByLibrary.simpleMessage("Account"),
        "accounts": MessageLookupByLibrary.simpleMessage("Accounts"),
        "ackBackedUp": MessageLookupByLibrary.simpleMessage(
            "Sei sicuro di aver fatto una copia della tua frase segreta o seed?"),
        "activeMessageHeader":
            MessageLookupByLibrary.simpleMessage("Messaggio attivo"),
        "addAccount": MessageLookupByLibrary.simpleMessage("Aggiungi"),
        "addBlocked": MessageLookupByLibrary.simpleMessage("Blocca un utente"),
        "addContact": MessageLookupByLibrary.simpleMessage("Aggiungi"),
        "addFavorite":
            MessageLookupByLibrary.simpleMessage("Aggiungi preferito"),
        "addressCopied": MessageLookupByLibrary.simpleMessage("Copiato"),
        "addressHint":
            MessageLookupByLibrary.simpleMessage("Inserisci Indirizzo"),
        "addressMissing":
            MessageLookupByLibrary.simpleMessage("Inserisci un indirizzo"),
        "addressOrUserMissing": MessageLookupByLibrary.simpleMessage(
            "Immettere un nome utente o un indirizzo"),
        "addressShare": MessageLookupByLibrary.simpleMessage("Condividi"),
        "aliases": MessageLookupByLibrary.simpleMessage("Alias"),
        "amountMissing":
            MessageLookupByLibrary.simpleMessage("Inserisci un importo"),
        "asked": MessageLookupByLibrary.simpleMessage("Chiesto"),
        "authMethod":
            MessageLookupByLibrary.simpleMessage("Metodo di Autenticazione"),
        "autoImport":
            MessageLookupByLibrary.simpleMessage("Importazione automatica"),
        "autoLockHeader":
            MessageLookupByLibrary.simpleMessage("Blocco Automatico"),
        "backupConfirmButton":
            MessageLookupByLibrary.simpleMessage("L\'ho Conservata"),
        "backupSecretPhrase":
            MessageLookupByLibrary.simpleMessage("Salva Frase Segreta"),
        "backupSeed": MessageLookupByLibrary.simpleMessage("Salva Seed"),
        "backupSeedConfirm": MessageLookupByLibrary.simpleMessage(
            "Sei sicuro di aver fatto un backup del tuo seed?"),
        "backupYourSeed": MessageLookupByLibrary.simpleMessage("Salva il seed"),
        "biometricsMethod": MessageLookupByLibrary.simpleMessage("Biometrica"),
        "blockExplorer":
            MessageLookupByLibrary.simpleMessage("Esplora blocchi"),
        "blockExplorerHeader": MessageLookupByLibrary.simpleMessage(
            "Informazioni su Block Explorer"),
        "blockExplorerInfo": MessageLookupByLibrary.simpleMessage(
            "Quale block explorer utilizzare per visualizzare le informazioni sulle transazioni"),
        "blockUser":
            MessageLookupByLibrary.simpleMessage("Blocca questo utente"),
        "blockedAdded":
            MessageLookupByLibrary.simpleMessage("%1 bloccato con successo."),
        "blockedExists":
            MessageLookupByLibrary.simpleMessage("Utente già bloccato!"),
        "blockedHeader": MessageLookupByLibrary.simpleMessage("Bloccato"),
        "blockedInfo": MessageLookupByLibrary.simpleMessage(
            "Blocca un utente con qualsiasi alias o indirizzo noto. Qualsiasi messaggio, transazione o richiesta da parte loro verrà ignorata."),
        "blockedInfoHeader":
            MessageLookupByLibrary.simpleMessage("Informazioni bloccate"),
        "blockedNameExists":
            MessageLookupByLibrary.simpleMessage("Nickname già usato!"),
        "blockedNameMissing":
            MessageLookupByLibrary.simpleMessage("Scegli un nick name"),
        "blockedRemoved":
            MessageLookupByLibrary.simpleMessage("%1 è stato sbloccato!"),
        "cancel": MessageLookupByLibrary.simpleMessage("Annulla"),
        "changeCurrency": MessageLookupByLibrary.simpleMessage("Cambia Valuta"),
        "changeLog": MessageLookupByLibrary.simpleMessage("Registro modifiche"),
        "changeRepAuthenticate":
            MessageLookupByLibrary.simpleMessage("Cambia Rappresentante"),
        "changeRepButton": MessageLookupByLibrary.simpleMessage("Cambia"),
        "changeRepHint": MessageLookupByLibrary.simpleMessage(
            "Inserisci Nuovo Rappresentante"),
        "changeRepSame": MessageLookupByLibrary.simpleMessage(
            "Questo è già il tuo rappresentante!"),
        "changeRepSucces": MessageLookupByLibrary.simpleMessage(
            "Rappresentante Cambiato con Successo"),
        "checkAvailability":
            MessageLookupByLibrary.simpleMessage("Verifica disponibilità"),
        "close": MessageLookupByLibrary.simpleMessage("Chiudi"),
        "confirm": MessageLookupByLibrary.simpleMessage("Conferma"),
        "confirmPasswordHint":
            MessageLookupByLibrary.simpleMessage("Conferma la password"),
        "connectingHeader":
            MessageLookupByLibrary.simpleMessage("In connessione"),
        "contactAdded": MessageLookupByLibrary.simpleMessage(
            "%1 è stato aggiunto ai contatti!"),
        "contactExists":
            MessageLookupByLibrary.simpleMessage("Contatto Già Esistente"),
        "contactHeader": MessageLookupByLibrary.simpleMessage("Contatto"),
        "contactInvalid":
            MessageLookupByLibrary.simpleMessage("Nome Contatto Invalido"),
        "contactNameHint":
            MessageLookupByLibrary.simpleMessage("Inserisci un Nome @"),
        "contactNameMissing": MessageLookupByLibrary.simpleMessage(
            "Non ci sono contatti da esportare"),
        "contactRemoved": MessageLookupByLibrary.simpleMessage(
            "%1 è stato rimosso dai contatti!"),
        "contactsHeader": MessageLookupByLibrary.simpleMessage("Contatti"),
        "contactsImportErr": MessageLookupByLibrary.simpleMessage(
            "Errore nell\'importazione contatti"),
        "contactsImportSuccess": MessageLookupByLibrary.simpleMessage(
            "%1 contatti importati con successo"),
        "copied": MessageLookupByLibrary.simpleMessage("Copiato"),
        "copy": MessageLookupByLibrary.simpleMessage("Copia"),
        "copyAddress": MessageLookupByLibrary.simpleMessage("Copia Indirizzo"),
        "copyLink": MessageLookupByLibrary.simpleMessage("Copia link"),
        "copySeed": MessageLookupByLibrary.simpleMessage("Copia Seed"),
        "copyWalletAddressToClipboard": MessageLookupByLibrary.simpleMessage(
            "Copia l\'indirizzo del portafoglio negli appunti"),
        "createAPasswordHeader":
            MessageLookupByLibrary.simpleMessage("Crea una password."),
        "createGiftCard":
            MessageLookupByLibrary.simpleMessage("Crea una carta regalo"),
        "createGiftHeader":
            MessageLookupByLibrary.simpleMessage("Crea una Gift Card"),
        "createPasswordFirstParagraph": MessageLookupByLibrary.simpleMessage(
            "Puoi creare una password per rendere il tuo portafoglio ancora più sicuro."),
        "createPasswordHint":
            MessageLookupByLibrary.simpleMessage("Crea una password"),
        "createPasswordSecondParagraph": MessageLookupByLibrary.simpleMessage(
            "La password è opzionale, e il tuo portafoglio sarà comunque protetto dal PIN o dal riconoscimento biometrico."),
        "createPasswordSheetHeader":
            MessageLookupByLibrary.simpleMessage("Crea"),
        "createQR": MessageLookupByLibrary.simpleMessage("Crea codice QR"),
        "creatingGiftCard": MessageLookupByLibrary.simpleMessage(
            "Creazione di una carta regalo"),
        "currency": MessageLookupByLibrary.simpleMessage("Valuta"),
        "currencyMode": MessageLookupByLibrary.simpleMessage("Modalità valuta"),
        "currencyModeHeader": MessageLookupByLibrary.simpleMessage(
            "Informazioni sulla modalità valuta"),
        "currencyModeInfo": MessageLookupByLibrary.simpleMessage(
            "Scegliere in quale unità visualizzare gli importi.\n1 nyano = 0,000001 NANO, oppure \n1.000.000 nyano = 1 NANO"),
        "currentlyRepresented": MessageLookupByLibrary.simpleMessage(
            "Attualmente Rappresentato Da"),
        "decryptionError":
            MessageLookupByLibrary.simpleMessage("Errore di decrittazione!"),
        "defaultAccountName":
            MessageLookupByLibrary.simpleMessage("Principale"),
        "defaultNewAccountName":
            MessageLookupByLibrary.simpleMessage("Account %1"),
        "delete": MessageLookupByLibrary.simpleMessage("Elimina"),
        "deleteRequest":
            MessageLookupByLibrary.simpleMessage("Delete this request"),
        "disablePasswordSheetHeader":
            MessageLookupByLibrary.simpleMessage("Disabilita"),
        "disablePasswordSuccess": MessageLookupByLibrary.simpleMessage(
            "La password è stata disabilitata"),
        "disableWalletPassword": MessageLookupByLibrary.simpleMessage(
            "Disabilita Password Portafoglio"),
        "dismiss": MessageLookupByLibrary.simpleMessage("Licenziare"),
        "domainInvalid":
            MessageLookupByLibrary.simpleMessage("Nome di dominio non valido"),
        "edit": MessageLookupByLibrary.simpleMessage("Modifica"),
        "encryptionFailedError": MessageLookupByLibrary.simpleMessage(
            "Errore nell’impostazione della password"),
        "enterAddress":
            MessageLookupByLibrary.simpleMessage("Inserisci Indirizzo"),
        "enterAmount":
            MessageLookupByLibrary.simpleMessage("Inserisci Importo"),
        "enterGiftMemo":
            MessageLookupByLibrary.simpleMessage("Inserisci la nota regalo"),
        "enterMemo":
            MessageLookupByLibrary.simpleMessage("Inserisci messaggio"),
        "enterPasswordHint":
            MessageLookupByLibrary.simpleMessage("Inserisci la password"),
        "enterUserOrAddress": MessageLookupByLibrary.simpleMessage(
            "Inserisci l\'utente o l\'indirizzo"),
        "enterUsername":
            MessageLookupByLibrary.simpleMessage("Inserisci un nome utente"),
        "eula": MessageLookupByLibrary.simpleMessage("EULA"),
        "exampleCardFrom": MessageLookupByLibrary.simpleMessage("da qualcuno"),
        "exampleCardFromKal":
            MessageLookupByLibrary.simpleMessage("da una scimmietta"),
        "exampleCardIntro": MessageLookupByLibrary.simpleMessage(
            "Benvenuto in Nautilus. Una volta ricevuti dei NANO, le transazioni compariranno in questo modo"),
        "exampleCardIntroKal": MessageLookupByLibrary.simpleMessage(
            "Benvenuto in Kalium. Una volta ricevuti dei BANANO, le transazioni compariranno in questo modo"),
        "exampleCardLittle": MessageLookupByLibrary.simpleMessage("Un po\' di"),
        "exampleCardLot": MessageLookupByLibrary.simpleMessage("Un sacco di"),
        "exampleCardTo": MessageLookupByLibrary.simpleMessage("a qualcuno"),
        "exampleCardToKal":
            MessageLookupByLibrary.simpleMessage("ad una scimmietta"),
        "examplePayRecipient": MessageLookupByLibrary.simpleMessage("@dad"),
        "examplePayRecipientMessage":
            MessageLookupByLibrary.simpleMessage("Buon compleanno!"),
        "examplePaymentExplainer": MessageLookupByLibrary.simpleMessage(
            "Una volta inviata o ricevuta una richiesta di pagamento, verranno visualizzate qui in questo modo con il colore e il tag della carta che ne indicano lo stato. \n\nIl verde indica che la richiesta è stata pagata.\nIl giallo indica che la richiesta/promemoria non è stata pagata/letta.\nIl rosso indica che la richiesta non è stata letta o ricevuta.\n\n Le carte colorate neutre senza importo sono solo messaggi."),
        "examplePaymentFrom": MessageLookupByLibrary.simpleMessage("@landlord"),
        "examplePaymentFulfilled":
            MessageLookupByLibrary.simpleMessage("Alcune"),
        "examplePaymentFulfilledMemo":
            MessageLookupByLibrary.simpleMessage("Sushi"),
        "examplePaymentIntro": MessageLookupByLibrary.simpleMessage(
            "Una volta inviata o ricevuta una richiesta di pagamento, questa verrà visualizzata qui:"),
        "examplePaymentMessage":
            MessageLookupByLibrary.simpleMessage("Ehi, che succede?"),
        "examplePaymentReceivable":
            MessageLookupByLibrary.simpleMessage("Un sacco di"),
        "examplePaymentReceivableMemo":
            MessageLookupByLibrary.simpleMessage("Noleggio"),
        "examplePaymentTo":
            MessageLookupByLibrary.simpleMessage("@best_friend"),
        "exampleRecRecipient":
            MessageLookupByLibrary.simpleMessage("@coworker"),
        "exampleRecRecipientMessage":
            MessageLookupByLibrary.simpleMessage("Denaro del gas"),
        "exit": MessageLookupByLibrary.simpleMessage("Esci"),
        "failed": MessageLookupByLibrary.simpleMessage("mancato"),
        "failedMessage": MessageLookupByLibrary.simpleMessage("msg failed"),
        "fallbackHeader":
            MessageLookupByLibrary.simpleMessage("Nautilus: Disconnessa:"),
        "fallbackInfo": MessageLookupByLibrary.simpleMessage(
            "I server Nautilus sembrano essere disconnessi, l\'invio e la ricezione (senza memo) dovrebbero essere ancora operativi ma le richieste di pagamento potrebbero non andare a buon fine\n\n Torna più tardi o riavvia l\'app per riprovare"),
        "favoriteExists":
            MessageLookupByLibrary.simpleMessage("Il preferito esiste già"),
        "favoriteHeader": MessageLookupByLibrary.simpleMessage("Preferiti"),
        "favoriteInvalid":
            MessageLookupByLibrary.simpleMessage("Nome preferito non valido"),
        "favoriteNameHint":
            MessageLookupByLibrary.simpleMessage("Inserisci un nick name"),
        "favoriteNameMissing": MessageLookupByLibrary.simpleMessage(
            "Scegli un nome per questo preferito"),
        "favoriteRemoved": MessageLookupByLibrary.simpleMessage(
            "%1 è stato rimosso dai preferiti!"),
        "favoritesHeader": MessageLookupByLibrary.simpleMessage("Preferiti"),
        "featured": MessageLookupByLibrary.simpleMessage("Consigliato"),
        "fingerprintSeedBackup": MessageLookupByLibrary.simpleMessage(
            "Conferma l\'impronta per salvare il seed."),
        "from": MessageLookupByLibrary.simpleMessage("Da"),
        "fulfilled": MessageLookupByLibrary.simpleMessage("soddisfatto"),
        "giftAlert": MessageLookupByLibrary.simpleMessage("Hai un regalo!"),
        "giftAlertEmpty": MessageLookupByLibrary.simpleMessage("Regalo vuoto"),
        "giftAmount":
            MessageLookupByLibrary.simpleMessage("Importo del regalo"),
        "giftFrom": MessageLookupByLibrary.simpleMessage("Regalo da"),
        "giftInfo": MessageLookupByLibrary.simpleMessage(
            "Carica una carta regalo digitale con NANO! Imposta un importo e un messaggio opzionale che il destinatario può vedere quando lo apre!\n\nUna volta creato, riceverai un link che puoi inviare a chiunque, che una volta aperto distribuirà automaticamente i fondi al destinatario dopo aver installato Nautilus!\n\nSe il destinatario è già un utente Nautilus, riceverà una richiesta di trasferire i fondi sul proprio conto all\'apertura del link."),
        "giftMessage": MessageLookupByLibrary.simpleMessage("Messaggio regalo"),
        "giftWarning": MessageLookupByLibrary.simpleMessage(
            "You already have a username registered! It\'s not currently possible to change your username, but you\'re free to register a new one under a different address."),
        "goBackButton": MessageLookupByLibrary.simpleMessage("Indietro"),
        "goToQRCode": MessageLookupByLibrary.simpleMessage("Vai a QR"),
        "gotItButton": MessageLookupByLibrary.simpleMessage("Capito!"),
        "hide": MessageLookupByLibrary.simpleMessage("nascondi"),
        "hideAccountHeader":
            MessageLookupByLibrary.simpleMessage("Nascondere l\'Account?"),
        "home": MessageLookupByLibrary.simpleMessage("Home"),
        "iUnderstandTheRisks":
            MessageLookupByLibrary.simpleMessage("Sono Consapevole dei Rischi"),
        "ignore": MessageLookupByLibrary.simpleMessage("Ignora"),
        "import": MessageLookupByLibrary.simpleMessage("Importa"),
        "importGift": MessageLookupByLibrary.simpleMessage(
            "Il link su cui hai cliccato contiene alcuni nano, vorresti importarlo in questo portafoglio o rimborsarlo a chi lo ha inviato?"),
        "importGiftEmpty": MessageLookupByLibrary.simpleMessage(
            "Unfortunately the link you clicked that contained some nano appears to be empty, but you can still see the amount and associated message."),
        "importSecretPhrase":
            MessageLookupByLibrary.simpleMessage("Importa Frase Segreta"),
        "importSecretPhraseHint": MessageLookupByLibrary.simpleMessage(
            "Inserisci la tua frase segreta da 24 parole qui sotto. Ogni parola deve essere separata da uno spazio."),
        "importSeed": MessageLookupByLibrary.simpleMessage("Importa seed"),
        "importSeedHint": MessageLookupByLibrary.simpleMessage(
            "Inserisci il seed qui in basso."),
        "importSeedInstead":
            MessageLookupByLibrary.simpleMessage("Oppure Importa Seed"),
        "importWallet": MessageLookupByLibrary.simpleMessage("Importa"),
        "instantly": MessageLookupByLibrary.simpleMessage("Subito"),
        "insufficientBalance":
            MessageLookupByLibrary.simpleMessage("Saldo Insufficiente"),
        "invalidAddress":
            MessageLookupByLibrary.simpleMessage("Indirizzo invalido"),
        "invalidPassword":
            MessageLookupByLibrary.simpleMessage("Password Invalida"),
        "kaliumWallet": MessageLookupByLibrary.simpleMessage("Kalium Wallet"),
        "language": MessageLookupByLibrary.simpleMessage("Lingua"),
        "linkCopied": MessageLookupByLibrary.simpleMessage("Link copiato"),
        "liveSupportButton": MessageLookupByLibrary.simpleMessage("Supporto"),
        "loaded": MessageLookupByLibrary.simpleMessage("Caricato"),
        "loadedInto": MessageLookupByLibrary.simpleMessage("Caricato in"),
        "lockAppSetting":
            MessageLookupByLibrary.simpleMessage("Autenticazione all\'Avvio"),
        "locked": MessageLookupByLibrary.simpleMessage("Bloccato"),
        "logout": MessageLookupByLibrary.simpleMessage("Logout"),
        "logoutAction": MessageLookupByLibrary.simpleMessage(
            "Elimina seed e fai il logout"),
        "logoutAreYouSure": MessageLookupByLibrary.simpleMessage("Sei sicuro?"),
        "logoutDetail": MessageLookupByLibrary.simpleMessage(
            "Facendo il logout il tuo seed e tutti i dati relativi a Nautilus verranno rimossi dal dispositivo. Se non hai salvato il tuo seed, non sarai più in grado di accedere ai tuoi fondi."),
        "logoutDetailKal": MessageLookupByLibrary.simpleMessage(
            "Facendo il logout il tuo seed e tutti i dati relativi a Kalium verranno rimossi dal dispositivo. Se non hai salvato il tuo seed, non sarai più in grado di accedere ai tuoi fondi."),
        "logoutReassurance": MessageLookupByLibrary.simpleMessage(
            "Finché avrai un backup del seed non avrai nulla di cui preoccuparti."),
        "manage": MessageLookupByLibrary.simpleMessage("Gestisci"),
        "mantaError": MessageLookupByLibrary.simpleMessage(
            "Errore nella Verifica della Richiesta"),
        "manualEntry":
            MessageLookupByLibrary.simpleMessage("Inserisci Manualmente"),
        "markAsPaid": MessageLookupByLibrary.simpleMessage("Segna come pagato"),
        "markAsUnpaid":
            MessageLookupByLibrary.simpleMessage("Segna come non pagato"),
        "maybeLater": MessageLookupByLibrary.simpleMessage("Maybe Later"),
        "memoSentButNotReceived": MessageLookupByLibrary.simpleMessage(
            "Memo inviato nuovamente! Se ancora non viene riconosciuto, il dispositivo del destinatario potrebbe essere offline."),
        "messageHeader": MessageLookupByLibrary.simpleMessage("Messaggio"),
        "minimumSend": MessageLookupByLibrary.simpleMessage(
            "L\'importo minimo di invio è %1 %2"),
        "mnemonicInvalidWord":
            MessageLookupByLibrary.simpleMessage("%1 non è una parola valida"),
        "mnemonicPhrase":
            MessageLookupByLibrary.simpleMessage("Frase Mnemonica"),
        "mnemonicSizeError": MessageLookupByLibrary.simpleMessage(
            "La frase segreta può contenere solo 24 parole"),
        "moonpay": MessageLookupByLibrary.simpleMessage("MoonPay"),
        "natricon": MessageLookupByLibrary.simpleMessage("Natricon"),
        "needVerificationAlert": MessageLookupByLibrary.simpleMessage(
            "Questa funzione richiede una cronologia delle transazioni più lunga per prevenire lo spam.\n\nIn alternativa, puoi mostrare un codice QR affinché qualcuno possa scansionarlo."),
        "needVerificationAlertHeader":
            MessageLookupByLibrary.simpleMessage("Verifica necessaria"),
        "newAccountIntro": MessageLookupByLibrary.simpleMessage(
            "Questo è il tuo nuovo account. Una volta ricevuti NANO, le transazioni appariranno così:"),
        "newAccountIntroKal": MessageLookupByLibrary.simpleMessage(
            "Questo è il tuo nuovo account. Una volta ricevuti BANANO, le transazioni appariranno così:"),
        "newWallet": MessageLookupByLibrary.simpleMessage("Nuovo"),
        "nextButton": MessageLookupByLibrary.simpleMessage("Avanti"),
        "no": MessageLookupByLibrary.simpleMessage("No"),
        "noContactsExport": MessageLookupByLibrary.simpleMessage(
            "Non ci sono contatti da esportare"),
        "noContactsImport": MessageLookupByLibrary.simpleMessage(
            "Nessun contatto da importare trovato"),
        "noSearchResults": MessageLookupByLibrary.simpleMessage(
            "Nessun risultato di ricerca!"),
        "noSkipButton": MessageLookupByLibrary.simpleMessage("No, Salta"),
        "noThanks": MessageLookupByLibrary.simpleMessage("No Thanks"),
        "nodeStatus": MessageLookupByLibrary.simpleMessage("Stato nodo"),
        "notSent": MessageLookupByLibrary.simpleMessage("non inviato"),
        "notificationBody": MessageLookupByLibrary.simpleMessage(
            "Apri Nautilus per vedere la transazione."),
        "notificationBodyKal": MessageLookupByLibrary.simpleMessage(
            "Apri Kalium per vedere la transazione."),
        "notificationHeaderSupplement":
            MessageLookupByLibrary.simpleMessage("Tocca per aprire"),
        "notificationInfo": MessageLookupByLibrary.simpleMessage(
            "Affinché questa funzione funzioni correttamente, le notifiche devono essere abilitate"),
        "notificationTitle":
            MessageLookupByLibrary.simpleMessage("Ricevuti %1 NANO"),
        "notificationTitleKal":
            MessageLookupByLibrary.simpleMessage("Ricevuti %1 BANANO"),
        "notifications": MessageLookupByLibrary.simpleMessage("Notifiche"),
        "nyanicon": MessageLookupByLibrary.simpleMessage("Nyanicon"),
        "off": MessageLookupByLibrary.simpleMessage("Off"),
        "ok": MessageLookupByLibrary.simpleMessage("Ok"),
        "onStr": MessageLookupByLibrary.simpleMessage("On"),
        "onramp": MessageLookupByLibrary.simpleMessage("Sulla rampa"),
        "onramper": MessageLookupByLibrary.simpleMessage("Onramper"),
        "opened": MessageLookupByLibrary.simpleMessage("Aperta"),
        "paid": MessageLookupByLibrary.simpleMessage("pagato"),
        "paperWallet":
            MessageLookupByLibrary.simpleMessage("Portafoglio Cartaceo"),
        "passwordBlank": MessageLookupByLibrary.simpleMessage(
            "La password non può essere vuota"),
        "passwordNoLongerRequiredToOpenParagraph":
            MessageLookupByLibrary.simpleMessage(
                "Non avrai più bisogno di una password per aprire Nautilus."),
        "passwordWillBeRequiredToOpenParagraph":
            MessageLookupByLibrary.simpleMessage(
                "Questa password sarà richiesta per aprire Nautilus."),
        "passwordsDontMatch": MessageLookupByLibrary.simpleMessage(
            "Le password non corrispondono"),
        "pay": MessageLookupByLibrary.simpleMessage("Paga"),
        "payRequest":
            MessageLookupByLibrary.simpleMessage("Paga questa richiesta"),
        "paymentRequestMessage": MessageLookupByLibrary.simpleMessage(
            "Qualcuno ha richiesto il pagamento da te! controlla la pagina dei pagamenti per maggiori informazioni."),
        "payments": MessageLookupByLibrary.simpleMessage("Pagamenti"),
        "pickFromList":
            MessageLookupByLibrary.simpleMessage("Scegli da una Lista"),
        "pinConfirmError":
            MessageLookupByLibrary.simpleMessage("I pin non combaciano"),
        "pinConfirmTitle":
            MessageLookupByLibrary.simpleMessage("Conferma il pin"),
        "pinCreateTitle":
            MessageLookupByLibrary.simpleMessage("Crea un pin a 6 cifre"),
        "pinEnterTitle": MessageLookupByLibrary.simpleMessage("Inserisci pin"),
        "pinInvalid": MessageLookupByLibrary.simpleMessage("Pin errato"),
        "pinMethod": MessageLookupByLibrary.simpleMessage("PIN"),
        "pinRepChange": MessageLookupByLibrary.simpleMessage(
            "Inserisci pin per cambiare rappresentante"),
        "pinSeedBackup": MessageLookupByLibrary.simpleMessage(
            "Inserisci il pin per vedere il seed."),
        "preferences": MessageLookupByLibrary.simpleMessage("Preferenze"),
        "privacyPolicy":
            MessageLookupByLibrary.simpleMessage("Politica sulla Privacy"),
        "purchaseNano": MessageLookupByLibrary.simpleMessage("Acquista Nano"),
        "qrInvalidAddress": MessageLookupByLibrary.simpleMessage(
            "Il codice QR non contiene una destinazione valida"),
        "qrInvalidPermissions": MessageLookupByLibrary.simpleMessage(
            "Abilita l’accesso alla fotocamera per scansionare i codici QR"),
        "qrInvalidSeed": MessageLookupByLibrary.simpleMessage(
            "Il codice QR non contiene un seed o una chiave privata validi"),
        "qrMnemonicError": MessageLookupByLibrary.simpleMessage(
            "Il QR non contiene una frase segreta valida"),
        "qrUnknownError": MessageLookupByLibrary.simpleMessage(
            "Errore nella Lettura del codice QR"),
        "rate": MessageLookupByLibrary.simpleMessage("Rate"),
        "rateTheApp": MessageLookupByLibrary.simpleMessage("Valuta l\'app"),
        "rateTheAppDescription": MessageLookupByLibrary.simpleMessage(
            "If you enjoy the app, consider taking the time to review it,\nIt really helps and it shouldn\'t take more than a minute."),
        "rawSeed": MessageLookupByLibrary.simpleMessage("Seed"),
        "readMore": MessageLookupByLibrary.simpleMessage("Per saperne di più"),
        "receivable": MessageLookupByLibrary.simpleMessage("ricevibile"),
        "receive": MessageLookupByLibrary.simpleMessage("Ricevi"),
        "receiveMinimum":
            MessageLookupByLibrary.simpleMessage("Ricevi il minimo"),
        "receiveMinimumHeader":
            MessageLookupByLibrary.simpleMessage("Ricevi informazioni minime"),
        "receiveMinimumInfo": MessageLookupByLibrary.simpleMessage(
            "Un importo minimo da ricevere. Se un pagamento o una richiesta viene ricevuta con un importo inferiore a questo, verrà ignorato."),
        "received": MessageLookupByLibrary.simpleMessage("Ricevuti"),
        "refund": MessageLookupByLibrary.simpleMessage("rimborso"),
        "registerFor": MessageLookupByLibrary.simpleMessage("per"),
        "registerUsername":
            MessageLookupByLibrary.simpleMessage("Registra nome utente"),
        "registerUsernameHeader":
            MessageLookupByLibrary.simpleMessage("Registra un nome utente"),
        "registering": MessageLookupByLibrary.simpleMessage("Registrazione"),
        "removeAccountText": MessageLookupByLibrary.simpleMessage(
            "Sei sicuro di voler nascondere questo account? Potrai riaggiungerlo in futuro cliccando sul pulsante \"%1\"."),
        "removeBlocked": MessageLookupByLibrary.simpleMessage("Sblocca"),
        "removeBlockedConfirmation": MessageLookupByLibrary.simpleMessage(
            "Sei sicuro di voler sbloccare %1?"),
        "removeContact":
            MessageLookupByLibrary.simpleMessage("Rimuovi Contatto"),
        "removeContactConfirmation": MessageLookupByLibrary.simpleMessage(
            "Sei sicuro di voler rimuovere %1?"),
        "removeFavorite":
            MessageLookupByLibrary.simpleMessage("Rimuovi preferito"),
        "removeFavoriteConfirmation": MessageLookupByLibrary.simpleMessage(
            "Are you sure you want to delete %1?"),
        "repInfo": MessageLookupByLibrary.simpleMessage(
            "Un rappresentante è un account che vota per il consenso della rete. Il potere di voto è determinato dal saldo, potresti delegare il tuo saldo per aumentare il peso del voto di un rappresentante di cui ti fidi. Il tuo rappresentante non ha il potere di spendere i tuoi fondi. Dovresti scegliere un rappresentante che abbia un basso tempo di inattività e che sia affidabile."),
        "repInfoHeader":
            MessageLookupByLibrary.simpleMessage("Cos\'è un Rappresentante?"),
        "reply": MessageLookupByLibrary.simpleMessage("Rispondi"),
        "representatives":
            MessageLookupByLibrary.simpleMessage("Rappresentanti"),
        "request": MessageLookupByLibrary.simpleMessage("Richiesta"),
        "requestAmountConfirm":
            MessageLookupByLibrary.simpleMessage("Richiesta %1 %2"),
        "requestError": MessageLookupByLibrary.simpleMessage(
            "Richiesta non riuscita: Sembra che questo utente non abbia installato Nautilus o abbia le notifiche disabilitate."),
        "requestPayment":
            MessageLookupByLibrary.simpleMessage("Richiesta di pagamento"),
        "requestSendError": MessageLookupByLibrary.simpleMessage(
            "Errore durante l\'invio della richiesta di pagamento, il dispositivo del destinatario potrebbe essere offline o non disponibile."),
        "requestSentButNotReceived": MessageLookupByLibrary.simpleMessage(
            "Richiesta inviata nuovamente! Se ancora non viene riconosciuto, il dispositivo del destinatario potrebbe essere offline."),
        "requested": MessageLookupByLibrary.simpleMessage("Richiesto"),
        "requestedFrom": MessageLookupByLibrary.simpleMessage("Richiesto da"),
        "requesting": MessageLookupByLibrary.simpleMessage("Richiedere"),
        "requireAPasswordToOpenHeader": MessageLookupByLibrary.simpleMessage(
            "Richiedi una password per aprire Nautilus?"),
        "resendMemo": MessageLookupByLibrary.simpleMessage(
            "Invia nuovamente questo memo"),
        "resetDatabase":
            MessageLookupByLibrary.simpleMessage("Ripristina il database"),
        "resetDatabaseConfirmation": MessageLookupByLibrary.simpleMessage(
            "Sei sicuro di voler ripristinare il database interno? \n\nQuesto potrebbe risolvere i problemi relativi all\'aggiornamento dell\'app, ma eliminerà anche tutte le preferenze salvate. Questo NON cancellerà il seme del tuo portafoglio. Se hai problemi dovresti fare il backup del tuo seed, reinstallare l\'app e, se il problema persiste, sentiti libero di fare una segnalazione di bug su github o discord."),
        "retry": MessageLookupByLibrary.simpleMessage("Riprova"),
        "rootWarning": MessageLookupByLibrary.simpleMessage(
            "Sembra che il tuo dispositivo sia “rooted”, “jailbroken”, o abbia una modifica che ne compromette la sicurezza. Prima di procedere, è consigliato eseguire un ripristino del dispositivo al suo stato originale."),
        "scanInstructions": MessageLookupByLibrary.simpleMessage(
            "Scansiona un \ncodice QR Nano"),
        "scanInstructionsKal": MessageLookupByLibrary.simpleMessage(
            "Scansiona un \ncodice QR Banano"),
        "scanQrCode": MessageLookupByLibrary.simpleMessage("Codice QR"),
        "searchHint":
            MessageLookupByLibrary.simpleMessage("Cerca qualsiasi cosa"),
        "secretInfo": MessageLookupByLibrary.simpleMessage(
            "Nella prossima schermata, vedrai la tua frase segreta. È la password per accedere ai tuoi fondi. È fondamentale che tu ne faccia una copia e che non la condivida con nessuno."),
        "secretInfoHeader":
            MessageLookupByLibrary.simpleMessage("Sicurezza al primo posto!"),
        "secretPhrase": MessageLookupByLibrary.simpleMessage("Frase Segreta"),
        "secretPhraseCopied":
            MessageLookupByLibrary.simpleMessage("Frase Segreta Copiata"),
        "secretPhraseCopy":
            MessageLookupByLibrary.simpleMessage("Copia Frase Segreta"),
        "secretWarning": MessageLookupByLibrary.simpleMessage(
            "Se perdi il tuo device o disinstalli l\'applicazione, avrai bisogno della tua frase segreta o del seed per recuperare i tuoi fondi!"),
        "securityHeader": MessageLookupByLibrary.simpleMessage("Sicurezza"),
        "seed": MessageLookupByLibrary.simpleMessage("Seed"),
        "seedBackupInfo": MessageLookupByLibrary.simpleMessage(
            "Qui sotto c\'è il seed del tuo portafoglio. È fondamentale che tu faccia un backup del seed evitando di conservarlo in chiaro o con uno screenshot."),
        "seedCopied": MessageLookupByLibrary.simpleMessage(
            "Seed copiato negli appunti.\n Potrai incollarlo per 2 minuti."),
        "seedCopiedShort": MessageLookupByLibrary.simpleMessage("Seed Copiato"),
        "seedDescription": MessageLookupByLibrary.simpleMessage(
            "Un seed contiene le stesse informazioni di una frase segreta, ma può essere letto da una macchina. Finché ne avrai una copia, avrai accesso ai tuoi fondi. "),
        "seedInvalid": MessageLookupByLibrary.simpleMessage("Seed non valido"),
        "selfSendError": MessageLookupByLibrary.simpleMessage(
            "Impossibile richiedere da sé"),
        "send": MessageLookupByLibrary.simpleMessage("Invia"),
        "sendAmountConfirm":
            MessageLookupByLibrary.simpleMessage("Inviare %1 Nano?"),
        "sendAmountConfirmKal":
            MessageLookupByLibrary.simpleMessage("Inviare %1 Banano?"),
        "sendError": MessageLookupByLibrary.simpleMessage(
            "Si è verificato un errore. Riprova più tardi."),
        "sendFrom": MessageLookupByLibrary.simpleMessage("Invia Da"),
        "sendMemoError": MessageLookupByLibrary.simpleMessage(
            "Invio di memo con transazione non riuscito, potrebbe non essere un utente Nautilus."),
        "sendMessageConfirm":
            MessageLookupByLibrary.simpleMessage("Invio messaggio"),
        "sendRequestAgain": MessageLookupByLibrary.simpleMessage(
            "Invia nuovamente la richiesta"),
        "sendSheetInfo": MessageLookupByLibrary.simpleMessage(
            "Invia o richiedi un pagamento, con messaggi crittografati End to End!\n\nLe richieste di pagamento, i promemoria e i messaggi saranno ricevibili solo da altri utenti nautilus.\n\nNon è necessario avere un nome utente per inviare o ricevere richieste di pagamento e puoi usarli per la tua tenuta dei registri anche se non usano nautilus."),
        "sendSheetInfoHeader": MessageLookupByLibrary.simpleMessage(
            "Invia informazioni sul foglio"),
        "sending": MessageLookupByLibrary.simpleMessage("Inviando"),
        "sent": MessageLookupByLibrary.simpleMessage("Inviati"),
        "sentTo": MessageLookupByLibrary.simpleMessage("Inviato A"),
        "setPassword": MessageLookupByLibrary.simpleMessage("Imposta Password"),
        "setPasswordSuccess": MessageLookupByLibrary.simpleMessage(
            "La password è stata impostata correttamente"),
        "setWalletPassword": MessageLookupByLibrary.simpleMessage(
            "Imposta Password Portafoglio"),
        "setWalletPin": MessageLookupByLibrary.simpleMessage("Set Wallet Pin"),
        "setWalletPlausiblePin":
            MessageLookupByLibrary.simpleMessage("Set Wallet Plausible Pin"),
        "settingsHeader": MessageLookupByLibrary.simpleMessage("Impostazioni"),
        "settingsTransfer":
            MessageLookupByLibrary.simpleMessage("Carica Portafoglio Cartaceo"),
        "shareLink": MessageLookupByLibrary.simpleMessage("Condividi link"),
        "shareNautilus":
            MessageLookupByLibrary.simpleMessage("Condividi Nautilus"),
        "shareNautilusText": MessageLookupByLibrary.simpleMessage(
            "Dai un\'occhiata a Nautilus! Il portafoglio ufficiale di Nano per Android!"),
        "showContacts": MessageLookupByLibrary.simpleMessage("Mostra contatti"),
        "simplex": MessageLookupByLibrary.simpleMessage("Simplex"),
        "supportButton": MessageLookupByLibrary.simpleMessage("Support"),
        "supportTheDeveloper":
            MessageLookupByLibrary.simpleMessage("Sostieni lo sviluppatore"),
        "switchToSeed": MessageLookupByLibrary.simpleMessage("Passa al Seed"),
        "systemDefault": MessageLookupByLibrary.simpleMessage("Predefinito"),
        "tapToHide":
            MessageLookupByLibrary.simpleMessage("Tocca per nascondere"),
        "tapToReveal":
            MessageLookupByLibrary.simpleMessage("Tocca per visualizzare"),
        "themeHeader": MessageLookupByLibrary.simpleMessage("Tema"),
        "to": MessageLookupByLibrary.simpleMessage("A"),
        "tooManyFailedAttempts": MessageLookupByLibrary.simpleMessage(
            "Troppi tentativi di sblocco falliti."),
        "transactions": MessageLookupByLibrary.simpleMessage("Transazioni"),
        "transfer": MessageLookupByLibrary.simpleMessage("Trasferisci"),
        "transferClose": MessageLookupByLibrary.simpleMessage(
            "Premi dove vuoi per chiudere la finestra."),
        "transferComplete": MessageLookupByLibrary.simpleMessage(
            "%1 NANO trasferiti con successo sul tuo portafoglio Nautilus."),
        "transferConfirmInfo": MessageLookupByLibrary.simpleMessage(
            "Rilevato un portafoglio con un saldo di %1 NANO.\n"),
        "transferConfirmInfoSecond": MessageLookupByLibrary.simpleMessage(
            "Premi conferma per trasferire i fondi.\n"),
        "transferConfirmInfoThird": MessageLookupByLibrary.simpleMessage(
            "Il trasferimento potrebbe richiedere parecchi secondi."),
        "transferError": MessageLookupByLibrary.simpleMessage(
            "Si è verificato un errore durante il trasferimento. Riprova più tardi."),
        "transferHeader":
            MessageLookupByLibrary.simpleMessage("Trasferisci\nFondi"),
        "transferIntro": MessageLookupByLibrary.simpleMessage(
            "Questo processo trasferirà i fondi da un portafoglio cartaceo al tuo portafoglio Nautilus.\n\nPremi il pulsante \"%1\" per iniziare."),
        "transferIntroShort": MessageLookupByLibrary.simpleMessage(
            "Questo processo trasferirà i fondi da un portafoglio cartaceo al tuo portafoglio Nautilus."),
        "transferLoading":
            MessageLookupByLibrary.simpleMessage("Trasferimento"),
        "transferManualHint":
            MessageLookupByLibrary.simpleMessage("Inserisci il tuo seed."),
        "transferNoFunds": MessageLookupByLibrary.simpleMessage(
            "Questo seed non contiene alcun NANO al suo interno."),
        "transferQrScanError": MessageLookupByLibrary.simpleMessage(
            "Questo codice QR non contiene un seed valido."),
        "transferQrScanHint": MessageLookupByLibrary.simpleMessage(
            "Scansiona un seed \no una chiave privata"),
        "unacknowledged":
            MessageLookupByLibrary.simpleMessage("non riconosciuto"),
        "unconfirmed": MessageLookupByLibrary.simpleMessage("Non confermato"),
        "unfulfilled": MessageLookupByLibrary.simpleMessage("insoddisfatto"),
        "unlock": MessageLookupByLibrary.simpleMessage("Sblocca"),
        "unlockBiometrics": MessageLookupByLibrary.simpleMessage(
            "Autenticati per Sbloccare Nautilus"),
        "unlockPin": MessageLookupByLibrary.simpleMessage(
            "Inserisci il PIN per Sbloccare Nautilus"),
        "unlockPinKal": MessageLookupByLibrary.simpleMessage(
            "Inserisci il PIN per Sbloccare Kalium"),
        "unpaid": MessageLookupByLibrary.simpleMessage("non pagati"),
        "unread": MessageLookupByLibrary.simpleMessage("da leggere"),
        "uptime": MessageLookupByLibrary.simpleMessage("Operatività"),
        "useNautilusRep":
            MessageLookupByLibrary.simpleMessage("Use Nautilus Rep"),
        "userNotFound":
            MessageLookupByLibrary.simpleMessage("Utente non trovato!"),
        "usernameAlreadyRegistered": MessageLookupByLibrary.simpleMessage(
            "Hai già un nome utente registrato! Al momento non è possibile modificare il tuo nome utente, ma sei libero di registrarne uno nuovo a un indirizzo diverso."),
        "usernameAvailable":
            MessageLookupByLibrary.simpleMessage("Username disponibile!"),
        "usernameEmpty":
            MessageLookupByLibrary.simpleMessage("Inserisci un nome utente"),
        "usernameError":
            MessageLookupByLibrary.simpleMessage("Errore nome utente"),
        "usernameInfo": MessageLookupByLibrary.simpleMessage(
            "Scegli un @username unico per farti trovare facilmente da amici e familiari!\n\nAvere un nome utente Nautilus aggiorna l\'interfaccia utente a livello globale per riflettere il tuo nuovo handle."),
        "usernameInvalid":
            MessageLookupByLibrary.simpleMessage("Nome utente non valido"),
        "usernameUnavailable":
            MessageLookupByLibrary.simpleMessage("Nome utente non disponibile"),
        "usernameWarning": MessageLookupByLibrary.simpleMessage(
            "I nomi utente Nautilus sono un servizio centralizzato fornito da Nano.to"),
        "viewDetails": MessageLookupByLibrary.simpleMessage("Dettagli"),
        "votingWeight": MessageLookupByLibrary.simpleMessage("Peso del Voto"),
        "warning": MessageLookupByLibrary.simpleMessage("ATTENZIONE"),
        "welcomeText": MessageLookupByLibrary.simpleMessage(
            "Benvenuto in Nautilus. Per continuare, puoi creare un nuovo portafoglio o importarne uno esistente."),
        "welcomeTextKal": MessageLookupByLibrary.simpleMessage(
            "Benvenuto in Kalium. Per continuare, puoi creare un nuovo portafoglio o importarne uno esistente."),
        "withAddress": MessageLookupByLibrary.simpleMessage("Con indirizzo"),
        "withMessage": MessageLookupByLibrary.simpleMessage("Con messaggio"),
        "xMinute": MessageLookupByLibrary.simpleMessage("Dopo %1 minuto"),
        "xMinutes": MessageLookupByLibrary.simpleMessage("Dopo %1 minuti"),
        "yes": MessageLookupByLibrary.simpleMessage("Si"),
        "yesButton": MessageLookupByLibrary.simpleMessage("Si")
      };
}
