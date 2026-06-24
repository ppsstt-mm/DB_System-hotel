package com.controller;

import com.annotation.IgnoreAuth;
import com.baomidou.mybatisplus.mapper.EntityWrapper;
import com.baomidou.mybatisplus.mapper.Wrapper;
import com.entity.StoreupEntity;
import com.entity.TokenEntity;
import com.entity.view.StoreupView;
import com.service.StoreupService;
import com.service.TokenService;
import com.utils.MPUtil;
import com.utils.PageUtils;
import com.utils.R;
import org.apache.commons.lang3.StringUtils;
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
import java.util.List;
import java.util.Map;

@RestController
@RequestMapping("/favorite")
public class StoreupController {

    @Autowired
    private StoreupService favoriteService;

    @Autowired
    private TokenService tokenService;

    private TokenEntity currentToken(HttpServletRequest request) {
        String token = request.getHeader("Token");
        if (StringUtils.isBlank(token)) {
            return null;
        }
        return tokenService.getTokenEntity(token);
    }

    private String currentTableName(HttpServletRequest request) {
        Object tableName = request.getSession().getAttribute("tableName");
        if (tableName != null) {
            return String.valueOf(tableName);
        }
        TokenEntity tokenEntity = currentToken(request);
        return tokenEntity == null ? null : tokenEntity.getTablename();
    }

    private Long currentUserId(HttpServletRequest request) {
        Object userId = request.getSession().getAttribute("userId");
        if (userId != null) {
            if (userId instanceof Long) {
                return (Long) userId;
            }
            return Long.valueOf(String.valueOf(userId));
        }
        TokenEntity tokenEntity = currentToken(request);
        return tokenEntity == null ? null : tokenEntity.getUserid();
    }

    private boolean isAdmin(HttpServletRequest request) {
        String tableName = currentTableName(request);
        return "admin".equals(tableName) || "admin_user".equals(tableName);
    }

    private Wrapper<StoreupEntity> scopedWrapper(HttpServletRequest request) {
        EntityWrapper<StoreupEntity> wrapper = new EntityWrapper<>();
        if (!isAdmin(request)) {
            Long userId = currentUserId(request);
            if (userId != null) {
                wrapper.eq("userid", userId);
            } else {
                wrapper.eq("userid", -1L);
            }
        }
        return wrapper;
    }

    private StoreupEntity existingFavorite(Long userId, Long refId, String tableName) {
        if (userId == null || refId == null || StringUtils.isBlank(tableName)) {
            return null;
        }
        EntityWrapper<StoreupEntity> wrapper = new EntityWrapper<>();
        wrapper.eq("userid", userId)
                .eq("refid", refId)
                .eq("tablename", tableName)
                .orderBy("id", false)
                .last("LIMIT 1");
        return favoriteService.selectOne(wrapper);
    }

    @RequestMapping("/page")
    public R page(@RequestParam Map<String, Object> params, StoreupEntity favorite, HttpServletRequest request) {
        if (!isAdmin(request)) {
            favorite.setUserid(currentUserId(request));
        }
        EntityWrapper<StoreupEntity> ew = new EntityWrapper<>();
        PageUtils page = favoriteService.queryPage(params, MPUtil.sort(MPUtil.between(MPUtil.likeOrEq(ew, favorite), params), params));
        return R.ok().put("data", page);
    }

    @RequestMapping("/list")
    public R list(@RequestParam Map<String, Object> params, StoreupEntity favorite, HttpServletRequest request) {
        if (!isAdmin(request)) {
            favorite.setUserid(currentUserId(request));
        }
        EntityWrapper<StoreupEntity> ew = new EntityWrapper<>();
        PageUtils page = favoriteService.queryPage(params, MPUtil.sort(MPUtil.between(MPUtil.likeOrEq(ew, favorite), params), params));
        return R.ok().put("data", page);
    }

    @RequestMapping("/lists")
    public R lists(StoreupEntity favorite, HttpServletRequest request) {
        EntityWrapper<StoreupEntity> ew = new EntityWrapper<>();
        ew.allEq(MPUtil.allEQMapPre(favorite, "favorite"));
        if (!isAdmin(request)) {
            ew.eq("userid", currentUserId(request));
        }
        return R.ok().put("data", favoriteService.selectListView(ew));
    }

    @RequestMapping("/query")
    public R query(StoreupEntity favorite, HttpServletRequest request) {
        EntityWrapper<StoreupEntity> ew = new EntityWrapper<>();
        ew.allEq(MPUtil.allEQMapPre(favorite, "favorite"));
        if (!isAdmin(request)) {
            ew.eq("userid", currentUserId(request));
        }
        StoreupView favoriteView = favoriteService.selectView(ew);
        return R.ok("查询收藏记录成功").put("data", favoriteView);
    }

    @RequestMapping("/info/{id}")
    public R info(@PathVariable("id") Long id, HttpServletRequest request) {
        StoreupEntity favorite = favoriteService.selectById(id);
        if (favorite == null) {
            return R.ok().put("data", null);
        }
        if (!isAdmin(request) && !favorite.getUserid().equals(currentUserId(request))) {
            return R.error("只能查看自己的收藏记录");
        }
        return R.ok().put("data", favorite);
    }

    @IgnoreAuth
    @RequestMapping("/detail/{id}")
    public R detail(@PathVariable("id") Long id) {
        StoreupEntity favorite = favoriteService.selectById(id);
        return R.ok().put("data", favorite);
    }

    @RequestMapping("/save")
    public R save(@RequestBody StoreupEntity favorite, HttpServletRequest request) {
        return add(favorite, request);
    }

    @RequestMapping("/add")
    public R add(@RequestBody StoreupEntity favorite, HttpServletRequest request) {
        Long userId = currentUserId(request);
        if (userId == null) {
            return R.error(401, "请先登录");
        }
        favorite.setUserid(userId);
        StoreupEntity existing = existingFavorite(userId, favorite.getRefid(), favorite.getTablename());
        if (existing != null) {
            return R.ok("已收藏").put("data", existing);
        }
        favoriteService.insert(favorite);
        return R.ok().put("data", favorite);
    }

    @RequestMapping("/update")
    public R update(@RequestBody StoreupEntity favorite, HttpServletRequest request) {
        StoreupEntity existing = favoriteService.selectById(favorite.getId());
        if (existing == null) {
            return R.error("收藏记录不存在");
        }
        if (!isAdmin(request) && !existing.getUserid().equals(currentUserId(request))) {
            return R.error("只能修改自己的收藏记录");
        }
        if (!isAdmin(request)) {
            favorite.setUserid(existing.getUserid());
        }
        favoriteService.updateById(favorite);
        return R.ok();
    }

    @RequestMapping("/delete")
    public R delete(@RequestBody Long[] ids, HttpServletRequest request) {
        if (ids == null || ids.length == 0) {
            return R.ok();
        }
        if (isAdmin(request)) {
            favoriteService.deleteBatchIds(Arrays.asList(ids));
            return R.ok();
        }
        Long userId = currentUserId(request);
        for (Long id : ids) {
            StoreupEntity favorite = favoriteService.selectById(id);
            if (favorite != null && userId != null && userId.equals(favorite.getUserid())) {
                favoriteService.deleteById(id);
            }
        }
        return R.ok();
    }

    @RequestMapping("/status")
    public R status(@RequestParam("tablename") String tableName,
                    @RequestParam("refid") Long refId,
                    HttpServletRequest request) {
        Long userId = currentUserId(request);
        if (userId == null) {
            return R.ok().put("data", buildStatus(null));
        }
        StoreupEntity favorite = existingFavorite(userId, refId, tableName);
        return R.ok().put("data", buildStatus(favorite));
    }

    @RequestMapping("/toggle")
    public R toggle(@RequestBody Map<String, Object> payload, HttpServletRequest request) {
        Long userId = currentUserId(request);
        if (userId == null) {
            return R.error(401, "请先登录");
        }
        Long refId = payload.get("refid") == null ? null : Long.valueOf(String.valueOf(payload.get("refid")));
        String tableName = payload.get("tablename") == null ? null : String.valueOf(payload.get("tablename")).trim();
        if (refId == null || StringUtils.isBlank(tableName)) {
            return R.error("缺少收藏对象信息");
        }
        StoreupEntity existing = existingFavorite(userId, refId, tableName);
        if (existing != null) {
            favoriteService.deleteById(existing.getId());
            return R.ok("已取消收藏").put("data", buildStatus(null));
        }

        StoreupEntity favorite = new StoreupEntity<>();
        favorite.setUserid(userId);
        favorite.setRefid(refId);
        favorite.setTablename(tableName);
        favorite.setName(payload.get("name") == null ? null : String.valueOf(payload.get("name")));
        favorite.setPicture(payload.get("picture") == null ? null : String.valueOf(payload.get("picture")));
        favorite.setType(payload.get("type") == null ? "收藏" : String.valueOf(payload.get("type")));
        favorite.setInteltype(payload.get("inteltype") == null ? null : String.valueOf(payload.get("inteltype")));
        favorite.setAddtime(new Date());
        favoriteService.insert(favorite);
        return R.ok("收藏成功").put("data", buildStatus(favorite));
    }

    @RequestMapping("/remind/{columnName}/{type}")
    public R remindCount(@PathVariable("columnName") String columnName,
                         HttpServletRequest request,
                         @PathVariable("type") String type,
                         @RequestParam Map<String, Object> map) {
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

        Wrapper<StoreupEntity> wrapper = scopedWrapper(request);
        if (map.get("remindstart") != null) {
            wrapper.ge(columnName, map.get("remindstart"));
        }
        if (map.get("remindend") != null) {
            wrapper.le(columnName, map.get("remindend"));
        }
        int count = favoriteService.selectCount(wrapper);
        return R.ok().put("count", count);
    }

    private Map<String, Object> buildStatus(StoreupEntity favorite) {
        return new java.util.LinkedHashMap<String, Object>() {{
            put("favorited", favorite != null);
            put("favoriteId", favorite == null ? null : favorite.getId());
        }};
    }
}
