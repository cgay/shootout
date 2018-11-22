module: fibo

define library fibo
  use common-dylan;
  use io;
end library;

define module fibo
  use common-dylan, exclude: { format-to-string };
  use format-out;
end module;

define function fibo (m :: <integer>) => (f :: <integer>)
  let f = 1;
  case 
    m < 1     => 0;
    m = 1     => 1;
    otherwise =>
      begin
        let n1 = 0;
        let n2 = 1;
        for (i from 2 to m)
          format-out("i = %d\n", i);
          f := n1 + n2;
          n1 := n2;
          n2 := f;
        end;
      end;
  end case;
  f
end function fibo;

begin
  let arg = string-to-integer(element(application-arguments(), 0, default: "1"));
  format-out("%d\n", fibo(arg));
end;

