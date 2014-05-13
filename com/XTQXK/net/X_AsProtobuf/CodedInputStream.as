package com.XTQXK.net.X_AsProtobuf
{	
	import com.XTQXK.net.X_AsProtobuf.XTQXK_Math.Int64;
	import com.XTQXK.net.X_AsProtobuf.XTQXK_Math.UInt64;
	import com.XTQXK.net.X_AsProtobuf.XTQXK_Math.ZigZag;
	
	import flash.utils.ByteArray;
	import flash.utils.IDataInput;
	
	/**
	 * Reads and decodes protocol message fields.
	 *
	 * @author Robert Blackwood
	 * -ported from kenton's java implementation
	 */
	public class CodedInputStream {
	  /**
	   * Create a new CodedInputStream wrapping the given InputStream.
	   */
	  public static function newInstance(input:IDataInput):CodedInputStream {
	    return new CodedInputStream(input);
	  }
	
	  // -----------------------------------------------------------------
	
	  /**
	   * Attempt to read a field tag, returning zero if we have reached EOF.
	   * Protocol message parsers use this to read tags, since a protocol message
	   * may legally end wherever a tag occurs, and zero is not a valid tag number.
	   */
	  public function readTag():int {
	  	
	  	if ( input.bytesAvailable != 0)
		    lastTag = readRawVarint32();
		else 
			lastTag = 0;
	    
	    return lastTag;
	  }
	
	  /**
	   * Verifies that the last call to readTag() returned the given tag value.
	   * This is used to verify that a nested group ended with the correct
	   * end tag.
	   *
	   * @throws InvalidProtocolBufferException {@code value} does not match the
	   *                                        last tag.
	   */
	  public function checkLastTagWas(value:int):void {
	    if (lastTag != value) {
	      throw InvalidProtocolBufferException.invalidEndTag();
	    }
	  }
	
	  /**
	   * Reads and discards a single field, given its tag value.
	   *
	   * @return {@code false} if the tag is an endgroup tag, in which case
	   *         nothing is skipped.  Otherwise, returns {@code true}.
	   */
	  public function skipField(tag:int):Boolean {
	    switch (WireFormat.getTagWireType(tag)) {
	      case WireFormat.WIRETYPE_VARINT:
			  while (input.readUnsignedByte() > 0x80) {}
	        return true;
	      case WireFormat.WIRETYPE_FIXED64:
		  	input.readInt()
		  	input.readInt()
	        return true;
	      case WireFormat.WIRETYPE_LENGTH_DELIMITED:
			  for (var i:uint = readUInt32(); i != 0; i--) {
				  input.readByte()
			  }
	        return true;
	      case WireFormat.WIRETYPE_START_GROUP:
	        skipMessage();
	        checkLastTagWas(
	          WireFormat.makeTag(WireFormat.getTagFieldNumber(tag),
	                             WireFormat.WIRETYPE_END_GROUP));
	        return true;
	      case WireFormat.WIRETYPE_END_GROUP:
	        return false;
	      case WireFormat.WIRETYPE_FIXED32:
			input.readInt();
	        return true;
	      default:
	        throw InvalidProtocolBufferException.invalidWireType();
	    }
	  }
	
	  /**
	   * Reads and discards an entire message.  This will read either until EOF
	   * or until an endgroup tag, whichever comes first.
	   */
	  public function skipMessage():void {
	    while (true) {
	      var tag:int = readTag();
	      if (tag == 0 || !skipField(tag)) return;
	    }
	  }
	
	  // -----------------------------------------------------------------
	
	  /** Read a {@code double} field value from the stream. */
	  public function readDouble():Number{
      	return input.readDouble();
	  }
	
	  /** Read a {@code float} field value from the stream. */
	  public function readFloat():Number {
	  	
		  return input.readFloat()
	  }
	
	  /** Read a {@code uint64} field value from the stream. */
	  public function readUInt64():UInt64 {
		  const result:UInt64 = new UInt64()
		  var b:uint
		  var i:uint = 0
		  for (;; i += 7) {
			  b = input.readUnsignedByte()
			  if (i == 28) {
				  break
			  } else {
				  if (b >= 0x80) {
					  result.low |= ((b & 0x7f) << i)
				  } else {
					  result.low |= (b << i)
					  return result
				  }
			  }
		  }
		  if (b >= 0x80) {
			  b &= 0x7f
			  result.low |= (b << i)
			  result.high = b >>> 4
		  } else {
			  result.low |= (b << i)
			  result.high = b >>> 4
			  return result
		  }
		  for (i = 3;; i += 7) {
			  b = input.readUnsignedByte()
			  if (i < 32) {
				  if (b >= 0x80) {
					  result.high |= ((b & 0x7f) << i)
				  } else {
					  result.high |= (b << i)
					  break
				  }
			  }
		  }
		  return result
	  }
	
	  /** Read an {@code int64} field value from the stream. */
	  public function readInt64():Int64 {
		  const result:Int64 = new Int64()
		  var b:uint
		  var i:uint = 0
		  for (;; i += 7) {
			  b = input.readUnsignedByte()
			  if (i == 28) {
				  break
			  } else {
				  if (b >= 0x80) {
					  result.low |= ((b & 0x7f) << i)
				  } else {
					  result.low |= (b << i)
					  return result
				  }
			  }
		  }
		  if (b >= 0x80) {
			  b &= 0x7f
			  result.low |= (b << i)
			  result.high = b >>> 4
		  } else {
			  result.low |= (b << i)
			  result.high = b >>> 4
			  return result
		  }
		  for (i = 3;; i += 7) {
			  b = input.readUnsignedByte()
			  if (i < 32) {
				  if (b >= 0x80) {
					  result.high |= ((b & 0x7f) << i)
				  } else {
					  result.high |= (b << i)
					  break
				  }
			  }
		  }
		  return result
	  }
	
	  /** Read an {@code int32} field value from the stream. */
	  public function readInt32():int {
	    return int(readUInt32());
	  }
	
	  /** Read a {@code fixed64} field value from the stream. */
	  public function readFixed64():UInt64 {
		  const result:UInt64 = new UInt64()
		  result.low = input.readUnsignedInt()
		  result.high = input.readUnsignedInt()
		  return result
	  }
	
	  /** Read a {@code fixed32} field value from the stream. */
	  public function readFixed32():uint {
	    return input.readUnsignedInt();
	  }
	
	  /** Read a {@code bool} field value from the stream. */
	  public function readBool():Boolean {
	    return readUInt32() != 0;
	  }
	
	  /** Read a {@code string} field value from the stream. */
	  public function readString():String 
	  {
		  const length:uint = readUInt32();
		  return input.readUTFBytes(length)
	  }
	
	  /** Read a {@code group} field value from the stream. */
	  /*public function readGroup(fieldNumber:int, builder:Message.Builder,
	                        extensionRegistry:ExtensionRegistry):void {

	    builder.mergeFrom(this, extensionRegistry);
	    checkLastTagWas(WireFormat.makeTag(fieldNumber, WireFormat.WIRETYPE_END_GROUP));

	  }*/
	
	  /**
	   * Reads a {@code group} field value from the stream and merges it into the
	   * given {@link UnknownFieldSet}.
	   */
	 /* public function readUnknownGroup(fieldNumber:int, builder:UnknownFieldSet.Builder):void {
	    builder.mergeFrom(this);
	    checkLastTagWas(WireFormat.makeTag(fieldNumber, WireFormat.WIRETYPE_END_GROUP));

	  }*/
	
	  /** Read an embedded message field value from the stream. */
	  /*public function readMessage(builder:Message.Builder,
	                          extensionRegistry:ExtensionRegistry):void {
	    length:int = readRawVarint32();
	    builder.mergeFrom(this, extensionRegistry);
	    checkLastTagWas(0);
	  }*/
	
	  /** Read a {@code bytes} field value from the stream. */
	  public function readBytes():ByteArray {
		  const result:ByteArray = new ByteArray
		  const length:uint = readUInt32();
		  if (length > 0) {
			  input.readBytes(result, 0, length)
		  }
		  return result
	  }
	
	  /** Read a {@code uint32} field value from the stream. */
	  public function readUInt32():uint {
		  var result:uint = 0
		  for (var i:uint = 0;; i += 7) {
			  const b:uint = input.readUnsignedByte()
			  if (i < 32) {
				  if (b >= 0x80) {
					  result |= ((b & 0x7f) << i)
				  } else {
					  result |= (b << i)
					  break
				  }
			  } else {
				  while (input.readUnsignedByte() >= 0x80) {}
				  break
			  }
		  }
		  return result
	  }
	
	  /**
	   * Read an enum field value from the stream.  Caller is responsible
	   * for converting the numeric value to an actual enum.
	   */
	  public function readEnum(): int {
	    return readInt32();
	  }
	
	  /** Read an {@code sfixed32} field value from the stream. */
	  public function readSFixed32():int{
	    return input.readInt();
	  }
	
	  /** Read an {@code sfixed64} field value from the stream. */
	  public function readSFixed64():Int64 {
		  const result:Int64 = new Int64()
		  result.low = input.readUnsignedInt()
		  result.high = input.readInt()
		  return result
	  }
	
	  /** Read an {@code sint32} field value from the stream. */
	  public function readSInt32():int {
	    return ZigZag.decode32(readUInt32())
	  }
	
	  /** Read an {@code sint64} field value from the stream. */
	  public function readSInt64():Int64 {
		  const result:Int64 = readInt64()
		  const low:uint = result.low
		  const high:uint = result.high
		  result.low = ZigZag.decode64low(low, high)
		  result.high = ZigZag.decode64high(low, high)
		  return result
	  }
	  
	 /**
	   * Read a field of a given wire type.  
	   * 
	   * @param type Declared type of the field.
	   * @return An object representing the field's value, of the exact
	   *         type which would be returned by
	   *         {@link Message#getField(Descriptors.FieldDescriptor)} for
	   *         this field.
	   */
	  public function  readPrimitiveField(type:int):Object {
	  	
	    switch (type) {
	      case Descriptor.DOUBLE  : return readDouble  ();
	      case Descriptor.FLOAT   : return readFloat   ();
	      case Descriptor.INT64   : return readInt64   ();
	      case Descriptor.UINT64  : return readUInt64  ();
	      case Descriptor.INT32   : return readInt32   ();
	      case Descriptor.FIXED64 : return readFixed64 ();
	      case Descriptor.FIXED32 : return readFixed32 ();
	      case Descriptor.BOOL    : return readBool    ();
	      case Descriptor.STRING  : return readString  ();
	      case Descriptor.BYTES   : return readBytes   ();
	      case Descriptor.UINT32  : return readUInt32  ();
	      case Descriptor.SFIXED32: return readSFixed32();
	      case Descriptor.SFIXED64: return readSFixed64();
	      case Descriptor.SINT32  : return readSInt32  ();
	      case Descriptor.SINT64  : return readSInt64  ();
	      //fix bug 1 protobuf-actionscript3
		  case Descriptor.ENUM    : return readEnum    ();
	
		  default: 
		  	trace("Unknown primative field type: " + type); 
		  	break;
	    }
	
	    return null;
	  }
	
	  // =================================================================
	
	  /**
	   * Read a raw Varint from the stream.  If larger than 32 bits, discard the
	   * upper bits.
	   */
	  public function readRawVarint32():int {
	    var tmp:int = readRawByte();
	    if (tmp >= 0) {
	      return tmp;
	    }
	    var result:int = tmp & 0x7f;
	    if ((tmp = readRawByte()) >= 0) {
	      result |= tmp << 7;
	    } else {
	      result |= (tmp & 0x7f) << 7;
	      if ((tmp = readRawByte()) >= 0) {
	        result |= tmp << 14;
	      } else {
	        result |= (tmp & 0x7f) << 14;
	        if ((tmp = readRawByte()) >= 0) {
	          result |= tmp << 21;
	        } else {
	          result |= (tmp & 0x7f) << 21;
	          result |= (tmp = readRawByte()) << 28;
	          if (tmp < 0) {
	            // Discard upper 32 bits.
	            for (var i:int = 0; i < 5; i++) {
	              if (readRawByte() >= 0) return result;
	            }
	            throw InvalidProtocolBufferException.malformedVarint();
	          }
	        }
	      }
	    }
	    return result;
	  }
	
	
	  /** Read a 32-bit little-endian integer from the stream. */
	  public function readRawLittleEndian32():int {
	    var b1:int = readRawByte();
	    var b2:int = readRawByte();
	    var b3:int = readRawByte();
	    var b4:int = readRawByte();
	    return ((b1 & 0xff)      ) |
	           ((b2 & 0xff) <<  8) |
	           ((b3 & 0xff) << 16) |
	           ((b4 & 0xff) << 24);
	  }
	
	
	  /**
	   * Decode a ZigZag-encoded 32-bit value.  ZigZag encodes signed integers
	   * into values that can be efficiently encoded with varint.  (Otherwise,
	   * negative values must be sign-extended to 64 bits to be varint encoded,
	   * thus always taking 10 bytes on the wire.)
	   *
	   * @param n An unsigned 32-bit integer, stored in a signed int because
	   *          Java has no explicit unsigned support.
	   * @return A signed 32-bit integer.
	   */
	  public static function decodeZigZag32(n:int):int {
	    return (n >>> 1) ^ -(n & 1);
	  }
	
	
	  // -----------------------------------------------------------------
	
	  private var bufferSize:int;
	  private var bufferSizeAfterLimit:int = 0;
	  private var bufferPos:int = 0;
	  private var input:IDataInput;
	  private var lastTag:int = 0;
	
	  /** See setSizeLimit() */
	  private var sizeLimit:int = DEFAULT_SIZE_LIMIT;
	
	  private static const DEFAULT_RECURSION_LIMIT:int = 64;
	  private static const DEFAULT_SIZE_LIMIT:int = 64 << 20;  // 64MB
	
	  public function CodedInputStream(input:IDataInput) {
	    this.bufferSize = 0;
	    this.input = input;
	  }
	
	  /**
	   * Read one byte from the input.
	   *
	   * @throws InvalidProtocolBufferException The end of the stream or the current
	   *                                        limit was reached.
	   */
	  public function readRawByte():int {
	  	//lame, wait until buffer is full enough
	  	//while(bytesAvailable() == 0) {}
	  	
	    return input.readByte();
	  }
	
	  /**
	   * Read a fixed size of bytes from the input.
	   *
	   * @throws InvalidProtocolBufferException The end of the stream or the current
	   *                                        limit was reached.
	   */
	  public function readRawBytes(size:int):ByteArray {
	    if (size < 0) {
	      throw InvalidProtocolBufferException.negativeSize();
	    }
	    
	    //lame, wait until buffer is full enough
		//while (bytesAvailable() < size) {}			
	    
	    var bytes:ByteArray = new ByteArray();
	    
	    if(size != 0)
	      input.readBytes(bytes,0,size);
	    
	    return bytes;
	  }
	
	  /**
	   * Reads and discards {@code size} bytes.
	   *
	   * @throws InvalidProtocolBufferException The end of the stream or the current
	   *                                        limit was reached.
	   */
	  public function skipRawBytes(size:int):void 
	  {
		readRawBytes(size);
	  }
	}
}
