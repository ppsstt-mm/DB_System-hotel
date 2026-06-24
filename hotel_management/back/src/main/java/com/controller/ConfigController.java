
package com.controller;


import java.util.Arrays;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import com.annotation.IgnoreAuth;
import com.baomidou.mybatisplus.mapper.EntityWrapper;
import com.entity.ConfigEntity;
import com.service.ConfigService;
import com.utils.MPUtil;
import com.utils.PageUtils;
import com.utils.R;
import com.utils.ValidatorUtils;

/**
 */
@RequestMapping("system_config")
@RestController
public class ConfigController{
	
	@Autowired
	private ConfigService system_configService;

	/**
     */
    @RequestMapping("/page")
    public R page(@RequestParam Map<String, Object> params,ConfigEntity system_config){
        EntityWrapper<ConfigEntity> ew = new EntityWrapper<ConfigEntity>();
    	PageUtils page = system_configService.queryPage(params, MPUtil.sort(MPUtil.between(MPUtil.likeOrEq(ew, system_config), params), params));
        return R.ok().put("data", page);
    }
    
	/**
     */
    @IgnoreAuth
    @RequestMapping("/list")
    public R list(@RequestParam Map<String, Object> params,ConfigEntity system_config){
        EntityWrapper<ConfigEntity> ew = new EntityWrapper<ConfigEntity>();
    	PageUtils page = system_configService.queryPage(params, MPUtil.sort(MPUtil.between(MPUtil.likeOrEq(ew, system_config), params), params));
        return R.ok().put("data", page);
    }

    /**
     */
    @RequestMapping("/info/{id}")
    public R info(@PathVariable("id") String id){
        ConfigEntity system_config = system_configService.selectById(id);
        return R.ok().put("data", system_config);
    }
    
    /**
     */
    @IgnoreAuth
    @RequestMapping("/detail/{id}")
    public R detail(@PathVariable("id") String id){
        ConfigEntity system_config = system_configService.selectById(id);
        return R.ok().put("data", system_config);
    }
    
    /**
     */
    @RequestMapping("/info")
    public R infoByName(@RequestParam String name){
        ConfigEntity system_config = system_configService.selectOne(new EntityWrapper<ConfigEntity>().eq("name", "faceFile"));
        return R.ok().put("data", system_config);
    }
    
    /**
     */
    @PostMapping("/save")
    public R save(@RequestBody ConfigEntity system_config){
//    	ValidatorUtils.validateEntity(system_config);
    	system_configService.insert(system_config);
        return R.ok();
    }

    /**
     */
    @RequestMapping("/update")
    public R update(@RequestBody ConfigEntity system_config){
//        ValidatorUtils.validateEntity(system_config);
        system_configService.updateById(system_config);//全部更新
        return R.ok();
    }

    /**
     */
    @RequestMapping("/delete")
    public R delete(@RequestBody Long[] ids){
    	system_configService.deleteBatchIds(Arrays.asList(ids));
        return R.ok();
    }
}
