package com.entity.view;

import com.entity.YonghuEntity;

import com.baomidou.mybatisplus.annotations.TableName;
import org.apache.commons.beanutils.BeanUtils;
import java.lang.reflect.InvocationTargetException;

import java.io.Serializable;
 

/**
 * @author 
 * @email 
 * @date 2022-04-04 00:20:04
 */
@TableName("customer")
public class YonghuView  extends YonghuEntity implements Serializable {
	private static final long serialVersionUID = 1L;

	public YonghuView(){
	}
 
 	public YonghuView(YonghuEntity customerEntity){
 	try {
			BeanUtils.copyProperties(this, customerEntity);
		} catch (IllegalAccessException | InvocationTargetException e) {
			e.printStackTrace();
		}
 		
	}
}
