package com.entity.view;

import com.entity.YuangongEntity;

import com.baomidou.mybatisplus.annotations.TableName;
import org.apache.commons.beanutils.BeanUtils;
import java.lang.reflect.InvocationTargetException;

import java.io.Serializable;
 

/**
 * @author 
 * @email 
 * @date 2022-04-04 00:20:04
 */
@TableName("employee")
public class YuangongView  extends YuangongEntity implements Serializable {
	private static final long serialVersionUID = 1L;

	public YuangongView(){
	}
 
 	public YuangongView(YuangongEntity employeeEntity){
 	try {
			BeanUtils.copyProperties(this, employeeEntity);
		} catch (IllegalAccessException | InvocationTargetException e) {
			e.printStackTrace();
		}
 		
	}
}
