/**
 * 设置LayaNative屏幕方向，可设置以下值
 * landscape           横屏
 * portrait            竖屏
 * sensor_landscape    横屏(双方向)
 * sensor_portrait     竖屏(双方向)
 */
window.screenOrientation = "sensor_landscape";

//-----libs-begin-----
loadLib("libs/box2d.js")
loadLib("libs/rollup/aes.js")
loadLib("libs/asset/asmjs.js")
loadLib("libs/component/aes.js")
loadLib("libs/component/mode-ecb.js")
loadLib("libs/component/pad-nopadding.js")
loadLib("libs/jsrsasign.js")
loadLib("libs/neo-ts.js")
loadLib("libs/scrypt.js")
loadLib("libs/code.js")

//-----libs-end-------
loadLib("js/bundle.js");


