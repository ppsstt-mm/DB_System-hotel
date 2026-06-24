package com.entity.view;

import com.entity.RuzhuanpaiEntity;

import com.baomidou.mybatisplus.annotations.TableName;
import org.apache.commons.beanutils.BeanUtils;
import java.lang.reflect.InvocationTargetException;

import java.io.Serializable;
 

/**
 * @author 
 * @email 
 * @date 2022-04-04 00:20:04
 */
@TableName("checkin_assignment")
public class RuzhuanpaiView  extends RuzhuanpaiEntity implements Serializable {
	private static final long serialVersionUID = 1L;

	public RuzhuanpaiView(){
	}
 
 	public RuzhuanpaiView(RuzhuanpaiEntity checkin_assignmentEntity){
 	try {
			BeanUtils.copyProperties(this, checkin_assignmentEntity);
		} catch (IllegalAccessException | InvocationTargetException e) {
			e.printStackTrace();
		}
 		
	}
}
