package com.entity.view;

import com.entity.StoreupEntity;

import com.baomidou.mybatisplus.annotations.TableName;
import org.apache.commons.beanutils.BeanUtils;
import java.lang.reflect.InvocationTargetException;

import java.io.Serializable;
 

/**
 * @author 
 * @email 
 * @date 2022-04-04 00:20:04
 */
@TableName("favorite")
public class StoreupView  extends StoreupEntity implements Serializable {
	private static final long serialVersionUID = 1L;

	public StoreupView(){
	}
 
 	public StoreupView(StoreupEntity favoriteEntity){
 	try {
			BeanUtils.copyProperties(this, favoriteEntity);
		} catch (IllegalAccessException | InvocationTargetException e) {
			e.printStackTrace();
		}
 		
	}
}
