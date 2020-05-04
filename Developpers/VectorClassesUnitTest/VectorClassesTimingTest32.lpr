program VectorClassesTimingTest32;

{$mode objfpc}{$H+}

{$define NO_TIMING_TEST}

uses
  Interfaces, Forms, GuiTestRunner,
  // Vector2f Test Case
  Vector2fFunctionalTest,
  Vector2OperatorsTestCase,
  Vector2NumericsTestCase,
  // Vector3b Test Case
  Vector3bComparatorTest,
  // Vector4b Test Case
  Vector4bComparatorTest,
  Vector4iComparatorTest,
  // Vector4f Test Case
  VectorOperatorsTestCase,
  VectorNumericsTestCase,
  VectorOtherTestCase,
  // HmgPlane Test Case
  HmgPlaneFunctionalTest,
  HmgPlaneComparatorTest,
  // Matrix Test Case
  MatrixFunctionalTest,  
  MatrixTestCase,
  // Quaternion Test Case
  QuaternionTestCase,
  // Vector4f and Plane Test Case
  VectorHelperTestCase,
  // bounding box et al
  BoundingBoxComparatorTest,  
  BSphereComparatorTest,
  AABBComparatorTest;

begin
  Application.Title:='VectorClassesUnitTest';
  Application.Initialize;
  Application.CreateForm(TGuiTestRunner, TestRunner);
  Application.Run;
end.

