package com.entity.view;

import com.entity.NewsEntity;

import com.baomidou.mybatisplus.annotations.TableName;
import org.apache.commons.beanutils.BeanUtils;
import java.lang.reflect.InvocationTargetException;

import java.io.Serializable;
 

/**
 * @author 
 * @email 
 * @date 2022-04-04 00:20:04
 */
@TableName("notice")
public class NewsView  extends NewsEntity implements Serializable {
	private static final long serialVersionUID = 1L;

	public NewsView(){
	}
 
 	public NewsView(NewsEntity noticeEntity){
 	try {
			BeanUtils.copyProperties(this, noticeEntity);
		} catch (IllegalAccessException | InvocationTargetException e) {
			e.printStackTrace();
		}
 		
	}
}
