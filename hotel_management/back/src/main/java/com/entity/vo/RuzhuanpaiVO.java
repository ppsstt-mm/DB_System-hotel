package com.entity.vo;

import com.entity.RuzhuanpaiEntity;

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
public class RuzhuanpaiVO  implements Serializable {
	private static final long serialVersionUID = 1L;

	 			
	/**
	 */
	
	private String jiudianmingcheng;
		
	/**
	 */
	
	private String fangjianleixing;
		
	/**
	 */
	
	private Float shuliang;
		
	/**
	 */
	
	private String kefangtupian;
		
	/**
	 */
	
	private String customerming;
		
	/**
	 */
	
	private String xingming;
		
	/**
	 */
	
	private String shoujihao;
		
	/**
	 */
	
	private String fangjianhao;
		
	/**
	 */
	
	private Long crossuserid;
		
	/**
	 */
	
	private Long crossrefid;
				
	
	/**
	 */
	 
	public void setJiudianmingcheng(String jiudianmingcheng) {
		this.jiudianmingcheng = jiudianmingcheng;
	}
	
	/**
	 */
	public String getJiudianmingcheng() {
		return jiudianmingcheng;
	}
				
	
	/**
	 */
	 
	public void setFangjianleixing(String fangjianleixing) {
		this.fangjianleixing = fangjianleixing;
	}
	
	/**
	 */
	public String getFangjianleixing() {
		return fangjianleixing;
	}
				
	
	/**
	 */
	 
	public void setShuliang(Float shuliang) {
		this.shuliang = shuliang;
	}
	
	/**
	 */
	public Float getShuliang() {
		return shuliang;
	}
				
	
	/**
	 */
	 
	public void setKefangtupian(String kefangtupian) {
		this.kefangtupian = kefangtupian;
	}
	
	/**
	 */
	public String getKefangtupian() {
		return kefangtupian;
	}
				
	
	/**
	 */
	 
	public void setCustomerming(String customerming) {
		this.customerming = customerming;
	}
	
	/**
	 */
	public String getCustomerming() {
		return customerming;
	}
				
	
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
	 
	public void setShoujihao(String shoujihao) {
		this.shoujihao = shoujihao;
	}
	
	/**
	 */
	public String getShoujihao() {
		return shoujihao;
	}
				
	
	/**
	 */
	 
	public void setFangjianhao(String fangjianhao) {
		this.fangjianhao = fangjianhao;
	}
	
	/**
	 */
	public String getFangjianhao() {
		return fangjianhao;
	}
				
	
	/**
	 */
	 
	public void setCrossuserid(Long crossuserid) {
		this.crossuserid = crossuserid;
	}
	
	/**
	 */
	public Long getCrossuserid() {
		return crossuserid;
	}
				
	
	/**
	 */
	 
	public void setCrossrefid(Long crossrefid) {
		this.crossrefid = crossrefid;
	}
	
	/**
	 */
	public Long getCrossrefid() {
		return crossrefid;
	}
			
}
