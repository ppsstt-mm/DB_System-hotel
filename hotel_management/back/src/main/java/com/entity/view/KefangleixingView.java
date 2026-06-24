package com.entity.view;

import com.entity.KefangleixingEntity;

import com.baomidou.mybatisplus.annotations.TableName;
import org.apache.commons.beanutils.BeanUtils;
import java.lang.reflect.InvocationTargetException;

import java.io.Serializable;
 

/**
 * @author 
 * @email 
 * @date 2022-04-04 00:20:04
 */
@TableName("room_category")
public class KefangleixingView  extends KefangleixingEntity implements Serializable {
	private static final long serialVersionUID = 1L;

	public KefangleixingView(){
	}
 
 	public KefangleixingView(KefangleixingEntity room_categoryEntity){
 	try {
			BeanUtils.copyProperties(this, room_categoryEntity);
		} catch (IllegalAccessException | InvocationTargetException e) {
			e.printStackTrace();
		}
 		
	}
}
