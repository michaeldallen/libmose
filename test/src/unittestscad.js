const assert = require("node:assert/strict");
const path = require("node:path");
const UnitTestSCAD = require("unittestscad");

const cube = new UnitTestSCAD.ThreeDModule({
  openSCADDirectory: __dirname,
  include: ["cube.scad"]
});

assert.equal(cube.width, 5);
assert.equal(cube.height, 5);
assert.equal(cube.depth, 5);

console.log("UnitTestSCAD cube test passed");