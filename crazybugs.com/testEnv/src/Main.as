package 
{
	import flash.display.Loader;
	import flash.display.Sprite;
    import flash.events.*;
    import flash.net.*;
	import flash.net.FileReference;
	import flash.utils.*;
	
	
	public class Main extends Sprite 
	{
		
		public function Main():void 
		{
			
			var fileR:FileReference = new FileReference();
			var fileLoader :Loader;
			fileR.browse(null);
			

            
	
			fileR.addEventListener(Event.CANCEL, cancelHandler);
			fileR.addEventListener(Event.SELECT, selectHandler);
			fileR.addEventListener(ProgressEvent.PROGRESS, progressHandler);
			fileR.addEventListener(Event.COMPLETE, completeHandler);

			function selectHandler(e:Event):void { 
				// file select
			   trace("selectHandler: " + fileR.name);
			   try {
				   
					fileR.load();
			   }
			   catch (e : Error) {
			   trace(e)}
			}
			function cancelHandler(e:Event):void { // file select canceled
			   trace("cancelHandler");
			}
			function progressHandler(e:ProgressEvent):void{ // progress event
			   trace("progressHandler: loaded="+e.bytesLoaded+" total="+e.bytesTotal);
			}
			function completeHandler(e:Event):void { // file loaded
				try{
			   trace("completeHandler: " + fileR.name);
			   var ba: ByteArray = fileR.data;
				}catch (e:Error) { trace(e) }
				
				
			trace("Ha");
            var loader : URLLoader = new URLLoader();			
			
			trace("HERE");
			   // now you have your file loaded as a ByteArray
			   var url:String = "http://10.24.15.67/dragonfly/upload.php";
				//var google:String = "http://www.google.com";
				//url = google;
				var request : URLRequest = new URLRequest(url);  
				request.method = URLRequestMethod.POST;
				request.contentType = "multipart/form-data; boundary=---------------------------7da24f2e50046--";
				
				
				
				//request.data = myByteArray;
	   
				loader.load(request);
				loader.addEventListener( Event.COMPLETE, handleLoaderComplete )

				trace(request.data);
				trace("got here");
			
			}
			

		}
		
		
		
		
		private function init(e:Event = null):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
			// entry point
		}
		private function handleLoaderComplete(e:Event):void
		{
			
			var loader:URLLoader = URLLoader(e.target);
			trace(loader.data);
		}
	}
	
}