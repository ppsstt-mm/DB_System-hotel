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
@TableName("room_catalog")
public class JiudiankefangEntity<T> implements Serializable {
	private static final long serialVersionUID = 1L;


	public JiudiankefangEntity() {
		
	}
	
	public JiudiankefangEntity(T t) {
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
					
	private String kefangmingcheng;
	
	/**
	 */
					
	private String room_category;

	@TableField("hotel_profile_id")
	private Long hotelProfileId;

	@TableField("room_category_id")
	private Long roomCategoryId;
	
	/**
	 */
					
	private String kefangtupian;
	
	/**
	 */
					
	private Float kefangjiage;
	
	/**
	 */
					
	private Integer shuliang;
	
	/**
	 */
					
	private String jiudianmingcheng;
	
	/**
	 */
					
	private String jiudiandizhi;
	
	/**
	 */
					
	private String kefangsheshi;
	
	/**
	 */
					
	private String kefangjieshao;
	
	/**
	 */
					
	private Integer clicknum;

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
	public void setKefangmingcheng(String kefangmingcheng) {
		this.kefangmingcheng = kefangmingcheng;
	}
	/**
	 */
	public String getKefangmingcheng() {
		return kefangmingcheng;
	}
	/**
	 */
	public void setRoom_category(String room_category) {
		this.room_category = room_category;
	}

	public String getRoom_category() {
		return room_category;
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
	public void setKefangjiage(Float kefangjiage) {
		this.kefangjiage = kefangjiage;
	}
	/**
	 */
	public Float getKefangjiage() {
		return kefangjiage;
	}
	/**
	 */
	public void setShuliang(Integer shuliang) {
		this.shuliang = shuliang;
	}
	/**
	 */
	public Integer getShuliang() {
		return shuliang;
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
	public void setKefangsheshi(String kefangsheshi) {
		this.kefangsheshi = kefangsheshi;
	}
	/**
	 */
	public String getKefangsheshi() {
		return kefangsheshi;
	}
	/**
	 */
	public void setKefangjieshao(String kefangjieshao) {
		this.kefangjieshao = kefangjieshao;
	}
	/**
	 */
	public String getKefangjieshao() {
		return kefangjieshao;
	}
	/**
	 */
	public void setClicknum(Integer clicknum) {
		this.clicknum = clicknum;
	}
	/**
	 */
	public Integer getClicknum() {
		return clicknum;
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

	public Long getHotelProfileId() {
		return hotelProfileId;
	}

	public void setHotelProfileId(Long hotelProfileId) {
		this.hotelProfileId = hotelProfileId;
	}

	public Long getRoomCategoryId() {
		return roomCategoryId;
	}

	public void setRoomCategoryId(Long roomCategoryId) {
		this.roomCategoryId = roomCategoryId;
	}

}
