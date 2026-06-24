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

import com.entity.KefangleixingEntity;
import com.entity.view.KefangleixingView;

import com.service.KefangleixingService;
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
@RequestMapping("/room_category")
public class KefangleixingController {
    @Autowired
    private KefangleixingService room_categoryService;


    


    /**
     */
    @RequestMapping("/page")
    public R page(@RequestParam Map<String, Object> params,KefangleixingEntity room_category,
		HttpServletRequest request){
        EntityWrapper<KefangleixingEntity> ew = new EntityWrapper<KefangleixingEntity>();
		PageUtils page = room_categoryService.queryPage(params, MPUtil.sort(MPUtil.between(MPUtil.likeOrEq(ew, room_category), params), params));

        return R.ok().put("data", page);
    }
    
    /**
     */
	@IgnoreAuth
    @RequestMapping("/list")
    public R list(@RequestParam Map<String, Object> params,KefangleixingEntity room_category, 
		HttpServletRequest request){
        EntityWrapper<KefangleixingEntity> ew = new EntityWrapper<KefangleixingEntity>();
		PageUtils page = room_categoryService.queryPage(params, MPUtil.sort(MPUtil.between(MPUtil.likeOrEq(ew, room_category), params), params));
        return R.ok().put("data", page);
    }

	/**
     */
    @RequestMapping("/lists")
    public R list( KefangleixingEntity room_category){
       	EntityWrapper<KefangleixingEntity> ew = new EntityWrapper<KefangleixingEntity>();
      	ew.allEq(MPUtil.allEQMapPre( room_category, "room_category")); 
        return R.ok().put("data", room_categoryService.selectListView(ew));
    }

	 /**
     */
    @RequestMapping("/query")
    public R query(KefangleixingEntity room_category){
        EntityWrapper< KefangleixingEntity> ew = new EntityWrapper< KefangleixingEntity>();
 		ew.allEq(MPUtil.allEQMapPre( room_category, "room_category")); 
		KefangleixingView room_categoryView =  room_categoryService.selectView(ew);
		return R.ok("查询客房类型成功").put("data", room_categoryView);
    }
	
    /**
     */
    @RequestMapping("/info/{id}")
    public R info(@PathVariable("id") Long id){
        KefangleixingEntity room_category = room_categoryService.selectById(id);
        return R.ok().put("data", room_category);
    }

    /**
     */
	@IgnoreAuth
    @RequestMapping("/detail/{id}")
    public R detail(@PathVariable("id") Long id){
        KefangleixingEntity room_category = room_categoryService.selectById(id);
        return R.ok().put("data", room_category);
    }
    



    /**
     */
    @RequestMapping("/save")
    public R save(@RequestBody KefangleixingEntity room_category, HttpServletRequest request){
    	//ValidatorUtils.validateEntity(room_category);
        room_categoryService.insert(room_category);
        return R.ok();
    }
    
    /**
     */
    @RequestMapping("/add")
    public R add(@RequestBody KefangleixingEntity room_category, HttpServletRequest request){
    	//ValidatorUtils.validateEntity(room_category);
        room_categoryService.insert(room_category);
        return R.ok();
    }

    /**
     */
    @RequestMapping("/update")
    public R update(@RequestBody KefangleixingEntity room_category, HttpServletRequest request){
        //ValidatorUtils.validateEntity(room_category);
        room_categoryService.updateById(room_category);//全部更新
        return R.ok();
    }
    

    /**
     */
    @RequestMapping("/delete")
    public R delete(@RequestBody Long[] ids){
        room_categoryService.deleteBatchIds(Arrays.asList(ids));
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
		
		Wrapper<KefangleixingEntity> wrapper = new EntityWrapper<KefangleixingEntity>();
		if(map.get("remindstart")!=null) {
			wrapper.ge(columnName, map.get("remindstart"));
		}
		if(map.get("remindend")!=null) {
			wrapper.le(columnName, map.get("remindend"));
		}


		int count = room_categoryService.selectCount(wrapper);
		return R.ok().put("count", count);
	}
	







}
