package com.entity.model;

import com.entity.YuangongEntity;

import com.baomidou.mybatisplus.annotations.TableName;
import java.util.Date;
import org.springframework.format.annotation.DateTimeFormat;

import com.fasterxml.jackson.annotation.JsonFormat;
import java.io.Serializable;
 

/**
 * @author 
 * @email 
 * @date 2022-04-04 00:20:04
 */
public class YuangongModel  implements Serializable {
	private static final long serialVersionUID = 1L;

	 			
	/**
	 */
	
	private String employeexingming;
		
	/**
	 */
	
	private String mima;
		
	/**
	 */
	
	private String xingbie;
		
	/**
	 */
	
	private String lianxidianhua;
		
	/**
	 */
	
	private String touxiang;
		
	/**
	 */
		
	@JsonFormat(locale="zh", timezone="GMT+8", pattern="yyyy-MM-dd HH:mm:ss")
	@DateTimeFormat 
	private Date ruzhishijian;
		
	/**
	 */
	
	private String zhiwei;
				
	
	/**
	 */
	 
	public void setYuangongxingming(String employeexingming) {
		this.employeexingming = employeexingming;
	}
	
	/**
	 */
	public String getYuangongxingming() {
		return employeexingming;
	}
				
	
	/**
	 */
	 
	public void setMima(String mima) {
		this.mima = mima;
	}
	
	/**
	 */
	public String getMima() {
		return mima;
	}
				
	
	/**
	 */
	 
	public void setXingbie(String xingbie) {
		this.xingbie = xingbie;
	}
	
	/**
	 */
	public String getXingbie() {
		return xingbie;
	}
				
	
	/**
	 */
	 
	public void setLianxidianhua(String lianxidianhua) {
		this.lianxidianhua = lianxidianhua;
	}
	
	/**
	 */
	public String getLianxidianhua() {
		return lianxidianhua;
	}
				
	
	/**
	 */
	 
	public void setTouxiang(String touxiang) {
		this.touxiang = touxiang;
	}
	
	/**
	 */
	public String getTouxiang() {
		return touxiang;
	}
				
	
	/**
	 */
	 
	public void setRuzhishijian(Date ruzhishijian) {
		this.ruzhishijian = ruzhishijian;
	}
	
	/**
	 */
	public Date getRuzhishijian() {
		return ruzhishijian;
	}
				
	
	/**
	 */
	 
	public void setZhiwei(String zhiwei) {
		this.zhiwei = zhiwei;
	}
	
	/**
	 */
	public String getZhiwei() {
		return zhiwei;
	}
			
}
