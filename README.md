# Licenta-3D-Crane

Acestea sunt fisierele sursă, fiecare dintre aceastea conținând scripturile pentru simularea procesului condus 3D Crane și mai apoi pentru proiectarea regulatorului de tip PID prin algoritmul VRFT.

Pașii de rulare sunt:

1) Se rulează pentru fiecare folder fișierul cu numele pas1.m, acesta va simula schema din simulink și le va reprezenta grafic, datele de intrare și iesire fiind salvate într-un fisier cu numele date_X, date_Y si date_Z în funcție de care axa suntem. In acest pas se apeleaza scriptul script_3DCrane care acesta defineste functiile de transfer pentru procesul condus

2) Vom rula fișierul date_intiale.m, care acesta este codul principal, se încarcă  datele colectate la pasul 1, apoi ne definim o variabila idx_split pentru a avea mijlocul datelor, unul dintre seturi fiind folosit la antrenare iar celalalt la validare, initializam matricile pentru referinte si eroriile virtuale pentru fiecare set, se defineste modelul de referinta ales,  se calculeaza semnalele de intrare virtuale, eroriile virtuale, se aplica 3 metode cele mai mici pătrate, quasi newton si sequential quadratic care sunt folosite in estimarea parametrilor regulatorului PID, in final apelandu-se functile de validare și testare(validare_MFC_VRFT și testare_MFC_VRFT)

4) functie1_x care are rolul de a evalua performanța regulatorului PID estimat, folosind funcția de cost denumită 𝐽𝑉𝑅𝐹𝑇. Codul prezintă o implementare MATLAB pentru calculul costului mediu pătratic al unei comenzi reale filtrate obținute din datele măsurate într-un sistem cu buclă deschisă, comparată cu comanda generată de un regulator PID estimat, utilizând funcția func_MFC pentru a evalua performanța pe baza unui vector de parametri PID (RHO), lungimea semnalului (eVirt1L), și datele reale filtrate (uHist1L). Funcția obiectiv J este definită ca media erorilor pătrate între comanda filtrată și cea generată de PID pe intervalul de date, oferind o metrică de optimizare pentru acordarea regulatorului.

5)  Schema simulink este Crane3D_testare.slcx

Link-ul repository: https://github.com/David324529/Licenta-3D-Crane.git
