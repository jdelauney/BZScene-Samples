unit native;

{$mode objfpc}{$H+}


{$COPERATORS ON}
{.$INLINE ON}

{$MODESWITCH ADVANCEDRECORDS}

interface

uses
  Classes, SysUtils, BZVectorMath, BZVectorMathEx;

type
{%region%----[ TNativeBZVector2i ]---------------------------------------------}
  TNativeBZVector2i = record
  { Return vector as string }
  procedure Create(aX, aY:Integer); overload;

  function ToString : String;

  { Add 2 TBZVector2i }
  class operator +(constref A, B: TNativeBZVector2i): TNativeBZVector2i; overload;
  { Sub 2 TBZVector2i }
  class operator -(constref A, B: TNativeBZVector2i): TNativeBZVector2i; overload;
  { Multiply 2 TBZVector2i }
  class operator *(constref A, B: TNativeBZVector2i): TNativeBZVector2i; overload;
   { Multiply 1 TBZVector2i and 1 1 TBZVector2i}
  //class operator *(constref A:TBZVector2i; Constref B: TBZVector2f): TBZVector2i; overload;
  { Divide 2 TBZVector2i }
  class operator Div(constref A, B: TNativeBZVector2i): TNativeBZVector2i; overload;
   { Divide 2 TBZVector2i }
  class operator Div(constref A: TNativeBZVector2i; Constref B:Integer): TNativeBZVector2i; overload;

  class operator +(constref A: TNativeBZVector2i; constref B:Integer): TNativeBZVector2i; overload;
  class operator +(constref A: TNativeBZVector2i; constref B:Single): TNativeBZVector2i; overload;
  class operator -(constref A: TNativeBZVector2i; constref B:Integer): TNativeBZVector2i; overload;
  class operator -(constref A: TNativeBZVector2i; constref B:Single): TNativeBZVector2i; overload;
  //class operator *(constref A: TNativeBZVector2i; constref B:Integer): TNativeBZVector2i; overload;
  class operator *(constref A: TNativeBZVector2i; constref B:Single): TNativeBZVector2i; overload;
  class operator /(constref A: TNativeBZVector2i; constref B:Single): TNativeBZVector2i; overload;

  class operator -(constref A: TNativeBZVector2i): TNativeBZVector2i; overload;

  class operator =(constref A, B: TNativeBZVector2i): Boolean;

  class operator mod(constref A, B : TNativeBZVector2i): TNativeBZVector2i;

  { TODO -oBZVectorMath -cTNativeBZVector2i : Add comparator operators <=,<=,>,< }
  (*
  class operator >=(constref A, B: TNativeBZVector2i): Boolean;
  class operator <=(constref A, B: TNativeBZVector2i): Boolean;
  class operator >(constref A, B: TNativeBZVector2i): Boolean;
  class operator <(constref A, B: TNativeBZVector2i): Boolean;
  *)

  class operator <>(constref A, B: TNativeBZVector2i): Boolean;

  function Min(constref B: TNativeBZVector2i): TNativeBZVector2i; overload;
  function Min(constref B: Integer): TNativeBZVector2i; overload;
  function Max(constref B: TNativeBZVector2i): TNativeBZVector2i; overload;
  function Max(constref B: Integer): TNativeBZVector2i; overload;

  function Clamp(constref AMin, AMax: TNativeBZVector2i): TNativeBZVector2i;overload;
  function Clamp(constref AMin, AMax: Integer): TNativeBZVector2i;overload;
  function MulAdd(constref A,B:TNativeBZVector2i): TNativeBZVector2i;
  function MulDiv(constref A,B:TNativeBZVector2i): TNativeBZVector2i;
  function Length:Single;
  function LengthSquare:Single;
  function Distance(constref A:TNativeBZVector2i):Single;
  function DistanceSquare(constref A:TNativeBZVector2i):Single;
  function DotProduct(A:TNativeBZVector2i):Single;
  function AngleBetween(Constref A, ACenterPoint : TNativeBZVector2i): Single;
  function AngleCosine(constref A: TNativeBZVector2i): Single;

  // function Reflect(I, NRef : TNativeBZVector2i):TNativeBZVector2i

//   function Edge(ConstRef A, B : TNativeBZVector2i):Single; // @TODO : a passer dans TBZVector2iHelper ???

  function Abs:TNativeBZVector2i;overload;

  case Byte of
    0: (V: TBZVector2iType);
    1: (X, Y : Integer);
    2: (Width, Height : Integer);
  end;
{%endregion%}

{%region%----[ TNativeBZVector2f ]---------------------------------------------}

  TNativeBZVector2f =  record
    procedure Create(aX,aY: Single);

    function ToString : String;

    class operator +(constref A, B: TNativeBZVector2f): TNativeBZVector2f; overload;
    class operator -(constref A, B: TNativeBZVector2f): TNativeBZVector2f; overload;
    class operator *(constref A, B: TNativeBZVector2f): TNativeBZVector2f; overload;
    class operator /(constref A, B: TNativeBZVector2f): TNativeBZVector2f; overload;

    class operator +(constref A: TNativeBZVector2f; constref B:Single): TNativeBZVector2f; overload;
    class operator -(constref A: TNativeBZVector2f; constref B:Single): TNativeBZVector2f; overload;
    class operator *(constref A: TNativeBZVector2f; constref B:Single): TNativeBZVector2f; overload;
    class operator /(constref A: TNativeBZVector2f; constref B:Single): TNativeBZVector2f; overload;
    class operator /(constref A: TNativeBZVector2f; constref B: TNativeBZVector2i): TNativeBZVector2f; overload;

    class operator -(constref A: TNativeBZVector2f): TNativeBZVector2f; overload;

    class operator =(constref A, B: TNativeBZVector2f): Boolean;
    (*class operator >=(constref A, B: TNativeBZVector2f): Boolean;
    class operator <=(constref A, B: TNativeBZVector2f): Boolean;
    class operator >(constref A, B: TNativeBZVector2f): Boolean;
    class operator <(constref A, B: TNativeBZVector2f): Boolean;*)
    class operator <>(constref A, B: TNativeBZVector2f): Boolean;

    function Min(constref B: TNativeBZVector2f): TNativeBZVector2f; overload;
    function Min(constref B: Single): TNativeBZVector2f; overload;
    function Max(constref B: TNativeBZVector2f): TNativeBZVector2f; overload;
    function Max(constref B: Single): TNativeBZVector2f; overload;
    function Abs: TNativeBZVector2f;

    function Clamp(constref AMin, AMax: TNativeBZVector2f): TNativeBZVector2f;overload;
    function Clamp(constref AMin, AMax: Single): TNativeBZVector2f;overload;
    function MulAdd(A,B:TNativeBZVector2f): TNativeBZVector2f;
    function MulDiv(A,B:TNativeBZVector2f): TNativeBZVector2f;
    function Length:Single;
    function LengthSquare:Single;
    function Distance(A:TNativeBZVector2f):Single;
    function DistanceSquare(A:TNativeBZVector2f):Single;
    function Normalize : TNativeBZVector2f;
    function DotProduct(A:TNativeBZVector2f):Single;
    function AngleBetween(Constref A, ACenterPoint : TNativeBZVector2f): Single;
    function AngleCosine(constref A: TNativeBZVector2f): Single;
    // function Reflect(I, NRef : TVector2f):TVector2f
    function Round: TNativeBZVector2i;
    function Trunc: TNativeBZVector2i;
    function Floor: TNativeBZVector2i; overload;
    function Ceil : TNativeBZVector2i; overload;
    function Fract : TNativeBZVector2f; overload;

    function Modf(constref A : TNativeBZVector2f): TNativeBZVector2f;
    function fMod(Constref A : TNativeBZVector2f): TNativeBZVector2i;

    function Sqrt : TNativeBZVector2f; overload;
    function InvSqrt : TNativeBZVector2f; overload;

    case Byte of
      0: (V: TBZVector2fType);
      1: (X, Y : Single);
  End;

{%endregion%}

{%region%----[ TNativeBZVector2d ]---------------------------------------------}

{ TNativeBZVector2d : 2D Float vector (Double) }
 TNativeBZVector2d =  record
   { @name : Initialize X and Y float values
     @param(aX : Single -- value for X)
     @param(aY : Single -- value for Y) }
   procedure Create(aX,aY: Double);

   { @name : Return Vector to a formatted string eg "("x, y")"
     @return(String) }
   function ToString : String;

   { @name : Add two TNativeBZVector2d
     @param(A : TNativeBZVector2d)
     @param(B : TNativeBZVector2d)
     @return(TNativeBZVector2d) }
   class operator +(constref A, B: TNativeBZVector2d): TNativeBZVector2d; overload;

   { @name : Add one TNativeBZVector2i to one TNativeBZVector2d
     @param(A : TNativeBZVector2d)
     @param(B : TNativeBZVector2i)
     @return(TNativeBZVector2d) }
   class operator +(constref A: TNativeBZVector2d; constref B: TNativeBZVector2i): TNativeBZVector2d; overload;

   { @name : Sub two TNativeBZVector2d
     @param(A : TNativeBZVector2d)
     @param(B : TNativeBZVector2d)
     @return(TNativeBZVector2d) }
   class operator -(constref A, B: TNativeBZVector2d): TNativeBZVector2d; overload;

   { @name : Substract one TNativeBZVector2i to one TNativeBZVector2d
     @param(A : TNativeBZVector2d)
     @param(B : TNativeBZVector2i)
     @return(TNativeBZVector2d) }
   class operator -(constref A: TNativeBZVector2d; constref B: TNativeBZVector2i): TNativeBZVector2d; overload;

   { @name : Multiply two TNativeBZVector2d
     @param(A : TNativeBZVector2d)
     @param(B : TNativeBZVector2d)
     @return(TNativeBZVector2d) }
   class operator *(constref A, B: TNativeBZVector2d): TNativeBZVector2d; overload;

   { @name : Multiply one TNativeBZVector2d by a TNativeBZVector2i
     @param(A : TNativeBZVector2d)
     @param(B : TNativeBZVector2i)
     @return(TNativeBZVector2d) }
   class operator *(constref A:TNativeBZVector2d; Constref B: TNativeBZVector2i): TNativeBZVector2d; overload;

   { @name : Divide two TNativeBZVector2i
     @param(A : TNativeBZVector2d)
     @param(B : TNativeBZVector2d)
     @return(TNativeBZVector2d) }
   class operator /(constref A, B: TNativeBZVector2d): TNativeBZVector2d; overload;

   { @name : Add one Float to one TNativeBZVector2d
     @param(A : TNativeBZVector2d)
     @param(B : Single)
     @return(TNativeBZVector2d) }
   class operator +(constref A: TNativeBZVector2d; constref B:Double): TNativeBZVector2d; overload;

   { @name : Substract one Float to one TNativeBZVector2d
     @param(A : TNativeBZVector2d)
     @param(B : Single)
     @return(TNativeBZVector2d) }
   class operator -(constref A: TNativeBZVector2d; constref B:Double): TNativeBZVector2d; overload;

   { @name : Multiply one TNativeBZVector2d by a Float
     @param(A : TNativeBZVector2d)
     @param(B : Single)
     @return(TNativeBZVector2d) }
   class operator *(constref A: TNativeBZVector2d; constref B:Double): TNativeBZVector2d; overload;

   { @name : Divide one TNativeBZVector2d by a Float
     @param(A : TNativeBZVector2d)
     @param(B : Single)
     @return(TNativeBZVector2d) }
   class operator /(constref A: TNativeBZVector2d; constref B:Double): TNativeBZVector2d; overload;

   { @name : Multiply one TNativeBZVector2d by a TNativeBZVector2i
     @param(A : TNativeBZVector2d)
     @param(B : TNativeBZVector2i)
     @return(TNativeBZVector2d) }
   class operator /(constref A: TNativeBZVector2d; constref B: TNativeBZVector2i): TNativeBZVector2d; overload;

   { @name : Negate a TNativeBZVector2d
     @param(A : TNativeBZVector2d)
     @return(TNativeBZVector2d) }
   class operator -(constref A: TNativeBZVector2d): TNativeBZVector2d; overload;

   { @name : Compare if two TNativeBZVector2d are equal
     @param(A : TNativeBZVector2d)
     @param(B : TNativeBZVector2d)
     @return(Boolean @True if equal)}
   class operator =(constref A, B: TNativeBZVector2d): Boolean;

   { @name : Compare if two TNativeBZVector2d are not equal
     @param(A : TNativeBZVector2d)
     @param(B : TNativeBZVector2d)
     @return(Boolean @True if not equal)}
   class operator <>(constref A, B: TNativeBZVector2d): Boolean;

   //class operator mod(const a,b:TNativeBZVector2d): TNativeBZVector2d;

   { @name : Return the minimum of each component in TNativeBZVector2d between self and another TNativeBZVector2d
     @param(B : TNativeBZVector2d)
     @return(TNativeBZVector2d) }
   function Min(constref B: TNativeBZVector2d): TNativeBZVector2d; overload;

   { @name : Return the minimum of each component in TNativeBZVector2d between self and a Float
     @param(B : Single)
     @return(TNativeBZVector2d) }
   function Min(constref B: Double): TNativeBZVector2d; overload;

   { @name : Return the maximum of each component in TNativeBZVector2d between self and another TNativeBZVector2d
     @param(B : TNativeBZVector2d)
     @return(TNativeBZVector2d) }
   function Max(constref B: TNativeBZVector2d): TNativeBZVector2d; overload;

   { @name : Return the maximum of each component in TNativeBZVector2d between self and a Float
     @param(B : Single)
     @return(TNativeBZVector2d) }
   function Max(constref B: Double): TNativeBZVector2d; overload;

   { @name : Clamp Self beetween a min and a max TNativeBZVector2d
     @param(AMin : TNativeBZVector2d)
     @param(AMax : TNativeBZVector2d)
     @return(TNativeBZVector2d) }
   function Clamp(constref AMin, AMax: TNativeBZVector2d): TNativeBZVector2d;overload;

   { @name : Clamp Self beetween a min and a max Float
     @param(AMin : Single)
     @param(AMax : Single)
     @return(TNativeBZVector2d) }
   function Clamp(constref AMin, AMax: Double): TNativeBZVector2d;overload;

   { @name : Multiply Self by a TNativeBZVector2d and add an another TNativeBZVector2d
     @param(A : TNativeBZVector2d)
     @param(B : TNativeBZVector2d)
     @return(TNativeBZVector2d) }
   function MulAdd(constref A,B:TNativeBZVector2d): TNativeBZVector2d;

   { @name : Multiply Self by a TNativeBZVector2d and substract an another TNativeBZVector2d
     @param( : TNativeBZVector2d)
     @param( : TNativeBZVector2d)
     @return(TNativeBZVector2d) }
   function MulSub(constref A,B:TNativeBZVector2d): TNativeBZVector2d;

   { @name : Multiply Self by a TNativeBZVector2d and div with an another TNativeBZVector2d
     @param( : TNativeBZVector2d)
     @param( : TNativeBZVector2d)
     @return(TNativeBZVector2d) }
   function MulDiv(constref A,B:TNativeBZVector2d): TNativeBZVector2d;

   { @name : Return self length
     @return(Single) }
   function Length:Double;

   { @name : Return self length squared
     @return(Single) }
   function LengthSquare:Double;

   { @name : Return distance from self to an another TNativeBZVector2d
     @param(A : TNativeBZVector2d)
     @return(Single) }
   function Distance(constref A:TNativeBZVector2d):Double;

   { @name : Return Self distance squared
     @param(A : TNativeBZVector2d)
     @param( : )
     @return(Single) }
   function DistanceSquare(constref A:TNativeBZVector2d):Double;

   { @name : Return self normalized TNativeBZVector2d
     @return(TNativeBZVector2d) }
   function Normalize : TNativeBZVector2d;

   { @name : Return the dot product of self and an another TNativeBZVector2d
     @param(A : TNativeBZVector2d)
     @return(Single) }
   function DotProduct(A:TNativeBZVector2d):Double;

   { @name : Return Angle between Self and an another TNativeBZVector2d, relative to a TNativeBZVector2d as a Center Point
     @param(A : TNativeBZVector2d)
     @param(ACenterPoint : TNativeBZVector2d)
     @return(Single) }
   function AngleBetween(Constref A, ACenterPoint : TNativeBZVector2d): Double;

   { @name : Return the Angle cosine between Self and an another TNativeBZVector2d
     @param(A : TNativeBZVector2d)
     @return(Single) }
   function AngleCosine(constref A: TNativeBZVector2d): Double;

   // function Reflect(I, NRef : TVector2f):TVector2f

//   function Edge(ConstRef A, B : TNativeBZVector2d):Single; // @TODO : a passer dans TNativeBZVector2dHelper ???

   { @name : Return absolute value of each component
     @return(TNativeBZVector2d) }
   function Abs:TNativeBZVector2d;overload;

   { @name : Round Self to a TNativeBZVector2i
     @return(TNativeBZVector2i) }
   function Round: TNativeBZVector2i; overload;

   { @name : Trunc Self to a TNativeBZVector2i
     @return(TNativeBZVector2i) }
   function Trunc: TNativeBZVector2i; overload;

   { @name : Floor Self to a TNativeBZVector2i
     @return(TNativeBZVector2i) }
   function Floor: TNativeBZVector2i; overload;

   { @name : Ceil Self to a TNativeBZVector2i
     @return(TNativeBZVector2i) }
   function Ceil : TNativeBZVector2i; overload;

   { @name : Return factorial of Self
     @return(TNativeBZVector2d) }
   function Fract : TNativeBZVector2d; overload;

   { @name : Return remainder of each component
     @param(A : TNativeBZVector2d)
     @return(TNativeBZVector2d) }
   function Modf(constref A : TNativeBZVector2d): TNativeBZVector2d;

   { @name : Return remainder of each component as TNativeBZVector2i
     @param(A : TNativeBZVector2d)
     @param( : )
     @return(TNativeBZVector2i) }
   function fMod(Constref A : TNativeBZVector2d): TNativeBZVector2i;

   { @name : Return square root of each component
     @return(TNativeBZVector2d) }
   function Sqrt : TNativeBZVector2d; overload;

   { @name : Return inversed square root of each component
     @return(TNativeBZVector2d) }
   function InvSqrt : TNativeBZVector2d; overload;

   { Access properties }
   case Byte of
     0: (V: TBZVector2dType);    //< Array access
     1: (X, Y : Double);          //< Legacy access
     2: (Width, Height : Double); //< Surface size
 End;

{%endregion%}

{%region%----[ TNativeBZVector3b ]---------------------------------------------}

    TNativeBZVector3b = Record
    private
      //FSwizzleMode : TBZVector3SwizzleRef;
    public
      procedure Create(Const aX,aY,aZ: Byte); overload;

      function ToString : String;

      class operator +(constref A, B: TNativeBZVector3b): TNativeBZVector3b; overload;
      class operator -(constref A, B: TNativeBZVector3b): TNativeBZVector3b; overload;
      class operator *(constref A, B: TNativeBZVector3b): TNativeBZVector3b; overload;
      class operator Div(constref A, B: TNativeBZVector3b): TNativeBZVector3b; overload;

      class operator +(constref A: TNativeBZVector3b; constref B:Byte): TNativeBZVector3b; overload;
      class operator -(constref A: TNativeBZVector3b; constref B:Byte): TNativeBZVector3b; overload;
      class operator *(constref A: TNativeBZVector3b; constref B:Byte): TNativeBZVector3b; overload;
      class operator *(constref A: TNativeBZVector3b; constref B:Single): TNativeBZVector3b; overload;
      class operator Div(constref A: TNativeBZVector3b; constref B:Byte): TNativeBZVector3b; overload;

      class operator =(constref A, B: TNativeBZVector3b): Boolean;
      class operator <>(constref A, B: TNativeBZVector3b): Boolean;

      class operator And(constref A, B: TNativeBZVector3b): TNativeBZVector3b; overload;
      class operator Or(constref A, B: TNativeBZVector3b): TNativeBZVector3b; overload;
      class operator Xor(constref A, B: TNativeBZVector3b): TNativeBZVector3b; overload;
      class operator And(constref A: TNativeBZVector3b; constref B:Byte): TNativeBZVector3b; overload;
      class operator or(constref A: TNativeBZVector3b; constref B:Byte): TNativeBZVector3b; overload;
      class operator Xor(constref A: TNativeBZVector3b; constref B:Byte): TNativeBZVector3b; overload;

      function Swizzle(Const ASwizzle : TBZVector3SwizzleRef): TNativeBZVector3b;

      Case Integer of
        0 : (V:TBZVector3bType);
        1 : (x,y,z:Byte);
        2 : (Red,Green,Blue:Byte);
    end;

{%endregion%}

{%region%----[ TNativeBZVector3i ]---------------------------------------------}
  TNativeBZVector3i = record
  case Byte of
    0: (V: TBZVector3iType);
    1: (X, Y, Z : Integer);
    2: (Red, Green, Blue : Integer);
  end;
{%endregion%}

{%region%----[ TNativeBZVector3f ]---------------------------------------------}
  TNativeBZVector3f =  record
    case Byte of
      0: (V: TBZVector3fType);
      1: (X, Y, Z: Single);
      2: (Red, Green, Blue: Single);
  End;

  TNativeBZAffineVector = TNativeBZVector3f;
  PNativeBZAffineVector = ^TNativeBZAffineVector;

{%endregion%}

{%region%----[ TNativeBZVector4b ]---------------------------------------------}
  TNativeBZVector4b = Record
  private

  public
    procedure Create(Const aX,aY,aZ: Byte; const aW : Byte = 255); overload;
    procedure Create(Const aValue : TNativeBZVector3b; const aW : Byte = 255); overload;

    function ToString : String;

    class operator +(constref A, B: TNativeBZVector4b): TNativeBZVector4b; overload;
    class operator -(constref A, B: TNativeBZVector4b): TNativeBZVector4b; overload;
    class operator *(constref A, B: TNativeBZVector4b): TNativeBZVector4b; overload;
    class operator Div(constref A, B: TNativeBZVector4b): TNativeBZVector4b; overload;

    class operator +(constref A: TNativeBZVector4b; constref B:Byte): TNativeBZVector4b; overload;
    class operator -(constref A: TNativeBZVector4b; constref B:Byte): TNativeBZVector4b; overload;
    class operator *(constref A: TNativeBZVector4b; constref B:Byte): TNativeBZVector4b; overload;
    class operator *(constref A: TNativeBZVector4b; constref B:Single): TNativeBZVector4b; overload;
    class operator Div(constref A: TNativeBZVector4b; constref B:Byte): TNativeBZVector4b; overload;

    class operator =(constref A, B: TNativeBZVector4b): Boolean;
    class operator <>(constref A, B: TNativeBZVector4b): Boolean;

    class operator And(constref A, B: TNativeBZVector4b): TNativeBZVector4b; overload;
    class operator Or(constref A, B: TNativeBZVector4b): TNativeBZVector4b; overload;
    class operator Xor(constref A, B: TNativeBZVector4b): TNativeBZVector4b; overload;
    class operator And(constref A: TNativeBZVector4b; constref B:Byte): TNativeBZVector4b; overload;
    class operator or(constref A: TNativeBZVector4b; constref B:Byte): TNativeBZVector4b; overload;
    class operator Xor(constref A: TNativeBZVector4b; constref B:Byte): TNativeBZVector4b; overload;

    function DivideBy2 : TNativeBZVector4b;

    function Min(Constref B : TNativeBZVector4b):TNativeBZVector4b; overload;
    function Min(Constref B : Byte):TNativeBZVector4b; overload;
    function Max(Constref B : TNativeBZVector4b):TNativeBZVector4b; overload;
    function Max(Constref B : Byte):TNativeBZVector4b; overload;
    function Clamp(Constref AMin, AMax : TNativeBZVector4b):TNativeBZVector4b; overload;
    function Clamp(Constref AMin, AMax : Byte):TNativeBZVector4b; overload;

    function MulAdd(Constref B, C : TNativeBZVector4b):TNativeBZVector4b;
    function MulDiv(Constref B, C : TNativeBZVector4b):TNativeBZVector4b;

    function Shuffle(const x,y,z,w : Byte):TNativeBZVector4b;
    function Swizzle(const ASwizzle: TBZVector4SwizzleRef ): TNativeBZVector4b;

    function Combine(constref V2: TNativeBZVector4b; constref F1: Single): TNativeBZVector4b;
    function Combine2(constref V2: TNativeBZVector4b; const F1, F2: Single): TNativeBZVector4b;
    function Combine3(constref V2, V3: TNativeBZVector4b; const F1, F2, F3: Single): TNativeBZVector4b;

    function MinXYZComponent : Byte;
    function MaxXYZComponent : Byte;

    Case Integer of
     0 : (V:TBZVector4bType);
     1 : (x,y,z,w:Byte);
     2 : (Red,Green,Blue, Alpha:Byte);
     3 : (AsVector3b : TNativeBZVector3b);
     4 : (AsInteger : Integer);
  end;
{%endregion%}

{%region%----[ TNativeBZVector4i ]---------------------------------------------}
  TNativeBZVector4i = Record
  public
    procedure Create(Const aX,aY,aZ: Longint; const aW : Longint = 0); overload;
    procedure Create(Const aValue : TNativeBZVector3i; const aW : Longint = MaxInt); overload;
    procedure Create(Const aValue : TNativeBZVector3b; const aW : Longint = MaxInt); overload;

    function ToString : String;

    class operator +(constref A, B: TNativeBZVector4i): TNativeBZVector4i; overload;
    class operator -(constref A, B: TNativeBZVector4i): TNativeBZVector4i; overload;
    class operator *(constref A, B: TNativeBZVector4i): TNativeBZVector4i; overload;
    class operator Div(constref A, B: TNativeBZVector4i): TNativeBZVector4i; overload;

    class operator +(constref A: TNativeBZVector4i; constref B:Longint): TNativeBZVector4i; overload;
    class operator -(constref A: TNativeBZVector4i; constref B:Longint): TNativeBZVector4i; overload;
    class operator *(constref A: TNativeBZVector4i; constref B:Longint): TNativeBZVector4i; overload;
    class operator *(constref A: TNativeBZVector4i; constref B:Single): TNativeBZVector4i; overload;
    class operator Div(constref A: TNativeBZVector4i; constref B:Longint): TNativeBZVector4i; overload;

    class operator -(constref A: TNativeBZVector4i): TNativeBZVector4i; overload;
    class operator =(constref A, B: TNativeBZVector4i): Boolean;
    class operator <>(constref A, B: TNativeBZVector4i): Boolean;

    (* class operator And(constref A, B: TBZVector4i): TBZVector4i; overload;
    class operator Or(constref A, B: TBZVector4i): TBZVector4i; overload;
    class operator Xor(constref A, B: TBZVector4i): TBZVector4i; overload;
    class operator And(constref A: TBZVector4i; constref B:LongInt): TBZVector4i; overload;
    class operator or(constref A: TBZVector4i; constref B:LongInt): TBZVector4i; overload;
    class operator Xor(constref A: TBZVector4i; constref B:LongInt): TBZVector4i; overload; *)

    function DivideBy2 : TNativeBZVector4i;
    function Abs: TNativeBZVector4i;

    function Min(Constref B : TNativeBZVector4i):TNativeBZVector4i; overload;
    function Min(Constref B : LongInt):TNativeBZVector4i; overload;
    function Max(Constref B : TNativeBZVector4i):TNativeBZVector4i; overload;
    function Max(Constref B : LongInt):TNativeBZVector4i; overload;
    function Clamp(Constref AMin, AMax : TNativeBZVector4i):TNativeBZVector4i; overload;
    function Clamp(Constref AMin, AMax : LongInt):TNativeBZVector4i; overload;

    function MulAdd(Constref B, C : TNativeBZVector4i):TNativeBZVector4i;
    function MulDiv(Constref B, C : TNativeBZVector4i):TNativeBZVector4i;


    function Shuffle(const x,y,z,w : Byte):TNativeBZVector4i;
    function Swizzle(const ASwizzle: TBZVector4SwizzleRef ): TNativeBZVector4i;

    function Combine(constref V2: TNativeBZVector4i; constref F1: Single): TNativeBZVector4i;
    function Combine2(constref V2: TNativeBZVector4i; const F1, F2: Single): TNativeBZVector4i;
    function Combine3(constref V2, V3: TNativeBZVector4i; const F1, F2, F3: Single): TNativeBZVector4i;

    function MinXYZComponent : LongInt;
    function MaxXYZComponent : LongInt;

    case Byte of
      0 : (V: TBZVector4iType);
      1 : (X,Y,Z,W: longint);
      2 : (Red, Green, Blue, Alpha : Longint);
      3 : (TopLeft, BottomRight : TNativeBZVector2i);
  end;
{%endregion%}

{%region%----[ TNativeBZVector4f ]---------------------------------------------}

  TNativeBZVector4f =  record  // With packed record the performance decrease a little
  public
    procedure Create(Const aX,aY,aZ: Single; const aW : Single = 0); overload;

    { Self Create TBZVector4f from a TBZVector3f and w value set by default to 1.0 }
    procedure CreateAffine(Const AValue: Single); overload;
    procedure CreateAffine(Const aX,aY,aZ: Single); overload;
    procedure Create(Const anAffineVector: TNativeBZVector3f; const aW : Single = 1.0); overload;

    function ToString : String;

    class operator +(constref A, B: TNativeBZVector4f): TNativeBZVector4f; overload;
    class operator -(constref A, B: TNativeBZVector4f): TNativeBZVector4f; overload;
    class operator *(constref A, B: TNativeBZVector4f): TNativeBZVector4f; overload;
    class operator /(constref A, B: TNativeBZVector4f): TNativeBZVector4f; overload;

    class operator +(constref A: TNativeBZVector4f; constref B:Single): TNativeBZVector4f; overload;
    class operator -(constref A: TNativeBZVector4f; constref B:Single): TNativeBZVector4f; overload;
    class operator *(constref A: TNativeBZVector4f; constref B:Single): TNativeBZVector4f; overload;
    class operator /(constref A: TNativeBZVector4f; constref B:Single): TNativeBZVector4f; overload;

    class operator -(constref A: TNativeBZVector4f): TNativeBZVector4f; overload;

    class operator =(constref A, B: TNativeBZVector4f): Boolean;
    class operator >=(constref A, B: TNativeBZVector4f): Boolean;
    class operator <=(constref A, B: TNativeBZVector4f): Boolean;
    class operator >(constref A, B: TNativeBZVector4f): Boolean;
    class operator <(constref A, B: TNativeBZVector4f): Boolean;
    class operator <>(constref A, B: TNativeBZVector4f): Boolean;

    function Shuffle(const x,y,z,w : Byte):TNativeBZVector4f;
    function Swizzle(const ASwizzle: TBZVector4SwizzleRef ): TNativeBZVector4f;
    function MinXYZComponent : Single;
    function MaxXYZComponent : Single;

    function Abs:TNativeBZVector4f;overload;
    function Negate:TNativeBZVector4f;
    function  DivideBy2:TNativeBZVector4f;
    function Distance(constref A: TNativeBZVector4f):Single;
    function Length:Single;
    function DistanceSquare(constref A: TNativeBZVector4f):Single;
    function LengthSquare:Single;
    function Spacing(constref A: TNativeBZVector4f):Single;
    function DotProduct(constref A: TNativeBZVector4f):Single;
    function CrossProduct(constref A: TNativeBZVector4f): TNativeBZVector4f;
    function Normalize: TNativeBZVector4f;
    function Norm:Single;
    function Min(constref B: TNativeBZVector4f): TNativeBZVector4f; overload;
    function Min(constref B: Single): TNativeBZVector4f; overload;
    function Max(constref B: TNativeBZVector4f): TNativeBZVector4f; overload;
    function Max(constref B: Single): TNativeBZVector4f; overload;
    function Clamp(Constref AMin, AMax: TNativeBZVector4f): TNativeBZVector4f; overload;
    function Clamp(constref AMin, AMax: Single): TNativeBZVector4f; overload;
    function MulAdd(Constref B, C: TNativeBZVector4f): TNativeBZVector4f;
    function MulDiv(Constref B, C: TNativeBZVector4f): TNativeBZVector4f;


    function Lerp(Constref B: TNativeBZVector4f; Constref T:Single): TNativeBZVector4f;
    function AngleCosine(constref A : TNativeBZVector4f): Single;
    function AngleBetween(Constref A, ACenterPoint : TNativeBZVector4f): Single;

    function Combine(constref V2: TNativeBZVector4f; constref F1: Single): TNativeBZVector4f;
    function Combine2(constref V2: TNativeBZVector4f; const F1, F2: Single): TNativeBZVector4f;
    function Combine3(constref V2, V3: TNativeBZVector4f; const F1, F2, F3: Single): TNativeBZVector4f;


    function Round: TNativeBZVector4i;
    function Trunc: TNativeBZVector4i;

//    function MoveAround(constRef AMovingUp, ATargetPosition: TNativeBZVector4f; pitchDelta, turnDelta: Single): TNativeBZVector4f;

    case Byte of
      0: (V: TBZVector4fType);
      1: (X, Y, Z, W: Single);
      2: (Red, Green, Blue, Alpha: Single);
      3: (AsVector3f : TNativeBZVector3f);   //change name for AsAffine ?????
      4: (UV,ST : TNativeBZVector2f);
      5: (Left, Top, Right, Bottom: Single);
      6: (TopLeft,BottomRight : TNativeBZVector2f);
  end;

  TNativeBZVector = TNativeBZVector4f;
  PNativeBZVector = ^TNativeBZVector;
//  TNativeBZHmgPlane = TNativeBZVector;
  TNativeBZVectorArray = array[0..MAXINT shr 5] of TNativeBZVector4f;

  TNativeBZColorVector = TNativeBZVector;
  PNativeBZColorVector = ^TNativeBZColorVector;

  TNativeBZClipRect = TNativeBZVector;

{%endregion%}

{%region%----[ TNativeBZHmgPlane ]---------------------------------------------}

  TNativeBZHmgPlane = record
     // Computes the parameters of a plane defined by a point and a normal.
     procedure Create(constref point, normal : TNativeBZVector); overload;
     procedure Create(constref p1, p2, p3 : TNativeBZVector); overload;
     procedure CalcNormal(constref p1, p2, p3 : TNativeBZVector);
     procedure Normalize; overload;
     function Normalized : TNativeBZHmgPlane; overload;
     function AbsDistance(constref point : TNativeBZVector) : Single;
     function Distance(constref point : TNativeBZVector) : Single; overload;
     function Distance(constref Center : TNativeBZVector; constref Radius:Single) : Single; overload;
     function Perpendicular(constref P : TNativeBZVector4f) : TNativeBZVector4f;
     function Reflect(constref V: TNativeBZVector4f): TNativeBZVector4f;
     function IsInHalfSpace(constref point: TNativeBZVector) : Boolean;

     case Byte of
       0: (V: TBZVector4fType);         // should have type compat with other vector4f
       1: (A, B, C, D: Single);          // Plane Parameter access
       2: (AsNormal3: TNativeBZAffineVector); // super quick descriptive access to Normal as Affine Vector.
       3: (AsVector: TNativeBZVector);
       4: (X, Y, Z, W: Single);          // legacy access so existing code works
  end;

{%endregion%}

{%region%----[ TNativeBZMatrix4 ]----------------------------------------------}

  TNativeBZMatrix4f = record
  private
    function GetComponent(const ARow, AColumn: Integer): Single; inline;
    procedure SetComponent(const ARow, AColumn: Integer; const Value: Single); inline;
    function GetRow(const AIndex: Integer): TNativeBZVector4f; inline;
    procedure SetRow(const AIndex: Integer; const Value: TNativeBZVector4f); inline;

    function GetDeterminant: Single;

    function MatrixDetInternal(const a1, a2, a3, b1, b2, b3, c1, c2, c3: Single): Single;
    procedure Transpose_Scale_M33(constref src : TNativeBZMatrix4f; Constref ascale : Single);
  public
    class operator +(constref A, B: TNativeBZMatrix4f): TNativeBZMatrix4f;overload;
    class operator +(constref A: TNativeBZMatrix4f; constref B: Single): TNativeBZMatrix4f; overload;
    class operator -(constref A, B: TNativeBZMatrix4f): TNativeBZMatrix4f;overload;
    class operator -(constref A: TNativeBZMatrix4f; constref B: Single): TNativeBZMatrix4f; overload;
    class operator *(constref A, B: TNativeBZMatrix4f): TNativeBZMatrix4f;overload;
    class operator *(constref A: TNativeBZMatrix4f; constref B: Single): TNativeBZMatrix4f; overload;
    class operator *(constref A: TNativeBZMatrix4f; constref B: TNativeBZVector4f): TNativeBZVector4f; overload;
    class operator *(constref A: TNativeBZVector4f; constref B: TNativeBZMatrix4f): TNativeBZVector4f; overload;
    class operator /(constref A: TNativeBZMatrix4f; constref B: Single): TNativeBZMatrix4f; overload;

    class operator -(constref A: TNativeBZMatrix4f): TNativeBZMatrix4f; overload;

    //class operator =(constref A, B: TBZMatrix4): Boolean;overload;
    //class operator <>(constref A, B: TBZMatrix4): Boolean;overload;

    procedure CreateIdentityMatrix;
    // Creates scale matrix
    procedure CreateScaleMatrix(const v : TNativeBZAffineVector); overload;
    // Creates scale matrix
    procedure CreateScaleMatrix(const v : TNativeBZVector4f); overload;
    // Creates translation matrix
    procedure CreateTranslationMatrix(const V : TNativeBZAffineVector); overload;
    // Creates translation matrix
    procedure CreateTranslationMatrix(const V : TNativeBZVector4f); overload;
    { Creates a scale+translation matrix.
       Scale is applied BEFORE applying offset }
    procedure CreateScaleAndTranslationMatrix(const ascale, offset : TNativeBZVector4f); overload;
    // Creates matrix for rotation about x-axis (Angle in rad)
    procedure CreateRotationMatrixX(const sine, cosine: Single); overload;
    procedure CreateRotationMatrixX(const Angle: Single); overload;
    // Creates matrix for rotation about y-axis (Angle in rad)
    procedure CreateRotationMatrixY(const sine, cosine: Single); overload;
    procedure CreateRotationMatrixY(const Angle: Single); overload;
    // Creates matrix for rotation about z-axis (Angle in rad)
    procedure CreateRotationMatrixZ(const sine, cosine: Single); overload;
    procedure CreateRotationMatrixZ(const Angle: Single); overload;
    // Creates a rotation matrix along the given Axis by the given Angle in radians.
    procedure CreateRotationMatrix(const anAxis : TNativeBZAffineVector; Angle : Single); overload;
    procedure CreateRotationMatrix(const anAxis : TNativeBZVector4f; Angle : Single); overload;

    procedure CreateLookAtMatrix(const eye, center, normUp: TNativeBZVector4f);
    procedure CreateMatrixFromFrustum(Left, Right, Bottom, Top, ZNear, ZFar: Single);
    procedure CreatePerspectiveMatrix(FOV, Aspect, ZNear, ZFar: Single);
    procedure CreateOrthoMatrix(Left, Right, Bottom, Top, ZNear, ZFar: Single);
    procedure CreatePickMatrix(x, y, deltax, deltay: Single; const viewport: TBZVector4i);

    { Creates a parallel projection matrix.
       Transformed points will projected on the plane along the specified direction. }
    procedure CreateParallelProjectionMatrix(const plane : TNativeBZHmgPlane; const dir : TNativeBZVector4f);

    { Creates a shadow projection matrix.
       Shadows will be projected onto the plane defined by planePoint and planeNormal,
       from lightPos. }
    procedure CreateShadowMatrix(const planePoint, planeNormal, lightPos : TNativeBZVector4f);

    { Builds a reflection matrix for the given plane.
       Reflection matrix allow implementing planar reflectors in OpenBZ (mirrors). }
    procedure CreateReflectionMatrix(const planePoint, planeNormal : TNativeBZVector4f);

    function ToString : String;

    //function Transform(constref A: TNativeBZVector4f):TNativeBZVector4f;
    function Transpose : TNativeBZMatrix4f;
    //procedure pTranspose;
    function Invert : TNativeBZMatrix4f;
    //procedure pInvert;
    function Normalize : TNativeBZMatrix4f;
    //procedure pNormalize;

    procedure Adjoint;
    procedure AnglePreservingMatrixInvert(constref mat : TNativeBZMatrix4f);

    function Decompose(var Tran: TBZMatrixTransformations): Boolean;

    Function Translate( constref v : TNativeBZVector4f):TNativeBZMatrix4f;
    function Multiply(constref M2: TNativeBZMatrix4f):TNativeBZMatrix4f;

    //function Lerp(constref m2: TBZMatrix4f; const Delta: Single): TBZMatrix4f;

    property Rows[const AIndex: Integer]: TNativeBZVector4f read GetRow write SetRow;
    property Components[const ARow, AColumn: Integer]: Single read GetComponent write SetComponent; default;
    property Determinant: Single read GetDeterminant;

    case Byte of
    { The elements of the matrix in row-major order }
      0: (M: array [0..3, 0..3] of Single);
      1: (V: array [0..3] of TNativeBZVector4f);
      2: (VX : Array[0..1] of array[0..7] of Single); //AVX Access
      3: (X,Y,Z,W : TNativeBZVector4f);
      4: (m11, m12, m13, m14: Single;
          m21, m22, m23, m24: Single;
          m31, m32, m33, m34: Single;
          m41, m42, m43, m44: Single);
  End;

  TNativeBZMatrix = TNativeBZMatrix4f;
  PNativeBZMatrix = ^TNativeBZMatrix;
  TNativeBZMatrixArray = array [0..MaxInt shr 7] of TNativeBZMatrix;
  PNativeBZMatrixArray = ^TNativeBZMatrixArray;

{%endregion%}

{%region%----[ TNativeBZQuaternion ]-------------------------------------------}

  TNativeBZQuaternion = record
  private
  public
    { Returns quaternion product qL * qR.
       Note: order is important!
    }
    class operator *(constref A, B: TNativeBZQuaternion): TNativeBZQuaternion;  overload;
    class operator =(constref A, B: TNativeBZQuaternion): Boolean;
    class operator <>(constref A, B: TNativeBZQuaternion): Boolean;

    function ToString : String;

    procedure Create(x,y,z: Single; Real : Single);overload;
    // Creates a quaternion from the given values
    procedure Create(const Imag: array of Single; Real : Single); overload;

    // Constructs a unit quaternion from two points on unit sphere
    procedure Create(const V1, V2: TNativeBZAffineVector); overload;
    procedure Create(const V1, V2: TNativeBZVector); overload;

    // Constructs a unit quaternion from a rotation matrix
    procedure Create(const mat : TNativeBZMatrix); overload;

    // Constructs quaternion from Angle (in deg) and axis
    procedure Create(const Angle  : Single; const axis : TNativeBZAffineVector); overload;
    //procedure Create(const Angle  : Single; const axis : TBZVector); overload;

    // Constructs quaternion from Euler Angles
    procedure Create(const y,p,r: Single); overload;

    // Constructs quaternion from Euler Angles in arbitrary order (Angles in degrees)
    procedure Create(const x, y, z: Single; eulerOrder : TBZEulerOrder); overload;
    procedure Create(const EulerAngles : TBZEulerAngles; eulerOrder : TBZEulerOrder);
    { Constructs a rotation matrix from (possibly non-unit) quaternion.
       Assumes matrix is used to multiply column vector on the left:
       vnew = mat vold.
       Works correctly for right-handed coordinate system and right-handed rotations. }
    function ConvertToMatrix : TNativeBZMatrix;

    { Convert quaternion to Euler Angles according the order }
    function ConvertToEuler(Const EulerOrder : TBZEulerOrder) : TBZEulerAngles;

    { Convert quaternion to Angle (in deg) and axis , Needed to Keep or remove ? }
    procedure ConvertToAngleAxis(out Angle  : Single; out axis : TNativeBZAffineVector);

    { Constructs an affine rotation matrix from (possibly non-unit) quaternion. }
    //function ConvertToAffineMatrix : TBZAffineMatrix;

    // Returns the conjugate of a quaternion
    function Conjugate : TNativeBZQuaternion;
    //procedure pConjugate;

    // Returns the magnitude of the quaternion
    function Magnitude : Single;

    // Normalizes the given quaternion
    procedure Normalize;

    // Applies rotation to V around local axes.
    function Transform(constref V: TNativeBZVector): TNativeBZVector;

    procedure Scale(ScaleVal: Single);

   { Returns quaternion product qL * qR.
       Note: order is important!
       which gives the effect of rotating by qFirst then Self.
      }
    //function MultiplyAsFirst(const qSecond : TNativeBZQuaternion): TNativeBZQuaternion;
    function MultiplyAsSecond(const qFirst : TNativeBZQuaternion): TNativeBZQuaternion;

    { Spherical linear interpolation of unit quaternions with spins.
       QStart, QEnd - start and end unit quaternions
       t            - interpolation parameter (0 to 1)
       Spin         - number of extra spin rotations to involve  }
    function Slerp(const QEnd: TNativeBZQuaternion; Spin: Integer; t: Single): TNativeBZQuaternion; overload;
    function Slerp(const QEnd: TNativeBZQuaternion; const t : Single) : TNativeBZQuaternion; overload;

    case Byte of
      0: (V: TBZVector4fType);
      1: (X, Y, Z, W: Single);
      2: (AsVector4f : TNativeBZVector4f);
      3: (ImagePart : TNativeBZVector3f; RealPart : Single);
  End;
  PNativeBZQuaternionArray = ^TNativeBZQuaternionArray;
  TNativeBZQuaternionArray = array[0..MAXINT shr 5] of TNativeBZQuaternion;

{%endregion%}

{%region%----[ BoundingBox ]----------------------------------------------------}

  TNativeBZBoundingBox = record
  private
  public
    procedure Create(Const AValue : TNativeBZVector);

    class operator +(ConstRef A, B : TNativeBZBoundingBox):TNativeBZBoundingBox;overload;
    class operator +(ConstRef A: TNativeBZBoundingBox; ConstRef B : TNativeBZVector):TNativeBZBoundingBox;overload;
    class operator =(ConstRef A, B : TNativeBZBoundingBox):Boolean;overload;

    function Transform(ConstRef M:TNativeBZMAtrix):TNativeBZBoundingBox;
    function MinX : Single;
    function MaxX : Single;
    function MinY : Single;
    function MaxY : Single;
    function MinZ : Single;
    function MaxZ : Single;

    Case Integer of
     0 : (Points : Array[0..7] of TNativeBZVector);
     1 : (pt1, pt2, pt3, pt4 :TNativeBZVector;
          pt5, pt6, pt7, pt8 :TNativeBZVector);
  end;

{%endregion%}

{%region%----[ BoundingSphere ]-------------------------------------------------}

  TNativeBZBoundingSphere = record
  public

    procedure Create(Const x,y,z: Single;Const r: Single = 1.0); overload;
    procedure Create(Const AValue : TNativeBZAffineVector;Const r: Single = 1.0); overload;
    procedure Create(Const AValue : TNativeBZVector;Const r: Single = 1.0); overload;

    function ToString: String;

    function Contains(const TestBSphere: TNativeBZBoundingSphere) : TBZSpaceContains;
    { : Determines if one BSphere intersects another BSphere }
    function Intersect(const TestBSphere: TNativeBZBoundingSphere): Boolean;

    Case Integer of
          { : Center of Bounding Sphere }
      0 : (Center: TNativeBZVector;
          { : Radius of Bounding Sphere }
          Radius: Single);
  end;

{%endregion%}

{%region%----[ Axis Aligned BoundingBox ]---------------------------------------}

{ : Structure for storing the corners of an AABB, used with ExtractAABBCorners }
  TNativeBZAABBCorners = array [0 .. 7] of TNativeBZVector;

  TNativeBZAxisAlignedBoundingBox =  record
  public
    procedure Create(const AValue: TNativeBZVector);
    { : Extract the AABB information from a BB. }
    procedure Create(const ABB: TNativeBZBoundingBox);

    { : Make the AABB that is formed by sweeping a sphere (or AABB) from Start to Dest }
    procedure CreateFromSweep(const Start, Dest: TNativeBZVector;const Radius: Single);

    { : Convert a BSphere to the AABB }
    procedure Create(const BSphere: TNativeBZBoundingSphere); overload;
    procedure Create(const Center: TNativeBZVector; Radius: Single); overload;


    class operator +(ConstRef A, B : TNativeBZAxisAlignedBoundingBox):TNativeBZAxisAlignedBoundingBox;overload;
    class operator +(ConstRef A: TNativeBZAxisAlignedBoundingBox; ConstRef B : TNativeBZVector):TNativeBZAxisAlignedBoundingBox;overload;
    class operator *(ConstRef A: TNativeBZAxisAlignedBoundingBox; ConstRef B : TNativeBZVector):TNativeBZAxisAlignedBoundingBox;overload;
    class operator =(ConstRef A, B : TNativeBZAxisAlignedBoundingBox):Boolean;overload;

    function Transform(Constref M:TNativeBZMatrix):TNativeBZAxisAlignedBoundingBox;
    function Include(Constref P:TNativeBZVector):TNativeBZAxisAlignedBoundingBox;
    { : Returns the intersection of the AABB with second AABBs.
      If the AABBs don't intersect, will return a degenerated AABB (plane, line or point). }
    function Intersection(const B: TNativeBZAxisAlignedBoundingBox): TNativeBZAxisAlignedBoundingBox;

    { : Converts the AABB to its canonical BB. }
    function ToBoundingBox: TNativeBZBoundingBox; overload;
    { : Transforms the AABB to a BB. }
    function ToBoundingBox(const M: TNativeBZMatrix) : TNativeBZBoundingBox; overload;
    { : Convert the AABB to a BSphere }
    function ToBoundingSphere: TNativeBZBoundingSphere;

    function ToClipRect(ModelViewProjection: TNativeBZMatrix; ViewportSizeX, ViewportSizeY: Integer): TNativeBZClipRect;
    { : Determines if two AxisAlignedBoundingBoxes intersect.
      The matrices are the ones that convert one point to the other's AABB system }
    function Intersect(const B: TNativeBZAxisAlignedBoundingBox;const M1, M2: TNativeBZMatrix):Boolean;
    { : Checks whether two Bounding boxes aligned with the world axes collide in the XY plane. }
    function IntersectAbsoluteXY(const B: TNativeBZAxisAlignedBoundingBox): Boolean;
    { : Checks whether two Bounding boxes aligned with the world axes collide in the XZ plane. }
    function IntersectAbsoluteXZ(const B: TNativeBZAxisAlignedBoundingBox): Boolean;
    { : Checks whether two Bounding boxes aligned with the world axes collide. }
    function IntersectAbsolute(const B: TNativeBZAxisAlignedBoundingBox): Boolean;
    { : Checks whether one Bounding box aligned with the world axes fits within
      another Bounding box. }
    function FitsInAbsolute(const B: TNativeBZAxisAlignedBoundingBox): Boolean;

    { : Checks if a point "p" is inside the AABB }
    function PointIn(const P: TNativeBZVector): Boolean;

    { : Extract the corners from the AABB }
    function ExtractCorners: TNativeBZAABBCorners;

    { : Determines to which extent the AABB contains another AABB }
    function Contains(const TestAABB: TNativeBZAxisAlignedBoundingBox): TBZSpaceContains; overload;
    { : Determines to which extent the AABB contains a BSphere }
    function Contains(const TestBSphere: TNativeBZBoundingSphere): TBZSpaceContains; overload;

    { : Clips a position to the AABB }
    function Clip(const V: TNativeBZAffineVector): TNativeBZAffineVector;

    { : Finds the intersection between a ray and an axis aligned bounding box. }
    function RayCastIntersect(const RayOrigin, RayDirection: TNativeBZVector; out TNear, TFar: Single): Boolean; overload;
    function RayCastIntersect(const RayOrigin, RayDirection: TNativeBZVector; IntersectPoint: PNativeBZVector = nil): Boolean; overload;

    Case Integer of
      0 : (Min, Max : TNativeBZVector);
  end;

{%endregion%}

{%region%----[ TNativeBZVector2iHelper ]---------------------------------------}

   TNativeBZVector2iHelper = record helper for TNativeBZVector2i
   public
     { Return self normalized TBZVector2i }
     function Normalize : TNativeBZVector2f;
   end;

{%endregion%}

{%region%----[ TBZVector2fHelper ]-----------------------------------------------}

  TNativeBZVector2fHelper = record helper for TNAtiveBZVector2f
  private
    // Swizling access
    function GetXY : TNativeBZVector2f;
    function GetYX : TNativeBZVector2f;
    function GetXX : TNativeBZVector2f;
    function GetYY : TNativeBZVector2f;

    function GetXXY : TNativeBZVector4f;
    function GetYYX : TNativeBZVector4f;

    function GetXYY : TNativeBZVector4f;
    function GetYXX : TNativeBZVector4f;

    function GetXYX : TNativeBZVector4f;
    function GetYXY : TNativeBZVector4f;

    function GetXXX : TNativeBZVector4f;
    function GetYYY : TNativeBZVector4f;

  public
    {  : Implement a step function returning either zero or one.
      Implements a step function returning one for each component of Self that is
      greater than or equal to the corresponding component in the reference
      vector B, and zero otherwise.
      see : http://developer.download.nvidia.com/cg/step.html
    }
    function Step(ConstRef B : TNativeBZVector2f):TNativeBZVector2f;

    { : Returns a normal as-is if a vertex's eye-space position vector points in the opposite direction of a geometric normal, otherwise return the negated version of the normal
      Self = Peturbed normal vector.
      A = Incidence vector (typically a direction vector from the eye to a vertex).
      B = Geometric normal vector (for some facet the peturbed normal belongs).
      see : http://developer.download.nvidia.com/cg/faceforward.html
    }
    //function FaceForward(constref A, B: TNativeBZVector2f): TNativeBZVector2f;

    { : Returns smallest integer not less than a scalar or each vector component.
      Returns Self saturated to the range [0,1] as follows:

      1) Returns 0 if Self is less than 0; else
      2) Returns 1 if Self is greater than 1; else
      3) Returns Self otherwise.

      For vectors, the returned vector contains the saturated result of each element
      of the vector Self saturated to [0,1].
      see : http://developer.download.nvidia.com/cg/saturate.html
    }
    function Saturate : TNativeBZVector2f;

    { : Interpolate smoothly between two input values based on a third
      Interpolates smoothly from 0 to 1 based on Self compared to a and b.
      1) Returns 0 if Self < a < b or Self > a > b
      1) Returns 1 if Self < b < a or Self > b > a
      3) Returns a value in the range [0,1] for the domain [a,b].

      if A = Self
      The slope of Self.smoothstep(a,b) and b.smoothstep(a,b) is zero.

      For vectors, the returned vector contains the smooth interpolation of each
      element of the vector x.
      see : http://developer.download.nvidia.com/cg/smoothstep.html
    }
    function SmoothStep(ConstRef A,B : TNativeBZVector2f): TNativeBZVector2f;

    { : Returns the linear interpolation of Self and B based on weight T.
       if T has values outside the [0,1] range, it actually extrapolates.
    }
    function Lerp(Constref B: TNativeBZVector2f; Constref T:Single): TNativeBZVector2f;

    { : Swizzling Properties values accessability like in HLSL and BZSL }

    // Vector2f

    property XY : TNativeBZVector2f read GetXY;
    property YX : TNativeBZVector2f read GetYX;
    property XX : TNativeBZVector2f read GetXX;
    property YY : TNativeBZVector2f read GetYY;

    property XXY : TNativeBZVector4f read GetXXY;
    property YYX : TNativeBZVector4f read GetYYX;

    property XYY : TNativeBZVector4f read GetXYY;
    property YXX : TNativeBZVector4f read GetYXX;

    property XYX : TNativeBZVector4f read GetXYX;
    property YXY : TNativeBZVector4f read GetYXY;

    property XXX : TNativeBZVector4f read GetXXX;
    property YYY : TNativeBZVector4f read GetYYY;

  end;

{%endregion%}

{%region%----[ TNativeBZVectorHelper ]-----------------------------------------}

  { TNativeBZVectorHelper }

  TNativeBZVectorHelper = record helper for TNativeBZVector
  private
      // Swizling access
      function GetXY : TNativeBZVector2f;
      function GetYX : TNativeBZVector2f;
      function GetXZ : TNativeBZVector2f;
      function GetZX : TNativeBZVector2f;
      function GetYZ : TNativeBZVector2f;
      function GetZY : TNativeBZVector2f;
      function GetXX : TNativeBZVector2f;
      function GetYY : TNativeBZVector2f;
      function GetZZ : TNativeBZVector2f;

      function GetXYZ : TNativeBZVector4f;
      function GetXZY : TNativeBZVector4f;

      function GetYXZ : TNativeBZVector4f;
      function GetYZX : TNativeBZVector4f;

      function GetZXY : TNativeBZVector4f;
      function GetZYX : TNativeBZVector4f;

      function GetXXX : TNativeBZVector4f;
      function GetYYY : TNativeBZVector4f;
      function GetZZZ : TNativeBZVector4f;

      function GetYYX : TNativeBZVector4f;
      function GetXYY : TNativeBZVector4f;
      function GetYXY : TNativeBZVector4f;
  public

//  procedure CreatePlane(constref p1, p2, p3 : TNativeBZVector);overload;
  // Computes the parameters of a plane defined by a point and a normal.
 // procedure CreatePlane(constref point, normal : TNativeBZVector); overload;


//  procedure CalcPlaneNormal(constref p1, p2, p3 : TNativeBZVector);

  //function PointIsInHalfSpace(constref point: TBZVector) : Boolean;
  //function PlaneEvaluatePoint(constref point : TBZVector) : Single;
//  function DistancePlaneToPoint(constref point : TNativeBZVector) : Single;
//  function DistancePlaneToSphere(constref Center : TNativeBZVector; constref Radius:Single) : Single;
  { Compute the intersection point "res" of a line with a plane.
    Return value:
     0 : no intersection, line parallel to plane
     1 : res is valid
     -1 : line is inside plane
    Adapted from:
    E.Hartmann, Computeruntersttzte Darstellende Geometrie, B.G. Teubner Stuttgart 1988 }
  //function IntersectLinePlane(const point, direction : TBZVector; intersectPoint : PBZVector = nil) : Integer;

    function Rotate(constref axis : TNativeBZVector; Angle : Single):TNativeBZVector;
    // Returns given vector rotated around the X axis (alpha is in rad, use Pure Math Model)
    function RotateWithMatrixAroundX(alpha : Single) : TNativeBZVector;
    // Returns given vector rotated around the Y axis (alpha is in rad, use Pure Math Model)
    function RotateWithMatrixAroundY(alpha : Single) : TNativeBZVector;
    // Returns given vector rotated around the Z axis (alpha is in rad, use Pure Math Model)
    function RotateWithMatrixAroundZ(alpha : Single) : TNativeBZVector;

    // Returns given vector rotated around the X axis (alpha is in rad)
    function RotateAroundX(alpha : Single) : TNativeBZVector;
    // Returns given vector rotated around the Y axis (alpha is in rad)
    function RotateAroundY(alpha : Single) : TNativeBZVector;
    // Returns given vector rotated around the Z axis (alpha is in rad)
    function RotateAroundZ(alpha : Single) : TNativeBZVector;

    { Extracted from Camera.MoveAroundTarget(pitch, turn). }
    function MoveAround(constref AMovingObjectUp, ATargetPosition: TNativeBZVector; pitchDelta, turnDelta: Single): TNativeBZVector;


    // Self is the point
    function PointProject(constref origin, direction : TNativeBZVector) : Single;

    //function IsPerpendicular(constref v2: TBZVector) : Boolean;
    //function IsParallel(constref v2: TBZVector) : Boolean;
    // Returns true if line intersect ABCD quad. Quad have to be flat and convex
    //function IsLineIntersectQuad(const direction, ptA, ptB, ptC, ptD : TBZVector) : Boolean;
    // Computes closest point on a segment (a segment is a limited line).
    //function PointSegmentClosestPoint(segmentStart, segmentStop : TBZVector) : TBZVector;
    { Computes algebraic distance between segment and line (a segment is a limited line).}
    //function PointSegmentDistance(const point, segmentStart, segmentStop : TAffineVector) : Single;
    { Computes closest point on a line.}
    //function PointLineClosestPoint(const linePoint, lineDirection : TBZVector) : TBZVector;
    { Computes algebraic distance between point and line.}
    //function PointLineDistance(const linePoint, lineDirection : TBZVector) : Single;

    { AOriginalPosition - Object initial position.
       ACenter - some point, from which is should be distanced.

       ADistance + AFromCenterSpot - distance, which object should keep from ACenter
       or
       ADistance + not AFromCenterSpot - distance, which object should shift from his current position away from center.
    }
    function ShiftObjectFromCenter(Constref ACenter: TNativeBZVector; const ADistance: Single; const AFromCenterSpot: Boolean): TNativeBZVector;
    function AverageNormal4(constref up, left, down, right: TNativeBZVector): TNativeBZVector;

    function ExtendClipRect(vX, vY: Single) : TNativeBZClipRect;

    function Step(ConstRef B : TNativeBZVector):TNativeBZVector;
    function FaceForward(constref A, B: TNativeBZVector): TNativeBZVector;
    function Saturate : TNativeBZVector;
    function SmoothStep(ConstRef  A,B : TNativeBZvector): TNativeBZVector;

    function Reflect(ConstRef N: TNativeBZVector4f): TNativeBZVector4f;

    { : Swizzling Properties values accessability like in HLSL and BZSL }

    // Vector2f
    property XY : TNativeBZVector2f read GetXY;
    property YX : TNativeBZVector2f read GetYX;
    property XZ : TNativeBZVector2f read GetXZ;
    property ZX : TNativeBZVector2f read GetZX;
    property YZ : TNativeBZVector2f read GetYZ;
    property ZY : TNativeBZVector2f read GetZY;
    property XX : TNativeBZVector2f read GetXX;
    property YY : TNativeBZVector2f read GetYY;
    property ZZ : TNativeBZVector2f read GetZZ;

    // As Affine Vector
    property XYZ : TNativeBZVector4f read GetXYZ;
    property XZY : TNativeBZVector4f read GetXZY;
    property YXZ : TNativeBZVector4f read GetYXZ;
    property YZX : TNativeBZVector4f read GetYZX;
    property ZXY : TNativeBZVector4f read GetZXY;
    property ZYX : TNativeBZVector4f read GetZYX;

    property XXX : TNativeBZVector4f read GetXXX;
    property YYY : TNativeBZVector4f read GetYYY;
    property ZZZ : TNativeBZVector4f read GetZZZ;

    property YYX : TNativeBZVector4f read GetYYX;
    property XYY : TNativeBZVector4f read GetXYY;
    property YXY : TNativeBZVector4f read GetYXY;
  end;

{%endregion%}

{%region%----[ TNativeBZHmgPlaneHelper ]-----------------------------------------------}
  // for functions where we use types not declared before TBZHmgPlane
  TNativeBZHmgPlaneHelper = record helper for TNativeBZHmgPlane
  public
    function Contains(const TestBSphere: TNativeBZBoundingSphere): TBZSpaceContains;

  end;
{%endregion%}

{%region%----[ TNativeBZMatrixHelper ]-----------------------------------------}

  TNativeBZMatrixHelper = record helper for TNativeBZMatrix4f
  public
    // Self is ViewProjMatrix
    //function Project(Const objectVector: TBZVector; const viewport: TVector4i; out WindowVector: TBZVector): Boolean;
    //function UnProject(Const WindowVector: TBZVector; const viewport: TVector4i; out objectVector: TBZVector): Boolean;
    // coordinate system manipulation functions
    // Rotates the given coordinate system (represented by the matrix) around its Y-axis
    function Turn(Angle : Single) : TNativeBZMatrix4f; overload;
    // Rotates the given coordinate system (represented by the matrix) around MasterUp
    function Turn(constref MasterUp : TNativeBZVector; Angle : Single) : TNativeBZMatrix; overload;
    // Rotates the given coordinate system (represented by the matrix) around its X-axis
    function Pitch(Angle: Single): TNativeBZMatrix; overload;
    // Rotates the given coordinate system (represented by the matrix) around MasterRight
    function Pitch(constref MasterRight: TNativeBZVector; Angle: Single): TNativeBZMatrix; overload;
    // Rotates the given coordinate system (represented by the matrix) around its Z-axis
    function Roll(Angle: Single): TNativeBZMatrix; overload;
    // Rotates the given coordinate system (represented by the matrix) around MasterDirection
    function Roll(constref MasterDirection: TNativeBZVector; Angle: Single): TNativeBZMatrix; overload;
  end;

{%endregion%}

{%region%----[ Vector Const ]---------------------------------------------------}

Const

  NativeNullVector2f : TNativeBZVector2f = (x:0;y:0);
  NativeOneVector2f : TNativeBZVector2f = (x:1;y:1);

  NativeNullVector2d : TNativeBZVector2d = (x:0;y:0);
  NativeOneVector2d : TNativeBZVector2d = (x:1;y:1);

  // standard affine vectors
  NativeXVector :    TNativeBZAffineVector = (X:1; Y:0; Z:0);
  NativeYVector :    TNativeBZAffineVector = (X:0; Y:1; Z:0);
  NativeZVector :    TNativeBZAffineVector = (X:0; Y:0; Z:1);
  NativeXYVector :   TNativeBZAffineVector = (X:1; Y:1; Z:0);
  NativeXZVector :   TNativeBZAffineVector = (X:1; Y:0; Z:1);
  NativeYZVector :   TNativeBZAffineVector = (X:0; Y:1; Z:1);
  NativeXYZVector :  TNativeBZAffineVector = (X:1; Y:1; Z:1);
  NativeNullVector : TNativeBZAffineVector = (X:0; Y:0; Z:0);
  // standard homogeneous vectors
  NativeXHmgVector : TNativeBZVector = (X:1; Y:0; Z:0; W:0);
  NativeYHmgVector : TNativeBZVector = (X:0; Y:1; Z:0; W:0);
  NativeZHmgVector : TNativeBZVector = (X:0; Y:0; Z:1; W:0);
  NativeWHmgVector : TNativeBZVector = (X:0; Y:0; Z:0; W:1);
  NativeNullHmgVector : TNativeBZVector = (X:0; Y:0; Z:0; W:0);
  NativeXYHmgVector: TNativeBZVector = (X: 1; Y: 1; Z: 0; W: 0);
  NativeYZHmgVector: TNativeBZVector = (X: 0; Y: 1; Z: 1; W: 0);
  NativeXZHmgVector: TNativeBZVector = (X: 1; Y: 0; Z: 1; W: 0);
  NativeXYZHmgVector: TNativeBZVector = (X: 1; Y: 1; Z: 1; W: 0);
  NativeXYZWHmgVector: TNativeBZVector = (X: 1; Y: 1; Z: 1; W: 1);

  // standard homogeneous points
  NativeXHmgPoint :  TNativeBZVector = (X:1; Y:0; Z:0; W:1);
  NativeYHmgPoint :  TNativeBZVector = (X:0; Y:1; Z:0; W:1);
  NativeZHmgPoint :  TNativeBZVector = (X:0; Y:0; Z:1; W:1);
  NativeWHmgPoint :  TNativeBZVector = (X:0; Y:0; Z:0; W:1);
  NativeNullHmgPoint : TNativeBZVector = (X:0; Y:0; Z:0; W:1);

  NativeNegativeUnitVector : TNativeBZVector = (X:-1; Y:-1; Z:-1; W:-1);

{%region%----[ Matrix Const ]---------------------------------------------------}
  NativeIdentityHmgMatrix : TNativeBZMatrix4f = (V:((X:1; Y:0; Z:0; W:0),
                                       (X:0; Y:1; Z:0; W:0),
                                       (X:0; Y:0; Z:1; W:0),
                                       (X:0; Y:0; Z:0; W:1)));

  NativeEmptyHmgMatrix : TNativeBZMatrix4f = (V:((X:0; Y:0; Z:0; W:0),
                                    (X:0; Y:0; Z:0; W:0),
                                    (X:0; Y:0; Z:0; W:0),
                                    (X:0; Y:0; Z:0; W:0)));
{%endregion%}

{%region%----[ Quaternion Const ]-----------------------------------------------}

Const
 NativeIdentityQuaternion: TNativeBZQuaternion = (ImagePart:(X:0; Y:0; Z:0); RealPart: 1);

{%endregion%}

{%region%----[ Others Const ]---------------------------------------------------}
  NativeNullBoundingBox: TNativeBZBoundingBox =
  (Points:((X: 0; Y: 0; Z: 0; W: 1),
           (X: 0; Y: 0; Z: 0; W: 1),
           (X: 0; Y: 0; Z: 0; W: 1),
           (X: 0; Y: 0; Z: 0; W: 1),
           (X: 0; Y: 0; Z: 0; W: 1),
           (X: 0; Y: 0; Z: 0; W: 1),
           (X: 0; Y: 0; Z: 0; W: 1),
           (X: 0; Y: 0; Z: 0; W: 1)));


{%endregion%}
{%endregion%}

{%region%----[ Misc Vector Helpers functions ]----------------------------------}

 function NativeAffineVectorMake(const x, y, z : Single) : TNativeBZAffineVector;overload;
 function NativeAffineVectorMake(const v : TNativeBZVector) : TNativeBZAffineVector;overload;


{%endregion%}

  function Compare(constref A: TNativeBZVector3f; constref B: TBZVector3f;Epsilon: Single = 1e-10): boolean; overload;
  function Compare(constref A: TNativeBZVector4f; constref B: TBZVector4f;Epsilon: Single = 1e-10): boolean; overload;
  function Compare(constref A: TNativeBZHmgPlane; constref B: TBZHmgPlane;Epsilon: Single = 1e-10): boolean; overload;
  function Compare(constref A: TBZHmgPlane; constref B: TBZHmgPlane;Epsilon: Single = 1e-10): boolean; overload;
  function Compare(constref A: TBZVector4f; constref B: TBZVector4f;Epsilon: Single = 1e-10): boolean; overload;
  function Compare(constref A: TNativeBZVector3b; constref B: TBZVector3b): boolean; overload;
  function Compare(constref A: TBZVector3b; constref B: TBZVector3b): boolean; overload;
  function Compare(constref A: TNativeBZVector4b; constref B: TBZVector4b): boolean; overload;
  function Compare(constref A: TNativeBZVector4i; constref B: TBZVector4i): boolean; overload;
  function Compare(constref A: TNativeBZVector2i; constref B: TBZVector2i): boolean; overload;
  function Compare(constref A: TNativeBZVector2f; constref B: TBZVector2f;Epsilon: Single = 1e-10): boolean; overload;
  function Compare(constref A: TNativeBZBoundingBox; constref B: TBZBoundingBox;Epsilon: Single = 1e-10): boolean; overload;
  function CompareMatrix(constref A: TNativeBZMatrix4f; constref B: TBZMatrix4f; Epsilon: Single = 1e-10): boolean;
  function Compare(constref A: TNativeBZQuaternion; constref B: TBZQuaternion; Epsilon: Single = 1e-10): boolean; overload;
  function Compare(constref A: TNativeBZBoundingSphere; constref B: TBZBoundingSphere; Epsilon: Single = 1e-10): boolean; overload;
  function Compare(constref A: TBZBoundingSphere; constref B: TBZBoundingSphere; Epsilon: Single = 1e-10): boolean; overload;
  function Compare(constref A: TNativeBZAxisAlignedBoundingBox; constref B: TBZAxisAlignedBoundingBox; Epsilon: Single = 1e-10): boolean; overload;
  function Compare(constref A: TNativeBZAABBCorners; constref B: TBZAABBCorners; Epsilon: Single = 1e-10): boolean; overload;
  function Compare(constref A: TBZMatrix4f; constref B: TBZMatrix4f; Epsilon: Single = 1e-10): boolean; overload;

  function IsEqual(A,B: Single; Epsilon: Single = 1e-10): boolean; inline;

implementation

uses
  Math, BZMath, BZUtils, BZFastMath;

function IsEqual(A,B: Single; Epsilon: Single): boolean;
begin
  Result := Abs(A-B) < Epsilon;
end;


function Compare(constref A: TNativeBZVector4f; constref B: TBZVector4f; Epsilon: Single): boolean;
begin
  Result := true;
  if not IsEqual (A.X, B.X, Epsilon) then Result := False;
  if not IsEqual (A.Y, B.Y, Epsilon) then Result := False;
  if not IsEqual (A.Z, B.Z, Epsilon) then Result := False;
  if not IsEqual (A.W, B.W, Epsilon) then Result := False;
end;

function Compare(constref A: TNativeBZVector3f; constref B: TBZVector3f; Epsilon: Single): boolean;
begin
  Result := true;
  if not IsEqual (A.X, B.X, Epsilon) then Result := False;
  if not IsEqual (A.Y, B.Y, Epsilon) then Result := False;
  if not IsEqual (A.Z, B.Z, Epsilon) then Result := False;
end;

function Compare(constref A: TNativeBZHmgPlane; constref B: TBZHmgPlane;
  Epsilon: Single): boolean;
begin
  Result := true;
  if not IsEqual (A.X, B.X, Epsilon) then Result := False;
  if not IsEqual (A.Y, B.Y, Epsilon) then Result := False;
  if not IsEqual (A.Z, B.Z, Epsilon) then Result := False;
  if not IsEqual (A.W, B.W, Epsilon) then Result := False;
end;

function Compare(constref A: TBZHmgPlane; constref B: TBZHmgPlane;
  Epsilon: Single): boolean;
begin
  Result := true;
  if not IsEqual (A.X, B.X, Epsilon) then Result := False;
  if not IsEqual (A.Y, B.Y, Epsilon) then Result := False;
  if not IsEqual (A.Z, B.Z, Epsilon) then Result := False;
  if not IsEqual (A.W, B.W, Epsilon) then Result := False;
end;

function Compare(constref A: TBZVector4f; constref B: TBZVector4f;
  Epsilon: Single): boolean;
begin
  Result := true;
  if not IsEqual (A.X, B.X, Epsilon) then Result := False;
  if not IsEqual (A.Y, B.Y, Epsilon) then Result := False;
  if not IsEqual (A.Z, B.Z, Epsilon) then Result := False;
  if not IsEqual (A.W, B.W, Epsilon) then Result := False;
end;

function Compare(constref A: TNativeBZVector3b; constref B: TBZVector3b): boolean;
begin
  Result := True;
  if A.Red <> B.Red then Result := False;
  if A.Green <> B.Green then Result := False;
  if A.Blue <> B.Blue then Result := False;
end;

function Compare(constref A: TBZVector3b; constref B: TBZVector3b): boolean;
begin
  Result := True;
  if A.Red <> B.Red then Result := False;
  if A.Green <> B.Green then Result := False;
  if A.Blue <> B.Blue then Result := False;
end;

function Compare(constref A: TNativeBZVector4b; constref B: TBZVector4b): boolean;
begin
  Result := True;
  if A.Red <> B.Red then Result := False;
  if A.Green <> B.Green then Result := False;
  if A.Blue <> B.Blue then Result := False;
  if A.Alpha<> B.Alpha then Result := False;
end;

function Compare(constref A: TNativeBZVector4i; constref B: TBZVector4i): boolean;
begin
  Result := True;
  if A.Red <> B.Red then Result := False;
  if A.Green <> B.Green then Result := False;
  if A.Blue <> B.Blue then Result := False;
  if A.Alpha<> B.Alpha then Result := False;
end;

function Compare(constref A: TNativeBZVector2i; constref B: TBZVector2i): boolean;
begin
  Result := True;
  if A.X <> B.X then Result := False;
  if A.Y <> B.Y then Result := False;
end;

function Compare(constref A: TNativeBZVector2f; constref B: TBZVector2f; Epsilon: Single): boolean;
begin
  Result := true;
  if not IsEqual (A.X, B.X, Epsilon) then Result := False;
  if not IsEqual (A.Y, B.Y, Epsilon) then Result := False;
end;

function Compare(constref A: TNativeBZBoundingBox; constref
  B: TBZBoundingBox; Epsilon: Single): boolean;
begin
  Result := True;
  if not compare(A.pt1,B.pt1, Epsilon) then Result := False;
  if not compare(A.pt2,B.pt2, Epsilon) then Result := False;
  if not compare(A.pt3,B.pt3, Epsilon) then Result := False;
  if not compare(A.pt4,B.pt4, Epsilon) then Result := False;
  if not compare(A.pt5,B.pt5, Epsilon) then Result := False;
  if not compare(A.pt6,B.pt6, Epsilon) then Result := False;
  if not compare(A.pt7,B.pt7, Epsilon) then Result := False;
  if not compare(A.pt8,B.pt8, Epsilon) then Result := False;
end;

function CompareMatrix(constref A: TNativeBZMatrix4f; constref B: TBZMatrix4f;  Epsilon: Single): boolean;
var i : Byte;
begin
  Result := true;
  for I:=0 to 3 do
  begin
   if not IsEqual (A.V[I].X, B.V[I].X, Epsilon) then Result := False;
   if not IsEqual (A.V[I].Y, B.V[I].Y, Epsilon) then Result := False;
   if not IsEqual (A.V[I].Z, B.V[I].Z, Epsilon) then Result := False;
   if not IsEqual (A.V[I].W, B.V[I].W, Epsilon) then Result := False;
   if result = false then break;
  end;
end;

function Compare(constref A: TNativeBZQuaternion; constref B: TBZQuaternion; Epsilon: Single): boolean;
begin
  Result := true;
  if not IsEqual (A.X, B.X, Epsilon) then Result := False;
  if not IsEqual (A.Y, B.Y, Epsilon) then Result := False;
  if not IsEqual (A.Z, B.Z, Epsilon) then Result := False;
  if not IsEqual (A.W, B.W, Epsilon) then Result := False;
end;

function Compare(constref A: TNativeBZBoundingSphere; constref
  B: TBZBoundingSphere; Epsilon: Single): boolean;
begin
  Result := True;
  if not Compare(A.Center, B.Center, Epsilon) then Result := False;
  if not IsEqual(A.Radius, B.Radius, Epsilon) then Result := False;
end;

function Compare(constref A: TBZBoundingSphere; constref
  B: TBZBoundingSphere; Epsilon: Single): boolean;
begin
  Result := True;
  if not Compare(A.Center, B.Center, Epsilon) then Result := False;
  if not IsEqual(A.Radius, B.Radius, Epsilon) then Result := False;
end;

function Compare(constref A: TNativeBZAxisAlignedBoundingBox; constref
  B: TBZAxisAlignedBoundingBox; Epsilon: Single): boolean;
begin
  Result := True;
  if not Compare(A.Min, B.Min, Epsilon) then Result := False;
  if not Compare(A.Max, B.Max, Epsilon) then Result := False;
end;

function Compare(constref A: TNativeBZAABBCorners; constref
  B: TBZAABBCorners; Epsilon: Single): boolean;
var i: integer;
begin
  Result := True;
  for i := 0 to 7 do
    if not compare(A[i],B[i],Epsilon) then Result := False;
end;

function Compare(constref A: TBZMatrix4f; constref B: TBZMatrix4f;
  Epsilon: Single): boolean;
begin
  Result := True;
  if not compare(A.V[0], B.V[0], Epsilon) then Result := False;
  if not compare(A.V[1], B.V[1], Epsilon) then Result := False;
  if not compare(A.V[2], B.V[2], Epsilon) then Result := False;
  if not compare(A.V[3], B.V[3], Epsilon) then Result := False;
end;

{$i native.inc}

end.
