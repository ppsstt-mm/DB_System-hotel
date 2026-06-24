package com.entity.view;

import com.entity.KefangyudingEntity;

import com.baomidou.mybatisplus.annotations.TableName;
import org.apache.commons.beanutils.BeanUtils;
import java.lang.reflect.InvocationTargetException;

import java.io.Serializable;
 

/**
 * @author 
 * @email 
 * @date 2022-04-04 00:20:04
 */
@TableName("booking_order")
public class KefangyudingView  extends KefangyudingEntity implements Serializable {
	private static final long serialVersionUID = 1L;

	public KefangyudingView(){
	}
 
 	public KefangyudingView(KefangyudingEntity booking_orderEntity){
 	try {
			BeanUtils.copyProperties(this, booking_orderEntity);
		} catch (IllegalAccessException | InvocationTargetException e) {
			e.printStackTrace();
		}
 		
	}
}
