package BaseAssets
{
	import cepa.utils.ToolTip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	/**
	 * ...
	 * @author Alexandre
	 */
	public class BaseMain extends Sprite
	{
		/**
		 * Telas da atividade
		 */
		protected var creditosScreen:AboutScreen;
		protected var orientacoesScreen:InstScreen;
		protected var feedbackScreen:FeedBackScreen;
		
		protected var bordaAtividade:Borda;
		protected var botoes:Botoes;
		
		public function BaseMain() 
		{
			if (stage) initBase();
			else addEventListener(Event.ADDED_TO_STAGE, initBase);
		}
		
		private function initBase(e:Event = null):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, initBase);
			
			scrollRect = new Rectangle(0, 0, stage.stageWidth, stage.stageHeight);
			
			criaBorda();
			criaBotoes();
			criaTelas();
			adicionaListeners();
		}
		
		/**
		 * Cria a borda da atividade.
		 */
		private function criaBorda():void 
		{
			bordaAtividade = new Borda();
			bordaAtividade.scale9Grid = new Rectangle(20, 20, 610, 460);
			bordaAtividade.scaleX = stage.stageWidth / bordaAtividade.width;
			bordaAtividade.scaleY = stage.stageHeight / bordaAtividade.height;
			addChild(bordaAtividade);
		}
		
		/**
		 * Cria o menu com os botões
		 */
		private function criaBotoes():void 
		{
			botoes = new Botoes();
			botoes.x = stage.stageWidth - botoes.width - 10;
			botoes.y = stage.stageHeight - botoes.height - 10;
			addChild(botoes);
		}
		
		/**
		 * Cria as telas e adiciona no palco.
		 */
		private function criaTelas():void 
		{
			creditosScreen = new AboutScreen();
			addChild(creditosScreen);
			orientacoesScreen = new InstScreen();
			addChild(orientacoesScreen);
			feedbackScreen = new FeedBackScreen();
			addChild(feedbackScreen);
		}
		
		/**
		 * Adiciona os eventListeners nos botões.
		 */
		private function adicionaListeners():void 
		{
			//botoes.tutorialBtn.addEventListener(MouseEvent.CLICK, iniciaTutorial);
			botoes.orientacoesBtn.addEventListener(MouseEvent.CLICK, openOrientacoes);
			botoes.creditos.addEventListener(MouseEvent.CLICK, openCreditos);
			botoes.resetButton.addEventListener(MouseEvent.CLICK, reset);
			
			createToolTips();
		}
		
		/**
		 * Cria os tooltips nos botões
		 */
		private function createToolTips():void 
		{
			//var intTT:ToolTip = new ToolTip(botoes.tutorialBtn, "Reiniciar tutorial", 12, 0.8, 150, 0.6, 0.1);
			var instTT:ToolTip = new ToolTip(botoes.orientacoesBtn, "Orientações", 12, 0.8, 100, 0.6, 0.1);
			var resetTT:ToolTip = new ToolTip(botoes.resetButton, "Reiniciar", 12, 0.8, 100, 0.6, 0.1);
			var infoTT:ToolTip = new ToolTip(botoes.creditos, "Créditos", 12, 0.8, 100, 0.6, 0.1);
			
			//addChild(intTT);
			addChild(instTT);
			addChild(resetTT);
			addChild(infoTT);
			
		}
		
		/**
		 * Inicia o tutorial da atividade.
		 */
		public function iniciaTutorial(e:MouseEvent = null):void 
		{
			
		}
		
		/**
		 * Abrea a tela de orientações.
		 */
		private function openOrientacoes(e:MouseEvent):void 
		{
			orientacoesScreen.openScreen();
			setChildIndex(orientacoesScreen, numChildren - 1);
			setChildIndex(bordaAtividade, numChildren - 1);
		}
		
		/**
		 * Abre a tela de créditos.
		 */
		private function openCreditos(e:MouseEvent):void 
		{
			creditosScreen.openScreen();
			setChildIndex(creditosScreen, numChildren - 1);
			setChildIndex(bordaAtividade, numChildren - 1);
		}
		
		/**
		 * Reinicia a atividade, colocando-a no seu estado inicial.
		 */
		public function reset(e:MouseEvent = null):void 
		{
			
		}
		
	}

}