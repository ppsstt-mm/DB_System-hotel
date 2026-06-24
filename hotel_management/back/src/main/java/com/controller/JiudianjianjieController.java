package com.controller;

import com.annotation.IgnoreAuth;
import com.baomidou.mybatisplus.mapper.EntityWrapper;
import com.baomidou.mybatisplus.mapper.Wrapper;
import com.entity.JiudianjianjieEntity;
import com.entity.view.JiudianjianjieView;
import com.service.JiudianjianjieService;
import com.service.StoreupService;
import com.utils.MPUtil;
import com.utils.PageUtils;
import com.utils.R;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import javax.servlet.http.HttpServletRequest;
import java.text.SimpleDateFormat;
import java.util.Arrays;
import java.util.Calendar;
import java.util.Date;
import java.util.Map;

@RestController
@RequestMapping("/hotel_profile")
public class JiudianjianjieController {
    @Autowired
    private JiudianjianjieService hotel_profileService;

    @Autowired
    private StoreupService favoriteService;

    @RequestMapping("/page")
    public R page(@RequestParam Map<String, Object> params, JiudianjianjieEntity hotel_profile, HttpServletRequest request) {
        EntityWrapper<JiudianjianjieEntity> ew = new EntityWrapper<JiudianjianjieEntity>();
        PageUtils page = hotel_profileService.queryPage(params, MPUtil.sort(MPUtil.between(MPUtil.likeOrEq(ew, hotel_profile), params), params));
        return R.ok().put("data", page);
    }

    @IgnoreAuth
    @RequestMapping("/list")
    public R list(@RequestParam Map<String, Object> params, JiudianjianjieEntity hotel_profile, HttpServletRequest request) {
        EntityWrapper<JiudianjianjieEntity> ew = new EntityWrapper<JiudianjianjieEntity>();
        PageUtils page = hotel_profileService.queryPage(params, MPUtil.sort(MPUtil.between(MPUtil.likeOrEq(ew, hotel_profile), params), params));
        return R.ok().put("data", page);
    }

    @RequestMapping("/lists")
    public R list(JiudianjianjieEntity hotel_profile) {
        EntityWrapper<JiudianjianjieEntity> ew = new EntityWrapper<JiudianjianjieEntity>();
        ew.allEq(MPUtil.allEQMapPre(hotel_profile, "hotel_profile"));
        return R.ok().put("data", hotel_profileService.selectListView(ew));
    }

    @RequestMapping("/query")
    public R query(JiudianjianjieEntity hotel_profile) {
        EntityWrapper<JiudianjianjieEntity> ew = new EntityWrapper<JiudianjianjieEntity>();
        ew.allEq(MPUtil.allEQMapPre(hotel_profile, "hotel_profile"));
        JiudianjianjieView hotel_profileView = hotel_profileService.selectView(ew);
        return R.ok("查询酒店信息成功").put("data", hotel_profileView);
    }

    @RequestMapping("/info/{id}")
    public R info(@PathVariable("id") Long id) {
        JiudianjianjieEntity hotel_profile = hotel_profileService.selectById(id);
        return R.ok().put("data", hotel_profile);
    }

    @IgnoreAuth
    @RequestMapping("/detail/{id}")
    public R detail(@PathVariable("id") Long id) {
        JiudianjianjieEntity hotel_profile = hotel_profileService.selectById(id);
        return R.ok().put("data", hotel_profile);
    }

    @RequestMapping("/save")
    public R save(@RequestBody JiudianjianjieEntity hotel_profile, HttpServletRequest request) {
        hotel_profileService.insert(hotel_profile);
        return R.ok();
    }

    @RequestMapping("/add")
    public R add(@RequestBody JiudianjianjieEntity hotel_profile, HttpServletRequest request) {
        hotel_profileService.insert(hotel_profile);
        return R.ok();
    }

    @RequestMapping("/update")
    public R update(@RequestBody JiudianjianjieEntity hotel_profile, HttpServletRequest request) {
        hotel_profileService.updateById(hotel_profile);
        return R.ok();
    }

    @RequestMapping("/delete")
    public R delete(@RequestBody Long[] ids) {
        hotel_profileService.deleteBatchIds(Arrays.asList(ids));
        return R.ok();
    }

    @RequestMapping("/remind/{columnName}/{type}")
    public R remindCount(@PathVariable("columnName") String columnName, HttpServletRequest request,
                         @PathVariable("type") String type, @RequestParam Map<String, Object> map) {
        map.put("column", columnName);
        map.put("type", type);

        if ("2".equals(type)) {
            SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
            Calendar c = Calendar.getInstance();
            if (map.get("remindstart") != null) {
                Integer remindStart = Integer.parseInt(map.get("remindstart").toString());
                c.setTime(new Date());
                c.add(Calendar.DAY_OF_MONTH, remindStart);
                map.put("remindstart", sdf.format(c.getTime()));
            }
            if (map.get("remindend") != null) {
                Integer remindEnd = Integer.parseInt(map.get("remindend").toString());
                c.setTime(new Date());
                c.add(Calendar.DAY_OF_MONTH, remindEnd);
                map.put("remindend", sdf.format(c.getTime()));
            }
        }

        Wrapper<JiudianjianjieEntity> wrapper = new EntityWrapper<JiudianjianjieEntity>();
        if (map.get("remindstart") != null) {
            wrapper.ge(columnName, map.get("remindstart"));
        }
        if (map.get("remindend") != null) {
            wrapper.le(columnName, map.get("remindend"));
        }

        int count = hotel_profileService.selectCount(wrapper);
        return R.ok().put("count", count);
    }
}
