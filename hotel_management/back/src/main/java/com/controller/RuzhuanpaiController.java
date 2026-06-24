package com.controller;

import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.Calendar;
import java.util.Map;
import java.util.HashMap;
import java.util.Iterator;
import java.util.Date;
import java.util.List;
import javax.servlet.http.HttpServletRequest;

import com.utils.ValidatorUtils;
import org.apache.commons.lang3.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.format.annotation.DateTimeFormat;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;
import com.baomidou.mybatisplus.mapper.EntityWrapper;
import com.baomidou.mybatisplus.mapper.Wrapper;
import com.annotation.IgnoreAuth;

import com.entity.RuzhuanpaiEntity;
import com.entity.view.RuzhuanpaiView;

import com.service.RuzhuanpaiService;
import com.service.TokenService;
import com.utils.PageUtils;
import com.utils.R;
import com.utils.MD5Util;
import com.utils.MPUtil;
import com.utils.CommonUtil;
import java.io.IOException;

/**
 * @author 
 * @email 
 * @date 2022-04-04 00:20:04
 */
@RestController
@RequestMapping("/checkin_assignment")
public class RuzhuanpaiController {
    @Autowired
    private RuzhuanpaiService checkin_assignmentService;


    


    /**
     */
    @RequestMapping("/page")
    public R page(@RequestParam Map<String, Object> params,RuzhuanpaiEntity checkin_assignment,
		HttpServletRequest request){
		String tableName = request.getSession().getAttribute("tableName").toString();
		if(tableName.equals("customer")) {
			checkin_assignment.setCustomerming((String)request.getSession().getAttribute("username"));
		}
        EntityWrapper<RuzhuanpaiEntity> ew = new EntityWrapper<RuzhuanpaiEntity>();
		PageUtils page = checkin_assignmentService.queryPage(params, MPUtil.sort(MPUtil.between(MPUtil.likeOrEq(ew, checkin_assignment), params), params));

        return R.ok().put("data", page);
    }
    
    /**
     */
    @RequestMapping("/list")
    public R list(@RequestParam Map<String, Object> params,RuzhuanpaiEntity checkin_assignment, 
		HttpServletRequest request){
        EntityWrapper<RuzhuanpaiEntity> ew = new EntityWrapper<RuzhuanpaiEntity>();
		PageUtils page = checkin_assignmentService.queryPage(params, MPUtil.sort(MPUtil.between(MPUtil.likeOrEq(ew, checkin_assignment), params), params));
        return R.ok().put("data", page);
    }

	/**
     */
    @RequestMapping("/lists")
    public R list( RuzhuanpaiEntity checkin_assignment){
       	EntityWrapper<RuzhuanpaiEntity> ew = new EntityWrapper<RuzhuanpaiEntity>();
      	ew.allEq(MPUtil.allEQMapPre( checkin_assignment, "checkin_assignment")); 
        return R.ok().put("data", checkin_assignmentService.selectListView(ew));
    }

	 /**
     */
    @RequestMapping("/query")
    public R query(RuzhuanpaiEntity checkin_assignment){
        EntityWrapper< RuzhuanpaiEntity> ew = new EntityWrapper< RuzhuanpaiEntity>();
 		ew.allEq(MPUtil.allEQMapPre( checkin_assignment, "checkin_assignment")); 
		RuzhuanpaiView checkin_assignmentView =  checkin_assignmentService.selectView(ew);
		return R.ok("查询入住安排成功").put("data", checkin_assignmentView);
    }
	
    /**
     */
    @RequestMapping("/info/{id}")
    public R info(@PathVariable("id") Long id){
        RuzhuanpaiEntity checkin_assignment = checkin_assignmentService.selectById(id);
        return R.ok().put("data", checkin_assignment);
    }

    /**
     */
    @RequestMapping("/detail/{id}")
    public R detail(@PathVariable("id") Long id){
        RuzhuanpaiEntity checkin_assignment = checkin_assignmentService.selectById(id);
        return R.ok().put("data", checkin_assignment);
    }
    



    /**
     */
    @RequestMapping("/save")
    public R save(@RequestBody RuzhuanpaiEntity checkin_assignment, HttpServletRequest request){
    	//ValidatorUtils.validateEntity(checkin_assignment);
        checkin_assignmentService.insert(checkin_assignment);
        return R.ok();
    }
    
    /**
     */
    @RequestMapping("/add")
    public R add(@RequestBody RuzhuanpaiEntity checkin_assignment, HttpServletRequest request){
    	//ValidatorUtils.validateEntity(checkin_assignment);
        checkin_assignmentService.insert(checkin_assignment);
        return R.ok();
    }

    /**
     */
    @RequestMapping("/update")
    public R update(@RequestBody RuzhuanpaiEntity checkin_assignment, HttpServletRequest request){
        //ValidatorUtils.validateEntity(checkin_assignment);
        checkin_assignmentService.updateById(checkin_assignment);//全部更新
        return R.ok();
    }
    

    /**
     */
    @RequestMapping("/delete")
    public R delete(@RequestBody Long[] ids){
        checkin_assignmentService.deleteBatchIds(Arrays.asList(ids));
        return R.ok();
    }
    
    /**
     */
	@RequestMapping("/remind/{columnName}/{type}")
	public R remindCount(@PathVariable("columnName") String columnName, HttpServletRequest request, 
						 @PathVariable("type") String type,@RequestParam Map<String, Object> map) {
		map.put("column", columnName);
		map.put("type", type);
		
		if(type.equals("2")) {
			SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
			Calendar c = Calendar.getInstance();
			Date remindStartDate = null;
			Date remindEndDate = null;
			if(map.get("remindstart")!=null) {
				Integer remindStart = Integer.parseInt(map.get("remindstart").toString());
				c.setTime(new Date()); 
				c.add(Calendar.DAY_OF_MONTH,remindStart);
				remindStartDate = c.getTime();
				map.put("remindstart", sdf.format(remindStartDate));
			}
			if(map.get("remindend")!=null) {
				Integer remindEnd = Integer.parseInt(map.get("remindend").toString());
				c.setTime(new Date());
				c.add(Calendar.DAY_OF_MONTH,remindEnd);
				remindEndDate = c.getTime();
				map.put("remindend", sdf.format(remindEndDate));
			}
		}
		
		Wrapper<RuzhuanpaiEntity> wrapper = new EntityWrapper<RuzhuanpaiEntity>();
		if(map.get("remindstart")!=null) {
			wrapper.ge(columnName, map.get("remindstart"));
		}
		if(map.get("remindend")!=null) {
			wrapper.le(columnName, map.get("remindend"));
		}

		String tableName = request.getSession().getAttribute("tableName").toString();
		if(tableName.equals("customer")) {
			wrapper.eq("customerming", (String)request.getSession().getAttribute("username"));
		}

		int count = checkin_assignmentService.selectCount(wrapper);
		return R.ok().put("count", count);
	}
	







}
