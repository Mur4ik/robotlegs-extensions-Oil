//------------------------------------------------------------------------------
//  Copyright (c) 2011 the original author or authors. All Rights Reserved. 
// 
//  NOTICE: You are permitted you to use, modify, and distribute this file 
//  in accordance with the terms of the license agreement accompanying it. 
//------------------------------------------------------------------------------

/*
 * Copyright (c) 2010 the original author or authors
 *
 * Permission is hereby granted to use, modify, and distribute this file
 * in accordance with the terms of the license agreement accompanying it.
 */

package org.robotlegs.oil.async
{
	import flexunit.framework.Assert;

	public class PromiseTest
	{

		/*============================================================================*/
		/* Private Properties                                                         */
		/*============================================================================*/

		private var errorHandlerHitCount:int;

		private var progressHandlerHitCount:int;

		private var promise:Promise;

		private var resultHandlerHitCount:int;


		/*============================================================================*/
		/* Public Static Functions                                                    */
		/*============================================================================*/

		[BeforeClass]
		public static function setUpBeforeClass():void
		{
		}

		[AfterClass]
		public static function tearDownAfterClass():void
		{
		}


		/*============================================================================*/
		/* Public Functions                                                           */
		/*============================================================================*/

		[Before]
		public function setUp():void
		{
			promise = new Promise();

			errorHandlerHitCount = 0;
			progressHandlerHitCount = 0;
			resultHandlerHitCount = 0;
		}

		[After]
		public function tearDown():void
		{
			promise = null;
		}

		[Test]
		public function testCancel():void
		{
			promise.addErrorHandler(supportErrorHandler);
			promise.addProgressHandler(supportProgressHandler);
			promise.addResultHandler(supportResultHandler);
			promise.cancel();
			promise.handleError(null);
			promise.handleProgress(null);
			promise.handleResult(null);
			Assert.assertTrue("Error handler should NOT have run", errorHandlerHitCount == 0);
			Assert.assertTrue("Progress handler should NOT have run", progressHandlerHitCount == 0);
			Assert.assertTrue("Result handler should NOT have run", resultHandlerHitCount == 0);
		}

		[Test]
		public function testGet_error():void
		{
			promise.handleError(0.5);
			Assert.assertEquals("Error should be set", 0.5, promise.error);
		}

		[Test]
		public function testGet_progress():void
		{
			promise.handleProgress(0.5);
			Assert.assertEquals("Progress should be set", 0.5, promise.progress);
		}

		[Test]
		public function testGet_result():void
		{
			promise.handleResult(0.5);
			Assert.assertEquals("Result should be set", 0.5, promise.result);
		}

		[Test]
		public function testGet_status():void
		{
			Assert.assertEquals("Status should start pending", Promise.PENDING, promise.status);
		}

		[Test]
		public function testHandleFutureError():void
		{
			promise.addErrorHandler(supportErrorHandler);
			promise.handleError(null);
			Assert.assertTrue("Error handler should run", errorHandlerHitCount > 0);
		}

		[Test]
		public function testHandleFutureProgress():void
		{
			promise.addProgressHandler(supportProgressHandler);
			promise.handleProgress(null);
			Assert.assertTrue("Progress handler should run", progressHandlerHitCount > 0);
		}

		[Test]
		public function testHandleFutureResult():void
		{
			promise.addResultHandler(supportResultHandler);
			promise.handleResult(null);
			Assert.assertTrue("Result handler should run", resultHandlerHitCount > 0);
		}

		[Test]
		public function testHandleFutureResultProcessor():void
		{
			promise.addResultProcessor(supportResultProcessor1);
			promise.addResultProcessor(supportResultProcessor2);
			promise.addResultHandler(supportResultProcessorHandler);
			promise.handleResult(100);
			Assert.assertTrue("Result handler should run", resultHandlerHitCount > 0);
			Assert.assertEquals("Result should be processed", "processed", promise.result.title);
			Assert.assertEquals("Result should be processed", "Test100", promise.result.string);
		}

		[Test]
		public function testHandleOldError():void
		{
			promise.handleError(null);
			promise.addErrorHandler(supportErrorHandler);
			Assert.assertTrue("Error handler should run", errorHandlerHitCount > 0);
		}

		[Test]
		public function testHandleOldProgress():void
		{
			promise.handleResult(null);
			promise.addProgressHandler(supportProgressHandler);
			Assert.assertTrue("Progress handler should run", progressHandlerHitCount > 0);
		}

		[Test]
		public function testHandleOldResult():void
		{
			promise.handleResult(null);
			promise.addResultHandler(supportResultHandler);
			Assert.assertTrue("Result handler should run", resultHandlerHitCount > 0);
		}

		[Test]
		public function testHandleOldResultProcessor():void
		{
			promise.addResultProcessor(supportResultProcessor1);
			promise.addResultProcessor(supportResultProcessor2);
			promise.handleResult(100);
			promise.addResultHandler(supportResultProcessorHandler);
			Assert.assertTrue("Result handler should run", resultHandlerHitCount > 0);
			Assert.assertEquals("Result should be processed", "processed", promise.result.title);
			Assert.assertEquals("Result should be processed", "Test100", promise.result.string);
		}

		[Test]
		public function testPromise():void
		{
			Assert.assertTrue("promise is Promise", promise is Promise);
		}

		/*============================================================================*/
		/* Protected Functions                                                        */
		/*============================================================================*/

		protected function supportErrorHandler(p:Promise):void
		{
			errorHandlerHitCount++;
		}

		protected function supportProgressHandler(p:Promise):void
		{
			progressHandlerHitCount++;
		}

		protected function supportResultHandler(p:Promise):void
		{
			resultHandlerHitCount++;
		}

		protected function supportResultProcessor1(input:Number, callback:Function):void
		{
			var output:String = "Test" + input;
			callback(null, output);
		}

		protected function supportResultProcessor2(input:String, callback:Function):void
		{
			var output:Object = {
					title: "processed",
					string: input
				};
			callback(null, output);
		}

		protected function supportResultProcessorHandler(p:Promise):void
		{
			resultHandlerHitCount++;
		}
	}
}
