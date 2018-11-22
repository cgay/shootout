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
  local method fib (m, n1, n2) => (f :: <integer>)
          if (m = 0)
            n1
          elseif (m = 1)
            n2
          else
            fib(m - 1, n2, n1 + n2)
          end
        end;
  fib(m, 0, 1)
end function fibo;

begin
  let arg = string-to-integer(element(application-arguments(), 0, default: "1"));
  format-out("%d\n", fibo(arg));
end;

