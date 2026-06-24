package com.entity.vo;

import com.entity.JiudianjianjieEntity;

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
public class JiudianjianjieVO  implements Serializable {
	private static final long serialVersionUID = 1L;

	private Integer reviewCount;

	private java.math.BigDecimal avgScore;

				
	/**
	 */
	
	private String leibie;
		
	/**
	 */
	
	private String xingji;
		
	/**
	 */
	
	private String jiudiantupian;
		
	/**
	 */
	
	private String jiudiandizhi;
		
	/**
	 */
	
	private String fuwurexian;
		
	/**
	 */
	
	private String jiudianjieshao;
				
	
	/**
	 */
	 
	public void setLeibie(String leibie) {
		this.leibie = leibie;
	}
	
	/**
	 */
	public String getLeibie() {
		return leibie;
	}
				
	
	/**
	 */
	 
	public void setXingji(String xingji) {
		this.xingji = xingji;
	}
	
	/**
	 */
	public String getXingji() {
		return xingji;
	}
				
	
	/**
	 */
	 
	public void setJiudiantupian(String jiudiantupian) {
		this.jiudiantupian = jiudiantupian;
	}
	
	/**
	 */
	public String getJiudiantupian() {
		return jiudiantupian;
	}
				
	
	/**
	 */
	 
	public void setJiudiandizhi(String jiudiandizhi) {
		this.jiudiandizhi = jiudiandizhi;
	}
	
	/**
	 */
	public String getJiudiandizhi() {
		return jiudiandizhi;
	}
				
	
	/**
	 */
	 
	public void setFuwurexian(String fuwurexian) {
		this.fuwurexian = fuwurexian;
	}
	
	/**
	 */
	public String getFuwurexian() {
		return fuwurexian;
	}
				
	
	/**
	 */
	 
	public void setJiudianjieshao(String jiudianjieshao) {
		this.jiudianjieshao = jiudianjieshao;
	}
	
	/**
	 */
	public String getJiudianjieshao() {
		return jiudianjieshao;
	}

	public Integer getReviewCount() {
		return reviewCount;
	}

	public void setReviewCount(Integer reviewCount) {
		this.reviewCount = reviewCount;
	}

	public java.math.BigDecimal getAvgScore() {
		return avgScore;
	}

	public void setAvgScore(java.math.BigDecimal avgScore) {
		this.avgScore = avgScore;
	}
			
}
