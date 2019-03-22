package script {
	import ui.test.TestSceneUI;
	import laya.events.Event;
	import laya.display.Scene;
	import laya.display.Sprite;
    import laya.utils.Browser;
	import laya.utils.Utils;

	public class GameUI extends TestSceneUI {
		private var logined : bool;	 	// 是否已经登录
		private var ect : number;   	// 玩家当前的ECT数量	
		private var counter : number;	// 一个计数器，用于计算交易是否结束
		override public function onEnable():void {
			// 打开注册页面
			this.regBtn.on(Event.CLICK, this, this.register);
			// 创建钱包账户
			this.createBtn.on(Event.CLICK, this, this.createWallet);
			// 从注册页面返回主页面
			this.backBtn.on(Event.CLICK, this, this.backFromCreate);
			// 打开登录页面
			this.login2Btn.on(Event.CLICK, this, this.openWifLoginView);
			// 登录
			this.wifLoginBtn.on(Event.CLICK, this, this.doWifLogin);
			// 从登录页面返回
			this.backFromWifBtn.on(Event.CLICK, this, this.backFromWifLogin);
			// 猜一下
			this.betBtn.on(Event.CLICK, this, this.guess);
		}
		
		override public function onDisable():void {
		}

		/**
		 * 打开注册页面
		 */
		public function register():void {
			this.promptLabel.text = '';
			console.log('Open Register View');
			this.mainView.visible = false;
			this.regView.visible = true;

			//Scene.open("test/RegScene.scene");
		}

		/**
		 * 初始化SDK
		 */
		public function createWallet():void {
			if (passwd.text != repasswd.text) {
				this.resultLabel.text = '两次输入密码不一致';
				return;
			}
			this.promptLabel.text = '下一步使用wif登录';

			var that = this;
			window.EasyCheers.SDK.createWallet(passwd.text,function(nep2key, wif):void {
				that.nep2key.text=nep2key;
				that.wif.text = wif;
			});
		}

		public function backFromCreate():void {
			this.mainView.visible = true;
			this.regView.visible = false;
		}

		

		public function openWifLoginView():void {
			this.promptLabel.text = '';
			console.log('Open wifLogin View');
			this.mainView.visible = false;
			this.wifLoginView.visible = true;
			var wif: string = this.wif1.text;

		}

		public function doWifLogin():void {
			var that = this;
			window.EasyCheers.SDK.loginWif(this.wif1.text, function(res):void {
				that.logined = res;
				that.wifLoginState.text = res;
				// 当高度发生变化时，调用回调函数，用于更新数据
				window.EasyCheers.SDK.registerHeightChangedCallback(window.EasyCheers.SDK.getBalances);
			})

		}

		public function backFromWifLogin():void {
			this.mainView.visible = true;
			this.wifLoginView.visible = false;
			if (this.logined) {
				console.log('register timer');
				Laya.timer.loop(500, this, this.loop500); 
				Laya.timer.loop(5000, this, this.loop5000); 
				this.promptLabel.text = '请等待获取ECT的数量';
			}
		}

		public function loop500()
		{
			this.UpdateAddrNeoGas();
		}

		public function loop5000()
		{
			//console.log('read Contract');
			this.getValueFromContract('2de5d7df633a81ef831434954d514d325863076d', 
				'balanceOf',
				'(addr)'+window.EasyCheers.SDK.getCurrentAddr());

			this.UpdateCounter();
		}

		public function UpdateCounter()
		{
			if (this.counter > 0) {
				if (this.counter > 20) {
					this.counter = 0
					this.promptLabel.text = "请猜测随机数的掉落区间"
				} 
				else 
				{
					this.counter += 5;
				}
			}

		}

		public function UpdateAddrNeoGas():void
		{
			//console.log('update addr neo gas');
			this.neoGasLabel.text = "neo:" + window.EasyCheers.SDK.getNeo() + " ";
			this.neoGasLabel.text = this.neoGasLabel.text + "gas:" + window.EasyCheers.SDK.getGas();
			this.curAddrTI.text = window.EasyCheers.SDK.getCurrentAddr();
			this.nep5Label.text = 'ECT:' + this.ect;
		}
		
		
		/**
		 * 合约查询-ok按钮
		 */
		public function getValueFromContract(assetID:string, method:string, addr:string):void {
			// assetid:	 '2de5d7df633a81ef831434954d514d325863076d';
			// addr: 	 '["(addr)AeMjpHfAbe4DZ3Qpvzem1aiAhz2FwDJYmH"]';
			// method: 	 'balanceOf';

			var that = this;
			window.EasyCheers.SDK.contractGetValue(assetID, method, addr, function(res):void {
				that.ect = res;
				if (that.ect == '0') {
					that.promptLabel.text = '若ECT=0，请向管理员索要';
				}
			});

			
		}

		
		/**
		 * 猜测
		 */
		public function guess():void {
			if (this.ect < 10) {
				this.promptLabel.text = 'ECT数量不够';
				return;
			}
			var contractHash : string = "0xa31149e3bf0b8f7a14d0c4f390958f9bef09314f";
			window.EasyCheers.SDK.guess(contractHash, window.EasyCheers.SDK.getCurrentAddr(), this.minTI.text, this.maxTI.text, 10, function(res):void {
				console.log("read", '[Easy]', 'invokescript.callback.function.res => ', res);
			});
			this.promptLabel.text = '请等待交易完成...';
			this.counter = 1;
		}
		
		
	}
}