package com.commands {

	import mx.rpc.IResponder;
	import com.adobe.cairngorm.commands.Command;
	import com.adobe.cairngorm.control.CairngormEvent;
	import com.business.GeneratorServicesDelegate;
	import com.model.ModelLocator;
	import mx.controls.Alert;
	import com.control.GetTablesEvent;
	import com.vo.datasourceVO;
	import mx.managers.CursorManager;
	

	public class GetTablesCommand implements Command, IResponder {

		private var model : ModelLocator = ModelLocator.getInstance();
		
		public function execute( cgEvent:CairngormEvent ) : void {
			CursorManager.setBusyCursor();
			var delegate : GeneratorServicesDelegate = new GeneratorServicesDelegate( this );
			var getTablesEvent : GetTablesEvent = GetTablesEvent( cgEvent );  
			model.datasource = getTablesEvent.datasource;
			delegate.getTablesService(getTablesEvent.datasource);
			}
		
		public function result( rpcEvent : Object ) : void {
			CursorManager.removeBusyCursor();
			model.tables.source = rpcEvent.result as Array;
			}
		
		public function fault( rpcEvent : Object ) : void {
			CursorManager.removeBusyCursor();
			// store an error message in the model locator
			// labels, alerts, etc can bind to this to notify the user of errors
			mx.controls.Alert.show("Fault occured in GetTablesCommand. Please verify your selected datasource in the CodldFusion administrator.");
			mx.controls.Alert.show(rpcEvent.fault.faultCode);
			mx.controls.Alert.show(rpcEvent.fault.faultString);
			}
		}
	}