package com.entity.view;

import com.entity.DiscussjiudiankefangEntity;

import com.baomidou.mybatisplus.annotations.TableName;
import org.apache.commons.beanutils.BeanUtils;
import java.lang.reflect.InvocationTargetException;

import java.io.Serializable;
 

/**
 * @author 
 * @email 
 * @date 2022-04-04 00:20:05
 */
@TableName("room_review")
public class DiscussjiudiankefangView  extends DiscussjiudiankefangEntity implements Serializable {
	private static final long serialVersionUID = 1L;

	public DiscussjiudiankefangView(){
	}
 
 	public DiscussjiudiankefangView(DiscussjiudiankefangEntity room_reviewEntity){
 	try {
			BeanUtils.copyProperties(this, room_reviewEntity);
		} catch (IllegalAccessException | InvocationTargetException e) {
			e.printStackTrace();
		}
 		
	}
}
