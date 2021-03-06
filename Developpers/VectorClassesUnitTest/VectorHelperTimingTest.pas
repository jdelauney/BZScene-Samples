unit VectorHelperTimingTest;

{$mode objfpc}{$H+}
{$CODEALIGN LOCALMIN=16}

interface

uses
  Classes, SysUtils, fpcunit, testregistry, BaseTestCase, BaseTimingTest,
  native, BZVectorMath, BZProfiler;

type

  TVectorHelperTimingTest = class(TVectorBaseTimingTest)
    protected
      {$CODEALIGN RECORDMIN=16}
      nt4,nt5 : TNativeBZVector;
       vt5 : TBZVector;
      {$CODEALIGN RECORDMIN=4}
      alpha: Single;
      procedure Setup; override;
    published
      procedure TestTimeRotate;
      procedure TestTimeRotateAroundX;
      procedure TestTimeRotateAroundY;
      procedure TestTimeRotateAroundZ;
      procedure TestTimeRotateWithMatrixAroundX;
      procedure TestTimeRotateWithMatrixAroundY;
      procedure TestTimeRotateWithMatrixAroundZ;
      procedure TestTimeAverageNormal4;
      procedure TestTimePointProject;
      procedure TestTimeMoveAround;
      procedure TestTimeShiftObjectFromCenter;
      procedure TestTimeExtendClipRect;
      procedure TestTimeStep;
      procedure TestTimeFaceForward;
      procedure TestTimeSaturate;
      procedure TestTimeSmoothStep;
  end;
  
implementation

procedure TVectorHelperTimingTest.Setup;
begin
  inherited Setup;
  Group := rgVector4f;
  nt3.Create(10.350,10.470,2.482,0.0);
  nt4.Create(20.350,18.470,8.482,0.0);
  vt3.V := nt3.V;
  vt4.V := nt4.V;
  alpha := pi / 6;
end;

procedure TVectorHelperTimingTest.TestTimeRotate;
begin
  TestDispName := 'VectorH Rotate';
  GlobalProfiler[0].Clear;
  GlobalProfiler[0].Start;
  for cnt := 1 to IterationsQuarter do begin nt3 := nt1.Rotate(NativeYHmgVector,alpha); end;
  GlobalProfiler[0].Stop;
  GlobalProfiler[1].Clear;
  GlobalProfiler[1].Start;
  for cnt := 1 to IterationsQuarter do begin vt3 := vt1.Rotate(YHmgVector,alpha); end;
  GlobalProfiler[1].Stop;
end;

procedure TVectorHelperTimingTest.TestTimeRotateAroundX;
begin
  TestDispName := 'VectorH Rotate Around X';
  GlobalProfiler[0].Clear;
  GlobalProfiler[0].Start;
  for cnt := 1 to IterationsQuarter do begin nt3 := nt1.RotateAroundX(alpha); end;
  GlobalProfiler[0].Stop;
  GlobalProfiler[1].Clear;
  GlobalProfiler[1].Start;
  for cnt := 1 to IterationsQuarter do begin vt3 := vt1.RotateAroundX(alpha); end;
  GlobalProfiler[1].Stop;
end;

procedure TVectorHelperTimingTest.TestTimeRotateAroundY;
begin
  TestDispName := 'VectorH Rotate Around Y';
  GlobalProfiler[0].Clear;
  GlobalProfiler[0].Start;
  for cnt := 1 to IterationsQuarter do begin nt3 := nt1.RotateAroundY(alpha); end;
  GlobalProfiler[0].Stop;
  GlobalProfiler[1].Clear;
  GlobalProfiler[1].Start;
  for cnt := 1 to IterationsQuarter do begin vt3 := vt1.RotateAroundY(alpha); end;
  GlobalProfiler[1].Stop;
end;

procedure TVectorHelperTimingTest.TestTimeRotateAroundZ;
begin
  TestDispName := 'VectorH Rotate Around Z';
  GlobalProfiler[0].Clear;
  GlobalProfiler[0].Start;
  for cnt := 1 to IterationsQuarter do begin nt3 := nt1.RotateAroundZ(alpha); end;
  GlobalProfiler[0].Stop;
  GlobalProfiler[1].Clear;
  GlobalProfiler[1].Start;
  for cnt := 1 to IterationsQuarter do begin vt3 := vt1.RotateAroundZ(alpha); end;
  GlobalProfiler[1].Stop;
end;

procedure TVectorHelperTimingTest.TestTimeRotateWithMatrixAroundX;
begin
  TestDispName := 'VectorH Rotate with Matrix Around X';
  GlobalProfiler[0].Clear;
  GlobalProfiler[0].Start;
  for cnt := 1 to IterationsQuarter do begin nt3 := nt1.RotateWithMatrixAroundX(alpha); end;
  GlobalProfiler[0].Stop;
  GlobalProfiler[1].Clear;
  GlobalProfiler[1].Start;
  for cnt := 1 to IterationsQuarter do begin vt3 := vt1.RotateWithMatrixAroundX(alpha); end;
  GlobalProfiler[1].Stop;
end;

procedure TVectorHelperTimingTest.TestTimeRotateWithMatrixAroundY;
begin
  TestDispName := 'VectorH Rotate with Matrix Around Y';
  GlobalProfiler[0].Clear;
  GlobalProfiler[0].Start;
  for cnt := 1 to IterationsQuarter do begin nt3 := nt1.RotateWithMatrixAroundY(alpha); end;
  GlobalProfiler[0].Stop;
  GlobalProfiler[1].Clear;
  GlobalProfiler[1].Start;
  for cnt := 1 to IterationsQuarter do begin vt3 := vt1.RotateWithMatrixAroundY(alpha); end;
  GlobalProfiler[1].Stop;
end;

procedure TVectorHelperTimingTest.TestTimeRotateWithMatrixAroundZ;
begin
  TestDispName := 'VectorH Rotate with Matrix Around Z';
  GlobalProfiler[0].Clear;
  GlobalProfiler[0].Start;
  for cnt := 1 to IterationsQuarter do begin nt3 := nt1.RotateWithMatrixAroundZ(alpha); end;
  GlobalProfiler[0].Stop;
  GlobalProfiler[1].Clear;
  GlobalProfiler[1].Start;
  for cnt := 1 to IterationsQuarter do begin vt3 := vt1.RotateWithMatrixAroundZ(alpha); end;
  GlobalProfiler[1].Stop;
end;

procedure TVectorHelperTimingTest.TestTimeAverageNormal4;
begin
  TestDispName := 'VectorH AverageNormal4';
  GlobalProfiler[0].Clear;
  GlobalProfiler[0].Start;
  for cnt := 1 to IterationsQuarter do begin nt5 := nt1.AverageNormal4(nt1,nt2,nt3,nt4); end;
  GlobalProfiler[0].Stop;
  GlobalProfiler[1].Clear;
  GlobalProfiler[1].Start;
  for cnt := 1 to IterationsQuarter do begin vt5 := vt1.AverageNormal4(vt1,vt2,vt3,vt4); end;
  GlobalProfiler[1].Stop;
end;

procedure TVectorHelperTimingTest.TestTimePointProject;
begin
  TestDispName := 'VectorH Point Project';
  GlobalProfiler[0].Clear;
  cnt:=0;
  GlobalProfiler[0].Start;

  //for cnt := 1 to Iterations do begin Fs1 := nt1.PointProject(nt2,nt3); end;
  while cnt<Iterations do
  begin
    Fs1 := nt1.PointProject(nt2,nt3);
    inc(cnt);
  end;
  GlobalProfiler[0].Stop;
  GlobalProfiler[1].Clear;
  cnt:=0;
  GlobalProfiler[1].Start;

  while cnt<Iterations do
  begin
    Fs2 := vt1.PointProject(vt2,vt3);
    inc(cnt);
  end;
  //for cnt := 1 to Iterations do begin Fs2 := vt1.PointProject(vt2,vt3); end;
  GlobalProfiler[1].Stop;
end;

procedure TVectorHelperTimingTest.TestTimeMoveAround;
begin
  TestDispName := 'VectorH MoveAround';
  GlobalProfiler[0].Clear;
  GlobalProfiler[0].Start;
  for cnt := 1 to IterationsQuarter do begin nt3 := nt1.MoveAround(NativeYHmgVector,nt2, alpha, alpha); end;
  GlobalProfiler[0].Stop;
  GlobalProfiler[1].Clear;
  GlobalProfiler[1].Start;
  for cnt := 1 to IterationsQuarter do begin vt3 := vt1.MoveAround(YHmgVector,vt2, alpha, alpha); end;
  GlobalProfiler[1].Stop;
end;

procedure TVectorHelperTimingTest.TestTimeShiftObjectFromCenter;
begin
  TestDispName := 'VectorH ShiftObjectFromCenter';
  GlobalProfiler[0].Clear;
  GlobalProfiler[0].Start;
  for cnt := 1 to IterationsQuarter do begin nt3 := nt1.ShiftObjectFromCenter(nt2, Fs1, True); end;
  GlobalProfiler[0].Stop;
  GlobalProfiler[1].Clear;
  GlobalProfiler[1].Start;
  for cnt := 1 to IterationsQuarter do begin vt3 := vt1.ShiftObjectFromCenter(vt2, Fs1, True); end;
  GlobalProfiler[1].Stop;
end;

procedure TVectorHelperTimingTest.TestTimeExtendClipRect;
var
  nCr: TNativeBZClipRect;
  aCr: TBZClipRect;
begin
  //nCr.V := nt1.V;
  //aCr.V := vt1.V;
  //TestDispName := 'VectorH ExtendClipRect';
  //GlobalProfiler[0].Clear;
  //GlobalProfiler[0].Start;
  //for cnt := 1 to Iterations do begin nCr.ExtendClipRect(Fs1,Fs2); end;
  //GlobalProfiler[0].Stop;
  //GlobalProfiler[1].Clear;
  //GlobalProfiler[1].Start;
  //for cnt := 1 to Iterations do begin aCr.ExtendClipRect(Fs1,Fs2); end;
  //GlobalProfiler[1].Stop;
end;

procedure TVectorHelperTimingTest.TestTimeStep;
begin
  TestDispName := 'VectorH Step';
  GlobalProfiler[0].Clear;
  GlobalProfiler[0].Start;
  for cnt := 1 to Iterations do begin nt3 := nt1.Step(nt2);  end;
  GlobalProfiler[0].Stop;
  GlobalProfiler[1].Clear;
  GlobalProfiler[1].Start;
  for cnt := 1 to Iterations do begin vt3 := vt1.Step(vt2);  end;
  GlobalProfiler[1].Stop;
end;

procedure TVectorHelperTimingTest.TestTimeFaceForward;
begin
  TestDispName := 'VectorH FaceForward';
  GlobalProfiler[0].Clear;
  GlobalProfiler[0].Start;
  for cnt := 1 to Iterations do begin nt4 := nt1.FaceForward(nt2,nt3); end;
  GlobalProfiler[0].Stop;
  GlobalProfiler[1].Clear;
  GlobalProfiler[1].Start;
  for cnt := 1 to Iterations do begin vt4 := vt1.FaceForward(vt2,vt3); end;
  GlobalProfiler[1].Stop;
end;

procedure TVectorHelperTimingTest.TestTimeSaturate;
begin
  TestDispName := 'VectorH Saturate';
  GlobalProfiler[0].Clear;
  GlobalProfiler[0].Start;
  for cnt := 1 to Iterations do begin nt4 := nt1.Saturate; end;
  GlobalProfiler[0].Stop;
  GlobalProfiler[1].Clear;
  GlobalProfiler[1].Start;
  for cnt := 1 to Iterations do begin vt4 := vt1.Saturate; end;
  GlobalProfiler[1].Stop;
end;

procedure TVectorHelperTimingTest.TestTimeSmoothStep;
begin
  vt1.Create(1,1,1,1);  // self
  vt2.Create(0,0,0,0);  // A
  vt3.Create(2,2,2,2);  // B
  TestDispName := 'VectorH SmoothStep';
  GlobalProfiler[0].Clear;
  GlobalProfiler[0].Start;
  for cnt := 1 to Iterations do begin nt4 := nt1.SmoothStep(nt2,nt3); end;
  GlobalProfiler[0].Stop;
  GlobalProfiler[1].Clear;
  GlobalProfiler[1].Start;
  for cnt := 1 to Iterations do begin vt4 := vt1.SmoothStep(vt2,vt3); end;
  GlobalProfiler[1].Stop;
end;

initialization
  RegisterTest(REPORT_GROUP_VECTOR4F, TVectorHelperTimingTest);
end.

