package com.cos.action.gmail;

import com.cos.action.Action;

public class GmailFactory {
	public static Action getAction(String cmd) {
	
		if(cmd.equals("check")) {
			return new GmailCheckAction();
		}else if(cmd.equals("send")) {
			return new GmailSendAction();
		}
		return null;
	}
}
