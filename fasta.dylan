module: fasta

define constant $alu :: <byte-string> =
  "GGCCGGGCGCGGTGGCTCACGCCTGTAATCCCAGCACTTTGG"
  "GAGGCCGAGGCGGGCGGATCACCTGAGGTCAGGAGTTCGAGA"
  "CCAGCCTGGCCAACATGGTGAAACCCCGTCTCTACTAAAAAT"
  "ACAAAAATTAGCCGGGCGTGGTGGCGCGCGCCTGTAATCCCA"
  "GCTACTCGGGAGGCTGAGGCAGGAGAATCGCTTGAACCCGGG"
  "AGGCGGAGGTTGCAGTGAGCCGAGATCGCGCCACTGCACTCC"
  "AGCCTGGGCGACAGAGCGAGACTCCGTCTCAAAAA";

define sealed class <frequency> (<object>)
  slot p :: <double-float>, required-init-keyword: p:;
  constant slot c :: <byte-character>, required-init-keyword: c:;
end class <frequency>;

define constant $null-frequency :: <frequency> = make(<frequency>, c: '\<0>', p: 0.0d0);

define constant <frequency-vector> = limited(<vector>, of: <frequency>);

define constant $iub :: <frequency-vector>
  = begin
      let v = make(<frequency-vector>, size: 15, fill: $null-frequency);
      v[0] := make(<frequency>, c: 'a', p: 0.27d0);
      v[1] := make(<frequency>, c: 'c', p: 0.12d0);
      v[2] := make(<frequency>, c: 'g', p: 0.12d0);
      v[3] := make(<frequency>, c: 't', p: 0.27d0);
      v[4] := make(<frequency>, c: 'B', p: 0.02d0);
      v[5] := make(<frequency>, c: 'D', p: 0.02d0);
      v[6] := make(<frequency>, c: 'H', p: 0.02d0);
      v[7] := make(<frequency>, c: 'K', p: 0.02d0);
      v[8] := make(<frequency>, c: 'M', p: 0.02d0);
      v[9] := make(<frequency>, c: 'N', p: 0.02d0);
      v[10] := make(<frequency>, c: 'R', p: 0.02d0);
      v[11] := make(<frequency>, c: 'S', p: 0.02d0);
      v[12] := make(<frequency>, c: 'V', p: 0.02d0);
      v[13] := make(<frequency>, c: 'W', p: 0.02d0);
      v[14] := make(<frequency>, c: 'Y', p: 0.02d0);
      v
    end;

define constant $homosapiens :: <frequency-vector> = make(<frequency-vector>, size: 4, fill: $null-frequency);
$homosapiens[0] := make(<frequency>, c: 'a', p: 0.3029549426680d0);
$homosapiens[1] := make(<frequency>, c: 'c', p: 0.1979883004921d0);
$homosapiens[2] := make(<frequency>, c: 'g', p: 0.1975473066391d0);
$homosapiens[3] := make(<frequency>, c: 't', p: 0.3015094502008d0);

define constant $ia = 3877;
define constant $ic = 29573;
define constant $im = 139968;
define variable *last* :: <integer> = 42;

define function gen-random(max-value :: <double-float>)
 => result :: <double-float>;
  *last* := modulo((*last* * $ia + $ic), $im);
  (max-value * *last*) / as(<double-float>, $im);
end function gen-random;

define function make-cumulative(tbl :: <frequency-vector>)
  let cp :: <double-float> = 0.0d0;
  for (i from 0 below size(tbl))
    let frequency :: <frequency> = tbl[i];
    cp := cp + frequency.p;
    frequency.p := cp;
  end for;
end function make-cumulative;

define function make-repeat-fasta
    (id :: <string>, desc :: <string>, src :: <byte-string>, n :: <integer>)
  format-out(">%s %s\n", id, desc);
  let width = 60;
  let length :: <integer> =  size(src);
  let count :: <integer> = 0;
  let k :: <integer> = 0;
  let buffer = make(<byte-string>, size: width + 1);
  while (n > 0)
    count := min(n, width);
    for (i from 0 below count)
      if (k == length)
        k := 0;
      end if;
      buffer[i] := src[k];
      k := k + 1;
    end for;
    buffer[count] := '\n';
    write(*standard-output*, buffer, end: count + 1);
    n := n - width;
  end while;
end function make-repeat-fasta;

define function select-random-char (tbl :: <frequency-vector>, last-index :: <integer>)
 => result :: <byte-character>;
  let rnd = gen-random(1.0d0);
  let result =
    block(break)
      for (i from 0 below last-index)
        let frequency :: <frequency> = tbl[i];
        if (rnd < frequency.p)
          break(frequency.c);
        end if;
      end for;
      tbl[last-index].c;
    end block;
  result;
end function select-random-char;

define function make-random-fasta
    (id :: <string>, desc :: <string>, tbl :: <frequency-vector>, n :: <integer>)
  format-out(">%s %s\n", id, desc);
  let width = 60;
  let m = 0;
  let sz = size(tbl) - 1;
  let buffer = make(<byte-string>, size: width + 1);
  while (n > 0)
    m := min(n, width);
    for (i from 0 below m)
      buffer[i] := select-random-char(tbl, sz);
    end for;
    buffer[m] := '\n';
    write(*standard-output*, buffer, end: m + 1);
    n := n - width;
  end while;
end function make-random-fasta;

begin
  let n = string-to-integer(element(application-arguments(), 0, default: "1000"));
  make-cumulative($iub);
  make-cumulative($homosapiens);
  
  make-repeat-fasta("ONE", "Homo sapiens alu", $alu, n * 2);
  make-random-fasta("TWO", "IUB ambiguity codes", $iub, n * 3);
  make-random-fasta("THREE", "Homo sapiens frequency", $homosapiens, n * 5);
end;
