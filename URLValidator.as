package com.collectivecolors.validators
{
	//----------------------------------------------------------------------------------------------
	// Imports
	
	import mx.validators.ValidationResult;
	import mx.validators.Validator;

	//----------------------------------------------------------------------------------------------
   
   	[ResourceBundle("ccValidators")]
    public class URLValidator extends Validator
    {
        //------------------------------------------------------------------------------------------
        // Static methods
        
        public static function validateURL( validator : URLValidator,
        									value : Object,
        									baseField : String ) : Array
        {
        	var results : Array = [ ];
        	
        	//                           /-- protocol --\  /-- user --\ /-- password --\  /----------- host --------\ /- port -\  /-------- file ---------\  /-- query ---\  /- anchor -\
        	var absPattern : RegExp = /^(?:([^\s:]+):\/\/)(?:([^\s:@]+)(?::([^\s@]+))?@)?([^\s:.\/]+(?:\.[^\s:\/?#]+))(?::(\d+))?(?:\/((?:[^\s\/?#]+\/?)*))?(?:\?([^\s#]*))?(?:#([^\s]*))?$/i;
        	var match : Object     = absPattern.exec( value as String );
        	
        	if ( match == null )
        	{
        		// Not a valid / supported URL construct
        		results.push( new ValidationResult( true, baseField, "invalidURL", validator.invalidUrlError ) );
        		return results;
        	}
        	else
        	{
        		var protocol : String = String( match[1] ).toLowerCase( ); // Required
        		var username : String = match[2]; // Optional
        		var password : String = match[3]; // Optional
        		var host : String     = String( match[4] ).toLowerCase( ); // Required
        		var port : int        = match[5] as int; // Optional
        		var file : String     = match[6]; // Optional
        		var query : String    = match[7]; // Optional
        		var anchor : String   = match[8]; // Optional
        		
        		// Check protocol
        		if ( validator.allowedProtocols.length )
        		{
        			var protocolSupported : Boolean = false;
        			
        			for each ( var allowedProtocol : String in validator.allowedProtocols )
        			{
        				if ( allowedProtocol.toLowerCase( ) == protocol )
        				{
        					protocolSupported = true;
        					break;
        				}	
        			}
        			
        			if ( ! protocolSupported )
        			{
        				results.push( new ValidationResult( true, baseField, "invalidProtocol", validator.invalidProtocolError ) );
        				return results;
        			}	
        		}
        		
        		// Check port
        		if ( validator.allowedPorts.length )
        		{
        			var portSupported : Boolean = false;
        			
        			for each ( var allowedPort : int in validator.allowedPorts )
        			{
        				if ( allowedPort == port )
        				{
        					portSupported = true;
        					break;
        				}
        			}
        			
        			if ( ! portSupported )
        			{
        				results.push( new ValidationResult( true, baseField, "invalidPort", validator.invalidPortError ) );
        				return results;
        			}
        		}
        		
        		// Check file extension
        		if ( validator.allowedFileExtensions.length )
        		{
        			var extensionSupported : Boolean = false;
        			var extension : Object           = new RegExp("\.([^.]+)$", 'i').exec( file );
        			
        			if ( extension != null )
        			{
        				var fileExtension : String = String( extension[1] ).toLowerCase( );
        				
        				for each ( var allowedExtension : String in validator.allowedFileExtensions )
        				{
        					if ( allowedExtension.toLowerCase( ) == fileExtension )
        					{
        						extensionSupported = true;
        						break;
        					}
        				}	
        			}
        			
        			if ( ! extensionSupported )
        			{
        				results.push( new ValidationResult( true, baseField, "invalidExtension", validator.invalidFileExtensionError ) );
        				return results;	
        			}
        		}	
        	}        	
        	
        	return results;	
        }
        
        //------------------------------------------------------------------------------------------
        // Properties
        
        private var _allowedProtocols : Array;
        private var _allowedPorts : Array;
        private var _allowedFileExtensions : Array;
        
        private var _invalidUrlError : String;
        private var invalidUrlErrorOverride : String;
        
        private var _invalidProtocolError : String;
        private var invalidProtocolErrorOverride : String;
        
        private var _invalidPortError : String;
        private var invalidPortErrorOverride : String;
        
        private var _invalidFileExtensionError : String;
        private var invalidFileExtensionErrorOverride : String;
                
        //------------------------------------------------------------------------------------------
        // Constructor
        
        public function URLValidator( )
        {
            super( );
        }
        
        //------------------------------------------------------------------------------------------
        // Accessor / modifiers
        
        //------------------------
        // Criteria
        
        [Inspectable(category="General", defaultValue="null")]
        
        public function get allowedProtocols( ) : Array
        {
        	return ( _allowedProtocols != null ? _allowedProtocols : [ ] );
        }
        
        public function set allowedProtocols( values : Array ) : void
        {
        	_allowedProtocols = values;
        	
        	invalidProtocolError = invalidProtocolErrorOverride;
        }
        
        [Inspectable(category="General", defaultValue="null")]
        
        public function get allowedPorts( ) : Array
        {
        	return ( _allowedPorts != null ? _allowedPorts : [ ] );
        }
        
        public function set allowedPorts( values : Array ) : void
        {
        	_allowedPorts = values;
        	
        	invalidPortError = invalidPortErrorOverride;
        }
        
        [Inspectable(category="General", defaultValue="null")]
        
        public function get allowedFileExtensions( ) : Array
        {
        	return ( _allowedFileExtensions != null ? _allowedFileExtensions : [ ] );
        }
        
        public function set allowedFileExtensions( values : Array ) : void
        {
        	_allowedFileExtensions = values;
        	
        	invalidFileExtensionError = invalidFileExtensionErrorOverride;
        }        
        
        //------------------------
        //Errors
        
        [Inspectable(category="Errors", defaultValue="null")]
        
        public function get invalidUrlError( ) : String
        {
        	return _invalidUrlError;
        }
        
        public function set invalidUrlError( value : String ) : void
        {
        	invalidUrlErrorOverride = value;
        	
        	_invalidUrlError = ( value != null 
        						? value
        						: resourceManager.getString( "ccValidators", 
        													 "invalidUrlError" ) );        					
        }
        
        [Inspectable(category="Errors", defaultValue="null")]
        
        public function get invalidProtocolError( ) : String
        {
        	return _invalidProtocolError;
        }
        
        public function set invalidProtocolError( value : String ) : void
        {
        	invalidProtocolErrorOverride = value;
        	
        	_invalidProtocolError = ( value != null
        							 ? value
        							 : resourceManager.getString( "ccValidators", 
        							 							  "invalidProtocolError",
        							 							  [ allowedProtocols.join( ', ' )
        							 							  	                .toLowerCase( ) ] ) ); 
        }
        
        [Inspectable(category="Errors", defaultValue="null")]
        
        public function get invalidPortError( ) : String
        {
        	return _invalidPortError;
        }
        
        public function set invalidPortError( value : String ) : void
        {
        	invalidPortErrorOverride = value;
        	
        	_invalidPortError = ( value != null
        						 ? value
        						 : resourceManager.getString( "ccValidators",
        						 							  "invalidPortError",
        						 							  [ allowedPorts.join( ', ' ) ] ) );
        }
        
        [Inspectable(category="Errors", defaultValue="null")]
        
        public function get invalidFileExtensionError( ) : String
        {
        	return _invalidFileExtensionError;
        }
        
        public function set invalidFileExtensionError( value : String ) : void
        {
        	invalidFileExtensionErrorOverride = value;
        	
        	_invalidFileExtensionError = ( value != null
        								  ? value
        								  : resourceManager.getString( "ccValidators",
        								  							   "invalidFileExtensionError",
        								  							   [ allowedFileExtensions.join( ', ' )
        								  							   	                      .toLowerCase( ) ] ) );
        }        
        
        //------------------------------------------------------------------------------------------
        // Overrides
        
        override protected function resourcesChanged( ) : void
        {
        	super.resourcesChanged( );
        	
        	invalidUrlError           = invalidUrlErrorOverride;
        	invalidProtocolError      = invalidProtocolErrorOverride;
        	invalidPortError          = invalidPortErrorOverride;
        	invalidFileExtensionError = invalidFileExtensionErrorOverride;	
        }
       
        override protected function doValidation( value : Object ) : Array
        {
            var results : Array = super.doValidation( value );
		
			// Return if there are errors
			// or if the required property is set to false and length is 0.
			var val : String = value ? value as String : "";
			
			if ( results.length > 0 || ( ( val.length == 0 ) && ! required ) )
			{
				return results;
			}
			else
			{
		    	return URLValidator.validateURL(this, value, null);
		 	}
        }
    }
}