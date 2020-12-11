FILES := *.cs

Program.exe: $(FILES)
	mcs $^ -pkg:dotnet -out:Program.exe

run:
	mono Program.exe   

clean:
	rm *.exe
