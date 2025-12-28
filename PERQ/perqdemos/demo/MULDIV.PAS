Module MulDiv;

{**************************************************
  Helpful Multiply/Divide Routines to Get Around
             Single Precision Arithmetic
  Ralph Guggenheim                 June 18, 1980
             Three Rivers Computer Corporation
             Pittsburgh, PA 15217
  
  Changed to use Arith module   20 Jun 81  JPS.
 **************************************************}
 
Exports
  Function MulMod(m1, m2, modval : integer) : integer;
  Procedure DblMul(Aa, Bb : integer; var Lo, Hi : integer);
  
Private

  imports Arith from Arith;

{  MulMod -- performs (m1 * m2) mod modval.
   It returns a 16 bit result.             }

function MulMod;
  var Product, Quotient, Divisor: FSBit32;
  begin
  MulMod := IntDouble(
               DoubleMod( DoubleMul( DoubleInt(M1), DoubleInt(M2) ),
                          DoubleInt(ModVal) ) )
  end;


{ DblMul -- takes two 16-bit multiplicands and generates
  a 32-bit product in referenced params Hi and Lo  }
Procedure DblMul;
  var ID: record case integer of
            1: (Low: Integer;
                High: Integer);
            2: (D: FSBit32)
            end;
  begin
  ID.D := DoubleMul( DoubleInt(Aa), DoubleInt(Bb) );
  Lo := ID.Low;
  Hi := ID.High
  end.
