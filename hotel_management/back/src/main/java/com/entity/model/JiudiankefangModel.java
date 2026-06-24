package com.entity.model;

import com.entity.JiudiankefangEntity;

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
public class JiudiankefangModel  implements Serializable {
	private static final long serialVersionUID = 1L;

	private Long hotelProfileId;

	private Long roomCategoryId;

				
	/**
	 */
	
	private String room_category;
		
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
				
	
	/**
	 */
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

	/**
	 */
	 
	public void setRoom_category(String room_category) {
		this.room_category = room_category;
	}
	
	/**
	 */
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
			
}
