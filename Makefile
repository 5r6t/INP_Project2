make:
	java -jar edumips64-1.3.0.jar --file=xmervaj00.s
test:
	gcc xlogin00.c && ./a.out