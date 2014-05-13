package com.XTQXK.net.X_AsProtobuf
{
	/**
	 * Descriptors are used for reflection and obtaining protocol
	 * buffer specific information about a field.
	 * 
	 * @author Robert Blackwood
	 */
	
	public class Descriptor {
		
		//Descriptor Types
	    static public const DOUBLE:int         = 1; // double, exactly eight bytes on the wire.
	    static public const FLOAT:int          = 2; // float, exactly four bytes on the wire.
	    static public const INT64:int          = 3; // int64, varint on the wire.  Negative numbers
	                               			   		// take 10 bytes.  Use SINT64 if negative
	                               			   		// values are likely.
	    static public const UINT64:int         = 4; // uint64, varint on the wire.
	    static public const INT32:int          = 5; // int32, varint on the wire.  Negative numbers
	                               			   		// take 10 bytes.  Use SINT32 if negative
	                               			   		// values are likely.
	    static public const FIXED64:int        = 6;  // uint64, exactly eight bytes on the wire.
	    static public const FIXED32:int        = 7;  // uint32, exactly four bytes on the wire.
	    static public const BOOL:int           = 8;  // bool, varint on the wire.
	    static public const STRING:int         = 9;  // UTF-8 text.
	    static public const GROUP:int          = 10; // Tag-delimited message.  Deprecated.
	    static public const MESSAGE:int        = 11; // Length-delimited message.
	
	    static public const BYTES:int          = 12;  // Arbitrary byte array.
	    static public const UINT32:int         = 13;  // uint32, varint on the wire
	    static public const ENUM:int           = 14;  // Enum, varint on the wire
	    static public const SFIXED32:int       = 15;  // int32, exactly four bytes on the wire
	    static public const SFIXED64:int       = 16;  // int64, exactly eight bytes on the wire
	    static public const SINT32:int         = 17;  // int32, ZigZag-encoded varint on the wire
	    static public const SINT64:int         = 18;  // int64, ZigZag-encoded varint on the wire
	
	    static public const MAX_TYPE:int       = 18;  	// Constant useful for defining lookup tables
	                               			   			// indexed by Type.
			
		//Descriptor Labels
	    static public const LABEL_OPTIONAL:int      = 1;  	// optional
	    static public const LABEL_REQUIRED:int      = 2;   	// required
	    static public const LABEL_REPEATED:int      = 3;   	// repeated
	    static public const MAX_LABEL:int           = 3;   	// Constant useful for defining lookup tables
                                							// indexed by Label.
 	
	 	public var fieldName:String;
 		public var label:int;
 		public var fieldNumber:int;
 		public var type:int;
 		public var messageClass:String;
 		
 		public function Descriptor(name:String, messageClass:String, type:int, label:int, fieldNumber:int) {
			this.fieldName = name;
			this.messageClass = messageClass;
			this.type = type;
 			this.label = label;
 			this.fieldNumber = fieldNumber;
 		}
 		
 		public function isOptional():Boolean { return label == LABEL_OPTIONAL; }
 		public function isRequired():Boolean { return label == LABEL_REQUIRED; }
 		public function isRepeated():Boolean { return label == LABEL_REPEATED; }
 		public function isMessage():Boolean  { return type == MESSAGE; }
 		
 	}
 	
 	
  
}