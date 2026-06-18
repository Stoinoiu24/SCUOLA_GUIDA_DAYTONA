DROP TABLE IF EXISTS  PAGAMENTO  CASCADE;
DROP TABLE IF EXISTS  ISCRIZIONE  CASCADE;
DROP TABLE IF EXISTS  GUIDA  CASCADE;
DROP TABLE IF EXISTS  LEZIONE  CASCADE;
DROP TABLE IF EXISTS  ESAME  CASCADE;
DROP TABLE IF EXISTS  VEICOLO  CASCADE;
DROP TABLE IF EXISTS  CORSO  CASCADE;
DROP TABLE IF EXISTS  PATENTE  CASCADE;
DROP TABLE IF EXISTS  ISTRUTTORE  CASCADE;
DROP TABLE IF EXISTS  ALLIEVO  CASCADE;
DROP TABLE IF EXISTS  UTENTE  CASCADE;


CREATE TABLE UTENTE (
    codice_fiscale CHAR(16) PRIMARY KEY,
    nome VARCHAR(50) NOT NULL,
    cognome VARCHAR(50) NOT NULL,
    data_nascita DATE NOT NULL,
    comune_nascita VARCHAR(50),
    indirizzo VARCHAR(100),
    citta VARCHAR(50),
    cap VARCHAR(10),
    telefono VARCHAR(20),
    email VARCHAR(100)
);

CREATE TABLE ALLIEVO (
    codice_fiscale CHAR(16) PRIMARY KEY,
    numero_foglio_rosa VARCHAR(20) UNIQUE,
    data_rilascio_foglio_rosa DATE,
    data_registrazione DATE NOT NULL,

    FOREIGN KEY (codice_fiscale)
        REFERENCES UTENTE(codice_fiscale)
        ON DELETE CASCADE
);

CREATE TABLE ISTRUTTORE (
    codice_fiscale CHAR(16) PRIMARY KEY,
    numero_patente VARCHAR(30) NOT NULL,
    data_assunzione DATE NOT NULL,
    stipendio NUMERIC(8,2) NOT NULL,

    FOREIGN KEY (codice_fiscale)
        REFERENCES UTENTE(codice_fiscale)
        ON DELETE CASCADE
);

CREATE TABLE PATENTE (
    id_patente SERIAL PRIMARY KEY,
    categoria VARCHAR(10) NOT NULL,
    descrizione TEXT,
    eta_minima INTEGER NOT NULL
);

CREATE TABLE CORSO (
    id_corso SERIAL PRIMARY KEY,
    nome VARCHAR(100) NOT NULL,
    descrizione TEXT,
    data_inizio DATE NOT NULL,
    stato VARCHAR(30),
	foglio_rosa bool,
    numero_lezioni_teoriche INTEGER NOT NULL,
    numero_minimo_lezioni_pratiche INTEGER NOT NULL,
    id_patente INTEGER NOT NULL,

    FOREIGN KEY (id_patente)
        REFERENCES PATENTE(id_patente)
);


CREATE TABLE VEICOLO (
    targa VARCHAR(10) PRIMARY KEY,
    marca VARCHAR(50) NOT NULL,
    modello VARCHAR(50) NOT NULL,
    categoria VARCHAR(20) NOT NULL,
    data_scadenza_revisione DATE NOT NULL,
    data_scadenza_assicurazione DATE NOT NULL
);


CREATE TABLE ISCRIZIONE (
    codice_pratica SERIAL PRIMARY KEY,
    data_iscrizione DATE NOT NULL,
    stato VARCHAR(30),

    codice_fiscale_allievo CHAR(16) NOT NULL,
    id_corso INTEGER NOT NULL,

    FOREIGN KEY (codice_fiscale_allievo)
        REFERENCES ALLIEVO(codice_fiscale),

    FOREIGN KEY (id_corso)
        REFERENCES CORSO(id_corso)
);



CREATE TABLE GUIDA (
    id_guida SERIAL PRIMARY KEY,

    data_guida DATE NOT NULL,
    ora_inizio TIME NOT NULL,
    durata INTEGER NOT NULL,
    luogo_partenza VARCHAR(100),

    codice_fiscale_allievo CHAR(16) NOT NULL,
    codice_fiscale_istruttore CHAR(16) NOT NULL,

    targa VARCHAR(10) NOT NULL,
    id_corso INTEGER NOT NULL,

    FOREIGN KEY (codice_fiscale_allievo)
        REFERENCES ALLIEVO(codice_fiscale),

    FOREIGN KEY (codice_fiscale_istruttore)
        REFERENCES ISTRUTTORE(codice_fiscale),

    FOREIGN KEY (targa)
        REFERENCES VEICOLO(targa),

    FOREIGN KEY (id_corso)
        REFERENCES CORSO(id_corso)
);


CREATE TABLE PAGAMENTO (
    id_pagamento SERIAL PRIMARY KEY,
    data_pagamento DATE,
    importo NUMERIC(8,2) NOT NULL,
    stato VARCHAR(30),
    metodo_pagamento VARCHAR(30),
    codice_pratica INTEGER,
    id_guida INTEGER,
	
	FOREIGN KEY (codice_pratica)
	REFERENCES ISCRIZIONE(codice_pratica),
	
	FOREIGN KEY (id_guida)
	REFERENCES GUIDA(id_guida)
	
);


CREATE TABLE LEZIONE (
    id_lezione SERIAL PRIMARY KEY,
    data DATE NOT NULL,
    ora_inizio TIME NOT NULL,
    durata INTEGER NOT NULL,
    argomento VARCHAR(255),

    id_corso INTEGER NOT NULL,
    codice_fiscale_istruttore CHAR(16) NOT NULL,

    FOREIGN KEY (id_corso)
        REFERENCES CORSO(id_corso),

    FOREIGN KEY (codice_fiscale_istruttore)
        REFERENCES ISTRUTTORE(codice_fiscale)
);


CREATE TABLE ESAME (
    id_esame SERIAL PRIMARY KEY,

    data_esame DATE NOT NULL,
    tipo_esame VARCHAR(30) NOT NULL,
    esito VARCHAR(20),
    luogo VARCHAR(100),
    note TEXT,

    codice_fiscale_allievo CHAR(16) NOT NULL,
    id_corso INTEGER NOT NULL,

    FOREIGN KEY (codice_fiscale_allievo)
        REFERENCES ALLIEVO(codice_fiscale),

    FOREIGN KEY (id_corso)
        REFERENCES CORSO(id_corso)
);






