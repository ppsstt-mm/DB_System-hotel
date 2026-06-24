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

import com.entity.JiudiankefangEntity;
import com.entity.JiudianjianjieEntity;
import com.entity.KefangleixingEntity;
import com.entity.view.JiudiankefangView;

import com.service.JiudiankefangService;
import com.service.JiudianjianjieService;
import com.service.KefangleixingService;
import com.service.TokenService;
import com.utils.PageUtils;
import com.utils.R;
import com.utils.MD5Util;
import com.utils.MPUtil;
import com.utils.CommonUtil;
import java.io.IOException;
import com.service.StoreupService;
import com.entity.StoreupEntity;
import org.springframework.jdbc.core.JdbcTemplate;

/**
 * @author 
 * @email 
 * @date 2022-04-04 00:20:04
 */
@RestController
@RequestMapping("/room_catalog")
public class JiudiankefangController {
    @Autowired
    private JiudiankefangService room_catalogService;

    @Autowired
    private StoreupService favoriteService;

    @Autowired
    private JiudianjianjieService hotel_profileService;

    @Autowired
    private KefangleixingService room_categoryService;

    @Autowired
    private JdbcTemplate jdbcTemplate;

    


    /**
     */
    @RequestMapping("/page")
    public R page(@RequestParam Map<String, Object> params,JiudiankefangEntity room_catalog,
		HttpServletRequest request){
        EntityWrapper<JiudiankefangEntity> ew = new EntityWrapper<JiudiankefangEntity>();
		PageUtils page = room_catalogService.queryPage(params, MPUtil.sort(MPUtil.between(MPUtil.likeOrEq(ew, room_catalog), params), params));

        return R.ok().put("data", page);
    }
    
    /**
     */
	@IgnoreAuth
    @RequestMapping("/list")
    public R list(@RequestParam Map<String, Object> params,JiudiankefangEntity room_catalog, 
		HttpServletRequest request){
        EntityWrapper<JiudiankefangEntity> ew = new EntityWrapper<JiudiankefangEntity>();
		PageUtils page = room_catalogService.queryPage(params, MPUtil.sort(MPUtil.between(MPUtil.likeOrEq(ew, room_catalog), params), params));
        return R.ok().put("data", page);
    }

	/**
     */
    @RequestMapping("/lists")
    public R list( JiudiankefangEntity room_catalog){
       	EntityWrapper<JiudiankefangEntity> ew = new EntityWrapper<JiudiankefangEntity>();
      	ew.allEq(MPUtil.allEQMapPre( room_catalog, "room_catalog")); 
        return R.ok().put("data", room_catalogService.selectListView(ew));
    }

	 /**
     */
    @RequestMapping("/query")
    public R query(JiudiankefangEntity room_catalog){
        EntityWrapper< JiudiankefangEntity> ew = new EntityWrapper< JiudiankefangEntity>();
 		ew.allEq(MPUtil.allEQMapPre( room_catalog, "room_catalog")); 
		JiudiankefangView room_catalogView =  room_catalogService.selectView(ew);
		return R.ok("查询酒店客房成功").put("data", room_catalogView);
    }
	
    /**
     */
    @RequestMapping("/info/{id}")
    public R info(@PathVariable("id") Long id){
        JiudiankefangEntity room_catalog = room_catalogService.selectById(id);
		room_catalog.setClicknum(room_catalog.getClicknum()+1);
		room_catalogService.updateById(room_catalog);
        return R.ok().put("data", room_catalog);
    }

    /**
     */
	@IgnoreAuth
    @RequestMapping("/detail/{id}")
    public R detail(@PathVariable("id") Long id){
        JiudiankefangEntity room_catalog = room_catalogService.selectById(id);
		room_catalog.setClicknum(room_catalog.getClicknum()+1);
		room_catalogService.updateById(room_catalog);
        return R.ok().put("data", room_catalog);
    }
    



    /**
     */
    @RequestMapping("/save")
    public R save(@RequestBody JiudiankefangEntity room_catalog, HttpServletRequest request){
    	//ValidatorUtils.validateEntity(room_catalog);
        syncResourceRelation(room_catalog);
        room_catalogService.insert(room_catalog);
        return R.ok();
    }
    
    /**
     */
    @RequestMapping("/add")
    public R add(@RequestBody JiudiankefangEntity room_catalog, HttpServletRequest request){
    	//ValidatorUtils.validateEntity(room_catalog);
        syncResourceRelation(room_catalog);
        room_catalogService.insert(room_catalog);
        return R.ok();
    }

    /**
     */
    @RequestMapping("/update")
    public R update(@RequestBody JiudiankefangEntity room_catalog, HttpServletRequest request){
        //ValidatorUtils.validateEntity(room_catalog);
        syncResourceRelation(room_catalog);
        room_catalogService.updateById(room_catalog);//全部更新
        return R.ok();
    }
    

    /**
     */
    @RequestMapping("/delete")
    public R delete(@RequestBody Long[] ids){
        room_catalogService.deleteBatchIds(Arrays.asList(ids));
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
		
		Wrapper<JiudiankefangEntity> wrapper = new EntityWrapper<JiudiankefangEntity>();
		if(map.get("remindstart")!=null) {
			wrapper.ge(columnName, map.get("remindstart"));
		}
		if(map.get("remindend")!=null) {
			wrapper.le(columnName, map.get("remindend"));
		}


		int count = room_catalogService.selectCount(wrapper);
		return R.ok().put("count", count);
	}

    @IgnoreAuth
    @RequestMapping("/availability/summary")
    public R availabilitySummary() {
        return R.ok().put("data", jdbcTemplate.queryForList(
                "SELECT room_name, room_category, hotel_name, total_rooms, available_rooms, reserved_rooms, occupied_rooms, cleaning_rooms, maintenance_rooms " +
                        "FROM v_room_inventory_overview ORDER BY room_category ASC, room_name ASC"
        ));
    }

    private void syncResourceRelation(JiudiankefangEntity room_catalog) {
        if(room_catalog == null) {
            return;
        }
        if(StringUtils.isNotBlank(room_catalog.getJiudianmingcheng())) {
            JiudianjianjieEntity hotel = hotel_profileService.selectOne(
                new EntityWrapper<JiudianjianjieEntity>().eq("jiudianmingcheng", room_catalog.getJiudianmingcheng())
            );
            if(hotel != null) {
                room_catalog.setHotelProfileId(hotel.getId());
                if(StringUtils.isBlank(room_catalog.getJiudiandizhi())) {
                    room_catalog.setJiudiandizhi(hotel.getJiudiandizhi());
                }
            }
        }
        if(StringUtils.isNotBlank(room_catalog.getRoom_category())) {
            KefangleixingEntity category = room_categoryService.selectOne(
                new EntityWrapper<KefangleixingEntity>().eq("room_category", room_catalog.getRoom_category())
            );
            if(category != null) {
                room_catalog.setRoomCategoryId(category.getId());
            }
        }
    }

}
