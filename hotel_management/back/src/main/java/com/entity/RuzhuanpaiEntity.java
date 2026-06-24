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
@TableName("checkin_assignment")
public class RuzhuanpaiEntity<T> implements Serializable {
	private static final long serialVersionUID = 1L;


	public RuzhuanpaiEntity() {
		
	}
	
	public RuzhuanpaiEntity(T t) {
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
					
	private String yudingbianhao;
	
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
	public void setYudingbianhao(String yudingbianhao) {
		this.yudingbianhao = yudingbianhao;
	}
	/**
	 */
	public String getYudingbianhao() {
		return yudingbianhao;
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
