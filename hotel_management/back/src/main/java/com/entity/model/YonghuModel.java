package com.entity.model;

import com.entity.YonghuEntity;

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
public class YonghuModel  implements Serializable {
	private static final long serialVersionUID = 1L;

	 			
	/**
	 */
	
	private String xingming;
		
	/**
	 */
	
	private String mima;
		
	/**
	 */
	
	private String xingbie;
		
	/**
	 */
	
	private Integer nianling;
		
	/**
	 */
	
	private String shoujihao;
				
	
	/**
	 */
	 
	public void setXingming(String xingming) {
		this.xingming = xingming;
	}
	
	/**
	 */
	public String getXingming() {
		return xingming;
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
	 
	public void setNianling(Integer nianling) {
		this.nianling = nianling;
	}
	
	/**
	 */
	public Integer getNianling() {
		return nianling;
	}
				
	
	/**
	 */
	 
	public void setShoujihao(String shoujihao) {
		this.shoujihao = shoujihao;
	}
	
	/**
	 */
	public String getShoujihao() {
		return shoujihao;
	}
			
}
