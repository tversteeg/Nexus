package com.utils{

	import flash.system.System;

	public class Memory {

		public function Memory() {
		}

		public function traceMemory() {
			trace(System.totalMemory / 1024);
		}

		public function getMemory():String {
			return (System.totalMemory / 1024).toString();
		}

		public function collectGarbage() {
			System.gc();

		}

	}

}