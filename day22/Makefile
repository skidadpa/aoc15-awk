.PHONY: test clean update

test : expected.txt results.txt
	diff -s expected.txt results.txt

PROGRAMS = one.awk two.awk
INPUTS = sample.txt sample2.txt input.txt

results.txt : $(PROGRAMS) $(INPUTS)
	./one.awk sample.txt > $@
	./one.awk sample2.txt >> $@
	./one.awk input.txt >> $@
	./two.awk input.txt >> $@
	cat $@

clean:
	$(RM) results.txt

update: results.txt
	cp $< expected.txt
