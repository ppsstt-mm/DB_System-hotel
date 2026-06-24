package com.entity;

import com.baomidou.mybatisplus.annotations.TableId;
import com.baomidou.mybatisplus.annotations.TableName;
import javax.validation.constraints.NotBlank;
import javax.validation.constraints.NotEmpty;
import javax.validation.constraints.NotNull;

import com.fasterxml.jackson.annotation.JsonIgnoreProperties;
import java.lang.reflect.InvocationTargetException;

import java.io.Serializable;
import java.util.Date;
import java.util.List;

import org.springframework.format.annotation.DateTimeFormat;
import com.fasterxml.jackson.annotation.JsonFormat;
import org.apache.commons.beanutils.BeanUtils;
import com.baomidou.mybatisplus.annotations.TableField;
import com.baomidou.mybatisplus.enums.FieldFill;
import com.baomidou.mybatisplus.enums.IdType;


/**
 * @author 
 * @email 
 * @date 2022-04-04 00:20:04
 */
@TableName("hotel_profile")
public class JiudianjianjieEntity<T> implements Serializable {
	private static final long serialVersionUID = 1L;


	public JiudianjianjieEntity() {
		
	}
	
	public JiudianjianjieEntity(T t) {
		try {
			BeanUtils.copyProperties(this, t);
		} catch (IllegalAccessException | InvocationTargetException e) {
			e.printStackTrace();
		}
	}
	
	/**
	 */
	@TableId(type = IdType.AUTO)
	private Long id;
	/**
	 */
					
	private String jiudianmingcheng;
	
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

	private Integer reviewCount;

	private java.math.BigDecimal avgScore;
	
	
	@JsonFormat(locale="zh", timezone="GMT+8", pattern="yyyy-MM-dd HH:mm:ss")
	@DateTimeFormat
	private Date addtime;

	public Date getAddtime() {
		return addtime;
	}
	public void setAddtime(Date addtime) {
		this.addtime = addtime;
	}

	public Long getId() {
		return id;
	}

	public void setId(Long id) {
		this.id = id;
	}
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
