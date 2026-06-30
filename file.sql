DROP TABLE IF EXISTS frequenza CASCADE;
DROP TABLE IF EXISTS guida CASCADE;
DROP TABLE IF EXISTS teoria CASCADE;
DROP TABLE IF EXISTS pratica CASCADE;
DROP TABLE IF EXISTS pagamento CASCADE;
DROP TABLE IF EXISTS esame CASCADE;
DROP TABLE IF EXISTS iscrizione CASCADE;
DROP TABLE IF EXISTS lezione CASCADE;
DROP TABLE IF EXISTS veicolo CASCADE;
DROP TABLE IF EXISTS corso CASCADE;
DROP TABLE IF EXISTS patente CASCADE;
DROP TABLE IF EXISTS istruttore CASCADE;
DROP TABLE IF EXISTS allievo CASCADE;
DROP TABLE IF EXISTS utente CASCADE;


CREATE TABLE utente (
    codice_fiscale CHAR(16) PRIMARY KEY,
    nome VARCHAR(50) NOT NULL,
    cognome VARCHAR(50) NOT NULL,
    data_nascita DATE NOT NULL,
    comune_nascita VARCHAR(50) NOT NULL,
    indirizzo VARCHAR(100) NOT NULL,
    citta VARCHAR(50) NOT NULL,
    cap VARCHAR(10) NOT NULL,
    telefono VARCHAR(20) NOT NULL,
    email VARCHAR(100)
);


CREATE TABLE allievo (
    codice_fiscale CHAR(16) PRIMARY KEY,
    data_registrazione DATE NOT NULL,
    numero_foglio_rosa VARCHAR(30),
    data_rilascio_foglio_rosa DATE,

    FOREIGN KEY (codice_fiscale)
        REFERENCES utente(codice_fiscale)
        ON DELETE CASCADE
);


CREATE TABLE istruttore (
    codice_fiscale CHAR(16) PRIMARY KEY,
    numero_patente VARCHAR(30) NOT NULL,
    data_assunzione DATE NOT NULL,
    stipendio NUMERIC(8,2 NOT NULL),

    FOREIGN KEY (codice_fiscale)
        REFERENCES utente(codice_fiscale)
        ON DELETE CASCADE
);


CREATE TABLE patente (
    categoria VARCHAR(10) PRIMARY KEY,
    descrizione VARCHAR(255) NOT NULL,
    eta_minima INTEGER NOT NULL,

    CHECK (eta_minima > 0)
);


CREATE TABLE corso (
    id_corso SERIAL PRIMARY KEY,
    nome VARCHAR(100) NOT NULL,
    descrizione TEXT,
    data_inizio DATE NOT NULL,
    stato VARCHAR(30) NOT NULL,
    numero_lezioni_teoriche INTEGER NOT NULL,
    numero_minimo_lezioni_pratiche INTEGER NOT NULL,
    foglio_rosa BOOLEAN NOT NULL,
    categoria_patente VARCHAR(10) NOT NULL,

    FOREIGN KEY (categoria_patente)
        REFERENCES patente(categoria),

    CHECK (numero_lezioni_teoriche IS NULL OR numero_lezioni_teoriche >= 0),
    CHECK (numero_minimo_lezioni_pratiche IS NULL OR numero_minimo_lezioni_pratiche >= 0)
);


CREATE TABLE iscrizione (
    codice_pratica SERIAL PRIMARY KEY,
    stato VARCHAR(30) NOT NULL,
    data_iscrizione DATE NOT NULL,
    codice_fiscale_allievo CHAR(16) NOT NULL,
    id_corso INTEGER NOT NULL,

    FOREIGN KEY (codice_fiscale_allievo)
        REFERENCES allievo(codice_fiscale)
        ON DELETE CASCADE,

    FOREIGN KEY (id_corso)
        REFERENCES corso(id_corso)
        ON DELETE CASCADE
);


CREATE TABLE veicolo (
    targa VARCHAR(10) PRIMARY KEY,
    marchio VARCHAR(50) NOT NULL,
    modello VARCHAR(50) NOT NULL,
    categoria VARCHAR(10) NOT NULL,
    data_scadenza_assicurazione DATE NOT NULL,
    data_scadenza_revisione DATE NOT NULL
);


CREATE TABLE lezione (
    data DATE NOT NULL,
    ora_inizio TIME NOT NULL,
    durata INTEGER NOT NULL,
    id_corso INTEGER NOT NULL,
    codice_fiscale_istruttore CHAR(16) NOT NULL,

    PRIMARY KEY (data, ora_inizio, durata),

    FOREIGN KEY (id_corso)
        REFERENCES corso(id_corso)
        ON DELETE CASCADE,

    FOREIGN KEY (codice_fiscale_istruttore)
        REFERENCES istruttore(codice_fiscale),

    CHECK (durata > 0)
);

CREATE TABLE teoria (
    data DATE NOT NULL,
    ora_inizio TIME NOT NULL,
    durata INTEGER NOT NULL,

    aula VARCHAR(50),
    modalita VARCHAR(30),
    argomento VARCHAR(255) NOT NULL,

    PRIMARY KEY (data, ora_inizio, durata),

    FOREIGN KEY (data, ora_inizio, durata)
        REFERENCES lezione(data, ora_inizio, durata)
        ON DELETE CASCADE
);


CREATE TABLE pratica (
    data DATE NOT NULL,
    ora_inizio TIME NOT NULL,
    durata INTEGER NOT NULL,

    luogo_partenza VARCHAR(100) NOT NULL,
    valutazione VARCHAR(50),
    note_istruttore TEXT,
    targa_veicolo VARCHAR(10) NOT NULL,
    codice_fiscale_allievo CHAR(16) NOT NULL,

    PRIMARY KEY (data, ora_inizio, durata),

    FOREIGN KEY (data, ora_inizio, durata)
        REFERENCES lezione(data, ora_inizio, durata)
        ON DELETE CASCADE,

    FOREIGN KEY (targa_veicolo)
        REFERENCES veicolo(targa),

    FOREIGN KEY (codice_fiscale_allievo)
        REFERENCES allievo(codice_fiscale)
        ON DELETE CASCADE
);


CREATE TABLE frequenza (
    codice_fiscale_allievo CHAR(16) NOT NULL,
    data_lezione DATE NOT NULL,
    ora_inizio_lezione TIME NOT NULL,
    durata_lezione INTEGER NOT NULL,

    PRIMARY KEY (
        codice_fiscale_allievo,
        data_lezione,
        ora_inizio_lezione,
        durata_lezione
    ),

    FOREIGN KEY (codice_fiscale_allievo)
        REFERENCES allievo(codice_fiscale)
        ON DELETE CASCADE,

    FOREIGN KEY (data_lezione, ora_inizio_lezione, durata_lezione)
        REFERENCES teoria(data, ora_inizio, durata)
        ON DELETE CASCADE
);




CREATE TABLE pagamento (
    id_pagamento SERIAL PRIMARY KEY,
    data_pagamento DATE NOT NULL,
    importo NUMERIC(8,2) NOT NULL,
    metodo_pagamento VARCHAR(30) NOT NULL,
    stato VARCHAR(30) NOT NULL,

    codice_pratica INTEGER,
    data_lezione_pratica DATE,
    ora_inizio_lezione_pratica TIME,
    durata_lezione_pratica INTEGER,

    FOREIGN KEY (codice_pratica)
        REFERENCES iscrizione(codice_pratica)
        ON DELETE CASCADE,

    FOREIGN KEY (
        data_lezione_pratica,
        ora_inizio_lezione_pratica,
        durata_lezione_pratica
    )
        REFERENCES pratica(data, ora_inizio, durata)
        ON DELETE CASCADE,

    CHECK (importo > 0),

    CHECK (
        (
            codice_pratica IS NOT NULL
            AND data_lezione_pratica IS NULL
            AND ora_inizio_lezione_pratica IS NULL
            AND durata_lezione_pratica IS NULL
        )
        OR
        (
            codice_pratica IS NULL
            AND data_lezione_pratica IS NOT NULL
            AND ora_inizio_lezione_pratica IS NOT NULL
            AND durata_lezione_pratica IS NOT NULL
        )
    )
);


CREATE TABLE esame (
    id_esame SERIAL PRIMARY KEY,
    data_esame DATE NOT NULL,
    tipo_esame VARCHAR(30) NOT NULL,
    esito VARCHAR(30) NOT NULL,
    luogo VARCHAR(100) NOT NULL,
    note TEXT,
    codice_fiscale_allievo CHAR(16) NOT NULL,
    id_corso INTEGER NOT NULL,

    FOREIGN KEY (codice_fiscale_allievo)
        REFERENCES allievo(codice_fiscale)
        ON DELETE CASCADE,

    FOREIGN KEY (id_corso)
        REFERENCES corso(id_corso)
        ON DELETE CASCADE
);
