package com.entity.view;

import com.entity.DiscussjiudianjianjieEntity;

import com.baomidou.mybatisplus.annotations.TableName;
import org.apache.commons.beanutils.BeanUtils;
import java.lang.reflect.InvocationTargetException;

import java.io.Serializable;
 

/**
 * @author 
 * @email 
 * @date 2022-04-04 00:20:05
 */
@TableName("hotel_review")
public class DiscussjiudianjianjieView  extends DiscussjiudianjianjieEntity implements Serializable {
	private static final long serialVersionUID = 1L;

	public DiscussjiudianjianjieView(){
	}
 
 	public DiscussjiudianjianjieView(DiscussjiudianjianjieEntity hotel_reviewEntity){
 	try {
			BeanUtils.copyProperties(this, hotel_reviewEntity);
		} catch (IllegalAccessException | InvocationTargetException e) {
			e.printStackTrace();
		}
 		
	}
}
