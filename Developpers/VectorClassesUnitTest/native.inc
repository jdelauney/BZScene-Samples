function NativeAffineVectorMake(const x, y, z : Single) : TNativeBZAffineVector;
begin
   Result.X:=x;
   Result.Y:=y;
   Result.Z:=z;
end;

function NativeAffineVectorMake(const v : TNativeBZVector) : TNativeBZAffineVector;
begin
   Result.X:=v.X;
   Result.Y:=v.Y;
   Result.Z:=v.Z;
end;

{%region%-----[ TNativeBZVector2i ]--------------------------------------------}

procedure TNativeBZVector2i.Create(aX,aY: Integer);
begin
  Self.X := aX;
  Self.Y := aY;
end;

function TNativeBZVector2i.ToString : String;
begin
   Result := '(X: '+IntToStr(Self.X)+
            ' ,Y: '+IntToStr(Self.Y)+')';
End;

class operator TNativeBZVector2i.+(constref A, B: TNativeBZVector2i): TNativeBZVector2i;
begin
  Result.X := A.X + B.X;
  Result.Y := A.Y + B.Y;
end;

class operator TNativeBZVector2i.+(constref A: TNativeBZVector2i; constref B:Integer): TNativeBZVector2i;
begin
  Result.X := A.X + B;
  Result.Y := A.Y + B;
end;

class operator TNativeBZVector2i.-(constref A, B: TNativeBZVector2i): TNativeBZVector2i;
begin
  Result.X := A.X - B.X;
  Result.Y := A.Y - B.Y;
end;

class operator TNativeBZVector2i.-(constref A: TNativeBZVector2i; constref B:Integer): TNativeBZVector2i;
begin
  Result.X := A.X - B;
  Result.Y := A.Y - B;
end;

class operator TNativeBZVector2i.*(constref A, B: TNativeBZVector2i): TNativeBZVector2i;
begin
  Result.X := A.X * B.X;
  Result.Y := A.Y * B.Y;
end;

//class operator TNativeBZVector2i.*(constref A:TNativeBZVector2i; Constref B: TNativeBZVector2f): TNativeBZVector2i;
//begin
//  Result.X := Round(A.X * B.X);
//  Result.Y := Round(A.Y * B.Y);
//end;

class operator TNativeBZVector2i.div(constref A, B: TNativeBZVector2i): TNativeBZVector2i;
begin
  Result.X := A.X div B.X;
  Result.Y := A.Y div B.Y;
end;

class operator TNativeBZVector2i.div(constref A : TNativeBZVector2i;Constref B:Integer ): TNativeBZVector2i;
begin
  Result.X := A.X div B;
  Result.Y := A.Y div B;
end;

class operator TNativeBZVector2i.+(constref A: TNativeBZVector2i; constref B:Single): TNativeBZVector2i;
begin
  Result.X := Round(A.X + B);
  Result.Y := Round(A.Y + B);
end;

class operator TNativeBZVector2i.-(constref A: TNativeBZVector2i; constref B:Single): TNativeBZVector2i;
begin
  Result.X := Round(A.X - B);
  Result.Y := Round(A.Y - B);
end;

class operator TNativeBZVector2i.*(constref A: TNativeBZVector2i; constref B:Single): TNativeBZVector2i;
begin
  Result.X := Round(A.X * B);
  Result.Y := Round(A.Y * B);
end;

//For Increase performance add this to an TNativeBZVector2iHelper and you TNativeBZVector2f for compute values
class operator TNativeBZVector2i./(constref A: TNativeBZVector2i; constref B:Single): TNativeBZVector2i;
Var
  d : Single;
  //v2 : TBZVector2f;
begin
  d :=1/B;
  //v2.Create(self);
  //v2 := v2 * d
  //result := v2.Trunc;
  Result.X := Round(A.X * d);
  Result.Y := Round(A.Y * d);
end;

class operator TNativeBZVector2i.-(constref A: TNativeBZVector2i): TNativeBZVector2i;
begin
  Result.X := -A.X;
  Result.Y := -A.Y;
end;

class operator TNativeBZVector2i.=(constref A, B: TNativeBZVector2i): Boolean;
begin
 result := ((A.X = B.X) And (A.Y = B.Y));
end;

class operator TNativeBZVector2i.Mod(Constref A, B : TNativeBZVector2i): TNativeBZVector2i;
begin
  Result.x := A.X Mod B.X;
  Result.Y := A.Y Mod B.Y;
end;

(*class operator >=(constref A, B: TVector4f): Boolean;
class operator <=(constref A, B: TVector4f): Boolean;
class operator >(constref A, B: TVector4f): Boolean;
class operator <(constref A, B: TVector4f): Boolean; *)

class operator TNativeBZVector2i.<>(constref A, B: TNativeBZVector2i): Boolean;
begin
  result := ((A.X <> B.X) or (A.Y <> B.Y));
end;


function TNativeBZVector2i.Min(constref B: TNativeBZVector2i): TNativeBZVector2i;
begin
  Result := Self;
  if Result.X > B.X then Result.X := B.X;
  //:= Math.Min(Self.X, B.X);
  //Result.Y := Math.Min(Self.Y, B.Y);
  if Result.Y > B.Y then Result.Y := B.Y;
end;

function TNativeBZVector2i.Min(constref B: Integer): TNativeBZVector2i;
Begin
  Result := Self;
  Result.X := Math.Min(Self.X, B);
  Result.Y := Math.Min(Self.Y, B);
end;

function TNativeBZVector2i.Max(constref B: TNativeBZVector2i): TNativeBZVector2i;
begin
  Result := Self;
  if Result.X < B.X then Result.X := B.X;
  if Result.Y < B.Y then Result.Y := B.Y;
end;

function TNativeBZVector2i.Max(constref B: Integer): TNativeBZVector2i;
begin
  Result := Self;
  Result.X := Math.Max(Self.X, B);
  Result.Y := Math.Max(Self.Y, B);
end;

function TNativeBZVector2i.Clamp(constref AMin, AMax: TNativeBZVector2i): TNativeBZVector2i;
begin
  Result.X := Math.Min(Math.Max(Self.X, AMin.X),AMax.X);
  Result.Y := Math.Min(Math.Max(Self.Y, AMin.Y),AMax.Y);
end;

function TNativeBZVector2i.Clamp(constref AMin, AMax: Integer): TNativeBZVector2i;
begin
  Result.X := Math.Min(Math.Max(Self.X, AMin),AMax);
  Result.Y := Math.Min(Math.Max(Self.Y, AMin),AMax);
end;

function TNativeBZVector2i.MulAdd(constref A,B:TNativeBZVector2i): TNativeBZVector2i;
begin
  Result := (Self*A) + B;
end;

function TNativeBZVector2i.MulDiv(constref A,B:TNativeBZVector2i): TNativeBZVector2i;
begin
  Result := (Self*A) div B;
end;

function TNativeBZVector2i.Length:Single;
begin
  Result := System.Sqrt((Self.X * Self.X) + (Self.Y * Self.Y));
end;

function TNativeBZVector2i.LengthSquare:Single;
begin
  Result := (Self.X * Self.X) + (Self.Y * Self.Y);
end;

function TNativeBZVector2i.Distance(constref A:TNativeBZVector2i):Single;
begin
  Result := (Self - A).Length;
end;

function TNativeBZVector2i.DistanceSquare(constref A:TNativeBZVector2i):Single;
var
  t : TNativeBZVector2i;
begin
   t := Self - A;
   Result := t.LengthSquare;
end;

function TNativeBZVector2i.Abs: TNativeBZVector2i;
begin
  Result.X := System.abs(Self.X);
  Result.Y := System.abs(Self.Y);
end;

function TNativeBZVector2i.DotProduct(A:TNativeBZVector2i):Single;
begin
  Result := (X * A.X) + (Y * A.Y);
end;

function TNativeBZVector2i.AngleCosine(constref A: TNativeBZVector2i): Single;
begin
   Result:=Self.DotProduct(A)/(Self.Length*A.Length);
end;

function TNativeBZVector2i.AngleBetween(Constref A, ACenterPoint : TNativeBZVector2i): Single;
Var
  vt1,vt2: TNativeBZVector2i;
  vf1,vf2: TNativeBZVector2f;
begin
  vt1 := Self - ACenterPoint;
  vt2 := A - ACenterPoint;
  vf1 := vt1.Normalize;
  vf2 := vt2.Normalize;
  Result := ArcCos(vf1.AngleCosine(vf2));
end;
{%endregion%}

{%region%-----[ TNativeBZVector2f ]--------------------------------------------}

{%region%----[ TNativeBZVector2f Operators ]-----------------------------------}

procedure TNativeBZVector2f.Create(aX,aY: Single);
begin
  Self.X := aX;
  Self.Y := aY;
end;

function TNativeBZVector2f.ToString : String;
begin
   Result := '(X: '+FloattoStrF(Self.X,fffixed,5,5)+
            ' ,Y: '+FloattoStrF(Self.Y,fffixed,5,5)+')';
End;

class operator TNativeBZVector2f.+(constref A, B: TNativeBZVector2f): TNativeBZVector2f;
begin
  Result.X := A.X + B.X;
  Result.Y := A.Y + B.Y;
end;

class operator TNativeBZVector2f.-(constref A, B: TNativeBZVector2f): TNativeBZVector2f;
begin
  Result.X := A.X - B.X;
  Result.Y := A.Y - B.Y;
end;

class operator TNativeBZVector2f.*(constref A, B: TNativeBZVector2f): TNativeBZVector2f;
begin
  Result.X := A.X * B.X;
  Result.Y := A.Y * B.Y;
end;

class operator TNativeBZVector2f./(constref A, B: TNativeBZVector2f): TNativeBZVector2f;
begin
  Result.X := A.X / B.X;
  Result.Y := A.Y / B.Y;
end;

class operator TNativeBZVector2f.+(constref A: TNativeBZVector2f; constref B:Single): TNativeBZVector2f;
begin
  Result.X := A.X + B;
  Result.Y := A.Y + B;
end;

class operator TNativeBZVector2f.-(constref A: TNativeBZVector2f; constref B:Single): TNativeBZVector2f;
begin
  Result.X := A.X - B;
  Result.Y := A.Y - B;
end;

class operator TNativeBZVector2f.*(constref A: TNativeBZVector2f; constref B:Single): TNativeBZVector2f;
begin
  Result.X := A.X * B;
  Result.Y := A.Y * B;
end;

class operator TNativeBZVector2f./(constref A: TNativeBZVector2f; constref B:Single): TNativeBZVector2f;
Var
  d : Single;
begin
  d :=1/B;
  Result.X := A.X * d;
  Result.Y := A.Y * d;
end;

class operator TNativeBZVector2f./(constref A: TNativeBZVector2f; constref B: TNativeBZVector2i): TNativeBZVector2f;
begin
  Result.X := A.X / B.X;
  Result.Y := A.Y / B.Y;
end;

{%endregion%}

{%region%----[ TNativeBZVector2f Functions ]-----------------------------------}

function TNativeBZVector2f.Min(constref B: Single): TNativeBZVector2f;
Begin
  Result.X := Math.Min(Self.X, B);
  Result.Y := Math.Min(Self.Y, B);
end;

function TNativeBZVector2f.Min(constref B: TNativeBZVector2f): TNativeBZVector2f;
begin
  Result.X := Math.Min(Self.X, B.X);
  Result.Y := Math.Min(Self.Y, B.Y);
end;

function TNativeBZVector2f.Max(constref B: Single): TNativeBZVector2f;
begin
  Result.X := Math.Max(Self.X, B);
  Result.Y := Math.Max(Self.Y, B);
end;

function TNativeBZVector2f.Max(constref B: TNativeBZVector2f): TNativeBZVector2f;
begin
  Result.X := Math.Max(Self.X, B.X);
  Result.Y := Math.Max(Self.Y, B.Y);
end;

function TNativeBZVector2f.Clamp(constref AMin, AMax: Single): TNativeBZVector2f;
begin
  Result.X := Math.Min(Math.Max(Self.X, AMin),AMax);
  Result.Y := Math.Min(Math.Max(Self.Y, AMin),AMax);
end;

function TNativeBZVector2f.Clamp(constref AMin, AMax: TNativeBZVector2f): TNativeBZVector2f;
begin
  Result.X := Math.Min(Math.Max(Self.X, AMin.X),AMax.X);
  Result.Y := Math.Min(Math.Max(Self.Y, AMin.Y),AMax.Y);
end;

function TNativeBZVector2f.MulAdd(A,B:TNativeBZVector2f): TNativeBZVector2f;
begin
  Result := (Self*A) + B;
end;

function TNativeBZVector2f.MulDiv(A,B:TNativeBZVector2f): TNativeBZVector2f;
begin
  Result := (Self*A) / B;
end;

function TNativeBZVector2f.Length:Single;
begin
  Result := System.Sqrt((Self.X * Self.X) + (Self.Y * Self.Y));
end;

function TNativeBZVector2f.LengthSquare:Single;
begin
  Result := (Self.X * Self.X) + (Self.Y * Self.Y);
end;

function TNativeBZVector2f.Distance(A:TNativeBZVector2f):Single;
begin
  Result := (Self - A).Length;
end;

function TNativeBZVector2f.DistanceSquare(A:TNativeBZVector2f):Single;
var
  t : TNativeBZVector2f;
begin
   t := Self - A;
   Result := t.LengthSquare;
end;

function TNativeBZVector2f.Normalize : TNativeBZVector2f;
begin
 Result := Self * (1/Self.Length);
end;

class operator TNativeBZVector2f.-(constref A: TNativeBZVector2f): TNativeBZVector2f;
begin
  Result.X := -A.X;
  Result.Y := -A.Y;
end;

class operator TNativeBZVector2f.=(constref A, B: TNativeBZVector2f): Boolean;
begin
 result := ((A.X = B.X) And (A.Y = B.Y));
end;
(*class operator >=(constref A, B: TVector4f): Boolean;
class operator <=(constref A, B: TVector4f): Boolean;
class operator >(constref A, B: TVector4f): Boolean;
class operator <(constref A, B: TVector4f): Boolean; *)

class operator TNativeBZVector2f.<>(constref A, B: TNativeBZVector2f): Boolean;
begin
  result := ((A.X <> B.X) or (A.Y <> B.Y));
end;

function TNativeBZVector2f.Abs: TNativeBZVector2f;
begin
  Result.X := System.Abs(Self.X);
  Result.Y := System.Abs(Self.Y);
end;

function TNativeBZVector2f.DotProduct(A:TNativeBZVector2f):Single;
begin
  Result := (X * A.X) + (Y * A.Y);
end;

function TNativeBZVector2f.AngleCosine(constref A: TNativeBZVector2f): Single;
begin
   Result:=Self.DotProduct(A)/(Self.Length*A.Length);
end;

function TNativeBZVector2f.AngleBetween(Constref A, ACenterPoint : TNativeBZVector2f): Single;
Var
  vt1,vt2  :  TNativeBZVector2f;
begin
  vt1 := Self - ACenterPoint;
  vt2 := A - ACenterPoint;
  vt1 := vt1.Normalize;
  vt2 := vt2.Normalize;
  Result := ArcCos(vt1.AngleCosine(vt2));
end;

function TNativeBZVector2f.Round : TNativeBZVector2i;
begin
 result.X := System.Round(Self.X);
 result.Y := System.Round(Self.Y);
end;

function TNativeBZVector2f.Trunc : TNativeBZVector2i;
begin
 result.X := System.Trunc(Self.X);
 result.Y := System.Trunc(Self.Y);
end;

function TNativeBZVector2f.Floor : TNativeBZVector2i;
begin
 result.X := BZMath.Floor(Self.X);
 result.Y := BZMath.Floor(Self.Y);
end;

function TNativeBZVector2f.Ceil : TNativeBZVector2i;
begin
 result.X := BZMath.Ceil(Self.X);
 result.Y := BZMath.Ceil(Self.Y);
end;

function TNativeBZVector2f.Fract : TNativeBZVector2f;
begin
 result.X := BZMath.Fract(Self.X);
 result.Y := BZMath.Fract(Self.Y);
end;

function TNativeBZVector2f.Sqrt : TNativeBZVector2f;
begin
 result.X := System.Sqrt(Self.X);
 result.Y := System.Sqrt(Self.Y);
end;

function TNativeBZVector2f.InvSqrt : TNativeBZVector2f;
begin
 result.X := BZMath.InvSqrt(Self.X);
 result.Y := BZMath.InvSqrt(Self.Y);
 //result.X := 1/System.Sqrt(Self.X);
 //result.Y := 1/System.Sqrt(Self.Y);
end;

function TNativeBZVector2f.ModF(Constref A : TNativeBZVector2f): TNativeBZVector2f;
var
  t : TNativeBZVector2i;
  vt : TNativeBZVector2f;
begin
  vt := (Self / a);
  t := vt.floor;
  vt.x:=t.x;
  vt.y:=t.y;
  result := (Self - (a*vt));
end;

function TNativeBZVector2f.fMod(Constref A : TNativeBZVector2f): TNativeBZVector2i;
var
  t : TNativeBZVector2i;
  vt : TNativeBZVector2f;
begin
  vt := (Self / A);
  t := vt.floor;
  vt.x:=t.x;
  vt.y:=t.y;
  vt := (Self - (A*vt));
  result := vt.Trunc;
end;


{%endregion%}
{%endregion%}


{%region%----[ TNativeBZVector2d ]---------------------------------------------}

procedure TNativeBZVector2d.Create(aX,aY: Double);
begin
  Self.X := aX;
  Self.Y := aY;
end;

function TNativeBZVector2d.ToString : String;
begin
   Result := '(X: '+FloattoStrF(Self.X,fffixed,5,5)+
            ' ,Y: '+FloattoStrF(Self.Y,fffixed,5,5)+')';
End;

class operator TNativeBZVector2d.-(constref A: TNativeBZVector2d): TNativeBZVector2d;
begin
  Result.X := -A.X;
  Result.Y := -A.Y;
end;

class operator TNativeBZVector2d.=(constref A, B: TNativeBZVector2d): Boolean;
begin
 result := ((A.X = B.X) And (A.Y = B.Y));
end;

(*class operator >=(constref A, B: TVector4f): Boolean;
class operator <=(constref A, B: TVector4f): Boolean;
class operator >(constref A, B: TVector4f): Boolean;
class operator <(constref A, B: TVector4f): Boolean; *)

class operator TNativeBZVector2d.<>(constref A, B: TNativeBZVector2d): Boolean;
begin
  result := ((A.X <> B.X) or (A.Y <> B.Y));
end;

function TNativeBZVector2d.DotProduct(A:TNativeBZVector2d):Double;
begin
  Result := (X * A.X) + (Y * A.Y);
end;

function TNativeBZVector2d.AngleCosine(constref A: TNativeBZVector2d): Double;
begin
   Result:=Self.DotProduct(A)/(Self.Length*A.Length);
end;

function TNativeBZVector2d.AngleBetween(Constref A, ACenterPoint : TNativeBZVector2d): Double;
Var
  vt1,vt2  :  TNativeBZVector2d;
begin
  vt1 := Self - ACenterPoint;
  vt2 := A - ACenterPoint;
  vt1 := vt1.Normalize;
  vt2 := vt2.Normalize;
  Result := ArcCos(vt1.AngleCosine(vt2));
end;


class operator TNativeBZVector2d.+(constref A, B: TNativeBZVector2d): TNativeBZVector2d;
begin
  Result.X := A.X + B.X;
  Result.Y := A.Y + B.Y;
end;

class operator TNativeBZVector2d.-(constref A, B: TNativeBZVector2d): TNativeBZVector2d;
begin
  Result.X := A.X - B.X;
  Result.Y := A.Y - B.Y;
end;

class operator TNativeBZVector2d.*(constref A, B: TNativeBZVector2d): TNativeBZVector2d;
begin
  Result.X := A.X * B.X;
  Result.Y := A.Y * B.Y;
end;

class operator TNativeBZVector2d.*(constref A:TNativeBZVector2d; Constref B: TNativeBZVector2i): TNativeBZVector2d;
begin
  Result.X := A.X * B.X;
  Result.Y := A.Y * B.Y;
end;

class operator TNativeBZVector2d./(constref A, B: TNativeBZVector2d): TNativeBZVector2d;
begin
  Result.X := A.X / B.X;
  Result.Y := A.Y / B.Y;
end;

class operator TNativeBZVector2d.+(constref A: TNativeBZVector2d; constref B:Double): TNativeBZVector2d;
begin
  Result.X := A.X + B;
  Result.Y := A.Y + B;
end;

class operator TNativeBZVector2d.-(constref A: TNativeBZVector2d; constref B:Double): TNativeBZVector2d;
begin
  Result.X := A.X - B;
  Result.Y := A.Y - B;
end;

class operator TNativeBZVector2d.*(constref A: TNativeBZVector2d; constref B:Double): TNativeBZVector2d;
begin
  Result.X := A.X * B;
  Result.Y := A.Y * B;
end;

class operator TNativeBZVector2d./(constref A: TNativeBZVector2d; constref B:Double): TNativeBZVector2d;
Var
  d : Double;
begin
  d :=1/B;
  Result.X := A.X * d;
  Result.Y := A.Y * d;
end;

class operator TNativeBZVector2d./(constref A: TNativeBZVector2d; constref B:TNativeBZVector2i): TNativeBZVector2d;
begin
  Result.X := A.X / B.X;
  Result.Y := A.Y / B.Y;
end;

class operator TNativeBZVector2d.+(constref A: TNativeBZVector2d; constref B: TNativeBZVector2i): TNativeBZVector2d;
begin
  Result.X := A.X + B.X;
  Result.Y := A.Y + B.Y;
end;

class operator TNativeBZVector2d.-(constref A: TNativeBZVector2d; constref B: TNativeBZVector2i): TNativeBZVector2d;
begin
  Result.X := A.X - B.X;
  Result.Y := A.Y - B.Y;
end;


function TNativeBZVector2d.Min(constref B: TNativeBZVector2d): TNativeBZVector2d;
begin
  Result := Self;
  if Result.X > B.X then Result.X := B.X;
  //:= Math.Min(Self.X, B.X);
  //Result.Y := Math.Min(Self.Y, B.Y);
  if Result.Y > B.Y then Result.Y := B.Y;
end;

function TNativeBZVector2d.Min(constref B: Double): TNativeBZVector2d;
Begin
  Result := Self;
  Result.X := Math.Min(Self.X, B);
  Result.Y := Math.Min(Self.Y, B);
end;

function TNativeBZVector2d.Max(constref B: TNativeBZVector2d): TNativeBZVector2d;
begin
  Result := Self;
  //Result.X := Math.Max(Self.X, B.X);
  //Result.Y := Math.Max(Self.Y, B.Y);
  Result := Self;
  if Result.X < B.X then Result.X := B.X;
  if Result.Y < B.Y then Result.Y := B.Y;
end;

function TNativeBZVector2d.Max(constref B: Double): TNativeBZVector2d;
begin
  Result := Self;
  Result.X := Math.Max(Self.X, B);
  Result.Y := Math.Max(Self.Y, B);
end;

function TNativeBZVector2d.Clamp(constref AMin, AMax: TNativeBZVector2d): TNativeBZVector2d;
begin
  Result.X := Math.Min(Math.Max(Self.X, AMin.X),AMax.X);
  Result.Y := Math.Min(Math.Max(Self.Y, AMin.Y),AMax.Y);
end;

function TNativeBZVector2d.Clamp(constref AMin, AMax: Double): TNativeBZVector2d;
begin
  Result.X := Math.Min(Math.Max(Self.X, AMin),AMax);
  Result.Y := Math.Min(Math.Max(Self.Y, AMin),AMax);
end;

function TNativeBZVector2d.MulAdd(constref A,B:TNativeBZVector2d): TNativeBZVector2d;
begin
  Result := (Self*A) + B;
end;

function TNativeBZVector2d.MulSub(constref A,B:TNativeBZVector2d): TNativeBZVector2d;
begin
  Result := (Self*A) - B;
end;

function TNativeBZVector2d.MulDiv(constref A,B:TNativeBZVector2d): TNativeBZVector2d;
begin
  Result := (Self*A) / B;
end;

function TNativeBZVector2d.Length:Double;
begin
  Result := System.Sqrt((Self.X * Self.X) + (Self.Y * Self.Y));
end;

function TNativeBZVector2d.LengthSquare:Double;
begin
  Result := (Self.X * Self.X) + (Self.Y * Self.Y);
end;

function TNativeBZVector2d.Distance(constref A:TNativeBZVector2d):Double;
begin
  Result := (Self - A).Length;
end;

function TNativeBZVector2d.DistanceSquare(constref A:TNativeBZVector2d):Double;
var
  t : TNativeBZVector2d;
begin
   t := Self - A;
   Result := t.LengthSquare;
end;

function TNativeBZVector2d.Normalize : TNativeBZVector2d;
begin
 Result := Self * (1/Self.Length);
end;

function TNativeBZVector2d.Abs: TNativeBZVector2d;
begin
  Result.X := System.abs(Self.X);
  Result.Y := System.abs(Self.Y);
end;

function TNativeBZVector2d.Round : TNativeBZVector2i;
begin
 result.X := System.Round(Self.X);
 result.Y := System.Round(Self.Y);
end;

function TNativeBZVector2d.Trunc : TNativeBZVector2i;
begin
 result.X := System.Trunc(Self.X);
 result.Y := System.Trunc(Self.Y);
end;

function TNativeBZVector2d.Floor : TNativeBZVector2i;
begin
 result.X := BZMath.Floor(Self.X);
 result.Y := BZMath.Floor(Self.Y);
end;

function TNativeBZVector2d.Ceil : TNativeBZVector2i;
begin
 result.X := BZMath.Ceil(Self.X);
 result.Y := BZMath.Ceil(Self.Y);
end;

function TNativeBZVector2d.Fract : TNativeBZVector2d;
begin
 result.X := BZMath.Fract(Self.X);
 result.Y := BZMath.Fract(Self.Y);
end;

function TNativeBZVector2d.Sqrt : TNativeBZVector2d;
begin
 result.X := System.Sqrt(Self.X);
 result.Y := System.Sqrt(Self.Y);
end;

function TNativeBZVector2d.InvSqrt : TNativeBZVector2d;
begin
 result.X := BZMath.InvSqrt(Self.X);
 result.Y := BZMath.InvSqrt(Self.Y);
end;

function TNativeBZVector2d.ModF(Constref A : TNativeBZVector2d): TNativeBZVector2d;
var
  t : TNativeBZVector2i;
  vt : TNativeBZVector2d;
begin
  vt := (Self / a);
  t := vt.floor;
  vt.x:=t.x;
  vt.y:=t.y;
  result := (Self - (a*vt));
end;

function TNativeBZVector2d.fMod(Constref A : TNativeBZVector2d): TNativeBZVector2i;
var
  t : TNativeBZVector2i;
  vt : TNativeBZVector2d;
begin
  vt := (Self / A);
  t := vt.floor;
  vt.x:=t.x;
  vt.y:=t.y;
  vt := (Self - (A*vt));
  result := vt.Trunc;
end;


{%endregion%}


{%region%----[ TNativeBZVector3b ]---------------------------------------------}

procedure TNativeBZVector3b.Create(const aX, aY, aZ: Byte);
begin
  Self.X := aX;
  Self.Y := aY;
  Self.Z := aZ;
end;

function TNativeBZVector3b.ToString: String;
begin
  Result := '(X: '+IntToStr(Self.X)+
           ' ,Y: '+IntToStr(Self.Y)+
           ' ,Z: '+IntToStr(Self.Z)+')';
end;


class operator TNativeBZVector3b.+(constref A, B: TNativeBZVector3b): TNativeBZVector3b;
begin
  Result.X := ClampByte((A.X + B.X));
  Result.Y := ClampByte((A.Y + B.Y));
  Result.Z := ClampByte((A.Z + B.Z));
end;

class operator TNativeBZVector3b.-(constref A, B: TNativeBZVector3b): TNativeBZVector3b;
begin
  Result.X := ClampByte((A.X - B.X));
  Result.Y := ClampByte((A.Y - B.Y));
  Result.Z := ClampByte((A.Z - B.Z));
end;

class operator TNativeBZVector3b.*(constref A, B: TNativeBZVector3b): TNativeBZVector3b;
begin
  Result.X := ClampByte((A.X * B.X));
  Result.Y := ClampByte((A.Y * B.Y));
  Result.Z := ClampByte((A.Z * B.Z));
end;

class operator TNativeBZVector3b.div(constref A, B: TNativeBZVector3b): TNativeBZVector3b;
begin
  Result.X := ClampByte((A.X div B.X));
  Result.Y := ClampByte((A.Y div B.Y));
  Result.Z := ClampByte((A.Z div B.Z));
end;

class operator TNativeBZVector3b.+(constref A: TNativeBZVector3b; constref B: Byte ): TNativeBZVector3b;
begin
  Result.X := ClampByte((A.X + B));
  Result.Y := ClampByte((A.Y + B));
  Result.Z := ClampByte((A.Z + B));
end;

class operator TNativeBZVector3b.-(constref A: TNativeBZVector3b; constref B: Byte ): TNativeBZVector3b;
begin
  Result.X := ClampByte((A.X - B));
  Result.Y := ClampByte((A.Y - B));
  Result.Z := ClampByte((A.Z - B));
end;

class operator TNativeBZVector3b.*(constref A: TNativeBZVector3b; constref B: Byte ): TNativeBZVector3b;
begin
  Result.X := ClampByte((A.X * B));
  Result.Y := ClampByte((A.Y * B));
  Result.Z := ClampByte((A.Z * B));
end;

class operator TNativeBZVector3b.*(constref A: TNativeBZVector3b; constref B: Single): TNativeBZVector3b;
begin
  Result.X := ClampByte(Round((A.X * B)));
  Result.Y := ClampByte(Round((A.Y * B)));
  Result.Z := ClampByte(Round((A.Z * B)));
end;

class operator TNativeBZVector3b.div(constref A: TNativeBZVector3b; constref B: Byte ): TNativeBZVector3b;
begin
  Result.X := ClampByte((A.X div B));
  Result.Y := ClampByte((A.Y div B));
  Result.Z := ClampByte((A.Z div B));
end;

class operator TNativeBZVector3b.=(constref A, B: TNativeBZVector3b): Boolean;
begin
  Result := (A.X = B.X) and (A.Y = B.Y) and (A.Z = B.Z);
end;

class operator TNativeBZVector3b.<>(constref A, B: TNativeBZVector3b): Boolean;
begin
  Result := (A.X <> B.X) or (A.Y <> B.Y) or (A.Z <> B.Z);
end;

class operator TNativeBZVector3b.and(constref A, B: TNativeBZVector3b): TNativeBZVector3b;
begin
  Result.X := ClampByte((A.X and B.X));
  Result.Y := ClampByte((A.Y and B.Y));
  Result.Z := ClampByte((A.Z and B.Z));
end;

class operator TNativeBZVector3b.Or(constref A, B: TNativeBZVector3b): TNativeBZVector3b;
begin
  Result.X := ClampByte((A.X or B.X));
  Result.Y := ClampByte((A.Y or B.Y));
  Result.Z := ClampByte((A.Z or B.Z));
end;

class operator TNativeBZVector3b.Xor(constref A, B: TNativeBZVector3b): TNativeBZVector3b;
begin
  Result.X := ClampByte((A.X xor B.X));
  Result.Y := ClampByte((A.Y xor B.Y));
  Result.Z := ClampByte((A.Z xor B.Z));
end;

class operator TNativeBZVector3b.and(constref A: TNativeBZVector3b; constref B: Byte): TNativeBZVector3b;
begin
  Result.X := ClampByte((A.X and B));
  Result.Y := ClampByte((A.Y and B));
  Result.Z := ClampByte((A.Z and B));
end;

class operator TNativeBZVector3b.or(constref A: TNativeBZVector3b; constref B: Byte): TNativeBZVector3b;
begin
  Result.X := ClampByte((A.X or B));
  Result.Y := ClampByte((A.Y or B));
  Result.Z := ClampByte((A.Z or B));
end;

class operator TNativeBZVector3b.Xor(constref A: TNativeBZVector3b; constref B: Byte): TNativeBZVector3b;
begin
  Result.X := ClampByte((A.X xor B));
  Result.Y := ClampByte((A.Y xor B));
  Result.Z := ClampByte((A.Z xor B));
end;

function TNativeBZVector3b.Swizzle(const ASwizzle: TBZVector3SwizzleRef ): TNativeBZVector3b;
begin
  case ASwizzle of
    swXXX, swRRR :
    begin
      Result.X := Self.X;
      Result.Y := Self.X;
      Result.Z := Self.X;
    end;
    swYYY, swGGG :
    begin
      Result.X := Self.Y;
      Result.Y := Self.Y;
      Result.Z := Self.Y;
    end;
    swZZZ, swBBB :
    begin
      Result.X := Self.Z;
      Result.Y := Self.Z;
      Result.Z := Self.Z;
    end;
    swXZY, swRBG :
    begin
      Result.X := Self.X;
      Result.Y := Self.Z;
      Result.Z := Self.Y;
    end;
    swZYX, swBGR :
    begin
      Result.X := Self.Z;
      Result.Y := Self.Y;
      Result.Z := Self.X;
    end;
    swZXY, swBRG :
    begin
      Result.X := Self.Z;
      Result.Y := Self.X;
      Result.Z := Self.Y;
    end;
    swYXZ, swGRB :
    begin
      Result.X := Self.Y;
      Result.Y := Self.X;
      Result.Z := Self.Z;
    end;
    swYZX, swGBR :
    begin
      Result.X := Self.Y;
      Result.Y := Self.Z;
      Result.Z := Self.X;
    end;

    else result := self;
  end;
end;

{%endregion%}

{%region%----[ TNativeBZVector4b ]---------------------------------------------}
procedure TNativeBZVector4b.Create(const aX, aY, aZ : Byte; const aW : Byte);
begin
  Self.X := aX;
  Self.Y := aY;
  Self.Z := aZ;
  Self.w := aW;
end;

procedure TNativeBZVector4b.Create(const aValue : TNativeBZVector3b; const aW : Byte);
begin
  Self.X := aValue.X;
  Self.Y := aValue.Y;
  Self.Z := aValue.Z;
  Self.W := aW;
end;

function TNativeBZVector4b.ToString: String;
begin
  Result := '(X: '+IntToStr(Self.X)+
           ' ,Y: '+IntToStr(Self.Y)+
           ' ,Z: '+IntToStr(Self.Z)+
           ' ,W: '+IntToStr(Self.W)+')';
end;

class operator TNativeBZVector4b.+(constref A, B : TNativeBZVector4b): TNativeBZVector4b;
begin
  Result.X := ClampByte((A.X + B.X));
  Result.Y := ClampByte((A.Y + B.Y));
  Result.Z := ClampByte((A.Z + B.Z));
  Result.W := ClampByte((A.W + B.W));
end;

class operator TNativeBZVector4b.-(constref A, B : TNativeBZVector4b): TNativeBZVector4b;
begin
  Result.X := ClampByte((A.X - B.X));
  Result.Y := ClampByte((A.Y - B.Y));
  Result.Z := ClampByte((A.Z - B.Z));
  Result.W := ClampByte((A.W - B.W));
end;

class operator TNativeBZVector4b.*(constref A, B : TNativeBZVector4b): TNativeBZVector4b;
begin
  Result.X := ClampByte((A.X * B.X));
  Result.Y := ClampByte((A.Y * B.Y));
  Result.Z := ClampByte((A.Z * B.Z));
  Result.W := ClampByte((A.W * B.W));
end;

class operator TNativeBZVector4b.div(constref A, B : TNativeBZVector4b): TNativeBZVector4b;
begin
  Result.X := ClampByte((A.X div B.X));
  Result.Y := ClampByte((A.Y div B.Y));
  Result.Z := ClampByte((A.Z div B.Z));
  Result.W := ClampByte((A.W div B.W));
end;

class operator TNativeBZVector4b.+(constref A: TNativeBZVector4b; constref B: Byte ): TNativeBZVector4b;
begin
  Result.X := ClampByte((A.X + B));
  Result.Y := ClampByte((A.Y + B));
  Result.Z := ClampByte((A.Z + B));
  Result.W := ClampByte((A.W + B));
end;

class operator TNativeBZVector4b.-(constref A: TNativeBZVector4b; constref B: Byte ): TNativeBZVector4b;
begin
  Result.X := ClampByte((A.X - B));
  Result.Y := ClampByte((A.Y - B));
  Result.Z := ClampByte((A.Z - B));
  Result.W := ClampByte((A.W - B));
end;

class operator TNativeBZVector4b.*(constref A: TNativeBZVector4b; constref B: Byte ): TNativeBZVector4b;
begin
  Result.X := ClampByte((A.X * B));
  Result.Y := ClampByte((A.Y * B));
  Result.Z := ClampByte((A.Z * B));
  Result.W := ClampByte((A.W * B));
end;

class operator TNativeBZVector4b.*(constref A: TNativeBZVector4b; constref B: Single): TNativeBZVector4b;
begin
  Result.X := ClampByte(Round((A.X * B)));
  Result.Y := ClampByte(Round((A.Y * B)));
  Result.Z := ClampByte(Round((A.Z * B)));
  Result.W := ClampByte(Round((A.W * B)));
end;

class operator TNativeBZVector4b.div(constref A: TNativeBZVector4b; constref B: Byte ): TNativeBZVector4b;
begin
  Result := A;
  if B<>0 then Result.X := ClampByte(A.X div B);
  if B<>0 then Result.Y := ClampByte(A.Y div B);
  if B<>0 then Result.Z := ClampByte(A.Z div B);
  if B<>0 then Result.W := ClampByte(A.W div B);
end;

class operator TNativeBZVector4b.=(constref A, B: TNativeBZVector4b): Boolean;
begin
  Result := (A.W = B.W) and (A.X = B.X) and (A.Y = B.Y) and (A.Z = B.Z);
end;

class operator TNativeBZVector4b.<>(constref A, B: TNativeBZVector4b): Boolean;
begin
  Result := (A.W <> B.W) or (A.X <> B.X) or (A.Y <> B.Y) or (A.Z <> B.Z);
end;

class operator TNativeBZVector4b.and(constref A, B : TNativeBZVector4b) : TNativeBZVector4b;
begin
  Result.X := A.X and B.X;
  Result.Y := A.Y and B.Y;
  Result.Z := A.Z and B.Z;
  Result.W := A.W and B.W;
end;

class operator TNativeBZVector4b.Or(constref A, B : TNativeBZVector4b) : TNativeBZVector4b;
begin
  Result.X := A.X or B.X;
  Result.Y := A.Y or B.Y;
  Result.Z := A.Z or B.Z;
  Result.W := A.W or B.W;
end;

class operator TNativeBZVector4b.Xor(constref A, B : TNativeBZVector4b) : TNativeBZVector4b;
begin
  Result.X := A.X xor B.X;
  Result.Y := A.Y xor B.Y;
  Result.Z := A.Z xor B.Z;
  Result.W := A.W xor B.W;
end;

class operator TNativeBZVector4b.and(constref A : TNativeBZVector4b; constref B : Byte) : TNativeBZVector4b;
begin
  Result.X := A.X and B;
  Result.Y := A.Y and B;
  Result.Z := A.Z and B;
  Result.W := A.W and B;
end;

class operator TNativeBZVector4b.or(constref A : TNativeBZVector4b; constref B : Byte) : TNativeBZVector4b;
begin
  Result.X := A.X or B;
  Result.Y := A.Y or B;
  Result.Z := A.Z or B;
  Result.W := A.W or B;
end;

class operator TNativeBZVector4b.Xor(constref A : TNativeBZVector4b; constref B : Byte) : TNativeBZVector4b;
begin
  Result.X := A.X xor B;
  Result.Y := A.Y xor B;
  Result.Z := A.Z xor B;
  Result.W := A.W xor B;
end;

function TNativeBZVector4b.DivideBy2 : TNativeBZVector4b;
begin
  Result.x := Round(Self.X*0.5);
  Result.y := Round(Self.Y*0.5);
  Result.z := Round(Self.Z*0.5);
  Result.w := Round(Self.W*0.5);
end;

function TNativeBZVector4b.Min(Constref B : TNativeBZVector4b) : TNativeBZVector4b;
begin
  Result := Self;
  if Self.X>B.X then Result.X := B.X;
  if Self.Y>B.Y then Result.Y := B.Y;
  if Self.Z>B.Z then Result.Z := B.Z;
  if Self.W>B.W then Result.W := B.W;
end;

function TNativeBZVector4b.Min(Constref B : Byte) : TNativeBZVector4b;
begin
  Result := Self;
  if Self.X>B then Result.X := B;
  if Self.Y>B then Result.Y := B;
  if Self.Z>B then Result.Z := B;
  if Self.W>B then Result.W := B;
End;

function TNativeBZVector4b.Max(Constref B : TNativeBZVector4b) : TNativeBZVector4b;
begin
  Result := Self;
  if Self.X<B.X then Result.X := B.X;
  if Self.Y<B.Y then Result.Y := B.Y;
  if Self.Z<B.Z then Result.Z := B.Z;
  if Self.W<B.W then Result.W := B.W;
end;

function TNativeBZVector4b.Max(Constref B : Byte) : TNativeBZVector4b;
begin
  Result := Self;
  if Self.X<B then Result.X := B;
  if Self.Y<B then Result.Y := B;
  if Self.Z<B then Result.Z := B;
  if Self.W<B then Result.W := B;
end;

function TNativeBZVector4b.Clamp(Constref AMin, AMax : TNativeBZVector4b) : TNativeBZVector4b;
begin
  Result := Self.Max(AMin);
  Result := Result.Min(AMax);
end;

function TNativeBZVector4b.Clamp(Constref AMin, AMax : Byte) : TNativeBZVector4b;
begin
  Result := Self.Max(AMin);
  Result := Result.Min(AMax);
end;

function TNativeBZVector4b.MulAdd(Constref B, C : TNativeBZVector4b) : TNativeBZVector4b;
begin
  result := (self*B)+C;
end;

function TNativeBZVector4b.MulDiv(Constref B, C : TNativeBZVector4b) : TNativeBZVector4b;
var tmp: integer;
begin
  tmp := self.x * B.X;
  result.x := ClampByte(tmp div C.X);
  tmp := self.y * B.Y;
  result.y := ClampByte(tmp div C.Y);
  tmp := self.z * B.Z;
  result.z := ClampByte(tmp div C.Z);
  tmp := self.w * B.W;
  result.w := ClampByte(tmp div C.W);
end;

function TNativeBZVector4b.Shuffle(const x,y,z,w : Byte):TNativeBZVector4b;
begin
  Result.X := Self.V[x];
  Result.Y := Self.V[y];
  Result.Z := Self.V[z];
  Result.W := Self.V[w];
End;

function TNativeBZVector4b.Swizzle(const ASwizzle: TBZVector4SwizzleRef ): TNativeBZVector4b;
begin
   //FSwizzleMode :=  ASwizzle;
   case ASwizzle of
     swXXXX, swRRRR :
     begin
       Result.X := Self.X;
       Result.Y := Self.X;
       Result.Z := Self.X;
       Result.W := Self.X;
     end;
     swYYYY, swGGGG :
     begin
       Result.X := Self.Y;
       Result.Y := Self.Y;
       Result.Z := Self.Y;
       Result.W := Self.Y;
     end;
     swZZZZ, swBBBB :
     begin
       Result.X := Self.Z;
       Result.Y := Self.Z;
       Result.Z := Self.Z;
       Result.W := Self.Z;
     end;
     swWWWW, swAAAA :
     begin
       Result.X := Self.W;
       Result.Y := Self.W;
       Result.Z := Self.W;
       Result.W := Self.W;
     end;
     swZYXW, swBGRA :
     begin
       Result.X := Self.Z;
       Result.Y := Self.Y;
       Result.Z := Self.X;
       Result.W := Self.W;
     end;
     swXZYW, swRBGA :
     begin
       Result.X := Self.X;
       Result.Y := Self.Z;
       Result.Z := Self.Y;
       Result.W := Self.W;
     end;
     swZXYW, swBRGA :
     begin
       Result.X := Self.Z;
       Result.Y := Self.X;
       Result.Z := Self.Y;
       Result.W := Self.W;
     end;
     swYXZW, swGRBA :
     begin
       Result.X := Self.Y;
       Result.Y := Self.X;
       Result.Z := Self.Z;
       Result.W := Self.W;
     end;
     swYZXW, swGBRA :
     begin
       Result.X := Self.Y;
       Result.Y := Self.Z;
       Result.Z := Self.X;
       Result.W := Self.W;
     end;
     swWXYZ, swARGB :
     begin
       Result.X := Self.W;
       Result.Y := Self.X;
       Result.Z := Self.Y;
       Result.W := Self.Z;
     end;
     swWZYX, swABGR :
     begin
       Result.X := Self.W;
       Result.Y := Self.Z;
       Result.Z := Self.Y;
       Result.W := Self.X;
     end;
     swWXZY, swARBG :
     begin
       Result.X := Self.W;
       Result.Y := Self.X;
       Result.Z := Self.Z;
       Result.W := Self.Y;
     end;
     swWZXY, swABRG :
     begin
       Result.X := Self.W;
       Result.Y := Self.Z;
       Result.Z := Self.X;
       Result.W := Self.Y;
     end;
     swWYXZ, swAGRB :
     begin
       Result.X := Self.W;
       Result.Y := Self.Y;
       Result.Z := Self.X;
       Result.W := Self.Z;
     end;
     swWYZX, swAGBR :
     begin
       Result.X := Self.W;
       Result.Y := Self.Y;
       Result.Z := Self.Z;
       Result.W := Self.X;
     end;

     else result := self; //swXYZW, swRGBA
   end;
end;

function TNativeBZVector4b.Combine(constref V2: TNativeBZVector4b; constref F1: Single): TNativeBZVector4b;
Var
  v3 : TNativeBZVector4b;
begin
  v3 := v2 * F1;
  result := Self + v3;
  result.W := Self.W;
End;

function TNativeBZVector4b.Combine2(constref V2: TNativeBZVector4b; const F1, F2: Single): TNativeBZVector4b;
begin
  result.X := ClampByte(Round(Self.X * F1 + V2.X * F2));
  result.Y := ClampByte(Round(Self.Y * F1 + V2.Y * F2));
  result.Z := ClampByte(Round(Self.Z * F1 + V2.Z * F2));
  result.W := Self.W;
end;

function TNativeBZVector4b.Combine3(constref V2, V3: TNativeBZVector4b; const F1, F2, F3: Single): TNativeBZVector4b;
begin
  result.X := ClampByte(Round(Self.X * F1 + V2.X * F2 + V3.X * F3));
  result.Y := ClampByte(Round(Self.Y * F1 + V2.Y * F2 + V3.Y * F3));
  result.Z := ClampByte(Round(Self.Z * F1 + V2.Z * F2 + V3.Z * F3));
  result.W := Self.W;
end;

function TNativeBZVector4b.MinXYZComponent : Byte;
begin
  Result:=BZMath.Min(Self.X, Self.Y, Self.Z);
end;

function TNativeBZVector4b.MaxXYZComponent : Byte;
begin
  Result:=BZMath.Max(Self.X, Self.Y, Self.Z);
end;
{%endregion%}

{%region%-----[ TNativeBZVector4i ]--------------------------------------------}

procedure TNativeBZVector4i.Create(const aX, aY, aZ : Longint; const aW : Longint);
begin
  Self.X := aX;
  Self.Y := aY;
  Self.Z := aZ;
  Self.W := aW;
end;

procedure TNativeBZVector4i.Create(const aValue : TNativeBZVector3i; const aW : Longint);
begin
  Self.X := aValue.X;
  Self.Y := aValue.Y;
  Self.Z := aValue.Z;
  Self.W := aW;
end;

procedure TNativeBZVector4i.Create(const aValue : TNativeBZVector3b; const aW : Longint);
begin
  Self.X := aValue.X;
  Self.Y := aValue.Y;
  Self.Z := aValue.Z;
  Self.W := aW;
end;

function TNativeBZVector4i.ToString : String;
begin
  Result := '(X: '+IntToStr(Self.X)+
           ' ,Y: '+IntToStr(Self.Y)+
           ' ,Z: '+IntToStr(Self.Z)+
           ' ,W: '+IntToStr(Self.W)+')';
end;


function TNativeBZVector4i.Shuffle(const x, y, z, w : Byte) : TNativeBZVector4i;
begin
  Result.X:=Self.V[x];
  Result.Y:=Self.V[y];
  Result.Z:=Self.V[z];
  Result.W:=Self.V[w];
end;

function TNativeBZVector4i.Swizzle(const ASwizzle : TBZVector4SwizzleRef) : TNativeBZVector4i;
begin
  //FSwizzleMode :=  ASwizzle;
  case ASwizzle of
    //swXYXY movlhps
    //swZWZW movhlps
    //swXXYY unpacklo
    //swZZWW unpackhi
    //swXXZZ movldup
    //swYYWW movhdup
    swXXXX, swRRRR :  // Shufps ,00000000b
    begin
      Result.X := Self.X;
      Result.Y := Self.X;
      Result.Z := Self.X;
      Result.W := Self.X;
    end;
    swYYYY, swGGGG :  // Shufps ,01010101b
    begin
      Result.X := Self.Y;
      Result.Y := Self.Y;
      Result.Z := Self.Y;
      Result.W := Self.Y;
    end;
    swZZZZ, swBBBB : // Shufps ,10101010b
    begin
      Result.X := Self.Z;
      Result.Y := Self.Z;
      Result.Z := Self.Z;
      Result.W := Self.Z;
    end;
    swWWWW, swAAAA :  // Shufps ,11111111b
    begin
      Result.X := Self.W;
      Result.Y := Self.W;
      Result.Z := Self.W;
      Result.W := Self.W;
    end;
    swZYXW, swBGRA : // Shufps ,11000110b ==>  ARGB
    begin
      Result.X := Self.Z;
      Result.Y := Self.Y;
      Result.Z := Self.X;
      Result.W := Self.W;
    end;
    swXZYW, swRBGA :  // Shufps ,11011000b
    begin
      Result.X := Self.X;
      Result.Y := Self.Z;
      Result.Z := Self.Y;
      Result.W := Self.W;
    end;
    swZXYW, swBRGA :
    begin
      Result.X := Self.Z;
      Result.Y := Self.X;
      Result.Z := Self.Y;
      Result.W := Self.W;
    end;
    swYXZW, swGRBA :
    begin
      Result.X := Self.Y;
      Result.Y := Self.X;
      Result.Z := Self.Z;
      Result.W := Self.W;
    end;
    swYZXW, swGBRA :
    begin
      Result.X := Self.Y;
      Result.Y := Self.Z;
      Result.Z := Self.X;
      Result.W := Self.W;
    end;
    swWXYZ, swARGB :
    begin
      Result.X := Self.W;
      Result.Y := Self.X;
      Result.Z := Self.Y;
      Result.W := Self.Z;
    end;
    swWZYX, swABGR :
    begin
      Result.X := Self.W;
      Result.Y := Self.Z;
      Result.Z := Self.Y;
      Result.W := Self.X;
    end;
    swWXZY, swARBG :
    begin
      Result.X := Self.W;
      Result.Y := Self.X;
      Result.Z := Self.Z;
      Result.W := Self.Y;
    end;
    swWZXY, swABRG :
    begin
      Result.X := Self.W;
      Result.Y := Self.Z;
      Result.Z := Self.X;
      Result.W := Self.Y;
    end;
    swWYXZ, swAGRB :
    begin
      Result.X := Self.W;
      Result.Y := Self.Y;
      Result.Z := Self.X;
      Result.W := Self.Z;
    end;
    swWYZX, swAGBR :
    begin
      Result.X := Self.W;
      Result.Y := Self.Y;
      Result.Z := Self.Z;
      Result.W := Self.X;
    end;

    else result := self; //swXYZW, swRGBA
  end;
end;

function TNativeBZVector4i.Combine(constref V2 : TNativeBZVector4i; constref F1 : Single) : TNativeBZVector4i;
Var
  v3 : TNativeBZVector4i;
begin
  v3 := v2 * F1;
  result := Self + v3;
  result.W := Self.W;
end;

function TNativeBZVector4i.Combine2(constref V2 : TNativeBZVector4i; const F1, F2 : Single) : TNativeBZVector4i;
begin
  result.X := Round(Self.X * F1 + V2.X * F2);
  result.Y := Round(Self.Y * F1 + V2.Y * F2);
  result.Z := Round(Self.Z * F1 + V2.Z * F2);
  result.W := Self.W;
end;

function TNativeBZVector4i.Combine3(constref V2, V3 : TNativeBZVector4i; const F1, F2, F3 : Single) : TNativeBZVector4i;
begin
  result.X := Round(Self.X * F1 + V2.X * F2 + V3.X * F3);
  result.Y := Round(Self.Y * F1 + V2.Y * F2 + V3.Y * F3);
  result.Z := Round(Self.Z * F1 + V2.Z * F2 + V3.Z * F3);
  result.W := Self.W;
end;

function TNativeBZVector4i.MinXYZComponent : LongInt;
begin
  Result:=BZMath.Min(Self.X, Self.Y, Self.Z);
end;

function TNativeBZVector4i.MaxXYZComponent : LongInt;
begin
  Result:=BZMath.Max(Self.X, Self.Y, Self.Z);
end;

{%region%----[ Operators ]------------------------------------------------------}

class operator TNativeBZVector4i.+ (constref A, B : TNativeBZVector4i) : TNativeBZVector4i;
begin
  Result.X := A.X + B.X;
  Result.Y := A.Y + B.Y;
  Result.Z := A.Z + B.Z;
  Result.W := A.W + B.W;
end;

class operator TNativeBZVector4i.- (constref A, B : TNativeBZVector4i) : TNativeBZVector4i;
begin
  Result.X := A.X - B.X;
  Result.Y := A.Y - B.Y;
  Result.Z := A.Z - B.Z;
  Result.W := A.W - B.W;
end;

class operator TNativeBZVector4i.*(constref A, B : TNativeBZVector4i) : TNativeBZVector4i;
begin
  Result.X := A.X * B.X;
  Result.Y := A.Y * B.Y;
  Result.Z := A.Z * B.Z;
  Result.W := A.W * B.W;
end;

class operator TNativeBZVector4i.div(constref A, B : TNativeBZVector4i) : TNativeBZVector4i;
begin
  Result.X := A.X div B.X;
  Result.Y := A.Y div B.Y;
  Result.Z := A.Z div B.Z;
  Result.W := A.W div B.W;
end;

class operator TNativeBZVector4i. + (constref A : TNativeBZVector4i; constref B : Longint) : TNativeBZVector4i;
begin
  Result.X := A.X + B;
  Result.Y := A.Y + B;
  Result.Z := A.Z + B;
  Result.W := A.W + B;
end;

class operator TNativeBZVector4i. - (constref A : TNativeBZVector4i; constref B : Longint) : TNativeBZVector4i;
begin
  Result.X := A.X - B;
  Result.Y := A.Y - B;
  Result.Z := A.Z - B;
  Result.W := A.W - B;
end;

class operator TNativeBZVector4i. * (constref A : TNativeBZVector4i; constref B : Longint) : TNativeBZVector4i;
begin
  Result.X := A.X * B;
  Result.Y := A.Y * B;
  Result.Z := A.Z * B;
  Result.W := A.W * B;
end;

class operator TNativeBZVector4i. * (constref A : TNativeBZVector4i; constref B : Single) : TNativeBZVector4i;
begin
  Result.X := Round(A.X * B);
  Result.Y := Round(A.Y * B);
  Result.Z := Round(A.Z * B);
  Result.W := Round(A.W * B);
end;

class operator TNativeBZVector4i.div(constref A : TNativeBZVector4i; constref B : Longint) : TNativeBZVector4i;
begin
  Result.X := A.X div B;
  Result.Y := A.Y div B;
  Result.Z := A.Z div B;
  Result.W := A.W div B;
end;

class operator TNativeBZVector4i. = (constref A, B : TNativeBZVector4i) : Boolean;
begin
  Result := (A.X = B.X) and (A.Y = B.Y) and (A.Z = B.Z) and (A.W = B.W);
end;

class operator TNativeBZVector4i. <> (constref A, B : TNativeBZVector4i) : Boolean;
begin
    Result := (A.X <> B.X) or (A.Y <> B.Y) or (A.Z <> B.Z) or (A.W <> B.W);
end;

class operator TNativeBZVector4i.-(constref A : TNativeBZVector4i) : TNativeBZVector4i;
begin
  Result.X := -A.X;
  Result.Y := -A.Y;
  Result.Z := -A.Z;
  Result.W := -A.W;
end;

(* class operator TNativeBZVector4i.and(constref A, B : TNativeBZVector4i) : TNativeBZVector4i;
begin
  Result.X := ClampByte((A.X and B.X));
  Result.Y := ClampByte((A.Y and B.Y));
  Result.Z := ClampByte((A.Z and B.Z));
  Result.W := ClampByte((A.W and B.W));
end;

class operator TNativeBZVector4i.Or(constref A, B : TNativeBZVector4i) : TNativeBZVector4i;
begin
  Result.X := ClampByte((A.X or B.X));
  Result.Y := ClampByte((A.Y or B.Y));
  Result.Z := ClampByte((A.Z or B.Z));
  Result.W := ClampByte((A.W or B.W));
end;

class operator TNativeBZVector4i.Xor(constref A, B : TNativeBZVector4i) : TNativeBZVector4i;
begin
  Result.X := ClampByte((A.X xor B.X));
  Result.Y := ClampByte((A.Y xor B.Y));
  Result.Z := ClampByte((A.Z xor B.Z));
  Result.W := ClampByte((A.W xor B.W));
end;

class operator TNativeBZVector4i.and(constref A : TNativeBZVector4i; constref B : LongInt) : TNativeBZVector4i;
begin
  Result.X := ClampByte((A.X and B));
  Result.Y := ClampByte((A.Y and B));
  Result.Z := ClampByte((A.Z and B));
  Result.W := ClampByte((A.W and B));
end;

class operator TNativeBZVector4i.or(constref A : TNativeBZVector4i; constref B : LongInt) : TNativeBZVector4i;
begin
  Result.X := ClampByte((A.X or B));
  Result.Y := ClampByte((A.Y or B));
  Result.Z := ClampByte((A.Z or B));
  Result.W := ClampByte((A.W or B));
end;

class operator TNativeBZVector4i.Xor(constref A : TNativeBZVector4i; constref B : LongInt) : TNativeBZVector4i;
begin
  Result.X := ClampByte((A.X xor B));
  Result.Y := ClampByte((A.Y xor B));
  Result.Z := ClampByte((A.Z xor B));
  Result.W := ClampByte((A.W xor B));
end;       *)

{%endregion%}

{%region%----[ Functions ]------------------------------------------------------}

function TNativeBZVector4i.DivideBy2 : TNativeBZVector4i;
begin
  Result.X := (Self.X shr 1);
  Result.Y := (Self.Y shr 1);
  Result.Z := (Self.Z shr 1);
  Result.W := (Self.W shr 1);
end;

function TNativeBZVector4i.abs : TNativeBZVector4i;
begin
  Result.X := system.Abs(Self.X);
  Result.Y := system.Abs(Self.Y);
  Result.Z := system.Abs(Self.Z);
  Result.W := system.Abs(Self.W);
end;

function TNativeBZVector4i.Min(Constref B : TNativeBZVector4i) : TNativeBZVector4i;
begin
  Result := Self;
  if Self.X>B.X then Result.X := B.X;
  if Self.Y>B.Y then Result.Y := B.Y;
  if Self.Z>B.Z then Result.Z := B.Z;
  if Self.W>B.W then Result.W := B.W;
end;

function TNativeBZVector4i.Min(Constref B : LongInt) : TNativeBZVector4i;
begin
  Result := Self;
  if Self.X>B then Result.X := B;
  if Self.Y>B then Result.Y := B;
  if Self.Z>B then Result.Z := B;
  if Self.W>B then Result.W := B;
end;

function TNativeBZVector4i.Max(Constref B : TNativeBZVector4i) : TNativeBZVector4i;
begin
  Result := Self;
  if Self.X<B.X then Result.X := B.X;
  if Self.Y<B.Y then Result.Y := B.Y;
  if Self.Z<B.Z then Result.Z := B.Z;
  if Self.W<B.W then Result.W := B.W;
end;

function TNativeBZVector4i.Max(Constref B : LongInt) : TNativeBZVector4i;
begin
  Result := Self;
  if Self.X<B then Result.X := B;
  if Self.Y<B then Result.Y := B;
  if Self.Z<B then Result.Z := B;
  if Self.W<B then Result.W := B;
end;

function TNativeBZVector4i.Clamp(Constref AMin, AMax : TNativeBZVector4i) : TNativeBZVector4i;
begin
  Result := Self.Max(AMin);
  Result := Result.Min(AMax);
end;

function TNativeBZVector4i.Clamp(Constref AMin, AMax : LongInt) : TNativeBZVector4i;
begin
  Result := Self.Max(AMin);
  Result := Result.Min(AMax);
end;

function TNativeBZVector4i.MulAdd(Constref B, C : TNativeBZVector4i) : TNativeBZVector4i;
begin
  result := (self*B)+C;
end;

function TNativeBZVector4i.MulDiv(Constref B, C : TNativeBZVector4i) : TNativeBZVector4i;
begin
  result := (self*B) div C;
end;

{%endregion%}

{%endregion%}

{%region%-----[ TNativeBZVector4f ]--------------------------------------------}

{%region%----[ TNativeBZVector4f Operators ]-----------------------------------}
procedure TNativeBZVector4f.Create(const aX, aY, aZ: Single; const aW: Single);
begin
   Self.X := AX;
   Self.Y := AY;
   Self.Z := AZ;
   Self.W := AW;
end;

procedure TNativeBZVector4f.CreateAffine(const AValue: Single);
begin
  Self.X := AValue;
  Self.Y := AValue;
  Self.Z := AValue;
  Self.W := 1.0;
end;

procedure TNativeBZVector4f.CreateAffine(Const aX,aY,aZ: Single);
begin
  Self.X := aX;
  Self.Y := aY;
  Self.Z := aZ;
  Self.W := 1.0;
end;

procedure TNativeBZVector4f.Create(const anAffineVector: TNativeBZVector3f; const aW: Single);
begin
   Self.X := anAffineVector.X;
   Self.Y := anAffineVector.Y;
   Self.Z := anAffineVector.Z;
   Self.W := AW;
end;

function TNativeBZVector4f.ToString : String;
begin
   Result := '(X: '+FloattoStrF(Self.X,fffixed,5,5)+
            ' ,Y: '+FloattoStrF(Self.Y,fffixed,5,5)+
            ' ,Z: '+FloattoStrF(Self.Z,fffixed,5,5)+
            ' ,W: '+FloattoStrF(Self.W,fffixed,5,5)+')';
End;


function TNativeBZVector4f.Shuffle(const x,y,z,w : Byte):TNativeBZVector4f;
begin
  Result.X:=Self.V[x];
  Result.Y:=Self.V[y];
  Result.Z:=Self.V[z];
  Result.W:=Self.V[w];
End;

function TNativeBZVector4f.MinXYZComponent : Single;
begin
   Result:=BZMath.Min(Self.X, Self.Y, Self.Z);
end;

function TNativeBZVector4f.MaxXYZComponent : Single;
begin
   Result:=BZMath.Max(Self.X, Self.Y, Self.Z);
end;

class operator TNativeBZVector4f.+(constref A, B: TNativeBZVector4f): TNativeBZVector4f;
begin
  Result.X := A.X + B.X;
  Result.Y := A.Y + B.Y;
  Result.Z := A.Z + B.Z;
  Result.W := A.W + B.W;
end;

class operator TNativeBZVector4f.-(constref A, B: TNativeBZVector4f): TNativeBZVector4f;
begin
  Result.X := A.X - B.X;
  Result.Y := A.Y - B.Y;
  Result.Z := A.Z - B.Z;
  Result.W := A.W - B.W;
end;

class operator TNativeBZVector4f.*(constref A, B: TNativeBZVector4f): TNativeBZVector4f;
begin
  Result.X := A.X * B.X;
  Result.Y := A.Y * B.Y;
  Result.Z := A.Z * B.Z;
  Result.W := A.W * B.W;
end;

class operator TNativeBZVector4f./(constref A, B: TNativeBZVector4f): TNativeBZVector4f;
begin
  Result.X := A.X / B.X;
  Result.Y := A.Y / B.Y;
  Result.Z := A.Z / B.Z;
  Result.W := A.W / B.W;
end;

class operator TNativeBZVector4f.+(constref A: TNativeBZVector4f; constref B:Single): TNativeBZVector4f;
begin
  Result.X := A.X + B;
  Result.Y := A.Y + B;
  Result.Z := A.Z + B;
  Result.W := A.W + B;
end;

class operator TNativeBZVector4f.-(constref A: TNativeBZVector4f; constref B:Single): TNativeBZVector4f;
begin
  Result.X := A.X - B;
  Result.Y := A.Y - B;
  Result.Z := A.Z - B;
  Result.W := A.W - B;
end;

class operator TNativeBZVector4f.*(constref A: TNativeBZVector4f; constref B:Single): TNativeBZVector4f;
begin
  Result.X := A.X * B;
  Result.Y := A.Y * B;
  Result.Z := A.Z * B;
  Result.W := A.W * B;
end;

class operator TNativeBZVector4f./(constref A: TNativeBZVector4f; constref B:Single): TNativeBZVector4f;
begin
  Result.X := A.X / B;
  Result.Y := A.Y / B;
  Result.Z := A.Z / B;
  Result.W := A.W / B;
end;

class operator TNativeBZVector4f.-(constref A : TNativeBZVector4f): TNativeBZVector4f;
begin
  Result.X := -A.X;
  Result.Y := -A.Y;
  Result.Z := -A.Z;
  Result.W := -A.W;
end;

class operator TNativeBZVector4f.=(constref A, B: TNativeBZVector4f): Boolean;
begin
  Result := (A.X = B.X) and (A.Y = B.Y) and (A.Z = B.Z) and (A.W = B.W);
end;

class operator TNativeBZVector4f.>=(constref A, B: TNativeBZVector4f): Boolean;
begin
  Result := (A.X >= B.X) and (A.Y >= B.Y) and (A.Z >= B.Z) and (A.W >= B.W);
end;

class operator TNativeBZVector4f.<=(constref A, B: TNativeBZVector4f): Boolean;
begin
  Result := (A.X <= B.X) and (A.Y <= B.Y) and (A.Z <= B.Z) and (A.W <= B.W);
end;

class operator TNativeBZVector4f.>(constref A, B: TNativeBZVector4f): Boolean;
begin
  Result := (A.X > B.X) and (A.Y > B.Y) and (A.Z > B.Z) and (A.W > B.W);
end;

class operator TNativeBZVector4f.<(constref A, B: TNativeBZVector4f): Boolean;
begin
  Result := (A.X < B.X) and (A.Y < B.Y) and (A.Z < B.Z) and (A.W < B.W);
end;

class operator TNativeBZVector4f.<>(constref A, B: TNativeBZVector4f): Boolean;
begin
  Result := (A.X <> B.X) or (A.Y <> B.Y) or (A.Z <> B.Z) or (A.W <> B.W);
end;
{%endregion%}

{%region%----[ TNativeBZVector4f Functions ]-----------------------------------}

function TNativeBZVector4f.Abs:TNativeBZVector4f;
begin
  result.X:=System.Abs(Self.X);
  result.Y:=System.Abs(Self.Y);
  result.Z:=System.Abs(Self.Z);
  result.W:=System.Abs(Self.W);
End;

function TNativeBZVector4f.Negate:TNativeBZVector4f;
begin
  Result:=Self;
  Result.X := -Result.X;
  Result.Y := -Result.Y;
  Result.Z := -Result.Z;
  Result.W := -Result.W;
end;

function TNativeBZVector4f.DivideBy2 : TNativeBZVector4f;
begin
  Result.x := Self.X*0.5;
  Result.y := Self.Y*0.5;
  Result.z := Self.Z*0.5;
  Result.w := Self.W*0.5;
end;

function TNativeBZVector4f.Distance(constref A: TNativeBZVector4f):Single;
begin
  result := sqrt(sqr(Self.X-A.X)+ sqr(Self.Y-A.Y) + sqr(Self.Z-A.Z));
end;

function TNativeBZVector4f.DistanceSquare(constref A: TNativeBZVector4f):Single;
begin
  result := sqr(Self.X-A.X)+ sqr(Self.Y-A.Y) + sqr(Self.Z-A.Z);
end;

function TNativeBZVector4f.Length : Single;
//var
//X1 : Single;
begin
  Result := Sqrt((Self.X * Self.X) +(Self.Y * Self.Y) +(Self.Z * Self.Z));
  { Ensure result is non-zero to avoid divide-by-zero errors }
  //if X1 = 0 then X1 := 0.0000000001;
  //Result := X1;
end;

function TNativeBZVector4f.LengthSquare : Single;
begin
  Result := (Self.X * Self.X) +(Self.Y * Self.Y) +(Self.Z * Self.Z);
end;

function TNativeBZVector4f.Spacing(constref A : TNativeBZVector4f) : Single;
//var vr : TNativeBZVector4f;
begin
//  vr := A -Self;
//  vr.pAbs;
//  result :=vr.x+vr.y+vr.z+vr.W;
  Result:=System.Abs(A.X-Self.X)+System.Abs(A.Y-Self.Y)+System.Abs(A.Z-Self.Z)+System.Abs(A.W-Self.W);
end;

function TNativeBZVector4f.DotProduct(constref A: TNativeBZVector4f) : Single;
var
 V2:TNativeBZVector4f;
begin
  V2.X := Self.X*A.X;
  V2.Y := Self.Y*A.Y;
  V2.Z := Self.Z*A.Z;
  //V2.W := Self.W*A.W;
  Result := V2.X + V2.Y + V2.Z;// + V2.W;
end;

function TNativeBZVector4f.CrossProduct(constref A: TNativeBZVector4f
  ): TNativeBZVector4f;
begin
  result.X:=Self.Y*A.Z-Self.Z*A.Y;
  result.Y:=Self.Z*A.X-Self.X*A.Z;
  result.Z:=Self.X*A.Y-Self.Y*A.X;
  result.W:=0;
end;

function TNativeBZVector4f.Norm : Single;
var v2:TNativeBZVector4f;
begin
  v2.x := Self.X*Self.X;
  v2.y := Self.Y*Self.Y;
  v2.z := Self.Z*Self.Z;
  v2.w := Self.W*Self.W;
  Result := v2.X + v2.Y + v2.Z; //+ v2.w;
end;

function TNativeBZVector4f.Normalize : TNativeBZVector4f;
var
  invLen : Single;
  vn : Single;
begin
  vn:=Self.Norm;
  if vn=0 then
  begin
    result := Self;
//    result.W := 0; //cZero;
  end
  else
  begin
    invLen:=1/Sqrt(vn);
    result.X:=Self.X*invLen;
    result.Y:=Self.Y*invLen;
    result.Z:=Self.Z*invLen;
    result.W:=Self.W;
  end;
end;

function TNativeBZVector4f.Min(constref B: Single): TNativeBZVector4f;
begin
  Result := Self;
  if Self.X>B then Result.X := B;
  if Self.Y>B then Result.Y := B;
  if Self.Z>B then Result.Z := B;
  if Self.W>B then Result.W := B;
End;

function TNativeBZVector4f.Min(constref B: TNativeBZVector4f): TNativeBZVector4f;
begin
  Result := Self;
  if Self.X>B.X then Result.X := B.X;
  if Self.Y>B.Y then Result.Y := B.Y;
  if Self.Z>B.Z then Result.Z := B.Z;
  if Self.W>B.W then Result.W := B.W;
End;

function TNativeBZVector4f.Max(constref B: TNativeBZVector4f): TNativeBZVector4f;
begin
  Result := Self;
  if Self.X<B.X then Result.X := B.X;
  if Self.Y<B.Y then Result.Y := B.Y;
  if Self.Z<B.Z then Result.Z := B.Z;
  if Self.W<B.W then Result.W := B.W;
End;

function TNativeBZVector4f.Max(constref B: Single): TNativeBZVector4f;
begin
  Result := Self;
  if Self.X<B then Result.X := B;
  if Self.Y<B then Result.Y := B;
  if Self.Z<B then Result.Z := B;
  if Self.W<B then Result.W := B;
End;

function TNativeBZVector4f.Clamp(Constref AMin, AMax: TNativeBZVector4f): TNativeBZVector4f;
begin
  Result := Self.Max(AMin);
  Result := Result.Min(AMax);
End;

function TNativeBZVector4f.Clamp(constref AMin, AMax: Single): TNativeBZVector4f;
begin
  Result := Self.Max(AMin);
  Result := Result.Min(AMax);
End;

function TNativeBZVector4f.MulAdd(Constref B, C: TNativeBZVector4f): TNativeBZVector4f;
begin
  result := (self*B)+C;
end;

function TNativeBZVector4f.MulDiv(Constref B, C: TNativeBZVector4f): TNativeBZVector4f;
begin
  result := (self*B)/C;
end;

function TNativeBZVector4f.Lerp(Constref B: TNativeBZVector4f; Constref T:Single): TNativeBZVector4f;
begin
   Result.X:=Self.X+(B.X-Self.X)*t;
   Result.Y:=Self.Y+(B.Y-Self.Y)*t;
   Result.Z:=Self.Z+(B.Z-Self.Z)*t;
   Result.W := Self.W;
end;

function TNativeBZVector4f.AngleCosine(constref A: TNativeBZVector4f): Single;
begin
   Result:=Self.DotProduct(A)/(Self.Length*A.Length);
end;

function TNativeBZVector4f.AngleBetween(Constref A, ACenterPoint : TNativeBZVector4f): Single;
Var
  vt1,vt2  :  TNativeBZVector4f;
begin
  vt1 := Self - ACenterPoint;
  vt2 := A - ACenterPoint;
  vt1 := vt1.Normalize;
  vt2 := vt2.Normalize;
  Result := ArcCos(vt1.AngleCosine(vt2));
end;

function TNativeBZVector4f.Combine(constref V2: TNativeBZVector4f; constref F1: Single): TNativeBZVector4f;
begin
  Result.X:=Self.X+v2.X*F1;
  Result.Y:=Self.Y+v2.Y*F1;
  Result.Z:=Self.Z+v2.Z*F1;
//  Result.W:=Self.W+v2.W*F1;
  Result.W:=0;
End;

function TNativeBZVector4f.Combine2(constref V2: TNativeBZVector4f; const F1, F2: Single): TNativeBZVector4f;
begin
   Result.X:=( Self.X*F1) + (V2.X*F2);
   Result.Y:=( Self.Y*F1) + (V2.Y*F2);
   Result.Z:=( Self.Z*F1) + (V2.Z*F2);
   Result.W:=0;
end;

function TNativeBZVector4f.Combine3(constref V2, V3: TNativeBZVector4f; const F1, F2, F3: Single): TNativeBZVector4f;
begin
  Result.X:=( Self.X*F1) + (V2.X*F2) + (V3.X*F3);
  Result.Y:=( Self.Y*F1) + (V2.Y*F2) + (V3.Y*F3);
  Result.Z:=( Self.Z*F1) + (V2.Z*F2) + (V3.Z*F3);
  Result.W:=0;
end;

function TNativeBZVector4f.Round:TNativeBZVector4i;
begin
  result.X:=System.Round(Self.X);
  result.Y:=System.Round(Self.Y);
  result.Z:=System.Round(Self.Z);
  result.W:=System.Round(Self.W);
end;

function TNativeBZVector4f.Trunc:TNativeBZVector4i;
begin
  result.X:=System.Trunc(Self.X);
  result.Y:=System.Trunc(Self.Y);
  result.Z:=System.Trunc(Self.Z);
  result.W:=System.Trunc(Self.W);
end;

function TNativeBZVector4f.Swizzle(const ASwizzle: TBZVector4SwizzleRef ): TNativeBZVector4f;
begin
   //FSwizzleMode :=  ASwizzle;
   case ASwizzle of
     //swXYXY movlhps
     //swZWZW movhlps
     //swXXYY unpacklo
     //swZZWW unpackhi
     //swXXZZ movldup
     //swYYWW movhdup
     swXXXX, swRRRR :  // Shufps ,00000000b
     begin
       Result.X := Self.X;
       Result.Y := Self.X;
       Result.Z := Self.X;
       Result.W := Self.X;
     end;
     swYYYY, swGGGG :  // Shufps ,01010101b
     begin
       Result.X := Self.Y;
       Result.Y := Self.Y;
       Result.Z := Self.Y;
       Result.W := Self.Y;
     end;
     swZZZZ, swBBBB : // Shufps ,10101010b
     begin
       Result.X := Self.Z;
       Result.Y := Self.Z;
       Result.Z := Self.Z;
       Result.W := Self.Z;
     end;
     swWWWW, swAAAA :  // Shufps ,11111111b
     begin
       Result.X := Self.W;
       Result.Y := Self.W;
       Result.Z := Self.W;
       Result.W := Self.W;
     end;
     swZYXW, swBGRA : // Shufps ,11000110b ==>  ARGB
     begin
       Result.X := Self.Z;
       Result.Y := Self.Y;
       Result.Z := Self.X;
       Result.W := Self.W;
     end;
     swXZYW, swRBGA :  // Shufps ,11011000b
     begin
       Result.X := Self.X;
       Result.Y := Self.Z;
       Result.Z := Self.Y;
       Result.W := Self.W;
     end;
     swZXYW, swBRGA :
     begin
       Result.X := Self.Z;
       Result.Y := Self.X;
       Result.Z := Self.Y;
       Result.W := Self.W;
     end;
     swYXZW, swGRBA :
     begin
       Result.X := Self.Y;
       Result.Y := Self.X;
       Result.Z := Self.Z;
       Result.W := Self.W;
     end;
     swYZXW, swGBRA :
     begin
       Result.X := Self.Y;
       Result.Y := Self.Z;
       Result.Z := Self.X;
       Result.W := Self.W;
     end;
     swWXYZ, swARGB :
     begin
       Result.X := Self.W;
       Result.Y := Self.X;
       Result.Z := Self.Y;
       Result.W := Self.Z;
     end;
     swWZYX, swABGR :
     begin
       Result.X := Self.W;
       Result.Y := Self.Z;
       Result.Z := Self.Y;
       Result.W := Self.X;
     end;
     swWXZY, swARBG :
     begin
       Result.X := Self.W;
       Result.Y := Self.X;
       Result.Z := Self.Z;
       Result.W := Self.Y;
     end;
     swWZXY, swABRG :
     begin
       Result.X := Self.W;
       Result.Y := Self.Z;
       Result.Z := Self.X;
       Result.W := Self.Y;
     end;
     swWYXZ, swAGRB :
     begin
       Result.X := Self.W;
       Result.Y := Self.Y;
       Result.Z := Self.X;
       Result.W := Self.Z;
     end;
     swWYZX, swAGBR :
     begin
       Result.X := Self.W;
       Result.Y := Self.Y;
       Result.Z := Self.Z;
       Result.W := Self.X;
     end;

     else result := self; //swXYZW, swRGBA
   end;
end;

{%endregion%}


{%endregion%}

{%region%-----[ TNativeBZMatrix4 ]---------------------------------------------}

function TNativeBZMatrix4f.GetComponent(const ARow, AColumn: Integer): Single;
begin
  Result := M[ARow, AColumn];
end;

procedure TNativeBZMatrix4f.SetComponent(const ARow, AColumn: Integer; const Value: Single);
begin
  M[ARow, AColumn] := Value;
end;

procedure TNativeBZMatrix4f.SetRow(const AIndex: Integer; const Value: TNativeBZVector4f);
begin
  V[AIndex] := Value;
end;

function TNativeBZMatrix4f.GetRow(const AIndex: Integer): TNativeBZVector4f;
begin
  Result := V[AIndex];
end;

function TNativeBZMatrix4f.ToString : String;
begin
  Result :='|'+V[0].ToString+'|'+#13+#10
          +'|'+V[1].ToString+'|'+#13+#10
          +'|'+V[2].ToString+'|'+#13+#10
          +'|'+V[3].ToString+'|'+#13+#10
End;

class operator TNativeBZMatrix4f.+(constref A, B: TNativeBZMatrix4f): TNativeBZMatrix4f;
begin
  Result.V[0] := A.V[0] + B.V[0];
  Result.V[1] := A.V[1] + B.V[1];
  Result.V[2] := A.V[2] + B.V[2];
  Result.V[3] := A.V[3] + B.V[3];
end;

class operator TNativeBZMatrix4f.+(constref A: TNativeBZMatrix4f; constref B: Single): TNativeBZMatrix4f;
begin
  Result.V[0] := A.V[0] + B;
  Result.V[1] := A.V[1] + B;
  Result.V[2] := A.V[2] + B;
  Result.V[3] := A.V[3] + B;
end;

class operator TNativeBZMatrix4f.-(constref A, B: TNativeBZMatrix4f): TNativeBZMatrix4f;
begin
  Result.V[0] := A.V[0] - B.V[0];
  Result.V[1] := A.V[1] - B.V[1];
  Result.V[2] := A.V[2] - B.V[2];
  Result.V[3] := A.V[3] - B.V[3];
end;

class operator TNativeBZMatrix4f.-(constref A: TNativeBZMatrix4f; constref B: Single): TNativeBZMatrix4f;
begin
  Result.V[0] := A.V[0] - B;
  Result.V[1] := A.V[1] - B;
  Result.V[2] := A.V[2] - B;
  Result.V[3] := A.V[3] - B;
end;

class operator TNativeBZMatrix4f.-(constref A: TNativeBZMatrix4f): TNativeBZMatrix4f;
begin
  Result.V[0] := -A.V[0];
  Result.V[1] := -A.V[1];
  Result.V[2] := -A.V[2];
  Result.V[3] := -A.V[3];
end;

class operator TNativeBZMatrix4f.*(constref A: TNativeBZMatrix4f; constref B: TNativeBZVector4f): TNativeBZVector4f;
begin
  Result.X := (B.X * A.M[0,0]) + (B.Y * A.M[0,1]) + (B.Z * A.M[0,2]) + (B.W * A.M[0,3]);
  Result.Y := (B.X * A.M[1,0]) + (B.Y * A.M[1,1]) + (B.Z * A.M[1,2]) + (B.W * A.M[1,3]);
  Result.Z := (B.X * A.M[2,0]) + (B.Y * A.M[2,1]) + (B.Z * A.M[2,2]) + (B.W * A.M[2,3]);
  Result.W := (B.X * A.M[3,0]) + (B.Y * A.M[3,1]) + (B.Z * A.M[3,2]) + (B.W * A.M[3,3]);
end;

class operator TNativeBZMatrix4f.*(constref A: TNativeBZVector4f; constref B: TNativeBZMatrix4f): TNativeBZVector4f;
begin
  Result.X := (A.X * B.M[0,0]) + (A.Y * B.M[1,0]) + (A.Z * B.M[2,0]) + (A.W * B.M[3,0]);
  Result.Y := (A.X * B.M[0,1]) + (A.Y * B.M[1,1]) + (A.Z * B.M[2,1]) + (A.W * B.M[3,1]);
  Result.Z := (A.X * B.M[0,2]) + (A.Y * B.M[1,2]) + (A.Z * B.M[2,2]) + (A.W * B.M[3,2]);
  Result.W := (A.X * B.M[0,3]) + (A.Y * B.M[1,3]) + (A.Z * B.M[2,3]) + (A.W * B.M[3,3]);
end;

class operator TNativeBZMatrix4f.*(constref A, B: TNativeBZMatrix4f): TNativeBZMatrix4f;
begin
  Result.M[0,0] := (A.M[0,0] * B.M[0,0]) + (A.M[0,1] * B.M[1,0]) + (A.M[0,2] * B.M[2,0]) + (A.M[0,3] * B.M[3,0]);
  Result.M[0,1] := (A.M[0,0] * B.M[0,1]) + (A.M[0,1] * B.M[1,1]) + (A.M[0,2] * B.M[2,1]) + (A.M[0,3] * B.M[3,1]);
  Result.M[0,2] := (A.M[0,0] * B.M[0,2]) + (A.M[0,1] * B.M[1,2]) + (A.M[0,2] * B.M[2,2]) + (A.M[0,3] * B.M[3,2]);
  Result.M[0,3] := (A.M[0,0] * B.M[0,3]) + (A.M[0,1] * B.M[1,3]) + (A.M[0,2] * B.M[2,3]) + (A.M[0,3] * B.M[3,3]);

  Result.M[1,0] := (A.M[1,0] * B.M[0,0]) + (A.M[1,1] * B.M[1,0]) + (A.M[1,2] * B.M[2,0]) + (A.M[1,3] * B.M[3,0]);
  Result.M[1,1] := (A.M[1,0] * B.M[0,1]) + (A.M[1,1] * B.M[1,1]) + (A.M[1,2] * B.M[2,1]) + (A.M[1,3] * B.M[3,1]);
  Result.M[1,2] := (A.M[1,0] * B.M[0,2]) + (A.M[1,1] * B.M[1,2]) + (A.M[1,2] * B.M[2,2]) + (A.M[1,3] * B.M[3,2]);
  Result.M[1,3] := (A.M[1,0] * B.M[0,3]) + (A.M[1,1] * B.M[1,3]) + (A.M[1,2] * B.M[2,3]) + (A.M[1,3] * B.M[3,3]);

  Result.M[2,0] := (A.M[2,0] * B.M[0,0]) + (A.M[2,1] * B.M[1,0]) + (A.M[2,2] * B.M[2,0]) + (A.M[2,3] * B.M[3,0]);
  Result.M[2,1] := (A.M[2,0] * B.M[0,1]) + (A.M[2,1] * B.M[1,1]) + (A.M[2,2] * B.M[2,1]) + (A.M[2,3] * B.M[3,1]);
  Result.M[2,2] := (A.M[2,0] * B.M[0,2]) + (A.M[2,1] * B.M[1,2]) + (A.M[2,2] * B.M[2,2]) + (A.M[2,3] * B.M[3,2]);
  Result.M[2,3] := (A.M[2,0] * B.M[0,3]) + (A.M[2,1] * B.M[1,3]) + (A.M[2,2] * B.M[2,3]) + (A.M[2,3] * B.M[3,3]);

  Result.M[3,0] := (A.M[3,0] * B.M[0,0]) + (A.M[3,1] * B.M[1,0]) + (A.M[3,2] * B.M[2,0]) + (A.M[3,3] * B.M[3,0]);
  Result.M[3,1] := (A.M[3,0] * B.M[0,1]) + (A.M[3,1] * B.M[1,1]) + (A.M[3,2] * B.M[2,1]) + (A.M[3,3] * B.M[3,1]);
  Result.M[3,2] := (A.M[3,0] * B.M[0,2]) + (A.M[3,1] * B.M[1,2]) + (A.M[3,2] * B.M[2,2]) + (A.M[3,3] * B.M[3,2]);
  Result.M[3,3] := (A.M[3,0] * B.M[0,3]) + (A.M[3,1] * B.M[1,3]) + (A.M[3,2] * B.M[2,3]) + (A.M[3,3] * B.M[3,3]);
end;

class operator TNativeBZMatrix4f.*(constref A: TNativeBZMatrix4f; constref B: Single): TNativeBZMatrix4f;
begin
  Result.V[0] := A.V[0] * B;
  Result.V[1] := A.V[1] * B;
  Result.V[2] := A.V[2] * B;
  Result.V[3] := A.V[3] * B;
end;

class operator TNativeBZMatrix4f./(constref A: TNativeBZMatrix4f; constref B: Single): TNativeBZMatrix4f;
var
  InvB: Single;
begin
  InvB := 1 / B;
  Result.V[0] := A.V[0] * InvB;
  Result.V[1] := A.V[1] * InvB;
  Result.V[2] := A.V[2] * InvB;
  Result.V[3] := A.V[3] * InvB;
end;

procedure TNativeBZMatrix4f.CreateIdentityMatrix;
begin
  Self:=NativeIdentityHmgMatrix;
End;

procedure TNativeBZMatrix4f.CreateScaleMatrix(const v : TNativeBZAffineVector);
begin
   Self:=NativeIdentityHmgMatrix;
   Self.X.X:=v.X;
   Self.Y.Y:=v.Y;
   Self.Z.Z:=v.Z;
end;

procedure TNativeBZMatrix4f.CreateScaleMatrix(const v : TNativeBZVector4f);
begin
   Self:=NativeIdentityHmgMatrix;
   Self.X.X:=v.X;
   Self.Y.Y:=v.Y;
   Self.Z.Z:=v.Z;
end;

procedure TNativeBZMatrix4f.CreateTranslationMatrix(const V: TNativeBZAffineVector);
begin
   Self:=NativeIdentityHmgMatrix;
   Self.X.W:=V.X;
   Self.Y.W:=V.Y;
   Self.Z.W:=V.Z;
end;

procedure TNativeBZMatrix4f.CreateTranslationMatrix(const V: TNativeBZVector4f);
begin
   Self:=NativeIdentityHmgMatrix;
   Self.X.W:=V.X;
   Self.Y.W:=V.Y;
   Self.Z.W:=V.Z;
end;

procedure TNativeBZMatrix4f.CreateScaleAndTranslationMatrix(const ascale, offset : TNativeBZVector4f);
begin
   Self:=NativeIdentityHmgMatrix;
   Self.X.X:=ascale.X;   Self.X.W:=offset.X;
   Self.Y.Y:=ascale.Y;   Self.Y.W:=offset.Y;
   Self.Z.Z:=ascale.Z;   Self.Z.W:=offset.Z;
end;

procedure TNativeBZMatrix4f.CreateRotationMatrixX(const sine, cosine: Single);
begin
  Self:=NativeEmptyHmgMatrix;

  // Right Hand Rotation Matrix around X
  // For Left Hand invert the sign of Sin
  {    X     Y     Z    W
   X | 1 |   0  |  0  | 0
   Y | 0 |  cos | sin | 0
   Z | 0 | -sin | cos | 0
   W | 0 |   0  |  0  | 1
  }

  Self.X.X:=1;

  Self.Y.Y:=cosine;
  Self.Y.Z:=-sine;

  Self.Z.Y:=sine;
  Self.Z.Z:=cosine;

  Self.W.W:=1;
end;

procedure TNativeBZMatrix4f.CreateRotationMatrixX(const Angle : Single);
var
   s, c : Single;
begin
   //BZMath.
   SinCos(Angle, s, c);
   CreateRotationMatrixX(s, c);
end;

procedure TNativeBZMatrix4f.CreateRotationMatrixY(const sine, cosine: Single);
begin
  Self:=NativeEmptyHmgMatrix;

  // Right Hand Rotation Matrix around Y
  // For Left Hand invert the sign of Sin
  {     X      Y      Z     W
   X | Cos |   0  |  Sin  | 0
   Y |  0  |   1  |   0   | 0
   Z |-Sin |   0  |  cos  | 0
   W |  0  |   0  |   0   | 1
  }

  Self.X.X:=cosine;
  Self.X.Z:=sine;
  Self.Y.Y:=1;
  Self.Z.X:=-sine;
  Self.Z.Z:=cosine;
  Self.W.W:=1;
end;

procedure TNativeBZMatrix4f.CreateRotationMatrixY(const Angle : Single);
var
   s, c : Single;
begin
   //BZMath.
   SinCos(Angle, s, c);
   CreateRotationMatrixY(s, c);
end;

procedure TNativeBZMatrix4f.CreateRotationMatrixZ(const sine, cosine: Single);
begin
  Self:=NativeEmptyHmgMatrix;

  // Right Hand Rotation Matrix around Z
  // For Left Hand invert the sign of Sin
  {     X      Y      Z     W
   X | Cos | -Sin |   0   | 0
   Y | Sin |  Cos |   0   | 0
   Z |  0  |   0  |   1   | 0
   W |  0  |   0  |   0   | 1
  }

  Self.X.X:=cosine;
  Self.X.Y:=-sine;
  Self.Y.X:=sine;
  Self.Y.Y:=cosine;
  Self.Z.Z:=1;
  Self.W.W:=1;
end;

procedure TNativeBZMatrix4f.CreateRotationMatrixZ(const Angle : Single);
var
   s, c : Single;
begin
   //BZMath.
   SinCos(Angle, s, c);
   CreateRotationMatrixZ(s, c);
end;

procedure TNativeBZMatrix4f.CreateRotationMatrix(const anAxis : TNativeBZAffineVector; Angle : Single);
var
   axis : TNativeBZVector;
   cosine, sine, one_minus_cosine : Single;
begin
   axis.AsVector3f := anAxis;
   //BZMath.
   SinCos(Angle, sine, cosine);
   one_minus_cosine:=1-cosine;
   axis.Normalize;

   Self.X.X:=(one_minus_cosine * axis.V[0] * axis.V[0]) + cosine;
   Self.X.Y:=(one_minus_cosine * axis.V[0] * axis.V[1]) - (axis.V[2] * sine);
   Self.X.Z:=(one_minus_cosine * axis.V[2] * axis.V[0]) + (axis.V[1] * sine);
   Self.X.W:=0;

   Self.Y.X:=(one_minus_cosine * axis.V[0] * axis.V[1]) + (axis.V[2] * sine);
   Self.Y.Y:=(one_minus_cosine * axis.V[1] * axis.V[1]) + cosine;
   Self.Y.Z:=(one_minus_cosine * axis.V[1] * axis.V[2]) - (axis.V[0] * sine);
   Self.Y.W:=0;

   Self.Z.X:=(one_minus_cosine * axis.V[2] * axis.V[0]) - (axis.V[1] * sine);
   Self.Z.Y:=(one_minus_cosine * axis.V[1] * axis.V[2]) + (axis.V[0] * sine);
   Self.Z.Z:=(one_minus_cosine * axis.V[2] * axis.V[2]) + cosine;
   Self.Z.W:=0;

   Self.W.X:=0;
   Self.W.Y:=0;
   Self.W.Z:=0;
   Self.W.W:=1;
end;

procedure TNativeBZMatrix4f.CreateRotationMatrix(const anAxis : TNativeBZVector4f; Angle : Single);
begin
   CreateRotationMatrix(anAxis.AsVector3f, Angle);
end;

// optimised pascal
function TNativeBZMatrix4f.Invert:TNativeBZMatrix4f;
var
  det: Single;
begin
  det := Self.determinant;
  if Abs(Det)<cEPSILON then  result:=NativeIdentityHmgMatrix
  else
  begin
    det := 1/det;
    with self do
    begin
      Result.m11 := (m23*m34*m42 - m24*m33*m42 + m24*m32*m43 - m22*m34*m43 - m23*m32*m44 + m22*m33*m44) * det;
      Result.m12 := (m14*m33*m42 - m13*m34*m42 - m14*m32*m43 + m12*m34*m43 + m13*m32*m44 - m12*m33*m44) * det;
      Result.m13 := (m13*m24*m42 - m14*m23*m42 + m14*m22*m43 - m12*m24*m43 - m13*m22*m44 + m12*m23*m44) * det;
      Result.m14 := (m14*m23*m32 - m13*m24*m32 - m14*m22*m33 + m12*m24*m33 + m13*m22*m34 - m12*m23*m34) * det;
      Result.m21 := (m24*m33*m41 - m23*m34*m41 - m24*m31*m43 + m21*m34*m43 + m23*m31*m44 - m21*m33*m44) * det;
      Result.m22 := (m13*m34*m41 - m14*m33*m41 + m14*m31*m43 - m11*m34*m43 - m13*m31*m44 + m11*m33*m44) * det;
      Result.m23 := (m14*m23*m41 - m13*m24*m41 - m14*m21*m43 + m11*m24*m43 + m13*m21*m44 - m11*m23*m44) * det;
      Result.m24 := (m13*m24*m31 - m14*m23*m31 + m14*m21*m33 - m11*m24*m33 - m13*m21*m34 + m11*m23*m34) * det;
      Result.m31 := (m22*m34*m41 - m24*m32*m41 + m24*m31*m42 - m21*m34*m42 - m22*m31*m44 + m21*m32*m44) * det;
      Result.m32 := (m14*m32*m41 - m12*m34*m41 - m14*m31*m42 + m11*m34*m42 + m12*m31*m44 - m11*m32*m44) * det;
      Result.m33 := (m12*m24*m41 - m14*m22*m41 + m14*m21*m42 - m11*m24*m42 - m12*m21*m44 + m11*m22*m44) * det;
      Result.m34 := (m14*m22*m31 - m12*m24*m31 - m14*m21*m32 + m11*m24*m32 + m12*m21*m34 - m11*m22*m34) * det;
      Result.m41 := (m23*m32*m41 - m22*m33*m41 - m23*m31*m42 + m21*m33*m42 + m22*m31*m43 - m21*m32*m43) * det;
      Result.m42 := (m12*m33*m41 - m13*m32*m41 + m13*m31*m42 - m11*m33*m42 - m12*m31*m43 + m11*m32*m43) * det;
      Result.m43 := (m13*m22*m41 - m12*m23*m41 - m13*m21*m42 + m11*m23*m42 + m12*m21*m43 - m11*m22*m43) * det;
      Result.m44 := (m12*m23*m31 - m13*m22*m31 + m13*m21*m32 - m11*m23*m32 - m12*m21*m33 + m11*m22*m33) * det;
    end;
  end;
end;

// original
//function TNativeBZMatrix4f.Invert:TNativeBZMatrix4f;
//var
//   det : Single;
//begin
//   det:=GetDeterminant;
//   if Abs(Det)<cEPSILON then  result:=NativeIdentityHmgMatrix
//   else
//   begin
//      Result := Self;
//      Result.Adjoint;
//      Result := Result * (1/det);
//   end;
//end;

(*function TMatrix4.Inverse: TMatrix4;
var
  C00, C02, C03, C04, C06, C07, C08, C10, C11: Single;
  C12, C14, C15, C16, C18, C19, C20, C22, C23: Single;
  F0, F1, F2, F3, F4, F5, V0, V1, V2, V3, I0, I1, I2, I3, SA, SB, Row, Dot: TVector4;
  Inv: TMatrix4;
  OneOverDeterminant: Single;
begin
  C00 := (M[2,2] * M[3,3]) - (M[3,2] * M[2,3]);
  C02 := (M[1,2] * M[3,3]) - (M[3,2] * M[1,3]);
  C03 := (M[1,2] * M[2,3]) - (M[2,2] * M[1,3]);

  C04 := (M[2,1] * M[3,3]) - (M[3,1] * M[2,3]);
  C06 := (M[1,1] * M[3,3]) - (M[3,1] * M[1,3]);
  C07 := (M[1,1] * M[2,3]) - (M[2,1] * M[1,3]);

  C08 := (M[2,1] * M[3,2]) - (M[3,1] * M[2,2]);
  C10 := (M[1,1] * M[3,2]) - (M[3,1] * M[1,2]);
  C11 := (M[1,1] * M[2,2]) - (M[2,1] * M[1,2]);

  C12 := (M[2,0] * M[3,3]) - (M[3,0] * M[2,3]);
  C14 := (M[1,0] * M[3,3]) - (M[3,0] * M[1,3]);
  C15 := (M[1,0] * M[2,3]) - (M[2,0] * M[1,3]);

  C16 := (M[2,0] * M[3,2]) - (M[3,0] * M[2,2]);
  C18 := (M[1,0] * M[3,2]) - (M[3,0] * M[1,2]);
  C19 := (M[1,0] * M[2,2]) - (M[2,0] * M[1,2]);

  C20 := (M[2,0] * M[3,1]) - (M[3,0] * M[2,1]);
  C22 := (M[1,0] * M[3,1]) - (M[3,0] * M[1,1]);
  C23 := (M[1,0] * M[2,1]) - (M[2,0] * M[1,1]);

  F0 := Vector4(C00, C00, C02, C03);
  F1 := Vector4(C04, C04, C06, C07);
  F2 := Vector4(C08, C08, C10, C11);
  F3 := Vector4(C12, C12, C14, C15);
  F4 := Vector4(C16, C16, C18, C19);
  F5 := Vector4(C20, C20, C22, C23);

  V0 := Vector4(M[1,0], M[0,0], M[0,0], M[0,0]);
  V1 := Vector4(M[1,1], M[0,1], M[0,1], M[0,1]);
  V2 := Vector4(M[1,2], M[0,2], M[0,2], M[0,2]);
  V3 := Vector4(M[1,3], M[0,3], M[0,3], M[0,3]);

  I0 := (V1 * F0) - (V2 * F1) + (V3 * F2);
  I1 := (V0 * F0) - (V2 * F3) + (V3 * F4);
  I2 := (V0 * F1) - (V1 * F3) + (V3 * F5);
  I3 := (V0 * F2) - (V1 * F4) + (V2 * F5);

  SA := Vector4(+1, -1, +1, -1);
  SB := Vector4(-1, +1, -1, +1);

  Inv := Matrix4(I0 * SA, I1 * SB, I2 * SA, I3 * SB);

  Row := Vector4(Inv[0,0], Inv[1,0], Inv[2,0], Inv[3,0]);
  Dot := V[0] * Row;

  OneOverDeterminant := 1 / ((Dot.X + Dot.Y) + (Dot.Z + Dot.W));
  Result := Inv * OneOverDeterminant;
end;  *)

function TNativeBZMatrix4f.MatrixDetInternal(const a1, a2, a3, b1, b2, b3, c1, c2, c3: Single): Single;
// internal version for the determinant of a 3x3 matrix
begin
  Result:=  a1 * (b2 * c3 - b3 * c2)
          - b1 * (a2 * c3 - a3 * c2)
          + c1 * (a2 * b3 - a3 * b2);
end;

function TNativeBZMatrix4f.GetDeterminant: Single;
begin
  Result:= Self.V[0].X*MatrixDetInternal(Self.V[1].Y, Self.V[2].Y, Self.V[3].Y, Self.V[1].Z, Self.V[2].Z, Self.V[3].Z, Self.V[1].W, Self.V[2].W, Self.V[3].W)
          -Self.V[0].Y*MatrixDetInternal(Self.V[1].X, Self.V[2].X, Self.V[3].X, Self.V[1].Z, Self.V[2].Z, Self.V[3].Z, Self.V[1].W, Self.V[2].W, Self.V[3].W)
          +Self.V[0].Z*MatrixDetInternal(Self.V[1].X, Self.V[2].X, Self.V[3].X, Self.V[1].Y, Self.V[2].Y, Self.V[3].Y, Self.V[1].W, Self.V[2].W, Self.V[3].W)
          -Self.V[0].W*MatrixDetInternal(Self.V[1].X, Self.V[2].X, Self.V[3].X, Self.V[1].Y, Self.V[2].Y, Self.V[3].Y, Self.V[1].Z, Self.V[2].Z, Self.V[3].Z);
end;

procedure TNativeBZMatrix4f.Adjoint;
var
   a1, a2, a3, a4,
   b1, b2, b3, b4,
   c1, c2, c3, c4,
   d1, d2, d3, d4: Single;
begin
    a1:= Self.X.X; b1:= Self.X.Y;
    c1:= Self.X.Z; d1:= Self.X.W;
    a2:= Self.Y.X; b2:= Self.Y.Y;
    c2:= Self.Y.Z; d2:= Self.Y.W;
    a3:= Self.Z.X; b3:= Self.Z.Y;
    c3:= Self.Z.Z; d3:= Self.Z.W;
    a4:= Self.W.X; b4:= Self.W.Y;
    c4:= Self.W.Z; d4:= Self.W.W;

    // row column labeling reversed since we transpose rows & columns
    Self.X.X:= MatrixDetInternal(b2, b3, b4, c2, c3, c4, d2, d3, d4);
    Self.Y.X:=-MatrixDetInternal(a2, a3, a4, c2, c3, c4, d2, d3, d4);
    Self.Z.X:= MatrixDetInternal(a2, a3, a4, b2, b3, b4, d2, d3, d4);
    Self.W.X:=-MatrixDetInternal(a2, a3, a4, b2, b3, b4, c2, c3, c4);

    Self.X.Y:=-MatrixDetInternal(b1, b3, b4, c1, c3, c4, d1, d3, d4);
    Self.Y.Y:= MatrixDetInternal(a1, a3, a4, c1, c3, c4, d1, d3, d4);
    Self.Z.Y:=-MatrixDetInternal(a1, a3, a4, b1, b3, b4, d1, d3, d4);
    Self.W.Y:= MatrixDetInternal(a1, a3, a4, b1, b3, b4, c1, c3, c4);

    Self.X.Z:= MatrixDetInternal(b1, b2, b4, c1, c2, c4, d1, d2, d4);
    Self.Y.Z:=-MatrixDetInternal(a1, a2, a4, c1, c2, c4, d1, d2, d4);
    Self.Z.Z:= MatrixDetInternal(a1, a2, a4, b1, b2, b4, d1, d2, d4);
    Self.W.Z:=-MatrixDetInternal(a1, a2, a4, b1, b2, b4, c1, c2, c4);

    Self.X.W:=-MatrixDetInternal(b1, b2, b3, c1, c2, c3, d1, d2, d3);
    Self.Y.W:= MatrixDetInternal(a1, a2, a3, c1, c2, c3, d1, d2, d3);
    Self.Z.W:=-MatrixDetInternal(a1, a2, a3, b1, b2, b3, d1, d2, d3);
    Self.W.W:= MatrixDetInternal(a1, a2, a3, b1, b2, b3, c1, c2, c3);
end;


(*procedure TNativeBZMatrix4.Translate(constref v : TBZAffineVector);
begin
   Self.W.X:=Self.W.X+v.X;
   Self.W.Y:=Self.W.Y+v.Y;
   Self.W.Z:=Self.W.Z+v.Z;
end; *)

function TNativeBZMatrix4f.Translate(constref v : TNativeBZVector4f):TNativeBZMatrix4f;
begin
   Result := Self;
   Result.X.W:=Self.X.W+v.X;
   Result.Y.W:=Self.Y.W+v.Y;
   Result.Z.W:=Self.Z.W+v.Z;
end;

function TNativeBZMatrix4f.Multiply(constref M2 : TNativeBZMatrix4f): TNativeBZMatrix4f;
var
  I: Integer;
begin
  for I := 0 to 3 do
    Result.V[I] := Self.V[I] * M2.V[I];
end;

function TNativeBZMatrix4f.Normalize: TNativeBZMatrix4f;
begin
   Result.X.W:=0;
   Result.X.Normalize;
   Result.Y.W:=0;
   Result.Y.Normalize;
   Result.Z:=Result.X.CrossProduct(Result.Y);
   Result.X:=Result.Y.CrossProduct(Result.Z);
   Result.W:=NativeWHmgVector;
end;

procedure TNativeBZMatrix4f.Transpose_Scale_M33(constref src : TNativeBZMatrix4f; Constref ascale : Single);
// EAX src
// EDX dest
// ECX scale
begin
   Self.V[0].V[0]:=ascale*src.V[0].V[0];
   Self.V[1].V[0]:=ascale*src.V[0].V[1];
   Self.V[2].V[0]:=ascale*src.V[0].V[2];
   Self.V[0].V[1]:=ascale*src.V[1].V[0];
   Self.V[1].V[1]:=ascale*src.V[1].V[1];
   Self.V[2].V[1]:=ascale*src.V[1].V[2];
   Self.V[0].V[2]:=ascale*src.V[2].V[0];
   Self.V[1].V[2]:=ascale*src.V[2].V[1];
   Self.V[2].V[2]:=ascale*src.V[2].V[2];
end;

function TNativeBZMatrix4f.Transpose: TNativeBZMatrix4f;
begin
  Result.M[0,0] := M[0,0];
  Result.M[0,1] := M[1,0];
  Result.M[0,2] := M[2,0];
  Result.M[0,3] := M[3,0];

  Result.M[1,0] := M[0,1];
  Result.M[1,1] := M[1,1];
  Result.M[1,2] := M[2,1];
  Result.M[1,3] := M[3,1];

  Result.M[2,0] := M[0,2];
  Result.M[2,1] := M[1,2];
  Result.M[2,2] := M[2,2];
  Result.M[2,3] := M[3,2];

  Result.M[3,0] := M[0,3];
  Result.M[3,1] := M[1,3];
  Result.M[3,2] := M[2,3];
  Result.M[3,3] := M[3,3];
end;

procedure TNativeBZMatrix4f.AnglePreservingMatrixInvert(constref mat : TNativeBZMatrix4f);
var
   ascale : Single;
begin
   ascale:=mat.V[0].Norm;

   // Is the submatrix A singular?
   if Abs(ascale)<cEPSILON then
   begin
      // Matrix M has no inverse
      Self:=NativeIdentityHmgMatrix;
      Exit;
   end
   else
   begin
      // Calculate the inverse of the square of the isotropic scale factor
      ascale:=1.0/ascale;
   end;

   // Fill in last row while CPU is busy with the division
   Self.V[0].V[3]:=0.0;
   Self.V[1].V[3]:=0.0;
   Self.V[2].V[3]:=0.0;
   Self.V[3].V[3]:=1.0;

   // Transpose and scale the 3 by 3 upper-left submatrix
   Self.transpose_scale_m33(mat,ascale);

   // Calculate -(transpose(A) / s*s) C
   Self.V[3].V[0]:=-(Self.V[0].V[0]*mat.V[3].V[0]
                    +Self.V[1].V[0]*mat.V[3].V[1]
                    +Self.V[2].V[0]*mat.V[3].V[2]);
   Self.V[3].V[1]:=-(Self.V[0].V[1]*mat.V[3].V[0]
                    +Self.V[1].V[1]*mat.V[3].V[1]
                    +Self.V[2].V[1]*mat.V[3].V[2]);
   Self.V[3].V[2]:=-(Self.V[0].V[2]*mat.V[3].V[0]
                    +Self.V[1].V[2]*mat.V[3].V[1]
                    +Self.V[2].V[2]*mat.V[3].V[2]);
end;

function TNativeBZMatrix4f.Decompose(var Tran: TBZMatrixTransformations): Boolean;
var
   I, J: Integer;
   LocMat, pmat, invpmat : TNativeBZMatrix4f;
   prhs, psol: TNativeBZVector4f;
   row0, row1, row2 : TNativeBZVector4f;
   f : Single;
begin
  Result:=False;
  locmat:=Self;
  // normalize the matrix
  if LocMat.W.W = 0 then Exit;
  for I:=0 to 3 do
    for J:=0 to 3 do
      Locmat.V[I].V[J]:=locmat.V[I].V[J] / locmat.W.W;

  // pmat is used to solve for perspective, but it also provides
  // an easy way to test for singularity of the upper 3x3 component.

  pmat:=locmat;
  for I:=0 to 2 do pmat.V[I].W:=0;
  pmat.W.W:=1;

  if pmat.Determinant = 0 then Exit;

  // First, isolate perspective.  This is the messiest.
  if (locmat.X.W <> 0) or (locmat.Y.W <> 0) or (locmat.Z.W <> 0) then begin
    // prhs is the right hand side of the equation.
    prhs.X:=locmat.X.W;
    prhs.Y:=locmat.Y.W;
    prhs.Z:=locmat.Z.W;
    prhs.W:=locmat.W.W;

    // Solve the equation by inverting pmat and multiplying
    // prhs by the inverse.  (This is the easiest way, not
    // necessarily the best.)

    invpmat:=pmat;
    invpmat.Invert;
    invpmat.Transpose;
    psol:=  invpmat * prhs; //VectorTransform(prhs, invpmat);

    // stuff the answer away
    Tran[ttPerspectiveX]:=psol.X;
    Tran[ttPerspectiveY]:=psol.Y;
    Tran[ttPerspectiveZ]:=psol.Z;
    Tran[ttPerspectiveW]:=psol.W;

    // clear the perspective partition
    locmat.X.W:=0;
    locmat.Y.W:=0;
    locmat.Z.W:=0;
    locmat.W.W:=1;
  end else begin
    // no perspective
    Tran[ttPerspectiveX]:=0;
    Tran[ttPerspectiveY]:=0;
    Tran[ttPerspectiveZ]:=0;
    Tran[ttPerspectiveW]:=0;
  end;

  // next take care of translation (easy)
  for I:=0 to 2 do begin
    Tran[TBZMAtrixTransType(Ord(ttTranslateX) + I)]:=locmat.V[3].V[I];
    locmat.V[3].V[I]:=0;
  end;

  // now get scale and shear
  row0 := locmat.X;
  row1 := locmat.Y;
  row2 := locmat.Z;

  // compute X scale factor and normalize first row
  Tran[ttScaleX]:=Row0.Norm;
  Row0 := Row0 * InvSqrt(Tran[ttScaleX]); //VectorScale(row0, RSqrt(Tran[ttScaleX]));

  // compute XY shear factor and make 2nd row orthogonal to 1st
  Tran[ttShearXY]:=row0.DotProduct(row1);
  f:=-Tran[ttShearXY];
  Row1.Combine(row0, f);

  // now, compute Y scale and normalize 2nd row
  Tran[ttScaleY]:=Row1.Norm;
  Row1 := Row1 * InvSqrt(Tran[ttScaleY]); //VectorScale(row1, RSqrt(Tran[ttScaleY]));
  Tran[ttShearXY]:=Tran[ttShearXY]/Tran[ttScaleY];

  // compute XZ and YZ shears, orthogonalize 3rd row
  Tran[ttShearXZ]:=row0.DotProduct(row2);
  f:=-Tran[ttShearXZ];
  row2.Combine(row0, f);
  Tran[ttShearYZ]:=Row1.DotProduct(row2);
  f:=-Tran[ttShearYZ];
  Row2.Combine(row1, f);

  // next, get Z scale and normalize 3rd row
  Tran[ttScaleZ]:=Row2.Norm;
  Row2:=row2* InvSqrt(Tran[ttScaleZ]);
  Tran[ttShearXZ]:=Tran[ttShearXZ] / tran[ttScaleZ];
  Tran[ttShearYZ]:=Tran[ttShearYZ] / Tran[ttScaleZ];

  // At this point, the matrix (in rows[]) is orthonormal.
  // Check for a coordinate system flip.  If the determinant
  // is -1, then negate the matrix and the scaling factors.
  if row0.DotProduct(row1.CrossProduct(row2)) < 0 then
  begin
    for I:=0 to 2 do
      Tran[TBZMatrixTransType(Ord(ttScaleX) + I)]:=-Tran[TBZMatrixTransType(Ord(ttScaleX) + I)];
    row0 := -row0; //row0.Negate;
    row1 := -row1;
    row2 := -row2;
  end;

  // now, get the rotations out, as described in the gem
  Tran[ttRotateY]:=FastArcSine(-row0.Z);
  if cos(Tran[ttRotateY]) <> 0 then
  begin
    Tran[ttRotateX]:=BZMath.ArcTan2(row1.Z, row2.Z);
    Tran[ttRotateZ]:=BZMath.ArcTan2(row0.Y, row0.X);
  end else
  begin
    tran[ttRotateX]:=BZMath.ArcTan2(row1.X, row1.Y);
    tran[ttRotateZ]:=0;
  end;
  // All done!
  Result:=True;
end;

procedure TNativeBZMatrix4f.CreateLookAtMatrix(const eye, center, normUp: TNativeBZVector4f);
var
  XAxis, YAxis, ZAxis: TNativeBZVector4f;
begin
  ZAxis := TNativeBZVector4f(center - eye).Normalize;
  XAxis := TNativeBZVector4f(ZAxis.CrossProduct(normUp)).Normalize;
  YAxis := TNativeBZVector4f(XAxis.CrossProduct(ZAxis)).Normalize;
  Self.V[0] := XAxis;
  Self.V[1] := YAxis;
  Self.V[2] := -ZAxis;
  Self.V[3] := NativeNullHmgPoint;
  // this is just a reverse tranlation of eye to world origin as origin was not passed in.
  self.m14 := -eye.X;
  self.m24 := -eye.Y;
  self.m34 := -eye.Z;
end;

procedure TNativeBZMatrix4f.CreateMatrixFromFrustum(Left, Right, Bottom, Top, ZNear, ZFar: Single);
begin
  Self.X.X := 2 * ZNear / (Right - Left);
  Self.X.Y := 0;
  Self.X.Z := 0;
  Self.X.W := 0;

  Self.Y.X := 0;
  Self.Y.Y := 2 * ZNear / (Top - Bottom);
  Self.Y.Z := 0;
  Self.Y.W := 0;

  Self.Z.X := (Right + Left) / (Right - Left);
  Self.Z.Y := (Top + Bottom) / (Top - Bottom);
  Self.Z.Z := -(ZFar + ZNear) / (ZFar - ZNear);
  Self.Z.W := -1;

  Self.W.X := 0;
  Self.W.Y := 0;
  Self.W.Z := -2 * ZFar * ZNear / (ZFar - ZNear);
  Self.W.W := 0;
end;

procedure TNativeBZMatrix4f.CreatePerspectiveMatrix(FOV, Aspect, ZNear, ZFar: Single);
var
  xx, yy: Single;
begin
  FOV := BZMath.Min(179.9, BZMath.Max(0, FOV));
  yy:= ZNear * BZMath.Tan(BZMath.DegToRadian(FOV) * 0.5);
  xx:= yy * Aspect;
  CreateMatrixFromFrustum(-xx, xx, -yy, yy, ZNear, ZFar);
end;

procedure TNativeBZMatrix4f.CreateOrthoMatrix(Left, Right, Bottom, Top, ZNear, ZFar: Single);
begin
  Self.V[0].V[0] := 2 / (Right - Left);
  Self.V[0].V[1] := 0;
  Self.V[0].V[2] := 0;
  Self.V[0].V[3] := 0;

  Self.V[1].V[0] := 0;
  Self.V[1].V[1] := 2 / (Top - Bottom);
  Self.V[1].V[2] := 0;
  Self.V[1].V[3] := 0;

  Self.V[2].V[0] := 0;
  Self.V[2].V[1] := 0;
  Self.V[2].V[2] := -2 / (ZFar - ZNear);
  Self.V[2].V[3] := 0;

  Self.V[3].V[0] := (Left + Right) / (Left - Right);
  Self.V[3].V[1] := (Bottom + Top) / (Bottom - Top);
  Self.V[3].V[2] := (ZNear + ZFar) / (ZNear - ZFar);
  Self.V[3].V[3] := 1;
end;

procedure TNativeBZMatrix4f.CreatePickMatrix(x, y, deltax, deltay: Single; const viewport: TBZVector4i);
begin
  if (deltax <= 0) or (deltay <= 0) then
  begin
    Self := NativeIdentityHmgMatrix;
    exit;
  end;
  // Translate and scale the picked region to the entire window
  CreateTranslationMatrix(NativeAffineVectorMake( (viewport.V[2] - 2 * (x - viewport.V[0])) / deltax,
	                                    (viewport.V[3] - 2 * (y - viewport.V[1])) / deltay,
                                            0.0));
  Self.V[0].V[0] := viewport.V[2] / deltax;
  Self.V[1].V[1] := viewport.V[3] / deltay;
end;

procedure TNativeBZMatrix4f.CreateParallelProjectionMatrix(const plane : TNativeBZHmgPlane;const dir : TNativeBZVector4f);
var
   dot, invDot : Single;
begin
   dot:=plane.V[0]*dir.V[0]+plane.V[1]*dir.V[1]+plane.V[2]*dir.V[2];
   if Abs(dot)<1e-5 then
   begin
      Self:=NativeIdentityHmgMatrix;
      Exit;
   end;
   invDot:=1/dot;

   Self.m11:=( plane.V[1] * dir.V[1] + plane.V[2] * dir.V[2]) * invDot;
   Self.m12:=(-plane.V[1] * dir.V[0]) * invDot;
   Self.m13:=(-plane.V[2] * dir.V[0]) * invDot;
   Self.m14:=(-plane.V[3] * dir.V[0]) * invDot;

   Self.m21:=(-plane.V[0] * dir.V[1]) * invDot;
   Self.m22:=( plane.V[0] * dir.V[0] + plane.V[2] * dir.V[2]) * invDot;
   Self.m23:=(-plane.V[2] * dir.V[1]) * invDot;
   Self.m24:=(-plane.V[3] * dir.V[1]) * invDot;

   Self.m31:=(-plane.V[0] * dir.V[2]) * invDot;
   Self.m32:=(-plane.V[1] * dir.V[2]) * invDot;
   Self.m33:=( plane.V[0] * dir.V[0] + plane.V[1] * dir.V[1]) * invDot;
   Self.m34:=(-plane.V[3] * dir.V[2]) * invDot;

   Self.m41:=0;
   Self.m42:=0;
   Self.m43:=0;
   Self.m44:=1;
end;
//// Based on material from a course by William D. Shoaff (www.cs.fit.edu)
//var
//   dot, invDot : Single;
//begin
//   dot:=plane.V[0]*dir.V[0]+plane.V[1]*dir.V[1]+plane.V[2]*dir.V[2];
//   if Abs(dot)<1e-5 then
//   begin
//      Self:=NativeIdentityHmgMatrix;
//      Exit;
//   end;
//   invDot:=1/dot;
//
//   Self.V[0].V[0]:=(plane.V[1]*dir.V[1]+plane.V[2]*dir.V[2])*invDot;
//   Self.V[1].V[0]:=(-plane.V[1]*dir.V[0])*invDot;
//   Self.V[2].V[0]:=(-plane.V[2]*dir.V[0])*invDot;
//   Self.V[3].V[0]:=(-plane.V[3]*dir.V[0])*invDot;
//
//   Self.V[0].V[1]:=(-plane.V[0]*dir.V[1])*invDot;
//   Self.V[1].V[1]:=(plane.V[0]*dir.V[0]+plane.V[2]*dir.V[2])*invDot;
//   Self.V[2].V[1]:=(-plane.V[2]*dir.V[1])*invDot;
//   Self.V[3].V[1]:=(-plane.V[3]*dir.V[1])*invDot;
//
//   Self.V[0].V[2]:=(-plane.V[0]*dir.V[2])*invDot;
//   Self.V[1].V[2]:=(-plane.V[1]*dir.V[2])*invDot;
//   Self.V[2].V[2]:=(plane.V[0]*dir.V[0]+plane.V[1]*dir.V[1])*invDot;
//   Self.V[3].V[2]:=(-plane.V[3]*dir.V[2])*invDot;
//
//   Self.V[0].V[3]:=0;
//   Self.V[1].V[3]:=0;
//   Self.V[2].V[3]:=0;
//   Self.V[3].V[3]:=1;
//end;

procedure TNativeBZMatrix4f.CreateShadowMatrix(const planePoint, planeNormal, lightPos : TNativeBZVector4f);
var
   planeNormal3, dot : Single;
begin
	// Find the last coefficient by back substitutions
	planeNormal3:=-( planeNormal.V[0]*planePoint.V[0]
                   +planeNormal.V[1]*planePoint.V[1]
                   +planeNormal.V[2]*planePoint.V[2]);
	// Dot product of plane and light position
	dot:= planeNormal.V[0]*lightPos.V[0]
        +planeNormal.V[1]*lightPos.V[1]
        +planeNormal.V[2]*lightPos.V[2]
        +planeNormal3  *lightPos.V[3];
	// Now do the projection
	// First column
        Self.V[0].V[0]:= dot - lightPos.V[0] * planeNormal.V[0];
        Self.V[1].V[0]:=     - lightPos.V[0] * planeNormal.V[1];
        Self.V[2].V[0]:=     - lightPos.V[0] * planeNormal.V[2];
        Self.V[3].V[0]:=     - lightPos.V[0] * planeNormal3;
	// Second column
	Self.V[0].V[1]:=     - lightPos.V[1] * planeNormal.V[0];
	Self.V[1].V[1]:= dot - lightPos.V[1] * planeNormal.V[1];
	Self.V[2].V[1]:=     - lightPos.V[1] * planeNormal.V[2];
	Self.V[3].V[1]:=     - lightPos.V[1] * planeNormal3;
	// Third Column
	Self.V[0].V[2]:=     - lightPos.V[2] * planeNormal.V[0];
	Self.V[1].V[2]:=     - lightPos.V[2] * planeNormal.V[1];
	Self.V[2].V[2]:= dot - lightPos.V[2] * planeNormal.V[2];
	Self.V[3].V[2]:=     - lightPos.V[2] * planeNormal3;
	// Fourth Column
	Self.V[0].V[3]:=     - lightPos.V[3] * planeNormal.V[0];
	Self.V[1].V[3]:=     - lightPos.V[3] * planeNormal.V[1];
	Self.V[2].V[3]:=     - lightPos.V[3] * planeNormal.V[2];
	Self.V[3].V[3]:= dot - lightPos.V[3] * planeNormal3;
end;

procedure TNativeBZMatrix4f.CreateReflectionMatrix(const planePoint, planeNormal : TNativeBZVector4f);
var
   pv2 : Single;
begin
   // Precalcs
   pv2:=2*planepoint.DotProduct(planeNormal);
   // 1st column
   Self.V[0].V[0]:=1-2*Sqr(planeNormal.V[0]);
   Self.V[0].V[1]:=-2*planeNormal.V[0]*planeNormal.V[1];
   Self.V[0].V[2]:=-2*planeNormal.V[0]*planeNormal.V[2];
   Self.V[0].V[3]:=0;
   // 2nd column
   Self.V[1].V[0]:=-2*planeNormal.V[1]*planeNormal.V[0];
   Self.V[1].V[1]:=1-2*Sqr(planeNormal.V[1]);
   Self.V[1].V[2]:=-2*planeNormal.V[1]*planeNormal.V[2];
   Self.V[1].V[3]:=0;
   // 3rd column
   Self.V[2].V[0]:=-2*planeNormal.V[2]*planeNormal.V[0];
   Self.V[2].V[1]:=-2*planeNormal.V[2]*planeNormal.V[1];
   Self.V[2].V[2]:=1-2*Sqr(planeNormal.V[2]);
   Self.V[2].V[3]:=0;
   // 4th column
   Self.V[3].V[0]:=pv2*planeNormal.V[0];
   Self.V[3].V[1]:=pv2*planeNormal.V[1];
   Self.V[3].V[2]:=pv2*planeNormal.V[2];
   Self.V[3].V[3]:=1;
end;



(* class operator TMatrix4.Divide(const A, B: TMatrix4): TMatrix4;
begin
  Result := A * B.Inverse;
end;

class operator TMatrix4.Divide(const A: TVector4; const B: TMatrix4): TVector4;
begin
  Result := A * B.Inverse;
end;

class operator TMatrix4.Divide(const A: TMatrix4; const B: TVector4): TVector4;
begin
  Result := A.Inverse * B;
end;

function TMatrix4.CompMult(const AOther: TMatrix4): TMatrix4;
var
  I: Integer;
begin
  for I := 0 to 3 do
    Result.V[I] := V[I] * AOther.V[I];
end; *)

{%endregion%}

{%region%-----[ TNativeBZQuaternion ]------------------------------------------}


class operator TNativeBZQuaternion.=(constref A, B: TNativeBZQuaternion): Boolean;
begin
  Result := (A.X = B.X) and (A.Y = B.Y) and (A.Z = B.Z) and (A.W = B.W);
end;

class operator TNativeBZQuaternion.<>(constref A, B: TNativeBZQuaternion): Boolean;
begin
   Result := (A.X <> B.X) or (A.Y <> B.Y) or (A.Z <> B.Z) or (A.W <> B.W);
end;

function TNativeBZQuaternion.Conjugate : TNativeBZQuaternion;
begin
  Result.X:=-Self.X;
  Result.Y:=-Self.Y;
  Result.Z:=-Self.Z;
  Result.W:=Self.W;
end;

{ function TNativeBZQuaternion.Magnitude : Single;
begin
  Result := Sqrt((X * X) + (Y * Y) + (Z * Z) + (W * W));
end; }

function TNativeBZQuaternion.Magnitude : Single;
begin
//  Result:=Sqrt(Self.AsVector4f.Norm + Sqr(Self.RealPart));
  Result := Sqrt((X * X) + (Y * Y) + (Z * Z) + (W * W));
end;

procedure TNativeBZQuaternion.Normalize;
var
   m, f : Single;
begin
   m:=Self.Magnitude;
   if m>cEpsilon30 then
   begin
      f:=1/m;
      Self.AsVector4f := Self.AsVector4f * f;
   end
   else Self:=NativeIdentityQuaternion;
end;

{%region%====[ Commons functions ]==============================================}

function TNativeBZQuaternion.ToString : String;
begin
   Result := '(ImagePart.X: '+FloattoStrF(Self.X,fffixed,5,5)+
            ' ,ImagePart.Y: '+FloattoStrF(Self.Y,fffixed,5,5)+
            ' ,ImagePart.Z: '+FloattoStrF(Self.Z,fffixed,5,5)+
            ' , RealPart.W: '+FloattoStrF(Self.W,fffixed,5,5)+')';
End;

procedure TNativeBZQuaternion.Create(x,y,z: Single; Real : Single);
begin
  Self.ImagePart.X:=X;
  Self.ImagePart.Y:=Y;
  Self.ImagePart.Z:=Z;
  Self.RealPart:=real;
end;

procedure TNativeBZQuaternion.Create(const Imag: array of Single; Real : Single);
var
   n : Integer;
begin
   n:=Length(Imag);
   if n>=1 then Self.ImagePart.X:=Imag[0];
   if n>=2 then Self.ImagePart.Y:=Imag[1];
   if n>=3 then Self.ImagePart.Z:=Imag[2];
   Self.RealPart:=real;
end;

procedure TNativeBZQuaternion.Create(const V1, V2: TNativeBZAffineVector);
Var
  vv1,vv2 : TNativeBZVector;
begin
  vv1.AsVector3f := V1;
  vv2.AsVector3f := V2;
  Self.AsVector4f:=vv1.CrossProduct(vv2);
  Self.RealPart:= vv1.DotProduct(vv2) + 1;
  self.Normalize;
end;

procedure TNativeBZQuaternion.Create(const V1, V2: TNativeBZVector); overload;
begin
   Self.AsVector4f := v1.CrossProduct(v2);
   Self.RealPart := v1.DotProduct(v2) + 1;
   self.Normalize;
end;

function TNativeBZQuaternion.Transform(constref V: TNativeBZVector): TNativeBZVector;
var
  res, v2, Conj: TNativeBZQuaternion;
begin
    conj := self.Conjugate;
    v2.Create(V.X,V.Y,V.Z,0);
    res := Self * v2;
    res := res * conj;
    Result := Res.AsVector4f;
    Result.W := 1;
end;

procedure TNativeBZQuaternion.Scale(ScaleVal: Single);
begin
   Self.AsVector4f := Self.AsVector4f * Sqrt(ScaleVal);
end;
//procedure TNativeBZQuaternion.Create(const V1, V2: TBZVector);

procedure TNativeBZQuaternion.Create(const mat : TNativeBZMatrix);
// the matrix must be a rotation matrix!
var
   traceMat, s, invS : Double;
begin
   traceMat := mat.m11 + mat.m22 + mat.m33;
   if traceMat > cFullEpsilon then begin
      s := 2 * Sqrt(1 + traceMat);
      invS := 1 / s;
      Self.X := (mat.m32 - mat.m23) * invS;
      Self.Y := (mat.m13 - mat.m31) * invS;
      Self.Z := (mat.m21 - mat.m12) * invS;
      Self.W := 0.25 * s;
   end else if ((mat.m11 > mat.m22) and (mat.m11 > mat.m33)) then begin  // Row 0:
      s := 2 * Sqrt(Max(cEpsilon30, cOne + mat.m11 - mat.m22 - mat.m33));
      invS:=1/s;
      Self.X := 0.25 * s;
      Self.Y := (mat.m12 + mat.m21) * invS;
      Self.Z := (mat.m31 + mat.m13) * invS;
      Self.W := (mat.m32 - mat.m23) * invS;
   end else if (mat.m22 > mat.m33) then begin  // Row 1:
      s:= 2 * Sqrt(Max(cEpsilon30, cOne + mat.m22 - mat.m11 - mat.m33));
      invS := 1 / s;
      Self.X := (mat.m12 + mat.m21) * invS;
      Self.Y := 0.25 * s;
      Self.Z := (mat.m23 + mat.m32) * invS;
      Self.W := (mat.m13 - mat.m31) * invS;
   end else begin  // Row 2:
      s := 2 * Sqrt(Max(cEpsilon30, cOne + mat.m33 - mat.m11 - mat.m22));
      invS := 1 / s;
      Self.X := (mat.m13 + mat.m31) * invS;
      Self.Y := (mat.m23 + mat.m32) * invS;
      Self.Z := 0.25 * s;
      Self.W := (mat.m21 - mat.m12) * invS;
   end;
   Self.Normalize;
end;

procedure TNativeBZQuaternion.Create(const Angle  : Single; const axis : TNativeBZAffineVector);
//procedure TNativeBZQuaternion.Create(const Angle  : Single; const axis : TBZVector);
var
   f, s, c : Single;
   vaxis : TNativeBZVector;
begin
   BZMath.SinCos(DegToRadian(Angle*cOneHalf), s, c);
   Self.RealPart:=c;
   vaxis.AsVector3f := axis;
   f:=s/vAxis.Length;
   Self.ImagePart.V[0]:=axis.V[0]*f;
   Self.ImagePart.V[1]:=axis.V[1]*f;
   Self.ImagePart.V[2]:=axis.V[2]*f;
end;

procedure TNativeBZQuaternion.Create(const y, p, r : Single); //Yaw Pitch Roll YZX order
var
  qr, qp, qy : TNativeBZQuaternion;
begin
   qr.Create(r, NativeZVector); // Create From Angle Axis
   qp.Create(p, NativeXVector);
   qy.Create(y, NativeYVector);

   Self:=qy * qp;
   Self:=Self * qr;
end;

procedure TNativeBZQuaternion.Create(const x, y, z: Single; eulerOrder : TBZEulerOrder);
const
   cEulerOrderRef : array [Low(TBZEulerOrder)..High(TBZEulerOrder)] of array [1..3] of Byte =
      ( (0, 1, 2), (0, 2, 1), (1, 0, 2),     // eulXYZ, eulXZY, eulYXZ,
        (1, 2, 0), (2, 0, 1), (2, 1, 0) );   // eulYZX, eulZXY, eulZYX


var
   q : array [0..2] of TNativeBZQuaternion;
begin
   {%H-}q[0].Create(X, NativeXVector); // Create From Angle Axis
   q[1].Create(Y, NativeYVector);
   q[2].Create(Z, NativeZVector);
   Self := (q[cEulerOrderRef[eulerOrder][1]] * q[cEulerOrderRef[eulerOrder][2]]);
   Self := self *q[cEulerOrderRef[eulerOrder][3]];
end;

procedure TNativeBZQuaternion.Create(const EulerAngles : TBZEulerAngles; eulerOrder : TBZEulerOrder);
begin
  Self.Create(EulerAngles.Roll,EulerAngles.Yaw,EulerAngles.Pitch, eulerOrder);
end;


//procedure TNativeBZQuaternion.ConvertToPoints(var ArcFrom, ArcTo: TNativeBZAffineVector);
////procedure ConvertToPoints(var ArcFrom, ArcTo: TBZVector); //overload;
//var
//   s, invS : Single;
//begin
//   s:=Self.ImagePart.X*Self.ImagePart.X+Self.ImagePart.Y*Self.ImagePart.Y;
//   if s=0 then ArcFrom := NativeAffineVectorMake( 0, 1, 0)
//   else
//   begin
//      invS:=InvSqrt(s);
//      ArcFrom := NativeAffineVectorMake( -Self.ImagePart.Y*invS, Self.ImagePart.X*invS, 0);
//   end;
//   ArcTo.X:=Self.RealPart*ArcFrom.X-Self.ImagePart.Z*ArcFrom.Y;
//   ArcTo.Y:=Self.RealPart*ArcFrom.Y+Self.ImagePart.Z*ArcFrom.X;
//   ArcTo.Z:=Self.ImagePart.X*ArcFrom.Y-Self.ImagePart.Y*ArcFrom.X;
//   if Self.RealPart<0 then ArcFrom := NativeAffineVectorMake( -ArcFrom.X, -ArcFrom.Y, 0);
//end;

function TNativeBZQuaternion.ConvertToMatrix : TNativeBZMatrix;
 var
   xx, xy, xz, xw, yy, yz, yw, zz, zw: Single;
begin
   Self.Normalize;
   xx := x * x;
   xy := x * y;
   xz := x * z;
   xw := x * w;
   yy := y * y;
   yz := y * z;
   yw := y * w;
   zz := z * z;
   zw := z * w;
   Result.V[0].V[0] := 1 - 2 * ( yy + zz );
   Result.V[1].V[0] :=     2 * ( xy + zw );
   Result.V[2].V[0] :=     2 * ( xz - yw );
   Result.V[3].V[0] := 0;
   Result.V[0].V[1] :=     2 * ( xy - zw );
   Result.V[1].V[1] := 1 - 2 * ( xx + zz );
   Result.V[2].V[1] :=     2 * ( yz + xw );
   Result.V[3].V[1] := 0;
   Result.V[0].V[2] :=     2 * ( xz + yw );
   Result.V[1].V[2] :=     2 * ( yz - xw );
   Result.V[2].V[2] := 1 - 2 * ( xx + yy );
   Result.V[3].V[2] := 0;
   Result.V[0].V[3] := 0;
   Result.V[1].V[3] := 0;
   Result.V[2].V[3] := 0;
   Result.V[3].V[3] := 1;
end;

class operator TNativeBZQuaternion.*(constref A, B: TNativeBZQuaternion): TNativeBZQuaternion;
begin
  Result.X :=  (A.w * B.x) + (A.x * B.w) + (A.y * B.z) - (A.z * B.y);
  Result.Y :=  (A.w * B.y) - (A.x * B.z) + (A.y * B.w) + (A.z * B.x);
  Result.Z :=  (A.w * B.z) + (A.x * B.y) - (A.y * B.x) + (A.z * B.w);
  Result.W :=  (A.w * B.w) - (A.x * B.x) - (A.y * B.y) - (A.z * B.z);
end;

function TNativeBZQuaternion.MultiplyAsSecond(const qFirst : TNativeBZQuaternion): TNativeBZQuaternion;
Begin
  Result.X :=  (QFirst.w * Self.x) + (QFirst.x * Self.w) + (QFirst.y * Self.z) - (QFirst.z * Self.y);
  Result.Y :=  (QFirst.w * Self.y) - (QFirst.x * Self.z) + (QFirst.y * Self.w) + (QFirst.z * Self.x);
  Result.Z :=  (QFirst.w * Self.z) + (QFirst.x * Self.y) - (QFirst.y * Self.x) + (QFirst.z * Self.w);
  Result.W :=  (QFirst.w * Self.w) - (QFirst.x * Self.x) - (QFirst.y * Self.y) - (QFirst.z * Self.z);
end;


function TNativeBZQuaternion.Slerp(const QEnd: TNativeBZQuaternion; Spin: Integer; t: Single): TNativeBZQuaternion;
begin
  Result := Self.Slerp(Qend,t*spin);
end;

function TNativeBZQuaternion.Slerp(const QEnd: TNativeBZQuaternion; const t : Single) : TNativeBZQuaternion;
var
   to1: array[0..4] of Single;
   omega, cosom, sinom, scale0, scale1: Extended;
// t goes from 0 to 1
// absolute rotations
begin
   // calc cosine
   cosom:= Self.ImagePart.X*QEnd.ImagePart.X
          +Self.ImagePart.Y*QEnd.ImagePart.Y
          +Self.ImagePart.Z*QEnd.ImagePart.Z
	  +Self.RealPart   *QEnd.RealPart;
   // adjust signs (if necessary)
   if cosom<0 then
   begin
      cosom := -cosom;
      to1[0] := - QEnd.ImagePart.X;
      to1[1] := - QEnd.ImagePart.Y;
      to1[2] := - QEnd.ImagePart.Z;
      to1[3] := - QEnd.RealPart;
   end
   else
   begin
      to1[0] := QEnd.ImagePart.X;
      to1[1] := QEnd.ImagePart.Y;
      to1[2] := QEnd.ImagePart.Z;
      to1[3] := QEnd.RealPart;
   end;
   // calculate coefficients
   if ((1.0-cosom)>cEpsilon30) then // standard case (slerp)
   begin
      omega:=BZMath.ArcCos(cosom);
      sinom:=1/Sin(omega);
      scale0:=Sin((1.0-t)*omega)*sinom;
      scale1:=Sin(t*omega)*sinom;
   end
   else  // "from" and "to" quaternions are very close
   begin
      //  ... so we can do a linear interpolation
      scale0:=1.0-t;
      scale1:=t;
   end;
   // calculate final values
   Result.ImagePart.V[0] := scale0 * Self.ImagePart.V[0] + scale1 * to1[0];
   Result.ImagePart.V[1] := scale0 * Self.ImagePart.V[1] + scale1 * to1[1];
   Result.ImagePart.V[2] := scale0 * Self.ImagePart.V[2] + scale1 * to1[2];
   Result.RealPart       := scale0 * Self.RealPart       + scale1 * to1[3];
   //NormalizeQuaternion(Result);
   //Result.pNormalize;
   Result.Normalize;
end;

// Get euler Angle from rotation matrix
// http://www.euclideanspace.com/maths/geometry/rotations/conversions/matrixToEuler/index.htm
// https://www.learnopencv.com/rotation-matrix-to-euler-Angles/
// http://www.euclideanspace.com/maths/geometry/rotations/conversions/matrixToAngle/derivation/index.htm
// http://www.euclideanspace.com/maths/geometry/rotations/for/index.htm

// @TODO : Take care of singularity at pole SUD  <-0.999999
function TNativeBZQuaternion.ConvertToEuler(Const EulerOrder : TBZEulerOrder) : TBZEulerAngles;
var
  rm : TNativeBZMatrix;
  m11,m12,m13,m21,m22,m23,m31,m32,m33 : Double;
begin
  rm := Self.ConvertToMatrix;
  // Rotation X
  m11 := rm.m11;
  m12 := Clamp(rm.m12,-1,1);
  m13 := Clamp(rm.m13,-1,1);
  // Rotation Y
  m21 := Clamp(rm.m21,-1,1);
  m22 := rm.m22;
  m23 := Clamp(rm.m23,-1,1);
  // Rotation Z
  m31 := Clamp(rm.m31,-1,1);
  m32 := Clamp(rm.m32,-1,1);
  m33 := rm.m33;

  // Remember :
  // ROLL = X ; YAW = Y ; PITCH = Z
  case EulerOrder of
    eulXYZ :
      begin
        Result.Yaw := ArcSin(m31);
        if Abs(m31) < 0.99999 then
        begin
          Result.Roll := ArcTan2(-m32,m33);
          Result.Pitch := ArcTan2(-m21,m11)
          //Yaw := -cPIDiv2; //DegToRad(-90);
        end
        else
        // if abs(m20)> 0.99999
        begin
          Result.Roll := ArcTan2(m23,m22);
          Result.Pitch := 0;
        end;
      end;
    eulXZY :
      begin
        Result.Pitch := ArcSin(m21);
        if Abs(m21) < 0.99999 then
        begin
           Result.Roll := ArcTan2(m23,m22);
           Result.Yaw := ArcTan2(m31,m11);
        end
        else
        begin
          Result.Roll := ArcTan2(-m32,m33);
          Result.Yaw := 0;
        end;
      end;
    eulYXZ :
      begin
        Result.Roll := ArcSin(-m32);
        if Abs(m32)< 0.99999 then
        begin
          Result.Yaw :=ArcTan2(m31,m33);
          Result.Pitch := ArcTan2(m12,m22);
        end
        else
        begin
          Result.Yaw := ArcTan2(-m13,m11);
          Result.Pitch := 0;
        end;
      end;
    eulYZX :
      begin
        Result.Pitch := ArcSin(m12);
        if Abs(m12) < 0.99999 then
        begin
          Result.Roll := ArcTan2(-m32,m22);
          Result.Yaw := ArcTan2(-m13,m11);
        end
        else
        begin
          Result.Roll := 0;
          Result.Yaw := ArcTan2(m31,m33);
        end;
      end;
    eulZXY :
      begin
        Result.Roll := ArcSin(m23);
        if Abs(m21)< 0.99999 then
        begin
          Result.Yaw := ArcTan2(-m13,m33);
          Result.Pitch := ArcTan2(-m21,m22);
        end
        else
        begin
          Result.Yaw := 0;
          Result.Pitch := ArcTan2(m12,m11);
        end;
      end;
    eulZYX :
      begin
        Result.Yaw := ArcSin(m13);
        if Abs(m13) < 0.99999 then
        begin
          Result.Roll := ArcTan2(m23,m33);
          Result.Pitch := ArcTan2(m12,m11);
        end
        else
        begin
          Result.Roll := 0;
          Result.Pitch :=  ArcTan2(-m21,m22);
        end;
      end;
  end;
  Result.Roll := RadToDeg(Result.Roll);
  Result.Pitch := RadToDeg(Result.Pitch);
  Result.Yaw := RadToDeg(Result.Yaw);
end;

procedure TNativeBZQuaternion.ConvertToAngleAxis(out Angle  : Single; out axis : TNativeBZAffineVector);
var
  qw2: Double;
  den: Double;
begin
  qw2 := Self.RealPart*Self.RealPart;
  Angle := RadToDeg(2*ArcCos(Self.RealPart));
  den := Sqrt(1-qw2);
  if den <> 0 then
  begin
    Axis.x := Self.X/den;
    Axis.y := Self.Y/den;
    Axis.z := Self.Z/den;
  end
  else
  begin
    Axis.x := 0;
    Axis.y := 0;
    Axis.z := 0;
  end;
end;

{%endregion%}

{%endregion%}

{%region%----[ TNativeBZHmgPlane Helper ]--------------------------------------}

procedure TNativeBZHmgPlane.Create(constref point, normal : TNativeBZVector);
begin
   Self.AsNormal3 := normal.AsVector3f;
   Self.W:=-(Point.DotProduct(normal));
end;

procedure TNativeBZHmgPlane.Create(constref p1, p2, p3 : TNativeBZVector);
begin
  CalcNormal(p1, p2, p3);
  Self.W:=-(p1.DotProduct(Self.AsVector));
end;

procedure TNativeBZHmgPlane.CalcNormal(constref p1, p2, p3 : TNativeBZVector);
var
   v1, v2 : TNativeBZVector;
begin
   v1:=p2-p1;
   v2:=p3-p1;
   Self.AsVector:=v1.CrossProduct(v2);
   Self.AsVector:=Self.AsVector.Normalize;
end;

function TNativeBZHmgPlane.Distance(constref point : TNativeBZVector) : Single;
begin
   result:= (Self.X*Point.X) + (Self.Y*Point.Y) + (Self.Z*Point.Z) + Self.W;
end;

function TNativeBZHmgPlane.AbsDistance(constref point : TNativeBZVector) : Single;
begin
   result:= System.Abs((Self.X*Point.X) + (Self.Y*Point.Y) + (Self.Z*Point.Z) + Self.W );
end;

function TNativeBZHmgPlane.Distance(constref Center : TNativeBZVector; constref Radius:Single) : Single;
var dist : Single;
begin
  dist := Self.Distance(Center);
  result := 0.0;
  if(Abs(dist) > Radius) then
    if Dist > 0 then
      result := dist - radius
    else
      result := dist + radius;
end;

function TNativeBZHmgPlane.Normalized:TNativeBZHmgPlane;
begin
   Result := Self;
   Result.Normalize;
end;

procedure TNativeBZHmgPlane.Normalize;
var
   n : Single;
begin
   n:=1/Sqrt(Self.X*Self.X+Self.Y*Self.Y+Self.Z*Self.Z);
   Self.AsVector := Self.AsVector * n;
end;

function TNativeBZHmgPlane.IsInHalfSpace(constref point: TNativeBZVector) : Boolean;
begin
 Result := ((Self.X*Point.X) + (Self.Y*Point.Y) + (Self.Z*Point.Z) + Self.W) > 0;
end;
function TNativeBZHmgPlane.Perpendicular(constref P : TNativeBZVector4f) : TNativeBZVector4f;
var
   dot : Single;
begin
  dot:= Self.AsVector.DotProduct(P);
  Result.X:=P.X - (Dot * Self.X);
  Result.Y:=P.Y - (Dot * Self.Y);
  Result.Z:=P.Z - (Dot * Self.Z);
  Result.W:=P.W;
end;

function TNativeBZHmgPlane.Reflect(constref V: TNativeBZVector4f): TNativeBZVector4f;
begin
  //  Result:=Self.Combine(Self, N, 1, -2*VectorDotProduct(Self, N));
  //  Result := Self - (N*(2 * N.Dotproduct(Self)));
    Result :=  V - (Self.AsVector * (2 * V.DotProduct(Self.AsVector)));
 // Result.W:=0;
end;
function TNativeBZHmgPlaneHelper.Contains(const TestBSphere: TNativeBZBoundingSphere): TBZSpaceContains;
var
   Dist: Single;
begin
  Dist := self.Distance(TestBSphere.Center);

  if Abs(Dist) < TestBSphere.Radius then
    Result := ScContainsPartially
  else if Dist < 0 then
    Result :=  ScNoOverlap
  else
    Result := ScContainsFully;
end;

{%endregion%}

{%region%----[ 2i Helper ]------------------------------------------------------}

function TNativeBZVector2iHelper.Normalize : TNativeBZVector2f;
begin
  Result.Create(Self.X,Self.Y);
  Result := Result.Normalize;
end;
{%endregion%}

{%region%----[ TNativeBZVector2fHelper ]---------------------------------------}


// Swizzling

function TNativeBZVector2fHelper.GetXY : TNativeBZVector2f;
begin
   Result.Create(Self.X,Self.Y);
end;

function TNativeBZVector2fHelper.GetYX : TNativeBZVector2f;
begin
   Result.Create(Self.Y,Self.X);
end;

function TNativeBZVector2fHelper.GetXX : TNativeBZVector2f;
begin
   Result.Create(Self.X,Self.X);
end;

function TNativeBZVector2fHelper.GetYY : TNativeBZVector2f;
begin
   Result.Create(Self.Y,Self.Y);
end;


function TNativeBZVector2fHelper.GetXXY : TNativeBZVector4f;
begin
  Result.X := Self.X;
  Result.Y := Self.X;
  Result.Z := Self.Y;
  Result.W := 1;
end;

function TNativeBZVector2fHelper.GetYYY : TNativeBZVector4f;
begin
  Result.X := Self.Y;
  Result.Y := Self.Y;
  Result.Z := Self.Y;
  Result.W := 1;
end;

function TNativeBZVector2fHelper.GetXXX : TNativeBZVector4f;
begin
  Result.X := Self.X;
  Result.Y := Self.X;
  Result.Z := Self.X;
  Result.W := 1;
end;

function TNativeBZVector2fHelper.GetYYX : TNativeBZVector4f;
begin
  Result.X := Self.Y;
  Result.Y := Self.Y;
  Result.Z := Self.X;
  Result.W := 1;
end;

function TNativeBZVector2fHelper.GetXYY : TNativeBZVector4f;
begin
  Result.X := Self.X;
  Result.Y := Self.Y;
  Result.Z := Self.Y;
  Result.W := 1;
end;

function TNativeBZVector2fHelper.GetYXY : TNativeBZVector4f;
begin
  Result.X := Self.Y;
  Result.Y := Self.X;
  Result.Z := Self.Y;
  Result.W := 1;
end;

function TNativeBZVector2fHelper.GetXYX : TNativeBZVector4f;
begin
  Result.X := Self.X;
  Result.Y := Self.Y;
  Result.Z := Self.X;
  Result.W := 1;
end;

function TNativeBZVector2fHelper.GetYXX : TNativeBZVector4f;
begin
  Result.X := Self.Y;
  Result.Y := Self.X;
  Result.Z := Self.X;
  Result.W := 1;
end;

function TNativeBZVector2fHelper.Step(ConstRef B : TNativeBZVector2f):TNativeBZVector2f;
begin
  result := Self;
  if self.X <= B.X then result.X := 0;
  if self.Y <= B.Y then result.Y := 0;
end;

//function TBZVectorHelper.FaceForward(constref A, B: TBZVector4f): TBZVector4f;
//begin
//  if (B.DotProduct(A) < 0) then
//     Result := -Self
//   else
//     Result := Self;
//end;

function TNativeBZVector2fHelper.Saturate : TNativeBZVector2f;
begin
  Result := self;
  Result := Result.Max(NativeNullVector2f);
  Result := Result.Min(NativeOneVector2f);
end;

function TNativeBZVector2fHelper.SmoothStep(ConstRef A,B : TNativeBZVector2f): TNativeBZVector2f;
var
  t: TNativeBZVector2f;
begin
  t := (Self-a)/(b-a);
  t := t.Saturate;
  // t * t * (3.0 - (t * 2.0)); <--- no overload for Single - vector
  result := t * t * -((t * 2.0) + -3);
end;

function TNativeBZVector2fHelper.Lerp(Constref B: TNativeBZVector2f; Constref T:Single): TNativeBZVector2f;
begin
  result := Self + (b-self)*t;
end;

{%endregion%}

{%region%----[ TNativeBZVectorHelper ]-----------------------------------------}

function TNativeBZVectorHelper.Rotate(constref axis : TNativeBZVector; Angle : Single):TNativeBZVector;
var
   rotMatrix : TNativeBZMatrix;
begin
   rotMatrix.CreateRotationMatrix(axis, Angle);
   Result := rotMatrix * Self;
end;

function TNativeBZVectorHelper.RotateWithMatrixAroundX(alpha : Single) : TNativeBZVector;
var
   rotMatrix : TNativeBZMatrix;
begin
   rotMatrix.CreateRotationMatrixX(Alpha);
   Result:= rotMatrix * Self;
end;

function TNativeBZVectorHelper.RotateWithMatrixAroundY(alpha : Single) : TNativeBZVector;
var
   rotMatrix : TNativeBZMatrix;
begin
   rotMatrix.CreateRotationMatrixY(Alpha);
   Result:= rotMatrix * Self;
end;

function TNativeBZVectorHelper.RotateWithMatrixAroundZ(alpha : Single) : TNativeBZVector;
var
   rotMatrix : TNativeBZMatrix;
begin
   rotMatrix.CreateRotationMatrixZ(Alpha);
   Result:= rotMatrix * Self;
end;

function TNativeBZVectorHelper.RotateAroundX( alpha : Single) : TNativeBZVector;
var
   c, s : Single;
begin
  SinCos(alpha, s, c);
  Result.X := Self.X;
  Result.Y := c * Self.Y - s * Self.Z;
  Result.Z := c * Self.Z + s * Self.Y;
  Result.W := Self.W
end;

function TNativeBZVectorHelper.RotateAroundY(alpha : Single) : TNativeBZVector;
var
   c, s : Single;
begin
  SinCos(alpha, s, c);
  Result.X := c * Self.X + s * Self.Z;
  Result.Y := Self.Y;
  Result.Z := c * Self.Z - s * Self.X;
  Result.W := Self.W
end;

function TNativeBZVectorHelper.RotateAroundZ(alpha : Single) : TNativeBZVector;
var
   c, s : Single;
begin
  SinCos(alpha, s, c);
  Result.X := c * Self.Y - s * Self.X;
  Result.Y := c * Self.X + s * Self.Y;
  Result.Z := Self.Z;
  Result.W := Self.W
end;

function TNativeBZVectorHelper.MoveAround(constref AMovingObjectUp, ATargetPosition: TNativeBZVector;pitchDelta, turnDelta: Single): TNativeBZVector;
var
  originalT2C, normalT2C, normalCameraRight: TNativeBZVector;
  pitchNow, dist: Single;
begin
    // normalT2C points away from the direction the camera is looking
    originalT2C := Self - ATargetPosition;
    normalT2C := originalT2C;
    dist := normalT2C.Length;
    normalT2C := normalT2C.Normalize;
    // normalRight points to the camera's right
    // the camera is pitching around this axis.
    normalCameraRight := AMovingObjectUp.CrossProduct(normalT2C);
    if normalCameraRight.Length < 0.001 then
      normalCameraRight:= NativeXHmgVector // arbitrary vector
    else
      normalCameraRight := normalCameraRight.Normalize;
    // calculate the current pitch.
    // 0 is looking down and PI is looking up
    pitchNow := ArcCos(AMovingObjectUp.DotProduct(normalT2C));
    pitchNow := BZMath.Clamp(pitchNow - DegToRadian(pitchDelta), 0 + 0.025, cPI - 0.025);
    // create a new vector pointing up and then rotate it down
    // into the new position
    normalT2C := AMovingObjectUp;
    normalT2C := normalT2C.Rotate(normalCameraRight, pitchNow);
    normalT2C := normalT2C.Rotate(AMovingObjectUp, DegToRadian(turnDelta));
    normalT2C := normalT2C * dist;
    Result := Self + (normalT2C - originalT2C);
end;

function TNativeBZVectorHelper.PointProject(constref origin, direction : TNativeBZVector) : Single;
begin
   Result:= direction.X*(Self.X-origin.X)
           +direction.Y*(Self.Y-origin.Y)
           +direction.Z*(Self.Z-origin.Z);
end;

function TNativeBZVectorHelper.ShiftObjectFromCenter(Constref
  ACenter : TNativeBZVector; const ADistance : Single;
  const AFromCenterSpot : Boolean) : TNativeBZVector;
var
  lDirection: TNativeBZVector;
begin
  lDirection := Self - ACenter;
  lDirection := lDirection.Normalize;
  if AFromCenterSpot then Result := ACenter + (lDirection * ADistance)
  else Result := Self + (lDirection * ADistance)
end;

{gets the normal at cen based on the connected quad mesh vectors}
function TNativeBZVectorHelper.AverageNormal4(constref up, left, down,right: TNativeBZVector): TNativeBZVector;
var
  s,t,u,r: TNativeBZVector4f;
begin
  s := up - self;
  t := left - self;
  u := down - self;
  r := right - self;
  Result.X := s.Y*t.Z - s.Z*t.Y + t.Y*u.Z - t.Z*u.Y + u.Y*r.Z - u.Z*r.Y + r.Y*s.Z - r.Z*s.Y;
  Result.Y := s.Z*t.X - s.X*t.Z + t.Z*u.X - t.x*u.Z + u.Z*r.X - u.X*r.Z + r.Z*s.X - r.X*s.Z;
  Result.Z := s.X*t.Y - s.Y*t.X + t.X*u.Y - t.Y*u.X + u.X*r.Y - u.Y*r.X + r.X*s.Y - r.Y*s.X;
  Result.W := 0;
  Result := Result.Normalize;
end;

function TNativeBZVectorHelper.ExtendClipRect(vX, vY: Single) : TNativeBZClipRect;
begin
  Result := Self;
  with Result do
  begin
    if vX < Left then Left := vX;
    if vY < Top then Top := vY;

    if vX > Right then Right := vX;
    if vY > Bottom then Bottom := vY;
  end;
end;

function TNativeBZVectorHelper.Step(ConstRef B : TNativeBZVector) : TNativeBZVector;
begin
  result := Self;
  if self.X <= B.X then result.X := 0;
  if self.Y <= B.Y then result.Y := 0;
  if self.Z <= B.Z then result.Z := 0;
  if self.W <= B.W then result.W := 0;
end;

function TNativeBZVectorHelper.FaceForward(constref A, B : TNativeBZVector) : TNativeBZVector;
begin
  if (B.DotProduct(A) < 0) then
     Result := -Self
   else
     Result := Self;
end;

function TNativeBZVectorHelper.Saturate : TNativeBZVector;
begin
  Result := Self.Min(NativeXYZWHmgVector);
  Result := Result.Max(NativeNullHmgVector);
end;

function TNativeBZVectorHelper.SmoothStep(ConstRef  A,B : TNativeBZvector): TNativeBZVector;
var
  t: TNativeBZVector;
begin
  t := (Self-a)/(b-a);
  t := t.Saturate;
  // t * t * (3.0 - (t * 2.0)); <--- no overload for Single - vector
  result := t * t * -((t * 2.0) + -3);
end;

function TNativeBZVectorHelper.Reflect(ConstRef N: TNativeBZVector4f): TNativeBZVector4f;
var
  d : Single;
begin
  //Self - (N*(N.DotProduct(Self)*2));
  d:= N.DotProduct(Self);
  d:=d+d;
  Result := Self - (N*d);
end;

function TNativeBZVectorHelper.GetXY : TNativeBZVector2f;
begin
  result.Create(Self.X,Self.Y);
end;

function TNativeBZVectorHelper.GetYX : TNativeBZVector2f;
begin
  result.Create(Self.Y,Self.X);
end;

function TNativeBZVectorHelper.GetXZ : TNativeBZVector2f;
begin
  result.Create(Self.X,Self.Z);
end;

function TNativeBZVectorHelper.GetZX : TNativeBZVector2f;
begin
  result.Create(Self.Z,Self.X);
end;

function TNativeBZVectorHelper.GetYZ : TNativeBZVector2f;
begin
  result.Create(Self.Y,Self.Z);
end;

function TNativeBZVectorHelper.GetZY : TNativeBZVector2f;
begin
  result.Create(Self.Z,Self.Y);
end;

function TNativeBZVectorHelper.GetXX : TNativeBZVector2f;
begin
  result.Create(Self.X,Self.X);
end;

function TNativeBZVectorHelper.GetYY : TNativeBZVector2f;
begin
  result.Create(Self.Y,Self.Y);
end;

function TNativeBZVectorHelper.GetZZ : TNativeBZVector2f;
begin
  result.Create(Self.Z,Self.Z);
end;

function TNativeBZVectorHelper.GetXYZ : TNativeBZVector4f;
begin
  result.CreateAffine(Self.X,Self.Y,Self.Z);
end;

function TNativeBZVectorHelper.GetXZY : TNativeBZVector4f;
begin
  result.CreateAffine(Self.X,Self.Z,Self.Y);
end;

function TNativeBZVectorHelper.GetYXZ : TNativeBZVector4f;
begin
  result.CreateAffine(Self.Y,Self.X,Self.Z);
end;

function TNativeBZVectorHelper.GetYZX : TNativeBZVector4f;
begin
  result.CreateAffine(Self.Y,Self.Z,Self.X);
end;

function TNativeBZVectorHelper.GetZXY : TNativeBZVector4f;
begin
  result.CreateAffine(Self.Z,Self.X,Self.Y);
end;

function TNativeBZVectorHelper.GetZYX : TNativeBZVector4f;
begin
  result.CreateAffine(Self.Z,Self.Y,Self.X);
end;

function TNativeBZVectorHelper.GetXXX : TNativeBZVector4f;
begin
  result.CreateAffine(Self.X,Self.X,Self.X);
end;

function TNativeBZVectorHelper.GetYYY : TNativeBZVector4f;
begin
  result.CreateAffine(Self.Y,Self.Y,Self.Y);
end;

function TNativeBZVectorHelper.GetZZZ : TNativeBZVector4f;
begin
  result.CreateAffine(Self.Z,Self.Z,Self.Z);
end;

function TNativeBZVectorHelper.GetYYX : TNativeBZVector4f;
begin
  result.CreateAffine(Self.Y,Self.Y,Self.X);
end;

function TNativeBZVectorHelper.GetXYY : TNativeBZVector4f;
begin
  result.CreateAffine(Self.X,Self.Y,Self.Y);
end;

function TNativeBZVectorHelper.GetYXY : TNativeBZVector4f;
begin
  result.CreateAffine(Self.Y,Self.X,Self.Y);
end;

{%endregion%}

{%region%----[ TNativeBZMatrixHelper ]-----------------------------------------}

// Turn (Y axis)
function TNativeBZMatrixHelper.Turn( Angle: Single): TNativeBZMatrix;
var
  m : TNativeBZMatrix;
begin
  m.CreateRotationMatrix(NativeAffineVectorMake(Self.V[1].V[0], Self.V[1].V[1], Self.V[1].V[2]), Angle);
  Result:=Self * m;
end;

// Turn (direction)
function TNativeBZMatrixHelper.Turn(constref MasterUp: TNativeBZVector; Angle: Single): TNativeBZMatrix;
var
  m : TNativeBZMatrix;
begin
  m.CreateRotationMatrix(MasterUp, Angle);
  Result:=Self * m;
end;

// Pitch (X axis)
function TNativeBZMatrixHelper.Pitch(Angle: Single): TNativeBZMatrix;
var
  m : TNativeBZMatrix;
begin
  m.CreateRotationMatrix(NativeAffineVectorMake(Self.V[0].V[0], Self.V[0].V[1], Self.V[0].V[2]), Angle);
  Result:=Self * m;
end;

// Pitch (direction)
function TNativeBZMatrixHelper.Pitch(constref MasterRight: TNativeBZVector; Angle: Single): TNativeBZMatrix;
var
  m : TNativeBZMatrix;
begin
  m.CreateRotationMatrix(MasterRight, Angle);
  Result := Self * m;
end;

// Roll (Z axis)
function TNativeBZMatrixHelper.Roll(Angle: Single): TNativeBZMatrix;
var
  m : TNativeBZMatrix;
begin
  m.CreateRotationMatrix(NativeAffineVectorMake(Self.V[2].V[0], Self.V[2].V[1], Self.V[2].V[2]), Angle);
  Result := Self * m;
end;

// Roll (direction)
function TNativeBZMatrixHelper.Roll(constref MasterDirection: TNativeBZVector; Angle: Single): TNativeBZMatrix;
var
  m : TNativeBZMatrix;
begin
  m.CreateRotationMatrix(MasterDirection, Angle);
  Result := Self * m;
end;

{%endregion%}

{%region%----[ TNativeBZBoundingBox ]------------------------------------------}
type
  TPlanIndices = array [0 .. 3] of Integer;
  TPlanBB = array [0 .. 5] of TPlanIndices;
  TDirPlan = array [0 .. 5] of Integer;

const
  CBBFront: TPlanIndices = (0, 1, 2, 3);
  CBBBack: TPlanIndices = (4, 5, 6, 7);
  CBBLeft: TPlanIndices = (0, 4, 7, 3);
  CBBRight: TPlanIndices = (1, 5, 6, 2);
  CBBTop: TPlanIndices = (0, 1, 5, 4);
  CBBBottom: TPlanIndices = (2, 3, 7, 6);
  CBBPlans: TPlanBB = ((0, 1, 2, 3), (4, 5, 6, 7), (0, 4, 7, 3), (1, 5, 6, 2),
    (0, 1, 5, 4), (2, 3, 7, 6));
  CDirPlan: TDirPlan = (0, 0, 1, 1, 2, 2);


procedure SetPlanBB(Var A:TNativeBZBoundingBox;const NumPlan: Integer; const Valeur: Double);
var
  I: Integer;
begin
  for I := 0 to 3 do
  begin
    A.Points[CBBPlans[NumPlan][I]].V[CDirPlan[NumPlan]] := Valeur;
    A.Points[CBBPlans[NumPlan][I]].V[3] := 1;
  end;
end;

procedure TNativeBZBoundingBox.Create(Const AValue : TNativeBZVector);
begin
  SetPlanBB(Self, 0,  AValue.X);
  SetPlanBB(Self, 1, -AValue.X);
  SetPlanBB(Self, 2,  AValue.Y);
  SetPlanBB(Self, 3, -AValue.Y);
  SetPlanBB(Self, 4,  AValue.Z);
  SetPlanBB(Self, 5, -AValue.Z);
end;

class operator TNativeBZBoundingBox.+(ConstRef A, B : TNativeBZBoundingBox):TNativeBZBoundingBox;overload;
var
  I, J: Integer;
  C1, C2 : TNativeBZBoundingBox;
begin
  C1 := A;
  C2 := B;
  for I := 0 to 7 do
  begin
    for J := 0 to 3 do
      if C1.Points[CBBFront[J]].X < C2.Points[I].X then SetPlanBB(C1, 0, C2.Points[I].X);
    for J := 0 to 3 do
      if C1.Points[CBBBack[J]].X > C2.Points[I].X then SetPlanBB(C1, 1, C2.Points[I].X);
    for J := 0 to 3 do
      if C1.Points[CBBLeft[J]].Y < C2.Points[I].Y then SetPlanBB(C1, 2, C2.Points[I].Y);
    for J := 0 to 3 do
      if C1.Points[CBBRight[J]].Y > C2.Points[I].Y then SetPlanBB(C1, 3, C2.Points[I].Y);
    for J := 0 to 3 do
      if C1.Points[CBBTop[J]].Z < C2.Points[I].Z then SetPlanBB(C1, 4, C2.Points[I].Z);
    for J := 0 to 3 do
      if C1.Points[CBBBottom[J]].Z > C2.Points[I].Z then SetPlanBB(C1, 5, C2.Points[I].Z);
  end;
  Result := C1;
end;

class operator TNativeBZBoundingBox.+(ConstRef A: TNativeBZBoundingBox; ConstRef B : TNativeBZVector):TNativeBZBoundingBox;
var
  I: Integer;
begin
  for I := 0 to 7 do
   result.Points[I] := A.Points[I] + B;
end;

class operator TNativeBZBoundingBox.=(ConstRef A, B : TNativeBZBoundingBox):Boolean;
begin
  Result := CompareMem(@A, @B, SizeOf(TNativeBZBoundingBox));

(*  Result := (A.Points[0] = B.Points[0]) and
            (A.Points[1] = B.Points[1]) and
            (A.Points[2] = B.Points[2]) and
            (A.Points[3] = B.Points[3]) and
            (A.Points[4] = B.Points[4]) and
            (A.Points[5] = B.Points[5]) and
            (A.Points[6] = B.Points[6]) and
            (A.Points[7] = B.Points[7]); *)
end;

function TNativeBZBoundingBox.Transform(ConstRef M:TNativeBZMAtrix):TNativeBZBoundingBox;
var
  I: Integer;
begin
  Result := Self;
  for I := 0 to 7 do
    Result.Points[I] := M * Result.Points[I];
end;

function TNativeBZBoundingBox.MinX : Single;
var
  I: Integer;
begin
  Result := Self.Points[0].X;
  for I := 1 to 7 do
    Result := Math.Min(Result, Self.Points[I].X);
end;

function TNativeBZBoundingBox.MaxX : Single;
var
  I: Integer;
begin
  Result := Self.Points[0].X;
  for I := 1 to 7 do
    Result := Math.Max(Result, Self.Points[I].X);
end;

function TNativeBZBoundingBox.MinY : Single;
var
  I: Integer;
begin
  Result := Self.Points[0].Y;
  for I := 1 to 7 do
    Result := Math.Min(Result, Self.Points[I].y);
end;

function TNativeBZBoundingBox.MaxY : Single;
var
  I: Integer;
begin
  Result := Self.Points[0].Y;
  for I := 1 to 7 do
    Result := Math.Max(Result, Self.Points[I].Y);
end;

function TNativeBZBoundingBox.MinZ : Single;
var
  I: Integer;
begin
  Result := Self.Points[0].Z;
  for I := 1 to 7 do
    Result := Math.Min(Result, Self.Points[I].Z);
end;

function TNativeBZBoundingBox.MaxZ : Single;
var
  I: Integer;
begin
  Result := Self.Points[0].Z;
  for I := 1 to 7 do
    Result := Math.Max(Result, Self.Points[I].Z);
end;

{%endregion}

{%region%----[ TNativeBZBoundingSphere ]---------------------------------------}

procedure TNativeBZBoundingSphere.Create(Const x,y,z: Single;Const r: Single = 1.0);
begin
 Center.Create(x,y,z,1);
 Radius := r;
end;

procedure TNativeBZBoundingSphere.Create(Const AValue : TNativeBZAffineVector;Const r: Single = 1.0);
begin
  Center.Create(AValue,1);
  Radius := r;
end;

procedure TNativeBZBoundingSphere.Create(Const AValue : TNativeBZVector;Const r: Single = 1.0);
begin
  Center := AValue;
  Center.W := 1;
  Radius := r;
end;

function TNativeBZBoundingSphere.ToString: String;
begin
  Result := '{' +Self.Center.ToString + ' R: ' + FloattoStrF(Self.Radius,fffixed,5,5) + '}';
end;

function TNativeBZBoundingSphere.Contains(const TestBSphere: TNativeBZBoundingSphere) : TBZSpaceContains;
var
  D2: Single;
begin
  D2 := Self.Center.DistanceSquare(TestBSphere.Center); // VectorDistance2(MainBSphere.Center, TestBSphere.Center);

  if D2 < Sqr(Self.Radius + TestBSphere.Radius) then
  begin
    if D2 < Sqr(Self.Radius - TestBSphere.Radius) then Result := ScContainsFully
    else
      Result := ScContainsPartially;
  end
  else Result := ScNoOverlap;
end;

function TNativeBZBoundingSphere.Intersect(const TestBSphere: TNativeBZBoundingSphere): Boolean;
begin
  Result := Self.Center.DistanceSquare(TestBSphere.Center) < Sqr(Self.Radius + TestBSphere.Radius);
end;

{%endregion}

{%region%----[ TNativeBZAxisAlignedBoundingBox ]-------------------------------}


procedure TNativeBZAxisAlignedBoundingBox.Create(const AValue: TNativeBZVector);
begin
  Self.Max := AValue.Abs;
  Self.Min := - Self.Max;

(*  Bb.Max.V[0] := Abs(V.V[0]);
  Bb.Max.V[1] := Abs(V.V[1]);
  Bb.Max.V[2] := Abs(V.V[2]);
  Bb.Min.V[0] := -Bb.Max.V[0];
  Bb.Min.V[1] := -Bb.Max.V[1];
  Bb.Min.V[2] := -Bb.Max.V[2]; *)
end;

{ : Extract the AABB information from a BB. }
procedure TNativeBZAxisAlignedBoundingBox.Create(const ABB: TNativeBZBoundingBox);
var
   I: Integer;
 begin
   //SetVector(Result.Min, ABB.BBox[0]);
   Self.Min := ABB.Points[0];
   //SetVector(Self.Max, ABB.Points[0]);
   Self.Max := ABB.Points[0];

   for I := 1 to 7 do
   begin
     if ABB.Points[I].X < Self.Min.X then Self.Min.X := ABB.Points[I].X;
     if ABB.Points[I].X > Self.Max.X then Self.Max.X := ABB.Points[I].X;

     if ABB.Points[I].Y < Self.Min.Y then Self.Min.Y := ABB.Points[I].Y;
     if ABB.Points[I].Y > Self.Max.Y then Self.Max.Y := ABB.Points[I].Y;

     if ABB.Points[I].Z < Self.Min.Z then Self.Min.Z := ABB.Points[I].Z;
     if ABB.Points[I].Z > Self.Max.Z then Self.Max.Z := ABB.Points[I].Z;
   end;
end;

{ : Make the AABB that is formed by sweeping a sphere (or AABB) from Start to Dest }
procedure TNativeBZAxisAlignedBoundingBox.CreateFromSweep(const Start, Dest: TNativeBZVector;const Radius: Single);
begin
  if Start.X < Dest.X then
  begin
    Self.Min.X := Start.X - Radius;
    Self.Max.X := Dest.X + Radius;
  end
  else
  begin
    Self.Min.X := Dest.X - Radius;
    Self.Max.X := Start.X + Radius;
  end;

  if Start.Y < Dest.Y then
  begin
    Self.Min.Y := Start.Y - Radius;
    Self.Max.Y := Dest.Y + Radius;
  end
  else
  begin
    Self.Min.Y := Dest.Y - Radius;
    Self.Max.Y := Start.Y + Radius;
  end;

  if Start.Z < Dest.Z then
  begin
    Self.Min.Z := Start.Z - Radius;
    Self.Max.Z := Dest.Z + Radius;
  end
  else
  begin
    Self.Min.Z := Dest.Z - Radius;
    Self.Max.Z := Start.Z + Radius;
  end;
end;

{ : Convert a BSphere to the AABB }
procedure TNativeBZAxisAlignedBoundingBox.Create(const BSphere: TNativeBZBoundingSphere); overload;
begin
 Self.Min := BSphere.Center - BSphere.Radius; // VectorSubtract(BSphere.Center, BSphere.Radius);
 Self.Max := BSphere.Center + BSphere.Radius; //VectorAdd(BSphere.Center, BSphere.Radius);
end;

procedure TNativeBZAxisAlignedBoundingBox.Create(const Center: TNativeBZVector; Radius: Single); overload;
begin
 Self.Min := Center - Radius; // VectorSubtract(Center, Radius);
 Self.Max := Center + Radius; //VectorAdd(Center, Radius);
end;

class operator TNativeBZAxisAlignedBoundingBox.+(ConstRef A, B : TNativeBZAxisAlignedBoundingBox):TNativeBZAxisAlignedBoundingBox;overload;
begin
  Result := A;

  if B.Min.X < A.Min.X then Result.Min.X := B.Min.X;
  if B.Min.Y < A.Min.Y then Result.Min.Y := B.Min.Y;
  if B.Min.Z < A.Min.Z then Result.Min.Z := B.Min.Z;
  if B.Max.X > A.Max.X then Result.Max.X := B.Max.X;
  if B.Max.Y > A.Max.Y then Result.Max.Y := B.Max.Y;
  if B.Max.Z > A.Max.Z then Result.Max.Z := B.Max.Z;

  (*Result.Min := A.Min;
    Result.Max := A.Max;
    Result.Min := Result.Min.Min(B.Min);
    Result.Max := Result.Max.Max(B.Max);
  *)
end;

class operator TNativeBZAxisAlignedBoundingBox.+(ConstRef A: TNativeBZAxisAlignedBoundingBox; ConstRef B : TNativeBZVector):TNativeBZAxisAlignedBoundingBox;overload;
begin
  Result.Min := A.Min + B;
  Result.Max := A.Max + B;
end;

class operator TNativeBZAxisAlignedBoundingBox.*(ConstRef A: TNativeBZAxisAlignedBoundingBox; ConstRef B : TNativeBZVector):TNativeBZAxisAlignedBoundingBox;overload;
begin
  Result.Min := A.Min * B;
  Result.Max := A.Max * B;
end;

class operator TNativeBZAxisAlignedBoundingBox.=(ConstRef A, B : TNativeBZAxisAlignedBoundingBox):Boolean;overload;
begin
  result := (A.Min = B.Min) and (A.Max = B.Max);
end;

function TNativeBZAxisAlignedBoundingBox.Transform(Constref M:TNativeBZMatrix):TNativeBZAxisAlignedBoundingBox;
var
  Temp, OldMin, OldMax: TNativeBZVector;
begin
  OldMin := Self.Min;
  OldMax := Self.Max;
  Result.Min := M * OldMin; //VectorTransform(OldMin, M);
  Result.Max := Self.Min;
  //AABBInclude(Bb, VectorTransform(AffineVectorMake(OldMin.V[0], OldMin.V[1], OldMax.V[2]), M));
  Temp.Create(OldMin.X, OldMin.Y, OldMax.Z,1);
  Temp := M * Temp;
  Result := Result.Include(Temp);
  //AABBInclude(Bb, VectorTransform(AffineVectorMake(OldMin.V[0], OldMax.V[1], OldMin.V[2]), M));
  Temp.Create(OldMin.X, OldMax.Y, OldMin.Z,1);
  Temp := M * Temp;
  Result := Result.Include(Temp);
  //AABBInclude(Bb, VectorTransform(AffineVectorMake(OldMin.V[0], OldMax.V[1], OldMax.V[2]), M));
  Temp.Create(OldMin.X, OldMax.Y, OldMax.Z,1);
  Temp := M * Temp;
  Result := Result.Include(Temp);
  //AABBInclude(Bb, VectorTransform(AffineVectorMake(OldMax.V[0], OldMin.V[1], OldMin.V[2]), M));
  Temp.Create(OldMax.X, OldMin.Y, OldMin.Z,1);
  Temp := M * Temp;
  Result := Result.Include(Temp);
  //AABBInclude(Bb, VectorTransform(AffineVectorMake(OldMax.V[0], OldMin.V[1], OldMax.V[2]), M));
  Temp.Create(OldMax.X, OldMin.Y, OldMax.Z,1);
  Temp := M * Temp;
  Result := Result.Include(Temp);
  //AABBInclude(Bb, VectorTransform(AffineVectorMake(OldMax.V[0], OldMax.V[1], OldMin.V[2]), M));
  Temp.Create(OldMax.X, OldMax.Y, OldMin.Z ,1);
  Temp := M * Temp;
  Result := Result.Include(Temp);
  //AABBInclude(Bb, VectorTransform(OldMax, M));
  Temp := M * OldMax;
  Result := Result.Include(Temp);
end;

function TNativeBZAxisAlignedBoundingBox.Include(Constref P:TNativeBZVector):TNativeBZAxisAlignedBoundingBox;
begin
  Result := Self;
  if P.X < Result.Min.X then Result.Min.X := P.X;
  if P.X > Result.Max.X then Result.Max.X := P.X;
  if P.Y < Result.Min.Y then Result.Min.Y := P.Y;
  if P.Y > Result.Max.Y then Result.Max.Y := P.Y;
  if P.Z < Result.Min.Z then Result.Min.Z := P.Z;
  if P.Z > Result.Max.Z then Result.Max.Z := P.Z;
end;

{ : Returns the intersection of the AABB with second AABBs.
  If the AABBs don't intersect, will return a degenerated AABB (plane, line or point). }
function TNativeBZAxisAlignedBoundingBox.Intersection(const B: TNativeBZAxisAlignedBoundingBox): TNativeBZAxisAlignedBoundingBox;
var
  I: Integer;
begin
  for I := 0 to 2 do
  begin
    Result.Min.V[I] := Math.Max(Self.Min.V[I], B.Min.V[I]);
    Result.Max.V[I] := Math.Min(Self.Max.V[I], B.Max.V[I]);
  end;
end;

{ : Converts the AABB to its canonical BB. }
function TNativeBZAxisAlignedBoundingBox.ToBoundingBox: TNativeBZBoundingBox; overload;
begin
  result:=NativeNullBoundingBox;
  with Self do
  begin
    SetPlanBB(Result, 0, Max.X);
    SetPlanBB(Result, 1, Min.X);
    SetPlanBB(Result, 2, Max.Y);
    SetPlanBB(Result, 3, Min.Y);
    SetPlanBB(Result, 4, Max.Z);
    SetPlanBB(Result, 5, Min.Z);
  end;
end;

{ : Transforms the AABB to a BB. }
function TNativeBZAxisAlignedBoundingBox.ToBoundingBox(const M: TNativeBZMatrix) : TNativeBZBoundingBox; overload;
begin
  Result := Self.ToBoundingBox;
  Result := Result.Transform(M);
end;

{ : Convert the AABB to a BSphere }
function TNativeBZAxisAlignedBoundingBox.ToBoundingSphere: TNativeBZBoundingSphere;
begin
 Result.Center := (Self.Min + Self.Max) * 0.5;// VectorScale(VectorAdd(AABB.Min, AABB.Max), 0.5);
 Result.Radius := Self.Min.Distance(Self.Max) * 0.5; // VectorDistance(AABB.Min, AABB.Max) * 0.5;
end;

function TNativeBZAxisAlignedBoundingBox.ToClipRect(ModelViewProjection: TNativeBZMatrix; ViewportSizeX, ViewportSizeY: Integer): TNativeBZClipRect;
var
  I: Integer;
  v, Vt: TNativeBZVector;
  Minmax: array [0 .. 1] of PNativeBZAffineVector;
begin

  Minmax[0] := @Self.Min;
  Minmax[1] := @Self.Max;
  v.W := 1;
  for I := 0 to 7 do
  begin
    v.X := Minmax[I and 1]^.V[0];
    v.Y := Minmax[(I shr 1) and 1]^.V[1];
    v.Z := Minmax[(I shr 2) and 1]^.V[2];

    // Project
    Vt := ModelViewProjection * v; //VectorTransform(V, ModelViewProjection);
    vt := vt * (1/vt.W); // ScaleVector(Vt, 1 / Vt.V[3]);

    // Convert to screen coordinates
    if I > 0 then
      //IncludeInClipRect(Result, ViewportSizeX * (Vt.V[0] + 1) * 0.5, ViewportSizeY * (Vt.V[1] + 1) * 0.5)
      Result := Result.ExtendClipRect(ViewportSizeX * (Vt.V[0] + 1) * 0.5, ViewportSizeY * (Vt.V[1] + 1) * 0.5)
    else
    begin
      Result.Left := ViewportSizeX * (Vt.X + 1) * 0.5;
      Result.Top := ViewportSizeY * (Vt.Y + 1) * 0.5;
      Result.Right := Result.Left;
      Result.Bottom := Result.Top;
    end;
  end;
end;

{ : Determines if two AxisAlignedBoundingBoxes intersect.
  The matrices are the ones that convert one point to the other's AABB system }
function TNativeBZAxisAlignedBoundingBox.Intersect(const B: TNativeBZAxisAlignedBoundingBox;const M1, M2: TNativeBZMatrix):Boolean;
begin
  result := false;
 (* const
  CWires: array [0 .. 11, 0 .. 1] of Integer // Points of the wire
    = ((0, 1), (1, 2), (2, 3), (3, 0), (4, 5), (5, 6), (6, 7), (7, 4), (0, 4),
    (1, 5), (2, 6), (3, 7));
  CPlanes: array [0 .. 5, 0 .. 3] of Integer // points of the planes
    = ((1, 2, 6, 5), (2, 3, 7, 6), (0, 1, 2, 3), (0, 3, 7, 4), (0, 1, 5, 4),
    (5, 6, 7, 4));

  procedure MakeAABBPoints(const AABB: TBZAxisAlignedBoundingBox; var Pt: array of TBZVector);
  begin
    with AABB do
    begin
      Pt[0].Create(Min.X, Min.Y, Min.Z,1);
      Pt[1].Create(Max.X, Min.Y, Min.Z,1);
      Pt[2].Create(Max.X, Max.Y, Min.Z,1);
      Pt[3].Create(Min.X, Max.Y, Min.Z,1);
      Pt[4].Create(Min.X, Min.Y, Max.Z,1);
      Pt[5].Create(Max.X, Min.Y, Max.Z,1);
      Pt[6].Create(Max.X, Max.Y, Max.Z,1);
      Pt[7].Create(Min.X, Max.Y, Max.Z,1);
    end;
  end;

  procedure MakePlanes(const Pt: array of TBZVector; var Planes: array of TBZHmgPlane);
  var
    I: Integer;
  begin
    for I := 0 to 5 do
      Planes[I] := PlaneMake(Pt[CPlanes[I, 0]], Pt[CPlanes[I, 1]],Pt[CPlanes[I, 2]]);
  end;

var
  Pt1, Pt2: array [0 .. 7] of TBZVector;
  Pt: TBZVector;
  Planes2: array [0 .. 5] of TBZHmgPlane;
  I, T: Integer;
  V: TBZVector;
  P: TBZVector;
begin
  Result := False;

  // Build Points
  MakeAABBPoints(AABB1, Pt1);
  MakeAABBPoints(AABB2, Pt2);
  for I := 0 to 7 do
  begin
    Pt := M2 * Pt2[I]; //VectorTransform(Pt2[I], M2To1);
    // check for inclusion (points of Obj2 in Obj1)
    if IsInRange(Pt.V[0], AABB1.Min.V[0], AABB1.Max.V[0]) and
      IsInRange(Pt.V[1], AABB1.Min.V[1], AABB1.Max.V[1]) and
      IsInRange(Pt.V[2], AABB1.Min.V[2], AABB1.Max.V[2]) then
    begin
      Result := True;
      Exit;
    end;
  end;

  for I := 0 to 7 do
  begin
    Pt1[I] := M2 * Pt1[I]; // VectorTransform(Pt1[I], M1To2);
    // check for inclusion (points of Obj1 in Obj2)
    if IsInRange(Pt1[I].V[0], AABB2.Min.V[0], AABB2.Max.V[0]) and
      IsInRange(Pt1[I].V[1], AABB2.Min.V[1], AABB2.Max.V[1]) and
      IsInRange(Pt1[I].V[2], AABB2.Min.V[2], AABB2.Max.V[2]) then
    begin
      Result := True;
      Exit;
    end;
  end;

  // Build Planes

  MakePlanes(Pt2, Planes2);

  // Wire test
  for I := 0 to 11 do
  begin
    for T := 0 to 5 do
    begin
      // Build Vector of Ray
      V := Pt1[CWires[I, 0]] - Pt1[CWires[I, 1]]; // VectorSubtract(Pt1[CWires[I, 0]], Pt1[CWires[I, 1]]);
      if IntersectLinePlane(VectorMake(Pt1[CWires[I, 0]]), VectorMake(V),
        Planes2[T], @P) = 1 then
      begin
        // check point in Wire
        if IsInRange(P.V[0], Pt1[CWires[I, 0]].V[0],
          Pt1[CWires[I, 1]].V[0]) and
          IsInRange(P.V[1], Pt1[CWires[I, 0]].V[1],
          Pt1[CWires[I, 1]].V[1]) and
          IsInRange(P.V[2], Pt1[CWires[I, 0]].V[2],
          Pt1[CWires[I, 1]].V[2]) then
        begin
          // check point in Plane
          if IsInRange(P.V[0], Pt2[CPlanes[T, 0]].V[0],
            Pt2[CPlanes[T, 2]].V[0]) and
            IsInRange(P.V[1], Pt2[CPlanes[T, 0]].V[1],
            Pt2[CPlanes[T, 2]].V[1]) and
            IsInRange(P.V[2], Pt2[CPlanes[T, 0]].V[2],
            Pt2[CPlanes[T, 2]].V[2]) then
          begin
            Result := True;
            Exit;
          end;
        end;
      end;
    end;
  end;   *)
end;

{ : Checks whether two Bounding boxes aligned with the world axes collide in the XY plane. }
function TNativeBZAxisAlignedBoundingBox.IntersectAbsoluteXY(const B: TNativeBZAxisAlignedBoundingBox): Boolean;
begin
 Result := False;

 if (B.Min.X > Self.Max.X) or (B.Min.Y > Self.Max.Y) then Exit
 else if (B.Max.X < Self.Min.X) or (B.Max.Y < Self.Min.Y) then Exit
 else
   Result := True;

end;

{ : Checks whether two Bounding boxes aligned with the world axes collide in the XZ plane. }
function TNativeBZAxisAlignedBoundingBox.IntersectAbsoluteXZ(const B: TNativeBZAxisAlignedBoundingBox): Boolean;
begin
 Result := ((Self.Min.X < B.Max.X) and (Self.Min.Z < B.Max.Z) and
            (B.Min.X < Self.Max.X) and (B.Min.Z < Self.Max.Z));
end;

{ : Checks whether two Bounding boxes aligned with the world axes collide. }
function TNativeBZAxisAlignedBoundingBox.IntersectAbsolute(const B: TNativeBZAxisAlignedBoundingBox): Boolean;
begin
 Result := not((Self.Min.X > B.Max.X) or (Self.Min.Y > B.Max.Y) or
               (Self.Min.Z > B.Max.Z) or (B.Min.X > Self.Max.X) or
               (B.Min.Y > Self.Max.Y) or (B.Min.Z > Self.Max.Z));
end;

{ : Checks whether one Bounding box aligned with the world axes fits within
  another Bounding box. }
function TNativeBZAxisAlignedBoundingBox.FitsInAbsolute(const B: TNativeBZAxisAlignedBoundingBox): Boolean;
begin
 // AABB1 fits completely inside AABB2?
 // AABB1 min must be >= to AABB2 min
 // AABB1 max must be <= to AABB2 max

 Result := (Self.Min.X >= B.Min.X) and (Self.Min.Y >= B.Min.Y) and
           (Self.Min.Z >= B.Min.Z) and (Self.Max.X <= B.Max.X) and
           (Self.Max.Y <= B.Max.Y) and (Self.Max.Z <= B.Max.Z);
end;

{ : Checks if a point "p" is inside the AABB }
function TNativeBZAxisAlignedBoundingBox.PointIn(const P: TNativeBZVector): Boolean;
begin
   Result := (P.X <= Self.Max.X) and (P.X >= Self.Min.X) and
             (P.Y <= Self.Max.Y) and (P.Y >= Self.Min.Y) and
             (P.Z <= Self.Max.Z) and (P.Z >= Self.Min.Z);
end;

{ : Extract the corners from the AABB }
function TNativeBZAxisAlignedBoundingBox.ExtractCorners: TNativeBZAABBCorners;
begin
  Result[0].Create(Self.Min.X, Self.Min.Y, Self.Min.Z,1);
  Result[1].Create(Self.Min.X, Self.Min.Y, Self.Max.Z,1);
  Result[2].Create(Self.Min.X, Self.Max.Y, Self.Min.Z,1);
  Result[3].Create(Self.Min.X, Self.Max.Y, Self.Max.Z,1);
  Result[4].Create(Self.Max.X, Self.Min.Y, Self.Min.Z,1);
  Result[5].Create(Self.Max.X, Self.Min.Y, Self.Max.Z,1);
  Result[6].Create(Self.Max.X, Self.Max.Y, Self.Min.Z,1);
  Result[7].Create(Self.Max.X, Self.Max.Y, Self.Max.Z,1);
end;

{ : Determines to which extent the AABB contains another AABB }
function TNativeBZAxisAlignedBoundingBox.Contains(const TestAABB: TNativeBZAxisAlignedBoundingBox): TBZSpaceContains; overload;
begin
 // AABB1 fits completely inside AABB2?
  // AABB1 min must be >= to AABB2 min
  // AABB1 max must be <= to AABB2 max

  if ((Self.Min.X < TestAABB.Max.X) and (Self.Min.Y < TestAABB.Max.Y) and
      (Self.Min.Z < TestAABB.Max.Z) and (TestAABB.Min.X < Self.Max.X) and
      (TestAABB.Min.Y < Self.Max.Y) and (TestAABB.Min.Z < Self.Max.Z)) then
  begin
    if (TestAABB.Min.X >= Self.Min.X) and (TestAABB.Min.Y >= Self.Min.Y) and
       (TestAABB.Min.Z >= Self.Min.Z) and (TestAABB.Max.X <= Self.Max.X) and
       (TestAABB.Max.Y <= Self.Max.Y) and (TestAABB.Max.Z <= Self.Max.Z) then
      Result := ScContainsFully
    else
      Result := ScContainsPartially;
  end
  else
    Result := ScNoOverlap;
end;

{ : Determines to which extent the AABB contains a BSphere }
function TNativeBZAxisAlignedBoundingBox.Contains(const TestBSphere: TNativeBZBoundingSphere): TBZSpaceContains; overload;
var
  TestAABB: TNativeBZAxisAlignedBoundingBox;
begin
  TestAABB.Create(TestBSphere);
  Result := Self.Contains(TestAABB);
end;

{ : Clips a position to the AABB }
function TNativeBZAxisAlignedBoundingBox.Clip(const V: TNativeBZAffineVector): TNativeBZAffineVector;
begin
 Result := V;

 if Result.X < Self.Min.X then Result.X := Self.Min.X;
 if Result.Y < Self.Min.Y then Result.Y := Self.Min.Y;
 if Result.Z < Self.Min.Z then Result.Z := Self.Min.Z;

 if Result.X > Self.Max.X then Result.X := Self.Max.X;
 if Result.Y > Self.Max.Y then Result.Y := Self.Max.Y;
 if Result.Z > Self.Max.Z then Result.Z := Self.Max.Z;
end;

{ : Finds the intersection between a ray and an axis aligned bounding box. }
function TNativeBZAxisAlignedBoundingBox.RayCastIntersect(const RayOrigin, RayDirection: TNativeBZVector; out TNear, TFar: Single): Boolean; overload;
const
  Infinity = 1.0 / 0.0;
var
  P: Integer;
  InvDir: Double;
  T0, T1, Tmp: Single;
begin
  Result := False;

  TNear := -Infinity;
  TFar := Infinity;

  for P := 0 to 2 do
  begin
    if (RayDirection.V[P] = 0) then
    begin
      if ((RayOrigin.V[P] < Self.Min.V[P]) or
          (RayOrigin.V[P] > Self.Max.V[P])) then Exit;
    end
    else
    begin
      // T0 := Self.Min.SubAndMul(
      InvDir := 1 / RayDirection.V[P];
      T0 := (Self.Min.V[P] - RayOrigin.V[P]) * InvDir;
      T1 := (Self.Max.V[P] - RayOrigin.V[P]) * InvDir;

      if (T0 > T1) then
      begin
        Tmp := T0;
        T0 := T1;
        T1 := Tmp;
      end;

      if (T0 > TNear) then TNear := T0;
      if (T1 < TFar) then TFar := T1;

      if ((TNear > TFar) or (TFar < 0)) then Exit;
    end;
  end;

  Result := True;
end;

function TNativeBZAxisAlignedBoundingBox.RayCastIntersect(const RayOrigin, RayDirection: TNativeBZVector; IntersectPoint: PNativeBZVector = nil): Boolean; overload;
var
  TNear, TFar: Single;
begin
  Result := RayCastIntersect(RayOrigin, RayDirection, TNear, TFar);

  if Result and Assigned(IntersectPoint) then
  begin
    if TNear >= 0 then
        // origin outside the box
        IntersectPoint^ :=RayOrigin.Combine2(RayDirection, 1, TNear) // VectorCombine(RayOrigin, RayDirection, 1, TNear)
    else
       // origin inside the box, near is "behind", use far
       IntersectPoint^ := RayOrigin.Combine2(RayDirection, 1, TFar); // VectorCombine(RayOrigin, RayDirection, 1, TFar);
  end;
end;

{%endregion}
