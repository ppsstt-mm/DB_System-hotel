package com.entity.view;

import com.entity.JiudiankefangEntity;

import com.baomidou.mybatisplus.annotations.TableName;
import org.apache.commons.beanutils.BeanUtils;
import java.lang.reflect.InvocationTargetException;

import java.io.Serializable;
 

/**
 * @author 
 * @email 
 * @date 2022-04-04 00:20:04
 */
@TableName("room_catalog")
public class JiudiankefangView  extends JiudiankefangEntity implements Serializable {
	private static final long serialVersionUID = 1L;

	public JiudiankefangView(){
	}
 
 	public JiudiankefangView(JiudiankefangEntity room_catalogEntity){
 	try {
			BeanUtils.copyProperties(this, room_catalogEntity);
		} catch (IllegalAccessException | InvocationTargetException e) {
			e.printStackTrace();
		}
 		
	}
}
