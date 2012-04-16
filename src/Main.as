package 
{
	import BaseAssets.BaseMain;
	import cepa.utils.ToolTip;
	import fl.transitions.easing.None;
	import fl.transitions.Tween;
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.filters.GlowFilter;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.utils.getDefinitionByName;
	import flash.utils.getQualifiedClassName;
	
	/**
	 * ...
	 * @author Alexandre
	 */
	public class Main extends BaseMain
	{
		private var tweenX:Tween;
		private var tweenY:Tween;
		
		private var tweenX2:Tween;
		private var tweenY2:Tween;
		
		private var tweenTime:Number = 0.2;
		
		public function Main() 
		{
			if (stage) init();
			else addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		private function init(e:Event = null):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
			this.scrollRect = new Rectangle(0, 0, 700, 760);
			
			addListeners();
			
			createAnswer();
			verificaFinaliza();
		}
		
		private function addListeners():void 
		{
			finaliza.addEventListener(MouseEvent.CLICK, finalizaExec);
			finaliza.buttonMode = true;
		}
		
		private function finalizaExec(e:MouseEvent):void 
		{
			var nCertas:int = 0;
			var nPecas:int = 0;
			
			for (var i:int = 0; i < numChildren; i++) 
			{
				var child:DisplayObject = getChildAt(i);
				if (child is Peca) {
					nPecas++;
					if(Peca(child).fundo.indexOf(Peca(child).currentFundo) != -1){
						nCertas++;
						trace(Peca(child).nome);
					}
				}
			}
			
			var currentScore:Number = int((nCertas / nPecas) * 100);
			
			trace(currentScore, nPecas, nCertas);
			if (currentScore < 100) {
				feedbackScreen.setText("Releia a questão e avalie a sequência escolhida.");
			}
			else {
				feedbackScreen.setText("Parabéns!\nA sequência está correta!");
			}
			setChildIndex(feedbackScreen, numChildren - 1);
			setChildIndex(bordaAtividade, numChildren - 1);
		}
		
		private function verificaFinaliza():void 
		{
			for (var i:int = 0; i < numChildren; i++) 
			{
				var child:DisplayObject = getChildAt(i);
				if (child is Peca) {
					if(Peca(child).currentFundo == null){
						finaliza.mouseEnabled = false;
						finaliza.alpha = 0.5;
						return;
					}
				}
			}
			
			finaliza.mouseEnabled = true;
			finaliza.alpha = 1;
		}
		
		private function checkForFinish():Boolean
		{
			for (var i:int = 0; i < numChildren; i++) 
			{
				var child:DisplayObject = getChildAt(i);
				
				if (child is Peca) {
					if (Peca(child).currentFundo == null) return false;
				}
			}
			
			return true;
		}
		
		private function createAnswer():void 
		{
			for (var i:int = 0; i < numChildren; i++) 
			{
				var child:DisplayObject = getChildAt(i);
				if (child is Peca) {
					setAnswerForPeca(Peca(child));
					var objClass:Class = Class(getDefinitionByName(getQualifiedClassName(child)));
					var ghostObj:* = new objClass();
					MovieClip(ghostObj).gotoAndStop(1);
					Peca(child).ghost = ghostObj;
					Peca(child).addListeners();
					Peca(child).inicialPosition = new Point(child.x, child.y);
					child.addEventListener(Event.CHANGE, verifyPosition);
					child.addEventListener(Event.ACTIVATE, verifyForFilter);
					Peca(child).buttonMode = true;
					Peca(child).gotoAndStop(1);
					if (child is Peca8 || child is Peca9) {
						child.addEventListener(MouseEvent.MOUSE_OVER, overMc);
						child.addEventListener(MouseEvent.MOUSE_OUT, outMc);
					}
				}
				
			}
		}
		
		private function overMc(e:MouseEvent):void
		{
			var peca:Peca = Peca(e.target);
			peca.gotoAndStop(2);
			setChildIndex(peca, numChildren - 1);
		}
		
		private function outMc(e:MouseEvent):void
		{
			var peca:Peca = Peca(e.target);
			peca.gotoAndStop(1);
		}
		
		private var pecaDragging:Peca;
		private var fundoFilter:GlowFilter = new GlowFilter(0xFF0000, 1, 20, 20, 1, 2, true, true);
		private var fundoWGlow:MovieClip;
		private function verifyForFilter(e:Event):void 
		{
			pecaDragging = Peca(e.target);
			stage.addEventListener(MouseEvent.MOUSE_MOVE, verifying);
		}
		
		private function verifying(e:MouseEvent):void 
		{
			var fundoUnder:Fundo = getFundo(new Point(pecaDragging.ghost.x, pecaDragging.ghost.y));
			
			if (fundoUnder != null) {
				/*if (fundoUnder.currentPeca != null) {
					if (fundoWGlow == null) {
						fundoWGlow = fundoUnder.currentPeca;
						fundoWGlow.gotoAndStop(2);
					}else {
						if (fundoWGlow is Fundo) {
							fundoWGlow.borda.filters = [];
						}else {
							fundoWGlow.gotoAndStop(1);
						}
						fundoWGlow = fundoUnder.currentPeca;
						fundoWGlow.gotoAndStop(2);
					}
				}else{*/
					if (fundoWGlow == null) {
						fundoWGlow = fundoUnder;
						fundoWGlow.borda.filters = [fundoFilter];
					}else {
						if (fundoWGlow is Fundo) {
							fundoWGlow.borda.filters = [];
						}else {
							fundoWGlow.gotoAndStop(1);
						}
						fundoWGlow = fundoUnder;
						fundoWGlow.borda.filters = [fundoFilter];
					}
				//}
			}else {
				if (fundoWGlow != null) {
					if(fundoWGlow is Fundo){
						Fundo(fundoWGlow).borda.filters = [];
					}else {
						fundoWGlow.gotoAndStop(1);
					}
					fundoWGlow = null;
				}
			}
		}
		
		private function verifyPosition(e:Event):void 
		{
			stage.removeEventListener(MouseEvent.MOUSE_MOVE, verifying);
			pecaDragging = null;
			if (fundoWGlow != null) {
				if (fundoWGlow is Fundo) fundoWGlow.borda.filters = [];
				else fundoWGlow.gotoAndStop(1);
				fundoWGlow = null;
			}
			
			var peca:Peca = e.target as Peca;
			var fundoDrop:Fundo = getFundo(peca.position);
			
			if (fundoDrop != null) {
				if (fundoDrop.currentPeca == null) {
					if (peca.currentFundo != null) {
						Fundo(peca.currentFundo).currentPeca = null;
					}
					fundoDrop.currentPeca = peca;
					peca.currentFundo = fundoDrop;
					//tweenX = new Tween(peca, "x", None.easeNone, peca.x, fundoDrop.x, 0.5, true);
					//tweenY = new Tween(peca, "y", None.easeNone, peca.y, fundoDrop.y, 0.5, true);
					peca.x = fundoDrop.x;
					peca.y = fundoDrop.y;
				}else {
					if(peca.currentFundo != null){
						var pecaFundo:Peca = Peca(fundoDrop.currentPeca);
						var fundoPeca:Fundo = Fundo(peca.currentFundo);
						
						tweenX = new Tween(peca, "x", None.easeNone, peca.x, fundoDrop.x, tweenTime, true);
						tweenY = new Tween(peca, "y", None.easeNone, peca.y, fundoDrop.y, tweenTime, true);
						
						tweenX2 = new Tween(pecaFundo, "x", None.easeNone, pecaFundo.x, fundoPeca.x, tweenTime, true);
						tweenY2 = new Tween(pecaFundo, "y", None.easeNone, pecaFundo.y, fundoPeca.y, tweenTime, true);
						
						peca.currentFundo = fundoDrop;
						fundoDrop.currentPeca = peca;
						
						pecaFundo.currentFundo = fundoPeca;
						fundoPeca.currentPeca = pecaFundo;
					}else {
						pecaFundo = Peca(fundoDrop.currentPeca);
						
						//tweenX = new Tween(peca, "x", None.easeNone, peca.position.x, fundoDrop.x, tweenTime, true);
						//tweenY = new Tween(peca, "y", None.easeNone, peca.position.y, fundoDrop.y, tweenTime, true);
						peca.x = fundoDrop.x;
						peca.y = fundoDrop.y;
						
						tweenX2 = new Tween(pecaFundo, "x", None.easeNone, pecaFundo.x, pecaFundo.inicialPosition.x, tweenTime, true);
						tweenY2 = new Tween(pecaFundo, "y", None.easeNone, pecaFundo.y, pecaFundo.inicialPosition.y, tweenTime, true);
						
						peca.currentFundo = fundoDrop;
						fundoDrop.currentPeca = peca;
						
						pecaFundo.currentFundo = null;
					}
				}
			}else {
				if (peca.currentFundo != null) {
					Fundo(peca.currentFundo).currentPeca = null;
					peca.currentFundo = null;
				}
				tweenX = new Tween(peca, "x", None.easeNone, peca.x, peca.inicialPosition.x, tweenTime, true);
				tweenY = new Tween(peca, "y", None.easeNone, peca.y, peca.inicialPosition.y, tweenTime, true);
			}
			
			verificaFinaliza();
		}
		
		private function getFundo(position:Point):Fundo 
		{
			for (var i:int = 0; i < numChildren; i++)
			{
				var child:DisplayObject = getChildAt(i);
				if (child is Fundo) {
					if (child.hitTestPoint(position.x, position.y)) return Fundo(child);
				}
			}
			return null;
		}
		
		private function getFundoByName(name:String):Fundo 
		{
			if (name == "") return null;
			for (var i:int = 0; i < numChildren; i++)
			{
				var child:DisplayObject = getChildAt(i);
				if (child is Fundo) {
					if (child.name == name) return Fundo(child);
				}
			}
			return null;
		}
		
		private function setAnswerForPeca(child:Peca):void 
		{
			if (child is Peca1) {
				child.fundo = [fundo1];
				child.nome = "peca1";
			}else if (child is Peca2) {
				child.fundo = [fundo2];
				child.nome = "peca2";
			}else if (child is Peca3) {
				child.fundo = [fundo3];
				child.nome = "peca3";
			}else if (child is Peca4) {
				child.fundo = [fundo4];
				child.nome = "peca4";
			}else if (child is Peca5) {
				child.fundo = [fundo5];
				child.nome = "peca5";
			}else if (child is Peca6) {
				child.fundo = [fundo6];
				child.nome = "peca6";
			}else if (child is Peca7) {
				child.fundo = [fundo7];
				child.nome = "peca7";
			}else if (child is Peca8) {
				child.fundo = [fundo8];
				child.nome = "peca8";
			}else if (child is Peca9) {
				child.fundo = [fundo9];
				child.nome = "peca9";
			}else if (child is Peca10) {
				child.fundo = [fundo10];
				child.nome = "peca10";
			}else if (child is Peca11) {
				child.fundo = [fundo11];
				child.nome = "peca11";
			}else if (child is Peca12) {
				child.fundo = [fundo12];
				child.nome = "peca12";
			}else if (child is Peca13) {
				child.fundo = [fundo13];
				child.nome = "peca13";
			}else if (child is Peca14) {
				child.fundo = [fundo14];
				child.nome = "peca14";
			}else if (child is Peca15) {
				child.fundo = [fundo15];
				child.nome = "peca15";
			}
		}
		
		override public function reset(e:MouseEvent = null):void
		{
			for (var i:int = 0; i < numChildren; i++)
			{
				var child:DisplayObject = getChildAt(i);
				if (child is Peca) {
					child.x = Peca(child).inicialPosition.x;
					child.y = Peca(child).inicialPosition.y;
					Peca(child).currentFundo = null;
				}
				if (child is Fundo) {
					Fundo(child).currentPeca = null;
				}
			}
			
			verificaFinaliza();
		}
		
	}

}