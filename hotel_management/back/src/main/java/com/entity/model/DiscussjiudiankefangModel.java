package com.entity.model;

import com.entity.DiscussjiudiankefangEntity;

import com.baomidou.mybatisplus.annotations.TableName;
import java.util.Date;
import org.springframework.format.annotation.DateTimeFormat;

import com.fasterxml.jackson.annotation.JsonFormat;
import java.io.Serializable;
 

/**
 * @author 
 * @email 
 * @date 2022-04-04 00:20:05
 */
public class DiscussjiudiankefangModel  implements Serializable {
	private static final long serialVersionUID = 1L;

	 			
	/**
	 */
	
	private Long userid;
		
	/**
	 */
	
	private String nickname;
		
	/**
	 */
	
	private String content;
		
	/**
	 */
	
	private String reply;
				
	
	/**
	 */
	 
	public void setUserid(Long userid) {
		this.userid = userid;
	}
	
	/**
	 */
	public Long getUserid() {
		return userid;
	}
				
	
	/**
	 */
	 
	public void setNickname(String nickname) {
		this.nickname = nickname;
	}
	
	/**
	 */
	public String getNickname() {
		return nickname;
	}
				
	
	/**
	 */
	 
	public void setContent(String content) {
		this.content = content;
	}
	
	/**
	 */
	public String getContent() {
		return content;
	}
				
	
	/**
	 */
	 
	public void setReply(String reply) {
		this.reply = reply;
	}
	
	/**
	 */
	public String getReply() {
		return reply;
	}
			
}
