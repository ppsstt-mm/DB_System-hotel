package com.entity.model;

import com.entity.KefangyudingEntity;

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
public class KefangyudingModel  implements Serializable {
	private static final long serialVersionUID = 1L;

	 			
	/**
	 */
	
	private String kefangmingcheng;
		
	/**
	 */
	
	private String room_category;
		
	/**
	 */
	
	private Float kefangjiage;
		
	/**
	 */
	
	private Integer shuliang;
		
	/**
	 */
	
	private Float zongjine;
		
	/**
	 */
	
	private String kefangtupian;
		
	/**
	 */
	
	private String jiudianmingcheng;
		
	/**
	 */
	
	private String jiudiandizhi;
		
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
		
	@JsonFormat(locale="zh", timezone="GMT+8", pattern="yyyy-MM-dd HH:mm:ss")
	@DateTimeFormat 
	private Date yudingriqi;
		
	/**
	 */
	
	private String ispay;

	private Long customer_id;

	private Long room_catalog_id;

	@JsonFormat(locale="zh", timezone="GMT+8", pattern="yyyy-MM-dd")
	@DateTimeFormat
	private Date expected_checkin_date;

	@JsonFormat(locale="zh", timezone="GMT+8", pattern="yyyy-MM-dd")
	@DateTimeFormat
	private Date expected_checkout_date;

	private String booking_status;

	private Long room_instance_id;
				
	
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
	
	/**
	 */
	public String getRoom_category() {
		return room_category;
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
	 
	public void setZongjine(Float zongjine) {
		this.zongjine = zongjine;
	}
	
	/**
	 */
	public Float getZongjine() {
		return zongjine;
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
	 
	public void setYudingriqi(Date yudingriqi) {
		this.yudingriqi = yudingriqi;
	}
	
	/**
	 */
	public Date getYudingriqi() {
		return yudingriqi;
	}
				
	
	/**
	 */
	 
	public void setIspay(String ispay) {
		this.ispay = ispay;
	}
	
	/**
	 */
	public String getIspay() {
		return ispay;
	}

	public Long getCustomer_id() {
		return customer_id;
	}

	public void setCustomer_id(Long customer_id) {
		this.customer_id = customer_id;
	}

	public Long getRoom_catalog_id() {
		return room_catalog_id;
	}

	public void setRoom_catalog_id(Long room_catalog_id) {
		this.room_catalog_id = room_catalog_id;
	}

	public Date getExpected_checkin_date() {
		return expected_checkin_date;
	}

	public void setExpected_checkin_date(Date expected_checkin_date) {
		this.expected_checkin_date = expected_checkin_date;
	}

	public Date getExpected_checkout_date() {
		return expected_checkout_date;
	}

	public void setExpected_checkout_date(Date expected_checkout_date) {
		this.expected_checkout_date = expected_checkout_date;
	}

	public String getBooking_status() {
		return booking_status;
	}

	public void setBooking_status(String booking_status) {
		this.booking_status = booking_status;
	}

	public Long getRoom_instance_id() {
		return room_instance_id;
	}

	public void setRoom_instance_id(Long room_instance_id) {
		this.room_instance_id = room_instance_id;
	}
			
}
