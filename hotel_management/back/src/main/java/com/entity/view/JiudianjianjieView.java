package com.entity.view;

import com.entity.JiudianjianjieEntity;

import com.baomidou.mybatisplus.annotations.TableName;
import org.apache.commons.beanutils.BeanUtils;
import java.lang.reflect.InvocationTargetException;

import java.io.Serializable;
 

/**
 * @author 
 * @email 
 * @date 2022-04-04 00:20:04
 */
@TableName("hotel_profile")
public class JiudianjianjieView  extends JiudianjianjieEntity implements Serializable {
	private static final long serialVersionUID = 1L;

	public JiudianjianjieView(){
	}
 
 	public JiudianjianjieView(JiudianjianjieEntity hotel_profileEntity){
 	try {
			BeanUtils.copyProperties(this, hotel_profileEntity);
		} catch (IllegalAccessException | InvocationTargetException e) {
			e.printStackTrace();
		}
 		
	}
}
